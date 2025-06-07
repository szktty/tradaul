import 'package:test/test.dart';
import 'package:tradaul/src/parser/parser.dart';

void main() {
  group('Whitespace parsing tests', () {
    test('should parse identifier followed by vertical tab and form feed', () {
      // Use actual control characters instead of escape sequences
      final input = 'x \v\f = \t\r \'a\x00a\' \v\f\f';
      final parser = LuaParser(input: input);
      final result = parser.parse();
      
      expect(
        result.isSuccess(),
        isTrue,
        reason: 'Should parse successfully: ${result.exceptionOrNull()}',
      );
    });

    test('should parse simple assignment with vertical tab', () {
      final parser = LuaParser(input: 'x\v=\v1');
      final result = parser.parse();
      
      expect(
        result.isSuccess(),
        isTrue,
        reason: 'Should parse simple assignment with vertical tab: '
            '${result.exceptionOrNull()}',
      );
    });

    test('should parse simple assignment with form feed', () {
      final parser = LuaParser(input: 'x\f=\f1');
      final result = parser.parse();
      
      expect(
        result.isSuccess(),
        isTrue,
        reason: 'Should parse simple assignment with form feed: '
            '${result.exceptionOrNull()}',
      );
    });

    test('should handle string literals with escape sequences', () {
      final parser = LuaParser(input: "x = 'a\\0a'");
      final result = parser.parse();
      
      expect(
        result.isSuccess(),
        isTrue,
        reason: 'Should parse string with null character: '
            '${result.exceptionOrNull()}',
      );
    });
  });
}