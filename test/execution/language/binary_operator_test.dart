import 'dart:math';

import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

import 'init_context.dart';
import 'test.dart';

// ignore_for_file: require_trailing_commas

void main() {
  testInitContext();
  testBinaryArithmeticOperators();
  testBinaryBitwiseOperators();
  testBinaryRelationalOperators();
  testBinaryLogicalOperators();
  testBinaryOtherOperators();
  testOperatorPrecedence();
}

void testBinaryArithmeticOperators() {
  group('binary arithmetic operators', () {
    testBinaryOperator('addition', '+', [
      ['integer addition', 3, 2, 5],
      ['float addition', 3.5, 2.5, 6.0],
      ['integer and float addition', 3, 2.5, 5.5],
      ['integer and string addition', 3, '2', 5],
      ['string and integer addition', '3', 2, 5],
      ['float and string addition', 3.5, '2.5', 6.0],
      ['string and float addition', '3', 2.5, 5.5],
      ['string and string addition', '3', '2', 5]
    ]);

    testBinaryOperator('subtraction', '-', [
      ['integer subtraction', 3, 2, 1],
      ['float subtraction', 3.5, 2.5, 1.0],
      ['integer and float subtraction', 3, 2.5, 0.5],
      ['integer and string subtraction', 3, '2', 1],
      ['string and integer subtraction', '3', 2, 1],
      ['float and string subtraction', 3.5, '2.5', 1.0],
      ['string and float subtraction', '3', 2.5, 0.5],
      ['string and string subtraction', '3', '2', 1]
    ]);

    testBinaryOperator('multiplication', '*', [
      ['integer multiplication', 3, 2, 6],
      ['float multiplication', 3.5, 2.5, 8.75],
      ['integer and float multiplication', 3, 2.5, 7.5],
      ['integer and string multiplication', 3, '2', 6],
      ['string and integer multiplication', '3', 2, 6],
      ['float and string multiplication', 3.5, '2.5', 8.75],
      ['string and float multiplication', '3', 2.5, 7.5],
      ['string and string multiplication', '3', '2', 6]
    ]);

    testBinaryOperator('float division', '/', [
      ['integer float division', 3, 2, 1.5],
      ['float float division', 3.5, 2.5, 1.4],
      ['integer and float float division', 3, 2.5, 1.2],
      ['integer and string float division', 3, '2', 1.5],
      ['string and integer float division', '3', 2, 1.5],
      ['float and string float division', 3.5, '2.5', 1.4],
      ['string and float float division', '3', 2.5, 1.2],
      ['string and string float division', '3', '2', 1.5],
      ['negative float division', -16, 3, -5.333333333333333],
    ]);

    testBinaryOperator('floor division', '//', [
      ['integer floor division', 3, 2, 1],
      ['float floor division', 3.5, 2.5, 1.0],
      ['negative float floor division', 3.5, -1.5, -3.0],
      ['integer and float floor division', 7, 2.5, 2.0],
      ['integer and string floor division', 3, '2', 1],
      ['string and integer floor division', '3', 2, 1],
      ['float and string floor division', 3.5, '2.5', 1.0],
      ['string and float floor division', '3', 2.5, 1.0],
      ['string and string floor division', '3', '2', 1],
      ['negative float division 1', -16, 3, -6],
      ['negative float division 2', -16, -15, 1],
    ]);

    testBinaryOperator('modulo', '%', [
      ['integer modulo', 7, 3, 1],
      ['float modulo', 7.5, 2.5, 0.0],
      ['integer and float modulo', 7, 2.5, 2.0],
      ['integer and string modulo', 7, '3', 1],
      ['string and integer modulo', '7', 3, 1],
      ['float and string modulo', 7.5, '2.5', 0.0],
      ['string and float modulo', '7.5', 2.5, 0.0],
      ['string and string modulo', '7', '3', 1]
    ]);

    testBinaryOperator('exponentiation', '^', [
      ['integer exponentiation', 3, 2, 9.0],
      ['float exponentiation', 3.5, 2.5, pow(3.5, 2.5)],
      ['integer and float exponentiation', 3, 2.5, pow(3, 2.5)],
      ['integer and string exponentiation', 3, '2', 9.0],
      ['string and integer exponentiation', '3', 2, 9.0],
      ['float and string exponentiation', 3.5, '2.5', pow(3.5, 2.5)],
      ['string and float exponentiation', '3', 2.5, pow(3, 2.5)],
      ['string and string exponentiation', '3', '2', 9.0]
    ]);
  });
}

void testBinaryRelationalOperators() {
  group('binary relational operators', () {
    group('> operator ', () {
      testBinaryOperator('basic numerical comparisons', '>', [
        ['integer less', 3, 2, true],
        ['integer greater', 2, 3, false],
        ['floating point less', 3.5, 2.5, true],
        ['floating point greater', 2.5, 3.5, false],
        ['integer to floating point less', 3, 2.5, true],
        ['integer to floating point greater', 2.5, 3, false]
      ]);

      testBinaryOperator('negative number comparisons', '>', [
        ['negative integer to positive integer', -3, 2, false],
        ['positive integer to negative integer', 3, -2, true],
        [
          'negative floating point to positive floating point',
          -3.5,
          2.5,
          false
        ],
        ['positive floating point to negative floating point', 3.5, -2.5, true]
      ]);

      testBinaryOperator('comparisons with zero', '>', [
        ['integer zero greater', 0, 3, false],
        ['negative integer to zero', -3, 0, false],
        ['floating point zero greater', 0.0, 3.5, false],
        ['negative floating point to zero', -3.5, 0.0, false]
      ]);

      testBinaryOperator('same value comparisons', '>', [
        ['same integer', 3, 3, false],
        ['same floating point', 3.5, 3.5, false]
      ]);

      testBinaryOperator('string comparisons', '>', [
        ['basic string less', '3', '2', true],
        ['basic string less', '3', '3', false],
        ['basic string less', '3', '9', false],
        ['basic string greater', '3', '10', true],
        ['alphabetical string', 'apple', 'banana', false]
      ]);
    });

    group('>= operator', () {
      testBinaryOperator('basic numerical comparisons', '>=', [
        ['integer less or equal', 3, 2, true],
        ['integer greater or equal', 2, 3, false],
        ['floating point less or equal', 3.5, 2.5, true],
        ['floating point greater or equal', 2.5, 3.5, false],
        ['integer to floating point less or equal', 3, 2.5, true],
        ['integer to floating point greater or equal', 2.5, 3, false]
      ]);

      testBinaryOperator('negative number comparisons', '>=', [
        ['negative integer to positive integer', -3, 2, false],
        ['positive integer to negative integer', 3, -2, true],
        [
          'negative floating point to positive floating point',
          -3.5,
          2.5,
          false
        ],
        ['positive floating point to negative floating point', 3.5, -2.5, true]
      ]);

      testBinaryOperator('comparisons with zero', '>=', [
        ['integer zero greater or equal', 0, 3, false],
        ['negative integer to zero', -3, 0, false],
        ['floating point zero greater or equal', 0.0, 3.5, false],
        ['negative floating point to zero', -3.5, 0.0, false]
      ]);

      testBinaryOperator('same value comparisons', '>=', [
        ['same integer', 3, 3, true],
        ['same floating point', 3.5, 3.5, true]
      ]);

      testBinaryOperator('string comparisons', '>=', [
        ['basic string less or equal', '3', '2', true],
        ['basic string greater or equal', '3', '10', true],
        ['alphabetical string', 'apple', 'banana', false]
      ]);
    });

    group('< operator', () {
      testBinaryOperator('basic numerical comparisons', '<', [
        ['integer less', 3, 2, false],
        ['integer greater', 2, 3, true],
        ['floating point less', 3.5, 2.5, false],
        ['floating point greater', 2.5, 3.5, true],
        ['integer to floating point less', 3, 2.5, false],
        ['integer to floating point greater', 2.5, 3, true]
      ]);

      testBinaryOperator('negative number comparisons', '<', [
        ['negative integer to positive integer', -3, 2, true],
        ['positive integer to negative integer', 3, -2, false],
        ['negative floating point to positive floating point', -3.5, 2.5, true],
        ['positive floating point to negative floating point', 3.5, -2.5, false]
      ]);

      testBinaryOperator('comparisons with zero', '<', [
        ['integer zero less', 0, 3, true],
        ['negative integer to zero', -3, 0, true],
        ['floating point zero less', 0.0, 3.5, true],
        ['negative floating point to zero', -3.5, 0.0, true]
      ]);

      testBinaryOperator('same value comparisons', '<', [
        ['same integer', 3, 3, false],
        ['same floating point', 3.5, 3.5, false]
      ]);

      testBinaryOperator('string comparisons', '<', [
        ['basic string less', '3', '2', false],
        ['basic string greater', '3', '10', false],
        ['alphabetical string', 'apple', 'banana', true]
      ]);
    });

    group('<= operator', () {
      testBinaryOperator('basic numerical comparisons', '<=', [
        ['integer less', 3, 2, false],
        ['integer greater', 2, 3, true],
        ['floating point less', 3.5, 2.5, false],
        ['floating point greater', 2.5, 3.5, true],
        ['integer to floating point less', 3, 2.5, false],
        ['integer to floating point greater', 2.5, 3, true]
      ]);

      testBinaryOperator('negative number comparisons', '<=', [
        ['negative integer to positive integer', -3, 2, true],
        ['positive integer to negative integer', 3, -2, false],
        ['negative floating point to positive floating point', -3.5, 2.5, true],
        ['positive floating point to negative floating point', 3.5, -2.5, false]
      ]);

      testBinaryOperator('comparisons with zero', '<=', [
        ['integer zero less', 0, 3, true],
        ['negative integer to zero', -3, 0, true],
        ['floating point zero less', 0.0, 3.5, true],
        ['negative floating point to zero', -3.5, 0.0, true]
      ]);

      testBinaryOperator('same value comparisons', '<=', [
        ['same integer', 3, 3, true],
        ['same floating point', 3.5, 3.5, true]
      ]);

      testBinaryOperator('string comparisons', '<=', [
        ['basic string less', '3', '2', false],
        ['basic string greater', '3', '10', false],
        ['alphabetical string', 'apple', 'banana', true]
      ]);
    });

    group('== operator ', () {
      testBinaryOperator('basic numerical comparisons', '==', [
        ['same integer', 3, 3, true],
        ['different integer', 3, 4, false],
        ['same floating point', 3.5, 3.5, true],
        ['different floating point', 3.5, 4.5, false],
        ['integer to floating point', 3, 3.0, true],
        ['floating point to integer', 3.0, 3, true],
      ]);

      testBinaryOperator('negative number comparisons', '==', [
        ['negative integer to positive integer', -3, 3, false],
        ['negative floating point to positive floating point', -3.5, 3.5, false]
      ]);

      testBinaryOperator('comparisons with zero', '==', [
        ['integer zero', 0, 3, false],
        ['negative integer to zero', 0, -3, false],
        ['floating point zero', 0.0, 3.5, false],
        ['negative floating point to zero', 0.0, -3.5, false]
      ]);

      testBinaryOperator('string comparisons', '==', [
        ['same string', 'hello', 'hello', true],
        ['different string', 'hello', 'world', false],
        ['different length string', 'hello', 'hell', false]
      ]);

      testBinaryOperator('boolean comparisons', '==', [
        ['true and true', true, true, true],
        ['false and false', false, false, true],
        ['true and false', true, false, false]
      ]);

      testBinaryOperator('mixed type comparisons', '==', [
        ['string and integer', '3', 3, false],
        ['string and floating point', '3.5', 3.5, false]
      ]);

      testBinaryOperator('nil comparisons', '==', [
        ['nil and integer', null, 3, false],
        ['nil and string', null, 'nil', false],
        ['nil and boolean', null, true, false],
        ['nil and nil', null, null, true]
      ]);
    });
  });
}

void testBinaryBitwiseOperators() {
  group('binary bitwise operators', () {
    testBinaryOperator('bitwise AND', '&', [
      ['basic bitwise AND', 5, 3, 1],
      ['all bits on', 0xFF, 0xFF, 0xFF],
      ['no bits on', 0x00, 0xFF, 0x00],
      ['float', 5.0, 3.0, 1],
    ]);

    testBinaryOperator('bitwise OR', '|', [
      ['basic bitwise OR', 5, 3, 7],
      ['all bits off', 0x00, 0xFF, 0xFF],
      ['no bits changed', 0xFF, 0xFF, 0xFF],
      ['float', 5.0, 3.0, 7],
    ]);

    testBinaryOperator('bitwise XOR', '~', [
      ['basic bitwise XOR', 5, 3, 6],
      ['same values', 0xFF, 0xFF, 0x00],
      ['opposite values', 0x00, 0xFF, 0xFF],
      ['float', 5.0, 3.0, 6],
    ]);

    testBinaryOperator('right shift', '>>', [
      ['basic right shift', 8, 1, 4],
      ['negative displacement', 8, -1, 16],
      ['shift all out', 8, 8, 0],
      ['float', 8.0, 1.0, 4],
    ]);

    testBinaryOperator('left shift', '<<', [
      ['basic left shift', 4, 1, 8],
      ['negative displacement', 8, -1, 4],
      ['shift all out', 8, -8, 0],
      ['float', 4.0, 1.0, 8],
    ]);
  });
}

void testBinaryLogicalOperators() {
  group('binary logical operators', () {
    group('and', () {
      testBinaryOperator('basic', 'and', [
        ['true and true', true, true, true],
        ['true and false', true, false, false],
        ['false and true', false, true, false],
        ['false and false', false, false, false]
      ]);

      testBinaryOperator('with nil', 'and', [
        ['true and nil', true, null, null],
        ['nil and true', null, true, null],
        ['nil and false', null, false, null],
        ['false and nil', false, null, false],
        ['nil and nil', null, null, null]
      ]);

      testBinaryOperator('non-bool left operand', 'and', [
        ['integer and true', 10, true, true],
        ['integer and false', 10, false, false],
        ['integer and nil', 10, null, null],
        ['integer (0) and true', 0, true, true],
        ['empty string and true', '', true, true],
        ['string and true', 'hello', true, true],
        ['nil and string', null, 'world', null]
      ]);

      testBinaryOperator('non-bool right operand', 'and', [
        ['true and integer', true, 10, 10],
        ['false and integer', false, 10, false],
        ['true and string', true, 'hello', 'hello'],
        ['false and string', false, 'hello', false]
      ]);

      group('short-circuit', () {
        test('first true', () async {
          expect(
            await luaExecute('return true and update(), count'),
            luaEquals([1, 1]),
          );
        });

        test('first false', () async {
          expect(
            await luaExecute('return false and update(), count'),
            luaEquals([false, 0]),
          );
        });
      });
    });

    group('or', () {
      testBinaryOperator('basic', 'or', [
        ['true or true', true, true, true],
        ['true or false', true, false, true],
        ['false or true', false, true, true],
        ['false or false', false, false, false]
      ]);

      testBinaryOperator('with nil', 'or', [
        ['true or nil', true, null, true],
        ['nil or true', null, true, true],
        ['nil or false', null, false, false],
        ['false or nil', false, null, null],
        ['nil or nil', null, null, null]
      ]);

      testBinaryOperator('non-bool left operand', 'or', [
        ['integer or true', 10, true, 10],
        ['integer or false', 10, false, 10],
        ['integer or nil', 10, null, 10],
        ['integer (0) or true', 0, true, 0],
        ['empty string or true', '', true, ''],
        ['string or true', 'hello', true, 'hello'],
        ['nil or string', null, 'world', 'world']
      ]);

      testBinaryOperator('non-bool right operand', 'or', [
        ['true or integer', true, 10, true],
        ['false or integer', false, 10, 10],
        ['true or string', true, 'hello', true],
        ['false or string', false, 'hello', 'hello']
      ]);

      group('short-circuit', () {
        test('first true', () async {
          expect(
            await luaExecute('return true or update(), count'),
            luaEquals([true, 0]),
          );
        });

        test('first false', () async {
          expect(
            await luaExecute('return false or update(), count'),
            luaEquals([1, 1]),
          );
        });
      });
    });
  });
}

void testBinaryOtherOperators() {
  group('binary other operators', () {
    testBinaryOperator('string concatenation (..)', '..', [
      ['two strings', 'hello', ' world', 'hello world'],
      ['string and number', 'hello', 5, 'hello5'],
      ['number and string', 5, 'hello', '5hello'],
      ['empty string and string', '', 'world', 'world'],
      ['string and empty string', 'hello', '', 'hello'],
      ['two numbers', 5, 3, '53'],
      ['two empty strings', '', '', ''],
    ]);
  });
}

void testOperatorPrecedence() {
  group('operator precedence', () {
    test('or, and', () async {
      expect(await luaExecute('return true or false and false'),
          luaEquals([true]));
      expect(await luaExecute('return (true or false) and false'),
          luaEquals([false]));
      expect(await luaExecute('return true or (false and false)'),
          luaEquals([true]));
    });

    test('and, relational', () async {
      expect(await luaExecute('return false and 3 < 2'), luaEquals([false]));
      expect(await luaExecute('return false and (3 < 2)'), luaEquals([false]));
      expect(() async => luaExecute('return (false and 3) < 2'),
          throwsA(isA<LuaException>()));
    });

    test('|', () async {
      expect(await luaExecute('return 1 | 2 == 3'), luaEquals([true]));
    });

    test('~', () async {
      expect(await luaExecute('return 1 ~ 2 | 3'), luaEquals([3]));
    });

    test('&', () async {
      expect(await luaExecute('return 1 & 2 ~ 3'), luaEquals([3]));
    });

    test('<<, >>', () async {
      expect(await luaExecute('return 1 << 2 << 3'), luaEquals([32]));
      expect(await luaExecute('return 1 << 2 >> 3'), luaEquals([0]));
      expect(await luaExecute('return 1 << 2 & 3'), luaEquals([0]));
    });

    test('..', () async {
      expect(await luaExecute('return "1" .. "2" * "3"'), luaEquals(['16']));
      expect(await luaExecute('return ("1" .. "2") * "3"'), luaEquals([36]));
      expect(await luaExecute('return "1" .. ("2" * "3")'), luaEquals(['16']));
    });

    test('+', () async {
      expect(await luaExecute('return 1 + 2 * 3'), luaEquals([7]));
      expect(await luaExecute('return (1 + 2) * 3'), luaEquals([9]));
      expect(await luaExecute('return 1 + (2 * 3)'), luaEquals([7]));
    });

    test('-', () async {
      expect(await luaExecute('return 5 - 3 - 1'), luaEquals([1]));
      expect(await luaExecute('return (5 - 3) - 1'), luaEquals([1]));
      expect(await luaExecute('return 5 - (3 - 1)'), luaEquals([3]));
    });

    test('*', () async {
      expect(await luaExecute('return 2 - 3 * 4'), luaEquals([-10]));
      expect(await luaExecute('return 2 * 3 - 4'), luaEquals([2]));
    });

    test('/', () async {
      expect(await luaExecute('return 12 / 3 / 2'), luaEquals([2.0]));
      expect(await luaExecute('return (12 / 3) / 2'), luaEquals([2.0]));
      expect(await luaExecute('return 12 / (3 / 2)'), luaEquals([8.0]));
    });

    test('//', () async {
      expect(await luaExecute('return 12 // 5 // 2'), luaEquals([1]));
      expect(await luaExecute('return (12 // 5) // 2'), luaEquals([1]));
      expect(await luaExecute('return 12 // (5 // 2)'), luaEquals([6]));
    });

    test('%', () async {
      expect(await luaExecute('return 12 % 5 % 3'), luaEquals([2]));
      expect(await luaExecute('return (12 % 5) % 3'), luaEquals([2]));
      expect(await luaExecute('return 12 % (5 % 3)'), luaEquals([0]));
    });

    test('unary -', () async {
      expect(await luaExecute('return -2 * 3'), luaEquals([-6]));
      expect(await luaExecute('return -2 + 3 * 3'), luaEquals([7]));
    });

    test('^, *', () async {
      expect(await luaExecute('return 3 ^ 2 * 3'), luaEquals([27.0]));
      expect(await luaExecute('return (3 ^ 2) * 3'), luaEquals([27.0]));
      expect(await luaExecute('return 3 ^ (2 * 3)'), luaEquals([729.0]));
    });

    test('^, ^', () async {
      expect(await luaExecute('return 2 ^ 2 ^ 3'), luaEquals([256.0]));
      expect(await luaExecute('return 2 ^ (2 ^ 3)'), luaEquals([256.0]));
      expect(await luaExecute('return (2 ^ 2) ^ 3'), luaEquals([64.0]));
    });

    test('^, unary -', () async {
      expect(await luaExecute('return ~3 ^ 2'), luaEquals([-10]));
      expect(await luaExecute('return ~(3 ^ 2)'), luaEquals([-10]));
      expect(await luaExecute('return (~3) ^ 2'), luaEquals([16.0]));
      expect(await luaExecute('return -2 ^ -2 ^ -2'),
          luaEquals([-0.8408964152537145]));
    });
  });
}
