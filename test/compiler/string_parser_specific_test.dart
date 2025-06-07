import 'package:test/test.dart';
import 'package:tradaul/src/compiler/string_parser.dart';

void main() {
  group('String parser tests', () {
    test('should parse escape sequences correctly', () {
      final result = LiteralStringParser.parse('"\\\\v\\\\f"');
      expect(result.isSuccess(), isTrue);
      
      final parsed = result.getOrThrow();
      expect(parsed.length, equals(2));
      expect(parsed.codeUnitAt(0), equals(11)); // \v = vertical tab
      expect(parsed.codeUnitAt(1), equals(12)); // \f = form feed
    });

    test('should parse single escape sequences', () {
      final result1 = LiteralStringParser.parse('"\\\\v"');
      expect(result1.isSuccess(), isTrue);
      expect(result1.getOrThrow().codeUnitAt(0), equals(11));
      
      final result2 = LiteralStringParser.parse('"\\\\f"');
      expect(result2.isSuccess(), isTrue);
      expect(result2.getOrThrow().codeUnitAt(0), equals(12));
    });

    test('should parse basic escape sequences', () {
      final result = LiteralStringParser.parse('"\\\\t\\\\n"');
      expect(result.isSuccess(), isTrue);
      
      final parsed = result.getOrThrow();
      expect(parsed.length, equals(2));
      expect(parsed.codeUnitAt(0), equals(9));  // \t = tab
      expect(parsed.codeUnitAt(1), equals(10)); // \n = newline
    });
  });
}