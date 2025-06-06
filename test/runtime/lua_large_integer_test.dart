import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

void main() {
  group('LuaLargeInteger', () {
    test('construction from BigInt', () {
      final bigInt = BigInt.parse('123456789012345678901234567890');
      final luaLargeInt = LuaLargeInteger(bigInt);

      expect(luaLargeInt.value, equals(bigInt));
      expect(luaLargeInt.isInteger, isTrue);
      expect(luaLargeInt.luaType, equals(LuaValueType.number));
    });

    test('construction from int', () {
      final luaLargeInt = LuaLargeInteger.fromInt(42);

      expect(luaLargeInt.value, equals(BigInt.from(42)));
      expect(luaLargeInt.isInteger, isTrue);
    });

    test('construction from string', () {
      final luaLargeInt =
          LuaLargeInteger.fromString('987654321098765432109876543210');

      expect(luaLargeInt.value,
          equals(BigInt.parse('987654321098765432109876543210')));
      expect(luaLargeInt.isInteger, isTrue);
    });

    test('equality with LuaLargeInteger', () {
      final a = LuaLargeInteger.fromString('123456789');
      final b = LuaLargeInteger.fromString('123456789');
      final c = LuaLargeInteger.fromString('987654321');

      expect(a.luaEquals(b), isTrue);
      expect(a.luaEquals(c), isFalse);
    });

    test('equality with LuaInteger', () {
      final largeInt = LuaLargeInteger.fromInt(42);
      final regularInt = LuaInteger.fromInt(42);
      final differentInt = LuaInteger.fromInt(24);

      expect(largeInt.luaEquals(regularInt), isTrue);
      expect(largeInt.luaEquals(differentInt), isFalse);
    });

    test('equality with LuaFloat', () {
      final largeInt = LuaLargeInteger.fromInt(42);
      final floatExact = LuaFloat(42);
      final floatDifferent = LuaFloat(42.5);

      expect(largeInt.luaEquals(floatExact), isTrue);
      expect(largeInt.luaEquals(floatDifferent), isFalse);
    });

    test('toRegularInteger when fits in Int64', () {
      final largeInt = LuaLargeInteger.fromInt(42);
      final regularInt = largeInt.toRegularInteger();

      expect(regularInt, isNotNull);
      expect(regularInt!.value.toInt(), equals(42));
    });

    test('toRegularInteger when too large', () {
      final largeInt =
          LuaLargeInteger.fromString('123456789012345678901234567890');
      final regularInt = largeInt.toRegularInteger();

      expect(regularInt, isNull);
    });

    test('normalize returns LuaInteger when possible', () {
      final largeInt = LuaLargeInteger.fromInt(42);
      final normalized = largeInt.normalize();

      expect(normalized, isA<LuaInteger>());
      expect((normalized as LuaInteger).value.toInt(), equals(42));
    });

    test('normalize returns self when too large', () {
      final largeInt =
          LuaLargeInteger.fromString('123456789012345678901234567890');
      final normalized = largeInt.normalize();

      expect(normalized, same(largeInt));
    });

    test('arithmetic operations', () {
      final a = LuaLargeInteger.fromString('123456789012345678901234567890');
      final b = LuaLargeInteger.fromString('987654321098765432109876543210');

      final sum = a.add(b);
      expect(
          sum.value, equals(BigInt.parse('1111111110111111111011111111100')));

      final diff = b.subtract(a);
      expect(
          diff.value, equals(BigInt.parse('864197532086419753208641975320')));

      final product =
          LuaLargeInteger.fromInt(123).multiply(LuaLargeInteger.fromInt(456));
      expect(product.value, equals(BigInt.from(123 * 456)));
    });

    test('bitwise operations', () {
      final a = LuaLargeInteger.fromInt(10); // 0b1010
      final b = LuaLargeInteger.fromInt(12); // 0b1100

      expect(a.bitwiseAnd(b).value, equals(BigInt.from(8))); // 0b1000
      expect(a.bitwiseOr(b).value, equals(BigInt.from(14))); // 0b1110
      expect(a.bitwiseXor(b).value, equals(BigInt.from(6))); // 0b0110
      expect(a.bitwiseNot().value, equals(~BigInt.from(10))); // ~0b1010
    });

    test('shift operations', () {
      final value = LuaLargeInteger.fromInt(8); // 0b1000

      expect(value.shiftLeft(2).value, equals(BigInt.from(32))); // 0b100000
      expect(value.shiftRight(1).value, equals(BigInt.from(4))); // 0b100
    });

    test('comparison operations', () {
      final a = LuaLargeInteger.fromInt(10);
      final b = LuaLargeInteger.fromInt(20);

      expect(a.isLessThan(b), isTrue);
      expect(b.isGreaterThan(a), isTrue);
      expect(a.isLessThanOrEqual(a), isTrue);
      expect(b.isGreaterThanOrEqual(b), isTrue);
    });

    test('utility methods', () {
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

    test('string representation', () {
      final largeInt =
          LuaLargeInteger.fromString('123456789012345678901234567890');

      expect(largeInt.toString(), equals('#123456789012345678901234567890'));
      expect(
          largeInt.luaRepresentation, equals('123456789012345678901234567890'));
    });

    test('LuaNumber.fromNum with BigInt', () {
      final bigInt = BigInt.parse('123456789012345678901234567890');
      final luaNumber = LuaNumber.fromNum(bigInt);

      expect(luaNumber, isA<LuaLargeInteger>());
      expect((luaNumber as LuaLargeInteger).value, equals(bigInt));
    });
  });
}
