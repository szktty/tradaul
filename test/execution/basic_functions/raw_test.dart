import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

import '../language/test.dart';

void main() {
  testRawequal();
  testRawlen();
  testRawget();
  testRawset();
}

void testRawequal() {
  group('rawequal function', () {
    test('rawequal with identical numbers', () async {
      const source = '''
  return rawequal(1, 1)
  ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('rawequal with identical strings', () async {
      const source = '''
  return rawequal("hello", "hello")
  ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('rawequal with different types', () async {
      const source = '''
  return rawequal(1, "1")
  ''';
      expect(await luaExecute(source), luaEquals([false]));
    });

    test('rawequal with different values', () async {
      const source = '''
  return rawequal(1, 2)
  ''';
      expect(await luaExecute(source), luaEquals([false]));
    });

    test('rawequal with tables without metatables', () async {
      const source = '''
  local t1 = {}
  local t2 = {}
  return rawequal(t1, t1), rawequal(t1, t2)
  ''';
      expect(await luaExecute(source), luaEquals([true, false]));
    });

    test('rawequal with tables with identical metatables', () async {
      const source = '''
  local mt = {}
  local t1 = setmetatable({}, mt)
  local t2 = setmetatable({}, mt)
  return rawequal(t1, t2)
  ''';
      expect(await luaExecute(source), luaEquals([false]));
    });

    test('rawequal with tables with different metatables', () async {
      const source = '''
  local mt1 = {}
  local mt2 = {}
  local t1 = setmetatable({}, mt1)
  local t2 = setmetatable({}, mt2)
  return rawequal(t1, t2)
  ''';
      expect(await luaExecute(source), luaEquals([false]));
    });
  });
}

void testRawlen() {
  group('rawlen function', () {
    test('rawlen on table without metatables', () async {
      const source = '''
  local t = {1, 2, 3, 4, 5}
  return rawlen(t)
  ''';
      expect(await luaExecute(source), luaEquals([5]));
    });

    test('rawlen on string', () async {
      const source = '''
  local s = "Hello, World!"
  return rawlen(s)
  ''';
      expect(await luaExecute(source), luaEquals([13]));
    });

    test('rawlen bypassing __len metamethod', () async {
      const source = '''
  local t = setmetatable({}, {__len = function(t)
    error("__len should not be called")
  end})
  return rawlen(t)
  ''';
      expect(await luaExecute(source), luaEquals([0]));
    });

    test('rawlen with invalid arguments', () async {
      const source = '''
  return rawlen(123)
  ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}

void testRawget() {
  group('rawget function', () {
    test('rawget without metatables', () async {
      const source = '''
  local t = {key1 = "value1"}
  return rawget(t, "key1")
  ''';
      expect(await luaExecute(source), luaEquals(['value1']));
    });

    test('rawget on nil key', () async {
      const source = '''
  local t = {key1 = "value1"}
  return rawget(t, nil)
  ''';
      expect(await luaExecute(source), luaEquals([null]));
    });

    test('rawget on non-existent key', () async {
      const source = '''
  local t = {key1 = "value1"}
  return rawget(t, "key2")
  ''';
      expect(await luaExecute(source), luaEquals([null]));
    });

    test('rawget bypassing __index metamethod', () async {
      const source = '''
  local t = {}
  setmetatable(t, {__index = function(t, k)
    error("__index should not be called")
  end})
  return rawget(t, "key")
  ''';
      expect(await luaExecute(source), luaEquals([null]));
    });

    test('rawget with invalid arguments', () async {
      const source = '''
  return rawget("not a table", "key")
  ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}

void testRawset() {
  group('rawset function', () {
    test('rawset without metatables', () async {
      const source = '''
  local t = {key1 = "value1"}
  rawset(t, "key2", "value2")
  return t.key1, t.key2
  ''';
      expect(await luaExecute(source), luaEquals(['value1', 'value2']));
    });

    test('return value', () async {
      const source = '''
  local t1 = {}
  local t2 = rawset(t1, "key2", "value2")
  return t1 == t2
  ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('rawset bypassing __newindex metamethod', () async {
      const source = '''
  local t = {}
  setmetatable(t, {__newindex = function(t, k, v)
    error("__newindex should not be called")
  end})
  rawset(t, "key", "value")
  return t.key
  ''';
      expect(await luaExecute(source), luaEquals(['value']));
    });

    test('rawset with invalid arguments', () async {
      const source = '''
  rawset("not a table", "key", "value")
  ''';
      await expectLater(
        () async => luaExecute(source),
        throwsA(isA<LuaException>()),
      );
    });
  });
}
