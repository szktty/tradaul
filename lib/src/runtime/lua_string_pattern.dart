import 'dart:collection';

import 'package:result_dart/result_dart.dart';
import 'package:string_scanner/string_scanner.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';
import 'package:tradaul/src/utils/errors.dart';

typedef LuaStringPatternSubstitute = Future<Result<String, String>?> Function(
  List<String>,
);

abstract class Node {
  bool match(MatchContext context, StringScanner scanner) {
    throw UnimplementedError('$runtimeType.match');
  }

  bool get matchesEndOfString => false;
}

final class LiteralNode extends Node {}

enum CharacterClassPattern {
  any,
  alphabet,
  control,
  digit,
  printable,
  lower,
  punctuation,
  space,
  upper,
  alphanumeric,
  hex,
}

abstract class CharacterClassNode extends Node {}

final class LiteralCharacterClassNode extends CharacterClassNode {
  LiteralCharacterClassNode(this.character);

  final int character;

  @override
  bool match(MatchContext context, StringScanner scanner) {
    return scanner.scanChar(character);
  }
}

final class CharacterClassPatternNode extends CharacterClassNode {
  CharacterClassPatternNode(this.pattern);

  final CharacterClassPattern pattern;

  @override
  bool match(MatchContext context, StringScanner scanner) {
    final char = scanner.readChar();
    switch (pattern) {
      case CharacterClassPattern.any:
        return true;
      case CharacterClassPattern.alphabet:
        return _matchInRange(char, 'a', 'z') || _matchInRange(char, 'A', 'Z');
      case CharacterClassPattern.control:
        return _matchInRange(char, '\x00', '\x1f') ||
            _matchInRange(char, '\x7f', '\x9f');
      case CharacterClassPattern.digit:
        return _matchInRange(char, '0', '9');
      case CharacterClassPattern.printable:
        return !((0 <= char && char <= 31) ||
            char == 127 ||
            _matchInCharacters(char, '\r\n\t '));
      case CharacterClassPattern.lower:
        return _matchInRange(char, 'a', 'z');
      case CharacterClassPattern.punctuation:
        return _matchInCharacters(char, r'"!#\$%&()*+,-./:;<=>?@[\\]^_`{|}~');
      case CharacterClassPattern.space:
        return _matchInCharacters(char, ' \f\n\r\t\v');
      case CharacterClassPattern.upper:
        return _matchInRange(char, 'A', 'Z');
      case CharacterClassPattern.alphanumeric:
        return _matchInRange(char, '0', '9') ||
            _matchInRange(char, 'a', 'z') ||
            _matchInRange(char, 'A', 'Z');
      case CharacterClassPattern.hex:
        return _matchInRange(char, '0', '9') ||
            _matchInRange(char, 'a', 'f') ||
            _matchInRange(char, 'A', 'F');
    }
  }
}

final class CharacterRangeNode extends CharacterClassNode {
  CharacterRangeNode(this.start, this.end);

  final int start;
  final int end;

  @override
  bool match(MatchContext context, StringScanner scanner) {
    final char = scanner.readChar();
    return char >= start && char <= end;
  }
}

final class CharacterSetNode extends CharacterClassNode {
  CharacterSetNode(this.classes, {required this.complement});

  final List<CharacterClassNode> classes;
  final bool complement;

  @override
  bool match(MatchContext context, StringScanner scanner) {
    if (!complement) {
      return classes.any(context.matchNode);
    } else {
      final current = scanner.position;
      var matched = false;
      for (final class_ in classes) {
        if (context.matchNode(class_)) {
          scanner.position = current;
          matched = true;
        }
      }

      if (!matched && !scanner.isDone) {
        scanner.readChar();
      }
      return !matched;
    }
  }
}

final class ComplementCharacterClassNode extends CharacterClassNode {
  ComplementCharacterClassNode(this.class_);

  final CharacterClassNode class_;

  @override
  bool match(MatchContext context, StringScanner scanner) {
    final current = scanner.position;
    final matched = context.matchNode(class_);
    if (!matched) {
      if (!scanner.isDone) {
        scanner.readChar();
      }
      return true;
    } else {
      scanner.position = current;
      return false;
    }
  }
}

abstract class PatternItemNode extends Node {}

final class CharacterClassPatternItemNode extends PatternItemNode {
  CharacterClassPatternItemNode(this.class_);

  final CharacterClassNode class_;

  @override
  bool match(MatchContext context, StringScanner scanner) {
    return context.matchNode(class_);
  }
}

final class QuantifierNode extends PatternItemNode {
  QuantifierNode(
    this.node, {
    required this.min,
    required this.max,
    required this.repeat,
    required this.greedy,
  });

  factory QuantifierNode.zeroOrOne(Node node, {required bool greedy}) {
    return QuantifierNode(node, min: 0, max: 1, repeat: true, greedy: greedy);
  }

  factory QuantifierNode.zeroOrMore(Node node, {required bool greedy}) {
    return QuantifierNode(
      node,
      min: 0,
      max: null,
      repeat: true,
      greedy: greedy,
    );
  }

  factory QuantifierNode.oneOrMore(Node node, {required bool greedy}) {
    return QuantifierNode(
      node,
      min: 1,
      max: null,
      repeat: true,
      greedy: greedy,
    );
  }

  final Node node;
  final int min;
  final int? max;
  final bool repeat;
  final bool greedy;

  @override
  bool match(MatchContext context, StringScanner scanner) {
    if (min == 0 && !greedy) {
      return true;
    }

    var count = 0;
    while (!scanner.isDone) {
      final before = scanner.position;
      if (context.matchNode(node)) {
        count++;
        if (before == scanner.position ||
            !repeat ||
            (!greedy && count >= min) ||
            (max != null && count >= max!)) {
          break;
        }
      } else {
        break;
      }
    }

    return count >= min;
  }
}

final class CaptureNode extends PatternItemNode {
  CaptureNode(this.pattern);

  final PatternNode? pattern;

  @override
  bool match(MatchContext context, StringScanner scanner) {
    if (pattern == null) {
      context.addCapture(this, LuaStringPatternCaptureIndex(scanner.position));
      return true;
    } else {
      final capture = LuaStringPatternCaptureString();
      context.addCapture(this, capture);
      final start = scanner.position;
      final matched = context.matchNode(pattern!);
      if (matched) {
        final end = scanner.position;
        capture.string = scanner.substring(start, end);
      } else {
        scanner.position = start;
      }
      return matched;
    }
  }
}

final class CapturedReferenceNode extends PatternItemNode {
  CapturedReferenceNode(this.index);

  final int index;

  @override
  bool match(MatchContext context, StringScanner scanner) {
    final capture = context.getCapture(index);
    if (capture == null) {
      throw MatchFailure('invalid capture index');
    } else if (capture is LuaStringPatternCaptureIndex) {
      return false;
    } else if (capture is LuaStringPatternCaptureString) {
      if (capture.string == null) {
        throw MatchFailure('invalid capture index');
      }
      return scanner.scan(capture.string!);
    } else {
      throw UnreachableError();
    }
  }
}

final class BalancedStringNode extends PatternItemNode {
  BalancedStringNode(this.open, this.close);

  final int open;
  final int close;

  @override
  bool match(MatchContext context, StringScanner scanner) {
    if (!scanner.scanChar(open)) {
      return false;
    }

    if (open == close) {
      while (!scanner.isDone) {
        if (scanner.scanChar(open)) {
          return true;
        } else {
          scanner.readChar();
        }
      }
    } else {
      var count = 1;
      while (!scanner.isDone) {
        if (scanner.scanChar(open)) {
          count++;
        } else if (scanner.scanChar(close)) {
          count--;
          if (count == 0) {
            return true;
          }
        } else {
          scanner.readChar();
        }
      }
    }
    return false;
  }
}

final class FrontierPatternNode extends PatternItemNode {
  FrontierPatternNode(this.set);

  final CharacterSetNode set;

  @override
  bool get matchesEndOfString => true;

  @override
  bool match(MatchContext context, StringScanner scanner) {
    if (scanner.isDone) {
      // end of string
      final start = scanner.position;
      scanner.position--;
      if (context.matchNode(set)) {
        return false;
      } else {
        context.matchedBoundaryEndOfString = true;
        return true;
      }
    } else if (scanner.position == 0) {
      // beginning of string
      final start = scanner.position;
      final matched = context.matchNode(set);
      if (matched) {
        scanner.position = start;
      }
      return matched;
    } else if (scanner.position < scanner.string.length) {
      final start = scanner.position;
      scanner.position--;
      if (!context.matchNode(set)) {
        scanner.position = start;
        if (context.matchNode(set)) {
          scanner.position = start;
          return true;
        } else {
          return false;
        }
      }
      return false;
    } else {
      throw UnreachableError();
    }
  }
}

final class PatternNode extends Node {
  PatternNode(this.items);

  final List<PatternItemNode> items;

  @override
  bool get matchesEndOfString => items.any((item) => item.matchesEndOfString);

  @override
  bool match(MatchContext context, StringScanner scanner) {
    if (scanner.isDone) {
      for (final item in items) {
        if (item.matchesEndOfString && !context.matchNode(item)) {
          return false;
        }
      }
      return true;
    } else if (items.isEmpty) {
      return true;
    } else {
      return items.every(context.matchNode);
    }
  }
}

final class LuaStringPattern {
  LuaStringPattern(this._pattern);

  static Result<LuaStringPattern, String> compile(String pattern) {
    final result = PatternParser.parse(pattern);
    if (result.isError()) {
      return Failure(result.exceptionOrNull()!);
    }
    return Success(LuaStringPattern(result.getOrThrow()));
  }

  final PatternNode _pattern;

  Result<LuaStringPatternMatch, String> match(String string, {int start = 0}) {
    final context = MatchContext(_pattern, string, start);
    return context.match();
  }

  Future<Result<(String, int), String>> replaceAll(
    String string,
    Object replacement,
    int? limit,
  ) async {
    final context = MatchContext(_pattern, string, 0);
    return context.replaceAll(replacement, limit);
  }
}

final class MatchFailure implements Exception {
  MatchFailure(this.message);

  final String message;
}

final class MatchContext {
  MatchContext(this.pattern, this.string, this.index) {
    scanner = StringScanner(string);
    scanner.position = index;
    _captures = LinkedHashMap();
  }

  final PatternNode pattern;
  final String string;
  late final StringScanner scanner;
  int index;

  List<LuaStringPatternCapture> get captures => _captures.values.toList();

  late LinkedHashMap<CaptureNode, LuaStringPatternCapture> _captures;

  bool matchedBoundaryEndOfString = false;

  LuaStringPatternCapture? getCapture(int index) {
    if (index < 0 || index >= _captures.length) {
      return null;
    } else {
      return captures[index];
    }
  }

  void addCapture(CaptureNode node, LuaStringPatternCapture capture) {
    _captures[node] = capture;
  }

  Result<LuaStringPatternMatch, String> match() {
    try {
      var start = -1;
      var end = 0;
      while (!scanner.isDone) {
        final current = scanner.position;
        if (matchNode(pattern)) {
          if (start < current) {
            start = current;
          }
          end = scanner.position - 1;
          break;
        }

        if (!scanner.isDone) {
          scanner.readChar();
        }
      }

      // end of string
      if (pattern.matchesEndOfString && matchNode(pattern)) {
        if (matchedBoundaryEndOfString && start < 0) {
          start = scanner.position + 1;
          end = scanner.position;
        }
      }

      return Success(LuaStringPatternMatch(start, end, captures));
    } on MatchFailure catch (e) {
      return Failure(e.message);
    }
  }

  bool matchNode(Node node) {
    final start = scanner.position;
    final matched = node.match(this, scanner);
    if (!matched) {
      scanner.position = start;
    }
    return matched;
  }

  Future<Result<(String, int), String>> replaceAll(
    Object replacement,
    int? limit,
  ) async {
    int? start;
    var count = 0;
    final buffer = StringBuffer();
    while ((limit == null || count < limit) && !scanner.isDone) {
      start = scanner.position;
      final matchResult = match();
      if (matchResult.isError()) {
        return Failure(matchResult.exceptionOrNull()!);
      }

      final matchInfo = matchResult.getOrThrow();
      if (!matchInfo.matched) {
        buffer.write(string.substring(start));
        break;
      } else if (start < matchInfo.start) {
        buffer.write(string.substring(start, matchInfo.start));
      }
      count++;
      final matched = scanner.string.substring(
        matchInfo.start,
        matchInfo.end + 1,
      );

      final replaceResult = await _replace(matchInfo, matched, replacement);
      if (replaceResult.isError()) {
        return Failure(replaceResult.exceptionOrNull()!);
      } else {
        buffer.write(replaceResult.getOrThrow());
      }

      if (limit != null && count >= limit) {
        buffer.write(string.substring(matchInfo.end + 1));
        break;
      }

      final next = matchInfo.end + 1;
      if (next < scanner.string.length) {
        scanner.position = next;
      } else {
        break;
      }
    }

    if (start == null) {
      return Success((string, 0));
    } else {
      return Success((buffer.toString(), count));
    }
  }

  Future<Result<String, String>> _replace(
    LuaStringPatternMatch matchInfo,
    String matched,
    Object replacement,
  ) async {
    if (replacement is String) {
      var escape = false;
      final scanner = StringScanner(replacement);
      final buffer = StringBuffer();
      while (!scanner.isDone) {
        if (escape) {
          if (scanner.scanChar('%'.codeUnitAt(0))) {
            buffer.write('%');
          } else if (scanner.scan(RegExp('[0-9]+'))) {
            final last = scanner.lastMatch!;
            final matched =
                scanner.string.substring(last.start, last.end).trim();
            final n = int.parse(matched);
            if (n == 0) {
              final whole = string.substring(
                matchInfo.start,
                matchInfo.end + 1,
              );
              buffer.write(whole);
            } else {
              if (n > matchInfo.captures.length) {
                return Failure('invalid capture index %$n');
              }
              final capture = matchInfo.captures[n - 1];
              if (capture is LuaStringPatternCaptureIndex) {
                buffer.write(capture.index.toString());
              } else {
                buffer.write((capture as LuaStringPatternCaptureString).string);
              }
            }
          } else {
            buffer.write(String.fromCharCode(scanner.readChar()));
          }
          escape = false;
        } else if (scanner.scanChar('%'.codeUnitAt(0))) {
          escape = true;
        } else {
          buffer.write(String.fromCharCode(scanner.readChar()));
          escape = false;
        }
      }
      return Success(buffer.toString());
    } else if (replacement is LuaTable) {
      final capture = matchInfo.captures.firstOrNull;
      if (capture != null && capture is LuaStringPatternCaptureString) {
        final value = replacement.stringKeyGet(capture.string!);
        if (value == null || value is LuaNil) {
          return Success(matched);
        } else if (value is LuaString) {
          return Success(value.value);
        } else if (value is LuaNumber) {
          return Success(value.luaToString());
        } else {
          return Failure('invalid replacement value (${value.runtimeType})');
        }
      } else {
        return Success(matched);
      }
    } else if (replacement is LuaStringPatternSubstitute) {
      final arguments = matchInfo.captures.map((capture) {
        if (capture is LuaStringPatternCaptureIndex) {
          return capture.index.toString();
        } else {
          return (capture as LuaStringPatternCaptureString).string!;
        }
      }).toList();
      final result = await replacement(arguments);
      if (result == null) {
        return Success(matched);
      } else if (result.isError()) {
        return Failure(result.exceptionOrNull()!);
      } else {
        return Success(result.getOrThrow());
      }
    } else {
      return Failure('invalid replacement ${replacement.runtimeType}');
    }
  }
}

final class LuaStringPatternMatch {
  LuaStringPatternMatch(this.start, this.end, this.captures);

  final List<LuaStringPatternCapture> captures;

  bool get matched => start >= 0;

  int start;
  int end;
}

abstract class LuaStringPatternCapture {}

final class LuaStringPatternCaptureIndex extends LuaStringPatternCapture {
  LuaStringPatternCaptureIndex(this.index);

  int index;
}

final class LuaStringPatternCaptureString extends LuaStringPatternCapture {
  LuaStringPatternCaptureString();

  String? string;
}

bool _matchInRange(int char, String start, String end) =>
    char >= start.codeUnitAt(0) && char <= end.codeUnitAt(0);

bool _matchInCharacters(int char, String characters) =>
    characters.contains(String.fromCharCode(char));

final class PatternParser {
  PatternParser(String pattern) : _scanner = StringScanner(pattern);
  final StringScanner _scanner;

  static Result<PatternNode, String> parse(String pattern) {
    return PatternParser(pattern)._parse();
  }

  Result<PatternNode, String> _parse({String? terminate}) {
    final items = <PatternItemNode>[];

    while (!_scanner.isDone) {
      if (terminate != null && _scanner.scan(terminate)) {
        break;
      }

      try {
        final result = _parsePatternItem();
        if (result.isError()) {
          return Failure(result.exceptionOrNull()!);
        }
        items.add(result.getOrThrow());
      } on FormatException {
        break;
      } catch (e) {
        return Failure(e.toString());
      }
    }

    return Success(PatternNode(items));
  }

  Result<PatternItemNode, String> _parsePatternItem() {
    if (_scanner.scan(RegExp('%([1-9]+)'))) {
      final n = _scanner.lastMatch![1]!;
      return Success(CapturedReferenceNode(int.parse(n) - 1));
    } else if (_scanner.scan(RegExp('%b(..)'))) {
      final match = _scanner.lastMatch![1]!;
      final open = match.codeUnitAt(0);
      final close = match.codeUnitAt(1);
      return Success(BalancedStringNode(open, close));
    } else if (_scanner.scan('%f')) {
      return _parseCharacterSet().map(FrontierPatternNode.new);
    } else {
      final result = _parseCharacterClass();
      if (result.isError()) {
        return Failure(result.exceptionOrNull()!);
      }
      final item = result.getOrThrow();
      if (_scanner.scan('?')) {
        return Success(QuantifierNode.zeroOrOne(item, greedy: true));
      } else if (_scanner.scan('*')) {
        return Success(QuantifierNode.zeroOrMore(item, greedy: true));
      } else if (_scanner.scan('+')) {
        return Success(QuantifierNode.oneOrMore(item, greedy: true));
      } else if (_scanner.scan('-')) {
        return Success(QuantifierNode.zeroOrMore(item, greedy: false));
      } else {
        return Success(item);
      }
    }
  }

  Result<PatternItemNode, String> _parseCharacterClass() {
    final basic = _parseBasicCharacterClass();
    if (basic != null) {
      return Success(CharacterClassPatternItemNode(basic.getOrThrow()));
    } else if (_scanner.scan('()')) {
      return Success(CaptureNode(null));
    } else if (_scanner.scan('(')) {
      return _parse(terminate: ')').map(CaptureNode.new);
    } else if (_scanner.scan('[')) {
      return _parseCharacterSet().map(CharacterClassPatternItemNode.new);
    } else {
      final char = _scanner.readChar();
      return Success(
        CharacterClassPatternItemNode(LiteralCharacterClassNode(char)),
      );
    }
  }

  Result<CharacterClassNode, String>? _parseBasicCharacterClass() {
    if (_scanner.scan('.')) {
      return Success(CharacterClassPatternNode(CharacterClassPattern.any));
    } else if (_scanner.scan('%a')) {
      return Success(CharacterClassPatternNode(CharacterClassPattern.alphabet));
    } else if (_scanner.scan('%A')) {
      return Success(
        ComplementCharacterClassNode(
          CharacterClassPatternNode(CharacterClassPattern.alphabet),
        ),
      );
    } else if (_scanner.scan('%c')) {
      return Success(CharacterClassPatternNode(CharacterClassPattern.control));
    } else if (_scanner.scan('%C')) {
      return Success(
        ComplementCharacterClassNode(
          CharacterClassPatternNode(CharacterClassPattern.control),
        ),
      );
    } else if (_scanner.scan('%d')) {
      return Success(CharacterClassPatternNode(CharacterClassPattern.digit));
    } else if (_scanner.scan('%D')) {
      return Success(
        ComplementCharacterClassNode(
          CharacterClassPatternNode(CharacterClassPattern.digit),
        ),
      );
    } else if (_scanner.scan('%g')) {
      return Success(
        CharacterClassPatternNode(CharacterClassPattern.printable),
      );
    } else if (_scanner.scan('%G')) {
      return Success(
        ComplementCharacterClassNode(
          CharacterClassPatternNode(CharacterClassPattern.printable),
        ),
      );
    } else if (_scanner.scan('%l')) {
      return Success(CharacterClassPatternNode(CharacterClassPattern.lower));
    } else if (_scanner.scan('%L')) {
      return Success(
        ComplementCharacterClassNode(
          CharacterClassPatternNode(CharacterClassPattern.lower),
        ),
      );
    } else if (_scanner.scan('%p')) {
      return Success(
        CharacterClassPatternNode(CharacterClassPattern.punctuation),
      );
    } else if (_scanner.scan('%P')) {
      return Success(
        ComplementCharacterClassNode(
          CharacterClassPatternNode(CharacterClassPattern.punctuation),
        ),
      );
    } else if (_scanner.scan('%s')) {
      return Success(CharacterClassPatternNode(CharacterClassPattern.space));
    } else if (_scanner.scan('%S')) {
      return Success(
        ComplementCharacterClassNode(
          CharacterClassPatternNode(CharacterClassPattern.space),
        ),
      );
    } else if (_scanner.scan('%u')) {
      return Success(CharacterClassPatternNode(CharacterClassPattern.upper));
    } else if (_scanner.scan('%U')) {
      return Success(
        ComplementCharacterClassNode(
          CharacterClassPatternNode(CharacterClassPattern.upper),
        ),
      );
    } else if (_scanner.scan('%w')) {
      return Success(
        CharacterClassPatternNode(CharacterClassPattern.alphanumeric),
      );
    } else if (_scanner.scan('%W')) {
      return Success(
        ComplementCharacterClassNode(
          CharacterClassPatternNode(CharacterClassPattern.alphanumeric),
        ),
      );
    } else if (_scanner.scan('%x')) {
      return Success(CharacterClassPatternNode(CharacterClassPattern.hex));
    } else if (_scanner.scan('%X')) {
      return Success(
        ComplementCharacterClassNode(
          CharacterClassPatternNode(CharacterClassPattern.hex),
        ),
      );
    } else if (_scanner.scan('%')) {
      if (!_scanner.isDone) {
        final char = _scanner.readChar();
        return Success(LiteralCharacterClassNode(char));
      } else {
        return Failure(
          "malformed pattern (ends with '%') at ${_scanner.position}",
        );
      }
    } else {
      return null;
    }
  }

  Result<CharacterSetNode, String> _parseCharacterSet() {
    final classes = <CharacterClassNode>[];
    final complement = _scanner.scan('^');
    var parseDone = false;
    while (!_scanner.isDone) {
      if (_scanner.scan(']')) {
        parseDone = true;
        break;
      } else {
        final basic = _parseBasicCharacterClass();
        if (basic != null) {
          classes.add(basic.getOrThrow());
          continue;
        } else {
          final char = _scanner.readChar();
          if (!_scanner.isDone && _scanner.scan('-')) {
            if (!_scanner.isDone) {
              final char2 = _scanner.readChar();
              if (char2 == ']'.codeUnitAt(0)) {
                classes
                  ..add(LiteralCharacterClassNode(char))
                  ..add(LiteralCharacterClassNode('-'.codeUnitAt(0)));
                parseDone = true;
                break;
              } else {
                classes.add(CharacterRangeNode(char, char2));
              }
            } else {
              break;
            }
          } else {
            classes.add(LiteralCharacterClassNode(char));
          }
        }
      }
    }

    if (parseDone) {
      return Success(CharacterSetNode(classes, complement: complement));
    } else {
      return Failure("malformed pattern (missing ']') at ${_scanner.position}");
    }
  }
}
