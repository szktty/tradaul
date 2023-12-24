import 'dart:math' as math;

import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

import '../language/test.dart';

void main() {
  group('math module', () {
    group('functions', () {
      group('math.abs', () {
        test('with integer', () async {
          expect(await luaExecute('return math.abs(-5)'), luaEquals([5]));
        });

        test('with float', () async {
          expect(await luaExecute('return math.abs(-3.5)'), luaEquals([3.5]));
        });

        test('with string', () async {
          expect(await luaExecute('return math.abs("-5")'), luaEquals([5]));
        });
      });

      group('math.acos', () {
        test('with valid argument', () async {
          expect(
            await luaExecute('return math.acos(0)'),
            luaEquals([math.acos(0)]),
          );
        });

        test('with valid argument', () async {
          expect(
            await luaExecute('return math.acos(2)'),
            luaEquals([luaIsNaN()]),
          );
        });
      });

      group('math.asin', () {
        test('with valid argument', () async {
          expect(
            await luaExecute('return math.asin(0)'),
            luaEquals([math.asin(0)]),
          );
        });

        test('with invalid argument', () async {
          expect(
            await luaExecute('return math.asin(2)'),
            luaEquals([luaIsNaN()]),
          );
        });
      });

      group('math.atan', () {
        test('with valid argument', () async {
          expect(
            await luaExecute('return math.atan(1)'),
            luaEquals([math.atan(1)]),
          );
        });

        test('with two arguments', () async {
          expect(
            await luaExecute('return math.atan(1, 1)'),
            luaEquals([math.atan2(1, 1)]),
          );
        });
      });

      group('math.ceil', () {
        test('with integer', () async {
          expect(await luaExecute('return math.ceil(3)'), luaEquals([3]));
        });

        test('with float', () async {
          expect(await luaExecute('return math.ceil(3.5)'), luaEquals([4]));
        });
      });

      group('math.cos', () {
        test('with valid argument', () async {
          expect(
            await luaExecute('return math.cos(0)'),
            luaEquals([math.cos(0)]),
          );
        });
      });

      group('math.deg', () {
        test('with valid argument', () async {
          expect(
            await luaExecute('return math.deg(math.pi)'),
            luaEquals([180]),
          );
        });
      });

      group('math.exp', () {
        test('with valid argument', () async {
          expect(
            await luaExecute('return math.exp(1)'),
            luaEquals([math.exp(1)]),
          );
        });
      });

      group('math.floor', () {
        test('with integer', () async {
          expect(await luaExecute('return math.floor(3)'), luaEquals([3]));
        });

        test('with float', () async {
          expect(await luaExecute('return math.floor(3.5)'), luaEquals([3]));
        });

        test('floor division and conversions', () async {
          expect(
            await luaExecute('''
for _, i in pairs{-16, -15, -3, -2, -1, 0, 1, 2, 3, 15} do
  for _, j in pairs{-16, -15, -3, -2, -1, 1, 2, 3, 15} do
    for _, ti in pairs{0, 0.0} do     -- try 'i' as integer and as float
      for _, tj in pairs{0, 0.0} do   -- try 'j' as integer and as float
      print('floor test', i, j, i//j, math.floor(i/j), i/j)
          assert(i//j == math.floor(i/j))
      end
    end
  end
end
            '''),
            luaEquals([]),
          );
        });
      });

      group('math.huge', () {
        test('with positive', () async {
          expect(
            await luaExecute('return math.huge > 10e30'),
            luaEquals([true]),
          );
        });

        test('with positive', () async {
          expect(
            await luaExecute('return -math.huge < -10e30'),
            luaEquals([true]),
          );
        });
      });

      group('math.log', () {
        test('with valid argument', () async {
          expect(
            await luaExecute('return math.log(1)'),
            luaEquals([math.log(1)]),
          );
        });

        test('with base 10', () async {
          expect(
            await luaExecute('return math.log(1, 10)'),
            luaEquals([math.log(1) / math.log(10)]),
          );
        });

        test('with base 2', () async {
          expect(
            await luaExecute('return math.log(9223372036854775807, 2)'),
            luaEquals([63.0]),
          );
        });
      });

      group('math.max', () {
        test('with multiple numbers', () async {
          expect(
            await luaExecute('return math.max(1, 2, 3, 4, 5)'),
            luaEquals([5]),
          );
        });

        test('with no numbers', () async {
          expect(
            () async => luaExecute('return math.max()'),
            throwsA(isA<LuaException>()),
          );
        });
      });

      test('math.maxinteger', () async {
        expect(
          await luaExecute('return math.maxinteger'),
          luaEquals([Int64.MAX_VALUE]),
        );
      });

      group('math.min', () {
        test('with multiple numbers', () async {
          expect(
            await luaExecute('return math.min(1, 2, 3, 4, 5)'),
            luaEquals([1]),
          );
        });

        test('with no numbers', () async {
          expect(
            () async => luaExecute('return math.min()'),
            throwsA(isA<LuaException>()),
          );
        });
      });

      test('math.mininteger', () async {
        expect(
          await luaExecute('return math.mininteger'),
          luaEquals([Int64.MIN_VALUE]),
        );
      });

      group('math.modf', () {
        test('with positive integer', () async {
          expect(await luaExecute('return math.modf(3)'), luaEquals([3, 0.0]));
        });

        test('with negative integer', () async {
          expect(
            await luaExecute('return math.modf(-3)'),
            luaEquals([-3, 0.0]),
          );
        });

        test('with positive float', () async {
          expect(
            await luaExecute('return math.modf(3.5)'),
            luaEquals([3, 0.5]),
          );
        });

        test('with negative float', () async {
          expect(
            await luaExecute('return math.modf(-3.5)'),
            luaEquals([-3, -0.5]),
          );
        });

        test('with positive exponent', () async {
          expect(
            await luaExecute('return math.modf(3e23)'),
            luaEquals([3e23, 0]),
          );
        });

        test('with negative exponent', () async {
          expect(
            await luaExecute('return math.modf(-3e23)'),
            luaEquals([-3e23, 0]),
          );
        });

        test('with positive infinity', () async {
          expect(
            await luaExecute('return math.modf(1/0)'),
            luaEquals([double.infinity, 0]),
          );
        });

        test('with negative infinity', () async {
          expect(
            await luaExecute('return math.modf(-1/0)'),
            luaEquals([double.negativeInfinity, 0]),
          );
        });

        test('with NaN', () async {
          expect(
            await luaExecute('''
            local function isNaN (x)
              return (x ~= x)
            end
            local a, b = math.modf(0/0)
            return isNaN(a) and isNaN(b)
            '''),
            luaEquals([true]),
          );
        });
      });

      test('math.pi', () async {
        expect(await luaExecute('return math.pi'), luaEquals([math.pi]));
      });

      group('math.rad', () {
        test('with valid argument', () async {
          expect(
            await luaExecute('return math.rad(180)'),
            luaEquals([math.pi]),
          );
        });
      });

      group('math.random', () {
        const n = 100;
        test('no arguments', () async {
          for (var i = 0; i < n; i++) {
            expect(
              await luaExecute('''
        local n = math.random()
        return n >= 0 and n <= 1
        '''),
              luaEquals([true]),
            );
          }
        });

        test('with high limit', () async {
          for (var i = 0; i < n; i++) {
            expect(
              await luaExecute('''
        local n = math.random(10)
        return n >= 1 and n <= 10
        '''),
              luaEquals([true]),
            );
          }
        });

        test('with low and high limit', () async {
          for (var i = 0; i < n; i++) {
            expect(
              await luaExecute('''
        local n = math.random(5, 10)
        return n >= 5 and n <= 10
        '''),
              luaEquals([true]),
            );
          }
        });
      });

      group('math.randomseed', () {
        const n = 100;

        test('without arguments', () async {
          expect(
            await luaExecute('''
        return math.randomseed()
        '''),
            luaEquals([isA<LuaInteger>(), isA<LuaInteger>()]),
          );
        });

        test('with x only', () async {
          for (var i = 0; i < n; i++) {
            expect(
              await luaExecute('''
        math.randomseed(123)
        return math.random() == math.random()
        '''),
              luaEquals([true]),
            );
          }
        });

        test('with x and y', () async {
          for (var i = 0; i < n; i++) {
            expect(
              await luaExecute('''
        math.randomseed(123, 456)
        return math.random() == math.random()
        '''),
              luaEquals([true]),
            );
          }
        });
      });

      group('math.sin', () {
        test('with valid argument', () async {
          expect(
            await luaExecute('return math.sin(math.pi / 2)'),
            luaEquals([math.sin(math.pi / 2)]),
          );
        });
      });

      group('math.sqrt', () {
        test('with valid argument', () async {
          expect(
            await luaExecute('return math.sqrt(4)'),
            luaEquals([math.sqrt(4)]),
          );
        });
      });

      group('math.tan', () {
        test('with valid argument', () async {
          expect(
            await luaExecute('return math.tan(math.pi / 4)'),
            luaEquals([math.tan(math.pi / 4)]),
          );
        });
      });

      group('math.tointeger', () {
        test('without arguments ', () async {
          expect(
            () async => luaExecute('return math.tointeger()'),
            throwsA(isA<LuaException>()),
          );
        });

        test('with integer', () async {
          expect(
            await luaExecute('return math.tointeger(10)'),
            luaEquals([10]),
          );
        });

        test('with float', () async {
          expect(
            await luaExecute('return math.tointeger(10.5)'),
            luaEquals([null]),
          );
        });

        test('with string', () async {
          expect(
            await luaExecute('return math.tointeger("10")'),
            luaEquals([10]),
          );
        });

        test('with non-convertible string', () async {
          expect(
            await luaExecute('return math.tointeger("hello")'),
            luaEquals([null]),
          );
        });
      });

      group('math.type', () {
        test('with integer', () async {
          expect(
            await luaExecute('return math.type(10)'),
            luaEquals(['integer']),
          );
        });

        test('with float', () async {
          expect(
            await luaExecute('return math.type(10.5)'),
            luaEquals(['float']),
          );
        });

        test('with other value', () async {
          expect(await luaExecute('return math.type("10")'), luaEquals([null]));
        });
      });

      group('math.ult', () {
        test('m, n', () async {
          expect(await luaExecute('return math.ult(2, 3)'), luaEquals([true]));
        });
        test('m, -n', () async {
          expect(await luaExecute('return math.ult(2, -3)'), luaEquals([true]));
        });
        test('-m, n', () async {
          expect(
            await luaExecute('return math.ult(-2, 3)'),
            luaEquals([false]),
          );
        });
        test('-m, -n', () async {
          expect(
            await luaExecute('return math.ult(-2, -3)'),
            luaEquals([false]),
          );
        });
      });
    });

    group('consistency', () {
      test('max integer == min integer - 1', () async {
        const source = '''
      return math.maxinteger == math.mininteger - 1
      ''';
        expect(await luaExecute(source), luaEquals([true]));
      });

      test('max integer bits', () async {
        const source = '''
    local bits = math.floor(math.log(math.maxinteger, 2) + 0.5) + 1
    return (1 << bits) == 0
    ''';
        expect(await luaExecute(source), luaEquals([true]));
      });

      test('max integer bits', () async {
        const source = '''
    local minint = math.mininteger
    local maxint = math.maxinteger
    local bits = math.floor(math.log(maxint, 2) + 0.5) + 1
    return minint == 1 << (bits - 1)
    ''';
        expect(await luaExecute(source), luaEquals([true]));
      });
    });
  });
}
