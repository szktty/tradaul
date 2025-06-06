import 'dart:convert';

import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_module.dart';
import 'package:tradaul/src/runtime/lua_native.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

class LuaUtf8Module extends LuaNativeModule {
  LuaUtf8Module() : super(name: 'utf8');

  /// Helper function to validate UTF-8 byte sequence from Lua string
  /// Returns null if valid, or the byte position of the first invalid byte
  static int? _findInvalidUtf8Byte(String s) {
    // Check if string contains any invalid UTF-8 sequences
    // In Lua, strings like "\xC3\x28" should be invalid UTF-8

    // For now, we'll detect common invalid patterns
    final bytes = <int>[];
    for (var i = 0; i < s.length; i++) {
      final codeUnit = s.codeUnitAt(i);
      if (codeUnit > 255) {
        // Multi-byte character, convert to UTF-8 bytes
        final char = s[i];
        bytes.addAll(utf8.encode(char));
      } else {
        // Single byte
        bytes.add(codeUnit);
      }
    }

    // Validate UTF-8 byte sequence
    for (var i = 0; i < bytes.length; i++) {
      final byte = bytes[i];

      if (byte <= 0x7F) {
        // ASCII, valid
        continue;
      } else if ((byte & 0xE0) == 0xC0) {
        // 2-byte sequence
        if (i + 1 >= bytes.length || (bytes[i + 1] & 0xC0) != 0x80) {
          return i + 1; // Invalid continuation byte
        }
        i++; // Skip continuation byte
      } else if ((byte & 0xF0) == 0xE0) {
        // 3-byte sequence
        if (i + 2 >= bytes.length ||
            (bytes[i + 1] & 0xC0) != 0x80 ||
            (bytes[i + 2] & 0xC0) != 0x80) {
          return i + 1;
        }
        i += 2;
      } else if ((byte & 0xF8) == 0xF0) {
        // 4-byte sequence
        if (i + 3 >= bytes.length ||
            (bytes[i + 1] & 0xC0) != 0x80 ||
            (bytes[i + 2] & 0xC0) != 0x80 ||
            (bytes[i + 3] & 0xC0) != 0x80) {
          return i + 1;
        }
        i += 3;
      } else {
        // Invalid start byte
        return i + 1;
      }
    }

    return null; // Valid UTF-8
  }

  /// Helper function to match utf8.charpattern against a string
  /// Returns the position and length of the first UTF-8 character
  static List<int>? _matchCharPattern(String s, String pattern, int startPos) {
    // Check if this is our specific UTF-8 charpattern
    final expectedPattern = String.fromCharCodes([
      0x5B, // [
      0x00, 0x2D, 0x7F, // \x00-\x7F
      0xC2, 0x2D, 0xFD, // \xC2-\xFD
      0x5D, // ]
      0x5B, // [
      0x80, 0x2D, 0xBF, // \x80-\xBF
      0x5D, // ]
      0x2A, // *
    ]);

    if (pattern != expectedPattern) {
      return null; // Not our pattern, use default matching
    }

    if (startPos < 1 || startPos > s.length) {
      return null; // Invalid position
    }

    // Find the first UTF-8 character starting at startPos
    final runes = s.runes.toList();
    if (startPos - 1 >= runes.length) {
      return null; // Position beyond string
    }

    // UTF-8 characters in Dart strings are already properly handled
    // Just return the position of the first character at startPos
    final bytePositions = _getUtf8BytePositions(s);

    // Find which character corresponds to the byte position
    var charIndex = 0;
    for (var i = 0; i < bytePositions.length - 1; i++) {
      if (bytePositions[i] + 1 <= startPos &&
          startPos <= bytePositions[i + 1]) {
        charIndex = i;
        break;
      }
    }

    if (charIndex >= runes.length) {
      return null;
    }

    // Return start and end positions (1-based)
    final start = bytePositions[charIndex] + 1;
    final end = (charIndex + 1 < bytePositions.length)
        ? bytePositions[charIndex + 1]
        : bytePositions.last;

    return [start, end];
  }

  /// Helper function to get UTF-8 byte start positions for each character
  static List<int> _getUtf8BytePositions(String s) {
    final utf8Bytes = utf8.encode(s);
    final positions = <int>[0]; // Character 1 starts at byte 0

    var byteIndex = 0;

    // Find start of each subsequent character
    while (byteIndex < utf8Bytes.length) {
      // Skip current character bytes
      final currentByte = utf8Bytes[byteIndex];
      if (currentByte <= 0x7F) {
        byteIndex += 1;
      } else if ((currentByte & 0xE0) == 0xC0) {
        byteIndex += 2;
      } else if ((currentByte & 0xF0) == 0xE0) {
        byteIndex += 3;
      } else if ((currentByte & 0xF8) == 0xF0) {
        byteIndex += 4;
      } else {
        byteIndex += 1; // Invalid UTF-8, skip one byte
      }

      // If not at end, this is start of next character
      if (byteIndex < utf8Bytes.length) {
        positions.add(byteIndex);
      }
    }

    // Add end position
    positions.add(utf8Bytes.length);

    return positions;
  }

  @override
  Future<LuaValueResult> load(LuaContext context, LuaValue? argument) async {
    if (!context.options.permissions.library.utf8) {
      return Success(LuaNil());
    }

    final module = LuaTable()
      ..addNativeCalls({
        'char': _luaChar,
        'codepoint': _luaCodepoint,
        'codes': _luaCodes,
        'len': _luaLen,
        'offset': _luaOffset,
      });

    // Add utf8.charpattern constant
    // This pattern matches a single UTF-8 encoded character
    // Build utf8.charpattern using byte values to avoid Dart string literal issues
    final charpatternBytes = <int>[
      0x5B, // [
      0x00, 0x2D, 0x7F, // \x00-\x7F
      0xC2, 0x2D, 0xFD, // \xC2-\xFD
      0x5D, // ]
      0x5B, // [
      0x80, 0x2D, 0xBF, // \x80-\xBF
      0x5D, // ]
      0x2A, // *
    ];
    module.stringKeySet(
      'charpattern',
      LuaString(String.fromCharCodes(charpatternBytes)),
    );

    context.environment.variables.stringKeySet('utf8', module);
    return Success(module);
  }
}

Future<LuaCallResult?> _luaChar(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length == 0) {
    return const Success([]);
  }

  final buffer = StringBuffer();

  for (var i = 0; i < arguments.length; i++) {
    final codepoint = arguments.getInt(i);
    if (codepoint == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'utf8.char',
          order: i + 1,
          expected: 'integer',
        ),
      );
    }

    if (codepoint < 0 || codepoint > 0x10FFFF) {
      return Failure(
        LuaException.badArgumentError(
          function: 'utf8.char',
          order: i + 1,
          message: 'value out of range',
        ),
      );
    }

    // Invalid UTF-16 surrogates
    if (codepoint >= 0xD800 && codepoint <= 0xDFFF) {
      return Failure(
        LuaException.badArgumentError(
          function: 'utf8.char',
          order: i + 1,
          message: 'value out of range',
        ),
      );
    }

    buffer.writeCharCode(codepoint);
  }

  return Success([LuaString(buffer.toString())]);
}

Future<LuaCallResult?> _luaCodepoint(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'utf8.codepoint',
        expected: 'at least 1',
      ),
    );
  }

  final s = arguments.getString(0);
  if (s == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'utf8.codepoint',
        order: 1,
        expected: 'string',
      ),
    );
  }

  final start = arguments.getInt(1) ?? 1;
  final end = arguments.getInt(2) ?? start;

  // Convert to 0-based indices
  final startIdx = start - 1;
  final endIdx = end - 1;

  if (startIdx < 0 || startIdx >= s.length) {
    return Failure(
      LuaException.badArgumentError(
        function: 'utf8.codepoint',
        order: 2,
        message: 'out of range',
      ),
    );
  }

  if (endIdx < startIdx || endIdx >= s.length) {
    return Failure(
      LuaException.badArgumentError(
        function: 'utf8.codepoint',
        order: 3,
        message: 'out of range',
      ),
    );
  }

  final results = <LuaValue>[];
  final runes = s.runes.toList();

  // Find the rune indices corresponding to byte positions
  var bytePos = 0;
  var runeStart = -1;
  var runeEnd = -1;

  for (var i = 0; i < runes.length; i++) {
    if (bytePos == startIdx) {
      runeStart = i;
    }
    if (bytePos <= endIdx) {
      runeEnd = i;
    }

    // Calculate byte length of this rune
    final codePoint = runes[i];
    if (codePoint <= 0x7F) {
      bytePos += 1;
    } else if (codePoint <= 0x7FF) {
      bytePos += 2;
    } else if (codePoint <= 0xFFFF) {
      bytePos += 3;
    } else {
      bytePos += 4;
    }
  }

  if (runeStart < 0 || runeEnd < 0) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'invalid UTF-8 code',
      ),
    );
  }

  for (var i = runeStart; i <= runeEnd; i++) {
    results.add(LuaInteger.fromInt(runes[i]));
  }

  return Success(results);
}

Future<LuaCallResult?> _luaCodes(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'utf8.codes',
        expected: '1',
      ),
    );
  }

  final s = arguments.getString(0);
  if (s == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'utf8.codes',
        order: 1,
        expected: 'string',
      ),
    );
  }

  // Check for invalid UTF-8 sequence
  final invalidPos = LuaUtf8Module._findInvalidUtf8Byte(s);
  if (invalidPos != null) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'invalid UTF-8 code at position $invalidPos',
      ),
    );
  }

  var position = 0;
  final runes = s.runes.toList();
  var runeIndex = 0;

  // Iterator function
  Future<LuaCallResult?> iterator(
    LuaContext context,
    LuaArguments arguments,
  ) async {
    if (runeIndex >= runes.length) {
      return const Success([]);
    }

    final codePoint = runes[runeIndex];
    final currentPosition = position;

    // Calculate byte length of this rune
    if (codePoint <= 0x7F) {
      position += 1;
    } else if (codePoint <= 0x7FF) {
      position += 2;
    } else if (codePoint <= 0xFFFF) {
      position += 3;
    } else {
      position += 4;
    }

    runeIndex++;

    return Success([
      LuaInteger.fromInt(currentPosition + 1), // 1-based position
      LuaInteger.fromInt(codePoint),
    ]);
  }

  return Success([
    LuaNativeFunction('utf8.codes_iterator', iterator),
    LuaString(s),
    LuaInteger.fromInt(0),
  ]);
}

Future<LuaCallResult?> _luaLen(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'utf8.len',
        expected: '1 to 3',
      ),
    );
  }

  final s = arguments.getString(0);
  if (s == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'utf8.len',
        order: 1,
        expected: 'string',
      ),
    );
  }

  final start = arguments.getInt(1) ?? 1;
  final end = arguments.getInt(2) ?? -1;

  // Convert to 0-based indices
  var startIdx = start - 1;
  var endIdx = end < 0 ? s.length + end : end - 1;

  if (startIdx < 0) startIdx = 0;
  if (endIdx >= s.length) endIdx = s.length - 1;

  if (startIdx > endIdx) {
    return Success([LuaInteger.fromInt(0)]);
  }

  // Check for invalid UTF-8 sequence
  final invalidPos = LuaUtf8Module._findInvalidUtf8Byte(s);
  if (invalidPos != null) {
    return Success([LuaNil(), LuaInteger.fromInt(invalidPos)]);
  }

  try {
    // Validate UTF-8 and count characters
    final substring = s.substring(startIdx, endIdx + 1);
    final runes = substring.runes.toList();

    return Success([LuaInteger.fromInt(runes.length)]);
  } on Exception {
    // Invalid UTF-8
    return Success([LuaNil(), LuaInteger.fromInt(startIdx + 1)]);
  }
}

Future<LuaCallResult?> _luaOffset(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 2) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'utf8.offset',
        expected: '2 or 3',
      ),
    );
  }

  final s = arguments.getString(0);
  if (s == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'utf8.offset',
        order: 1,
        expected: 'string',
      ),
    );
  }

  final n = arguments.getInt(1);
  if (n == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'utf8.offset',
        order: 2,
        expected: 'integer',
      ),
    );
  }

  final utf8Bytes = utf8.encode(s);
  final utf8Length = utf8Bytes.length;
  final runes = s.runes.toList();

  // Get byte positions for each character
  final bytePositions = LuaUtf8Module._getUtf8BytePositions(s);

  // Simple case: return the byte position of the n-th character
  if (arguments.length < 3) {
    // No i parameter, start from beginning for positive n, end for negative n
    final targetCharIndex = n > 0 ? n - 1 : runes.length + n;

    if (targetCharIndex < 0 || targetCharIndex >= runes.length) {
      return Success([LuaNil()]);
    }

    return Success([LuaInteger.fromInt(bytePositions[targetCharIndex] + 1)]);
  }

  // Complex case with starting position i
  final i = arguments.getInt(2)!;

  if (n == 0) {
    // Return start of character at byte position i
    // Find which character contains byte i
    for (var charIdx = 0; charIdx < bytePositions.length - 1; charIdx++) {
      final start = bytePositions[charIdx] + 1; // Convert to 1-based
      final end = bytePositions[charIdx + 1]; // End is exclusive in 0-based

      if (i >= start && i <= end) {
        return Success([LuaInteger.fromInt(start)]);
      }
    }

    // Special case: position after last character
    if (i == utf8Length + 1) {
      return Success([LuaInteger.fromInt(utf8Length + 1)]);
    }

    return Success([LuaNil()]);
  }

  // Find character index for starting byte position i
  var startCharIndex = -1;
  for (var charIdx = 0; charIdx < bytePositions.length - 1; charIdx++) {
    final start = bytePositions[charIdx] + 1; // Convert to 1-based
    final end = bytePositions[charIdx + 1]; // End is exclusive in 0-based

    if (i >= start && i <= end) {
      startCharIndex = charIdx;
      break;
    }
  }

  // Special cases for boundary positions
  if (startCharIndex < 0) {
    if (i == 1) {
      startCharIndex = 0;
    } else if (i == utf8Length + 1) {
      startCharIndex = runes.length;
    } else {
      return Success([LuaNil()]);
    }
  }

  // Calculate target character index
  final targetCharIndex = startCharIndex + n;

  if (targetCharIndex < 0 || targetCharIndex >= runes.length) {
    return Success([LuaNil()]);
  }

  return Success([LuaInteger.fromInt(bytePositions[targetCharIndex] + 1)]);
}
