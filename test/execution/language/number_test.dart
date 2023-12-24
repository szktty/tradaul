import 'package:test/test.dart';

import 'test.dart';

void main() {
  group('converting numeric strings', () {
    test('negative integer', () async {
      expect(
        await luaExecute('return " -2 " + 0'),
        luaEquals([-2]),
      );
    });

    test('negative hex integer', () async {
      expect(
        await luaExecute('return " -0xa " + 0'),
        luaEquals([-0xa]),
      );
    });
  });

  group('float', () {
    group('NaN', () {
      test('create NaN', () async {
        expect(
          await luaExecute('return 0/0'),
          luaEquals(
            [luaIsNaN()],
          ),
        );
      });

      test('check NaN (1)', () async {
        expect(
          await luaExecute('''
        local function isNaN (x)
          return (x ~= x)
        end
        return isNaN(0/0)
        '''),
          luaEquals(
            [true],
          ),
        );
      });

      test('check NaN (2)', () async {
        expect(
          await luaExecute('''
        local function isNaN (x)
          return (x ~= x)
        end
        return not isNaN(1/0)
        '''),
          luaEquals(
            [true],
          ),
        );
      });

      test('NaN < 0', () async {
        expect(
          await luaExecute('''
        local NaN = 0/0
        return not (NaN < 0)
        '''),
          luaEquals([true]),
        );
      });

      test('NaN > math.mininteger', () async {
        expect(
          await luaExecute('''
        local NaN = 0/0
        return not (NaN > math.mininteger)
        '''),
          luaEquals([true]),
        );
      });
    });

    group('infinity', () {
      test('positive integer division', () async {
        expect(
          await luaExecute('return 1/0'),
          luaEquals([double.infinity]),
        );
      });

      test('negative integer division', () async {
        expect(
          await luaExecute('return -1/0'),
          luaEquals([double.negativeInfinity]),
        );
      });

      test('positive float floor division', () async {
        expect(
          await luaExecute('return 1//0.0'),
          luaEquals([double.infinity]),
        );
      });

      test('negative float floor division', () async {
        expect(
          await luaExecute('return -1//0.0'),
          luaEquals([double.negativeInfinity]),
        );
      });

      test('positive equal division', () async {
        expect(
          await luaExecute('return 1/0 == 1/0'),
          luaEquals([true]),
        );
      });

      test('negative equal division', () async {
        expect(
          await luaExecute('return -1/0 == -1/0'),
          luaEquals([true]),
        );
      });

      test('positive equal float and floor division', () async {
        expect(
          await luaExecute('return 1//0.0 == 1/0'),
          luaEquals([true]),
        );
      });

      test('negative equal float and floor division', () async {
        expect(
          await luaExecute('return -1 // 0.0 == -1/0'),
          luaEquals([true]),
        );
      });
    });
  });
}
