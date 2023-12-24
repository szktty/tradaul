import 'package:result_dart/result_dart.dart';

class LiteralStringParser {
  LiteralStringParser(this.input);

  static Result<String, Exception> parse(String input) {
    try {
      final parser = LiteralStringParser(input);
      return Success(parser._parse());
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  String input;
  int position = 0;

  String _parse() {
    if (input.isEmpty ||
        (input[0] != '"' && input[0] != "'" && input[0] != '[')) {
      throw const FormatException('Invalid string format');
    }

    position++;
    final result = StringBuffer();

    // Long bracket string
    if (input[0] == '[') {
      _handleLongBracket(result, position);
    }
    // Short string
    else {
      final quoteChar = input[0];
      while (position < input.length - 1 && input[position] != quoteChar) {
        final currentChar = input[position];
        if (currentChar == r'\') {
          position++;
          result.write(_handleEscapeSequence());
        } else {
          result.write(currentChar);
          position++;
        }
      }
      if (position >= input.length || input[position] != quoteChar) {
        throw const FormatException('Mismatched quotes');
      }
      position++;
    }

    return result.toString();
  }

  String _handleEscapeSequence() {
    final currentChar = input[position];
    position++;
    switch (currentChar) {
      case 'a':
        return 'a';
      case 'b':
        return '\b';
      case 'f':
        return '\f';
      case 'n':
        return '\n';
      case '\n':
        return '\n';
      case 'r':
        return '\r';
      case 't':
        return '\t';
      case 'v':
        return '\v';
      case r'\':
        return r'\';
      case "'":
        return "'";
      case '"':
        return '"';
      case 'z':
        _skipWhitespace();
        return '';
      case 'x':
        return _parseHexEscapeSequence();
      case 'u':
        return _parseUnicodeEscapeSequence();
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        return _parseDecimalEscapeSequence(currentChar);
      default:
        throw const FormatException('Invalid escape sequence');
    }
  }

  String _parseHexEscapeSequence() {
    // Ensure that there are at least two characters after '\x'
    if (position + 2 > input.length) {
      throw const FormatException('Invalid hex escape sequence');
    }

    final hexString = input.substring(position, position + 2);
    position += 2;

    final codeUnit = int.tryParse(hexString, radix: 16);
    if (codeUnit == null) {
      throw FormatException('Invalid hex escape sequence: $hexString');
    }

    return String.fromCharCode(codeUnit);
  }

  String _parseUnicodeEscapeSequence() {
    // Ensure that there are at least 3 characters after '\u'
    if (position + 3 > input.length || input[position] != '{') {
      throw const FormatException('Invalid Unicode escape sequence');
    }
    position++;

    final closingBraceIndex = input.indexOf('}', position);
    if (closingBraceIndex == -1) {
      throw const FormatException('Invalid Unicode escape sequence');
    }

    final hexString = input.substring(position, closingBraceIndex);
    position = closingBraceIndex + 1;

    final codePoint = int.tryParse(hexString, radix: 16);
    if (codePoint == null) {
      throw FormatException('Invalid Unicode escape sequence: $hexString');
    }

    final bytes = <int>[];
    for (var n = codePoint; n > 0; n >>= 8) {
      bytes.add(n & 0xFF);
    }
    return String.fromCharCodes(bytes.reversed);
  }

  String _parseDecimalEscapeSequence(String firstChar) {
    var decimalString = firstChar;
    while (position < input.length &&
        int.tryParse(input[position]) != null &&
        decimalString.length < 3) {
      decimalString += input[position];
      position++;
    }

    final codeUnit = int.tryParse(decimalString);
    if (codeUnit == null) {
      throw FormatException('Invalid decimal escape sequence: $decimalString');
    }

    return String.fromCharCode(codeUnit);
  }

  void _handleLongBracket(StringBuffer result, int bracketStart) {
    var bracketLevel = 0;
    while (bracketStart + bracketLevel < input.length &&
        input[bracketStart + bracketLevel] == '=') {
      bracketLevel++;
    }
    if (bracketStart + bracketLevel >= input.length ||
        input[bracketStart + bracketLevel] != '[') {
      throw const FormatException('Invalid long bracket start');
    }

    // Skip the opening long bracket and newlines
    position = bracketStart + bracketLevel + 1;
    while (position < input.length &&
        (input[position] == '\r' || input[position] == '\n')) {
      position++;
    }

    while (position < input.length) {
      if (input[position] == ']') {
        var offset = 1;
        while (position + offset < input.length &&
            offset <= bracketLevel &&
            input[position + offset] == '=') {
          offset++;
        }
        if (position + offset < input.length &&
            offset - 1 == bracketLevel &&
            input[position + offset] == ']') {
          // Found matching closing long bracket
          position += bracketLevel + 2; // Skip the closing long bracket
          return;
        }
      }
      result.write(input[position]);
      position++;
    }

    throw const FormatException('Mismatched long brackets');
  }

  void _skipWhitespace() {
    while (position < input.length &&
        (input[position] == ' ' || input[position] == '\n')) {
      position++;
    }
  }
}
