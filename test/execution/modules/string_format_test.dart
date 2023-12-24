import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

import '../language/test.dart';

void main() {
  group('string.format function', () {
    group('basic formatting', () {
      test('float', () async {
        expect(
          await luaExecute('return string.format("%f", 123.456)'),
          luaEquals(['123.456000']),
        );
      });

      test('integer', () async {
        expect(
          await luaExecute('return string.format("%d", 123)'),
          luaEquals(['123']),
        );
      });

      test('octal', () async {
        expect(
          await luaExecute('return string.format("%o", 123)'),
          luaEquals(['173']),
        );
      });

      test('unsigned', () async {
        expect(
          await luaExecute('return string.format("%u", -123)'),
          // 64 bit integer
          luaEquals(['18446744073709551493']),
        );
      });

      test('hexadecimal (lower case)', () async {
        expect(
          await luaExecute('return string.format("%x", 123)'),
          luaEquals(['7b']),
        );
      });

      test('hexadecimal (upper case)', () async {
        expect(
          await luaExecute('return string.format("%X", 123)'),
          luaEquals(['7B']),
        );
      });

      test('character', () async {
        expect(
          await luaExecute('return string.format("%c", 97)'),
          luaEquals(['a']),
        );
      });

      test('scientific notation (lower case)', () async {
        expect(
          await luaExecute('return string.format("%e", 123.456)'),
          luaEquals(['1.234560e+02']),
        );
      });

      test('scientific notation (upper case)', () async {
        expect(
          await luaExecute('return string.format("%E", 123.456)'),
          luaEquals(['1.234560E+02']),
        );
      });

      test('generic format (lower case)', () async {
        expect(
          await luaExecute('return string.format("%g", 123.456)'),
          luaEquals(['123.456']),
        );
      });

      test('generic format (upper case)', () async {
        expect(
          await luaExecute('return string.format("%G", 123.456)'),
          luaEquals(['123.456']),
        );
      });
    });

    test('special format specifier q for string', () async {
      expect(
        await luaExecute(r'''
              local s = 'String with "quotes" and \n new line'
              return string.format("%q", s)
              '''),
        luaEquals(['"String with \\"quotes\\" and \\\n new line"']),
      );
    });

    test('formatting with multiple types', () async {
      expect(
        await luaExecute('return string.format("%d %s", 123, "abc")'),
        luaEquals(['123 abc']),
      );
    });

    test('formatting with width and precision', () async {
      expect(
        await luaExecute('return string.format("%10.2f", 123.456)'),
        luaEquals(['    123.46']),
      );
    });

    test('escaping percent sign', () async {
      expect(await luaExecute('return string.format("%%")'), luaEquals(['%']));
    });

    group('non-string arguments for s and q specifiers', () {
      test('specifier s with a number', () async {
        expect(
          await luaExecute('return string.format("%s", 123)'),
          luaEquals(['123']),
        );
      });

      test('specifier s with a boolean', () async {
        expect(
          await luaExecute('return string.format("%s", true)'),
          luaEquals(['true']),
        );
      });

      test('specifier s with nil', () async {
        expect(
          await luaExecute('return string.format("%s", nil)'),
          luaEquals(['nil']),
        );
      });

      test('specifier q with a number', () async {
        expect(
          await luaExecute('return string.format("%q", 123)'),
          luaEquals(['123']),
        );
      });

      test('specifier q with a boolean', () async {
        expect(
          await luaExecute('return string.format("%q", true)'),
          luaEquals(['true']),
        );
      });

      test('specifier q with nil', () async {
        expect(
          await luaExecute('return string.format("%q", nil)'),
          luaEquals(['nil']),
        );
      });
    });

    group('formatting pointer with specifier p', () {
      test('table', () async {
        const source = '''
        local t = {}
        return string.format("%p", t)
      ''';
        expect(await luaExecute(source), luaEquals(['(null)']));
      });

      test('nil', () async {
        const source = '''
        return string.format("%p", nil)
      ''';
        expect(await luaExecute(source), luaEquals(['(null)']));
      });

      test('bool', () async {
        const source = '''
        return string.format("%p", true)
      ''';
        expect(await luaExecute(source), luaEquals(['(null)']));
      });

      test('number', () async {
        const source = '''
        return string.format("%p", 12345)
      ''';
        expect(await luaExecute(source), luaEquals(['(null)']));
      });
    });

    group('specifying number of digits', () {
      test('fixed-point notation', () async {
        expect(
          await luaExecute('return string.format("%.2f", 123.456)'),
          luaEquals(['123.46']),
        );
      });

      test('exponential notation', () async {
        expect(
          await luaExecute('return string.format("%.2e", 123.456)'),
          luaEquals(['1.23e+02']),
        );
      });

      test('hexadecimal notation', () async {
        expect(
          await luaExecute('return string.format("%.4x", 255)'),
          luaEquals(['00ff']),
        );
      });

      test('width specified', () async {
        expect(
          await luaExecute('return string.format("%10.2f", 123.456)'),
          luaEquals(['    123.46']),
        );
      });

      test('zero padding', () async {
        expect(
          await luaExecute('return string.format("%010.2f", 123.456)'),
          luaEquals(['0000123.46']),
        );
      });

      test('left-justified', () async {
        expect(
          await luaExecute('return string.format("%-10.2f", 123.456)'),
          luaEquals(['123.46    ']),
        );
      });

      test('space padding', () async {
        expect(
          await luaExecute('return string.format("% 10.2f", 123.456)'),
          luaEquals(['    123.46']),
        );
      });
    });

    group('error cases', () {
      group('no argument', () {
        test('specifier A', () async {
          const source = 'return string.format("%A")';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });

        test('specifier a', () async {
          const source = 'return string.format("%a")';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });

        test('specifier E', () async {
          const source = 'return string.format("%E")';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });

        test('specifier e', () async {
          const source = 'return string.format("%e")';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });

        test('specifier f', () async {
          const source = 'return string.format("%f")';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });

        test('specifier G', () async {
          const source = 'return string.format("%G")';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });

        test('specifier c', () async {
          const source = 'return string.format("%c")';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });

        test('specifier d', () async {
          const source = 'return string.format("%d")';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });

        test('specifier i', () async {
          const source = 'return string.format("%i")';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });

        test('specifier o', () async {
          const source = 'return string.format("%o")';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });

        test('specifier u', () async {
          const source = 'return string.format("%u")';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });

        test('specifier X', () async {
          const source = 'return string.format("%X")';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });

        test('specifier x', () async {
          const source = 'return string.format("%x")';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });
      });

      group('argument type errors', () {
        group('number expected', () {
          final numberExpectedOptions = ['A', 'a', 'E', 'e', 'f', 'G', 'g'];
          for (final option in numberExpectedOptions) {
            test('specifier $option with non-number', () async {
              final source = 'return string.format("%$option", "not a number")';
              expect(
                () async => luaExecute(source),
                throwsA(isA<LuaException>()),
              );
            });
          }
        });

        group('integer expected', () {
          final integerExpectedOptions = ['c', 'd', 'i', 'o', 'u', 'X', 'x'];
          for (final option in integerExpectedOptions) {
            test('specifier $option with non-integer', () async {
              final source =
                  'return string.format("%$option", "not an integer")';
              expect(
                () async => luaExecute(source),
                throwsA(isA<LuaException>()),
              );
            });
          }
        });
      });

      test('invalid conversion', () async {
        const source = 'return string.format("%z")';
        expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
      });
    });
  });
}
