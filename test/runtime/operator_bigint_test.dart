import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

void main() {
  group('BigInt string parsing behavior', () {
    test('BigInt.parse with valid string succeeds', () {
      final result = BigInt.parse('123456789012345678901234567890');
      expect(result, equals(BigInt.parse('123456789012345678901234567890')));
    });

    test('BigInt.parse with invalid string throws FormatException', () {
      expect(() => BigInt.parse('not_a_number'), throwsFormatException);
    });

    test('BigInt.parse with empty string throws FormatException', () {
      expect(() => BigInt.parse(''), throwsFormatException);
    });

    test('BigInt.parse with whitespace string throws FormatException', () {
      expect(() => BigInt.parse('   '), throwsFormatException);
    });

    test('BigInt.parse with mixed string throws FormatException', () {
      expect(() => BigInt.parse('123abc'), throwsFormatException);
    });

    test('LuaNumber.fromNum with valid BigInt creates LuaLargeInteger', () {
      final bigInt = BigInt.parse('123456789012345678901234567890');
      final luaNumber = LuaNumber.fromNum(bigInt);
      
      expect(luaNumber, isA<LuaLargeInteger>());
      expect((luaNumber as LuaLargeInteger).value, equals(bigInt));
    });
  });
}
