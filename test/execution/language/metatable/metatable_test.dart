import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

import '../test.dart';

void main() {
  testMetatable();
}

void testMetatable() {
  group('metatable', () {
    test('empty metatable', () async {
      const source = '''
      return getmetatable({});
    ''';
      expect(await luaExecute(source), luaEquals([null]));
    });

    test('basic metatable assignment', () async {
      const source = '''
      local t = {}
      local mt = {}
      setmetatable(t, mt)
      return getmetatable(t) == mt;
    ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('overwriting a metatable', () async {
      const source = '''
      local t = {}
      local mt1 = {}
      local mt2 = {}
      setmetatable(t, mt1)
      setmetatable(t, mt2)
      return getmetatable(t) == mt2;
    ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('metatable for different object types', () async {
      const source = '''
      local num = 5
      local mt = {}
      setmetatable(num, mt)
    ''';
      expect(
        () async {
          await luaExecute(source);
        },
        luaThrows(LuaExceptionType.badArgument),
      );
    });

    test('"__metatable" behavior', () async {
      const source = '''
      local t = {}
      local mt = {__metatable = "locked"}
      setmetatable(t, mt)
      return getmetatable(t);
    ''';
      expect(await luaExecute(source), luaEquals(['locked']));
    });

    test('setting an empty metatable', () async {
      const source = '''
      local t = {}
      setmetatable(t, {})
      return getmetatable(t) ~= nil;
    ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('setting nil as a metatable', () async {
      const source = '''
      local t = {}
      setmetatable(t, nil)
      return getmetatable(t) == nil;
    ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('setting non-table as metatable', () async {
      const source = '''
      local t = {}
      setmetatable(t, 5)
    ''';
      expect(
        () async {
          await luaExecute(source);
        },
        luaThrows(LuaExceptionType.badArgument),
      );
    });

    test('removing a metatable', () async {
      const source = '''
      local t = {}
      local mt = {}
      setmetatable(t, mt)
      setmetatable(t, nil)
      return getmetatable(t) == nil;
    ''';
      expect(await luaExecute(source), luaEquals([true]));
    });
  });
}
