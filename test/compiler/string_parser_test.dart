import 'package:test/test.dart';
import 'package:tradaul/src/compiler/string_parser.dart';

void main() {
  test('parses a simple literal string correctly', () {
    const input = '"hello"';
    final result = LiteralStringParser.parse(input);
    expect(result.isSuccess(), isTrue);
    expect(result.getOrThrow(), 'hello');
  });

  group('Escape sequences', () {
    test('newline', () {
      const input = r'"he\nllo"';
      final result = LiteralStringParser.parse(input);
      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), 'he\nllo');
    });

    test('newline (line break)', () {
      const input = r'''
"he\
llo"
''';
      final result = LiteralStringParser.parse(input);
      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), 'he\nllo');
    });

    test('double quote', () {
      const input = r'"he\"llo"';
      final result = LiteralStringParser.parse(input);
      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), 'he"llo');
    });

    test('single quote', () {
      const input = r"'he\'llo'";
      final result = LiteralStringParser.parse(input);
      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), "he'llo");
    });

    test('backslash', () {
      const input = r'"he\\"';
      final result = LiteralStringParser.parse(input);
      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), r'he\');
    });

    test('invalid escape sequence', () {
      const input = r"'\p'";
      final result = LiteralStringParser.parse(input);
      expect(result.isSuccess(), isFalse);
    });

    test('decimal number', () {
      const input = r'"\97\98\99\100\101"';
      final result = LiteralStringParser.parse(input);
      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), 'abcde');
    });

    test('hex decimal number', () {
      const input = r'"\x68ello"';
      final result = LiteralStringParser.parse(input);
      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), 'hello');
    });

    group('code point', () {
      test('basic', () {
        const input = r'"\u{0041}lo"';
        final result = LiteralStringParser.parse(input);
        expect(result.isSuccess(), isTrue);
        expect(result.getOrThrow(), 'Alo');
      });
      test('large code point', () {
        const input = r'"\u{110000}"';
        final result = LiteralStringParser.parse(input);
        expect(result.isSuccess(), isTrue);
        expect(result.getOrThrow(), String.fromCharCodes([0x11, 0x00, 0x00]));
      });
      test('surrogate', () {
        const input = r'"\u{D7FF}"';
        final result = LiteralStringParser.parse(input);
        expect(result.isSuccess(), isTrue);
        expect(result.getOrThrow(), String.fromCharCodes([0xd7, 0xff]));
      });
    });
  });

  group('Long literal strings', () {
    test('parses a long literal string correctly', () {
      const input = '[[hello]]';
      final result = LiteralStringParser.parse(input);
      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), 'hello');
    });

    test('parses a long literal string with newlines correctly', () {
      const input = '[[hello\nworld]]';
      final result = LiteralStringParser.parse(input);
      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), 'hello\nworld');
    });

    test('parses a long literal string with equal sign and newlines correctly',
        () {
      const input = '[==[\nhello\nworld]==]';
      final result = LiteralStringParser.parse(input);
      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), 'hello\nworld');
    });
  });

  group('Invalid inputs', () {
    test('invalid string format', () {
      const input = 'hello"';
      final result = LiteralStringParser.parse(input);
      expect(result.isError(), isTrue);
      expect(result.exceptionOrNull(), isA<FormatException>());
    });

    test('mismatched long brackets', () {
      final inputs = ['[[hello]', '[==[hello]', '[==[hello]]', '[', '[='];
      for (final input in inputs) {
        final result = LiteralStringParser.parse(input);
        expect(result.isError(), isTrue);
        expect(result.exceptionOrNull(), isA<FormatException>());
      }
    });
  });

  group('Lua documentation examples', () {
    const expected = 'alo\n123"';

    test('single quoted string', () {
      const input = "'alo\\n123\"'";
      final result = LiteralStringParser.parse(input);
      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), expected);
    });

    test('double quoted string', () {
      const input = r'"alo\n123\""';
      final result = LiteralStringParser.parse(input);
      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), expected);
    });

    test('decimal escape sequence string', () {
      const input = "'\\97lo\\10\\04923\"'";
      final result = LiteralStringParser.parse(input);
      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), expected);
    });

    test('long literal string without equal sign', () {
      const input = '[[alo\n123"]]';
      final result = LiteralStringParser.parse(input);
      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), expected);
    });

    test('long literal string with equal sign', () {
      const input = '[==[\nalo\n123"]==]';
      final result = LiteralStringParser.parse(input);
      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow(), expected);
    });
  });
}
