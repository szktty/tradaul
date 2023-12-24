import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

import '../language/test.dart';

void main() {
  group('tostring tests', () {
    test('tostring with basic types', () async {
      const source = '''
        return tostring(123), tostring("abc"), tostring(true), tostring(nil)
      ''';
      expect(
        await luaExecute(source),
        luaEquals(['123', 'abc', 'true', 'nil']),
      );
    });

    test('tostring with a table', () async {
      const source = '''
        local t = {}
        return tostring(t)
      ''';
      expect(await luaExecute(source), luaEquals([luaIsA<LuaString>()]));
    });

    test('__tostring metamethod', () async {
      const source = '''
        local t = setmetatable({}, {
          __tostring = function(self) return "my table" end
        })
        return tostring(t)
      ''';
      expect(await luaExecute(source), luaEquals(['my table']));
    });

    test('__name field in metatable', () async {
      const source = '''
        local t = setmetatable({}, {
          __tostring = function(self) return "my table" end,
          __name = "MyTable"
        })
        return tostring(t)
      ''';
      expect(await luaExecute(source), luaEquals(['my table']));
    });

    test('tostring with a function', () async {
      const source = '''
        local f = function() end
        return tostring(f)
      ''';
      expect(await luaExecute(source), luaEquals([luaIsA<LuaString>()]));
    });

    test('tostring with a coroutine', () async {
      const source = '''
        local co = coroutine.create(function() end)
        return tostring(co)
      ''';
      expect(await luaExecute(source), luaEquals([luaIsA<LuaString>()]));
    });

    test('tostring with a custom value', () async {
      const source = '''
        return tostring(custom)
      ''';
      const custom = 123;
      expect(
        await luaExecute(
          source,
          onInit: (context) {
            context.environment.variables.stringKeySet(
              'custom',
              LuaCustomValue(
                custom,
                type: LuaValueType.number,
                onLuaToString: (value) => value.toString(),
              ),
            );
          },
        ),
        luaEquals([custom.toString()]),
      );
    });

    test('__tostring metamethod errors', () async {
      const source = '''
        local t = setmetatable({}, {
          __tostring = function(self) error("conversion error") end
        })
        return tostring(t)
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__tostring metamethod returns invalid value', () async {
      const source = '''
        local t = setmetatable({}, {
          __tostring = function(self) return {} end
        })
        return tostring(t)
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });

  group('tonumber function', () {
    group('without base', () {
      test('valid integer string', () async {
        expect(await luaExecute('return tonumber("42")'), luaEquals([42]));
      });

      test('valid float string', () async {
        expect(
          await luaExecute('return tonumber("3.1415")'),
          luaEquals([3.1415]),
        );
      });

      test('valid negative number string', () async {
        expect(
          await luaExecute('return tonumber("  -42  ")'),
          luaEquals([-42]),
        );
      });

      test('string with invalid number', () async {
        expect(await luaExecute('return tonumber("abc")'), luaEquals([null]));
      });

      test('empty string', () async {
        expect(await luaExecute('return tonumber("")'), luaEquals([null]));
      });

      test('nil value', () async {
        expect(await luaExecute('return tonumber(nil)'), luaEquals([null]));
      });
    });

    group('with base', () {
      test('valid binary string', () async {
        expect(
          await luaExecute('return tonumber("101010", 2)'),
          luaEquals([42]),
        );
      });

      test('valid hexadecimal string', () async {
        expect(await luaExecute('return tonumber("2A", 16)'), luaEquals([42]));
      });

      test('string not valid in given base', () async {
        expect(
          await luaExecute('return tonumber("101020", 2)'),
          luaEquals([null]),
        );
      });

      test('string outside base range', () async {
        expect(await luaExecute('return tonumber("z", 36)'), luaEquals([35]));
      });

      test('invalid base (too low)', () async {
        expect(
          () async => luaExecute('return tonumber("42", 1)'),
          throwsA(isA<LuaException>()),
        );
      });

      test('invalid base (too high)', () async {
        expect(
          () async => luaExecute('return tonumber("42", 37)'),
          throwsA(isA<LuaException>()),
        );
      });
    });
  });
}
