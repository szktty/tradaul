import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

void main() {
  group('BigInt integration tests', () {
    test('LuaNumber.fromNum with BigInt creates LuaLargeInteger', () {
      final bigInt = BigInt.parse('123456789012345678901234567890');
      final luaNumber = LuaNumber.fromNum(bigInt);

      expect(luaNumber, isA<LuaLargeInteger>());
      expect((luaNumber as LuaLargeInteger).value, equals(bigInt));
    });

    test('LuaLargeInteger normalizes to LuaInteger when possible', () {
      final smallBigInt = BigInt.from(42);
      final luaLargeInt = LuaLargeInteger(smallBigInt);
      final normalized = luaLargeInt.normalize();

      expect(normalized, isA<LuaInteger>());
      expect((normalized as LuaInteger).value.toInt(), equals(42));
    });

    test('Very large BigInt remains as LuaLargeInteger', () async {
      final hugeBigInt = BigInt.parse('123456789012345678901234567890');
      final luaLargeInt = LuaLargeInteger(hugeBigInt);
      final normalized = luaLargeInt.normalize();

      expect(normalized, isA<LuaLargeInteger>());
      expect(normalized, same(luaLargeInt));
    });

    test('BigInt arithmetic operations work correctly', () {
      final a = LuaLargeInteger.fromString('123456789012345678901234567890');
      final b = LuaLargeInteger.fromString('987654321098765432109876543210');

      final sum = a.add(b);
      expect(
          sum.value, equals(BigInt.parse('1111111110111111111011111111100')));

      final product =
          LuaLargeInteger.fromInt(123).multiply(LuaLargeInteger.fromInt(456));
      expect(product.value, equals(BigInt.from(123 * 456)));
    });

    test('BigInt comparison operations work correctly', () {
      final small = LuaLargeInteger.fromInt(10);
      final large = LuaLargeInteger.fromInt(20);

      expect(small.isLessThan(large), isTrue);
      expect(large.isGreaterThan(small), isTrue);
      expect(small.isLessThanOrEqual(small), isTrue);
      expect(large.isGreaterThanOrEqual(large), isTrue);
    });

    test('BigInt bitwise operations work correctly', () {
      final a = LuaLargeInteger.fromInt(10); // binary 1010
      final b = LuaLargeInteger.fromInt(12); // binary 1100

      expect(a.bitwiseAnd(b).value, equals(BigInt.from(8))); // binary 1000
      expect(a.bitwiseOr(b).value, equals(BigInt.from(14))); // binary 1110
      expect(a.bitwiseXor(b).value, equals(BigInt.from(6))); // binary 0110
    });

    test('BigInt utility methods work correctly', () {
      final even = LuaLargeInteger.fromInt(42);
      final odd = LuaLargeInteger.fromInt(43);
      final negative = LuaLargeInteger.fromInt(-10);
      final zero = LuaLargeInteger.fromInt(0);
      final one = LuaLargeInteger.fromInt(1);

      expect(even.isEven, isTrue);
      expect(odd.isOdd, isTrue);
      expect(negative.isNegative, isTrue);
      expect(zero.isZero, isTrue);
      expect(one.isOne, isTrue);

      expect(negative.sign, equals(-1));
      expect(zero.sign, equals(0));
      expect(one.sign, equals(1));
    });
  });
}
