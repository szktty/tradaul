import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

import '../test.dart';

void main() {
  testMetamethodConcat();
  testMetamethodLen();
  testMetamethodIndex();
  testMetamethodNewindex();
  testMetamethodCall();
}

void testMetamethodConcat() {
  group('__concat meta-method', () {
    test('left operand is a number and right has __concat meta-method',
        () async {
      const source = '''
      local t = setmetatable({}, {__concat = function(a, b) return a .. b.value end})
      t.value = " pieces"
      return 100 .. t
      ''';
      expect(await luaExecute(source), luaEquals(['100 pieces']));
    });

    test('right operand is a number and left has __concat meta-method',
        () async {
      const source = '''
      local t = setmetatable({}, {__concat = function(a, b) return a.value .. b end})
      t.value = "Total: "
      return t .. 100
      ''';
      expect(await luaExecute(source), luaEquals(['Total: 100']));
    });

    test('only left operand has __concat meta-method', () async {
      const source = '''
      local t1 = setmetatable({}, {__concat = function(a, b) return a.value .. b end})
      t1.value = "Hello, "
      local t2 = "world!"
      return t1 .. t2
      ''';
      expect(await luaExecute(source), luaEquals(['Hello, world!']));
    });

    test('only right operand has __concat meta-method', () async {
      const source = '''
      local t1 = "Hello, "
      local t2 = setmetatable({}, {__concat = function(a, b) return a .. b.value end})
      t2.value = "world!"
      return t1 .. t2
      ''';
      expect(await luaExecute(source), luaEquals(['Hello, world!']));
    });

    test('__concat meta-method raise error', () async {
      const source = '''
      local t1 = setmetatable({}, {__concat = function(a, b) error('error') end})
      return t1 .. 'foo'
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}

void testMetamethodLen() {
  group('__len meta-method', () {
    test('table with __len meta-method', () async {
      const source = '''
      local t = setmetatable({}, { __len = function(t) return 10 end })
      return #t
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('meta-method returns non-integer', () async {
      const source = '''
      local t = setmetatable({}, { __len = function(t) return "length" end })
      return #t
      ''';
      expect(await luaExecute(source), luaEquals(['length']));
    });

    test(
        'error when __len meta-method is not defined and object is not a table',
        () async {
      const source = '''
      local f = setmetatable(function() end, {})
      return #f
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('table with __len returning multiple values, only first is used',
        () async {
      const source = '''
      local t = setmetatable({}, { __len = function(t) return 3, 7 end })
      return #t
      ''';
      expect(await luaExecute(source), luaEquals([3]));
    });
  });
}

void testMetamethodIndex() {
  group('__index meta-method', () {
    test('when key is not present, __index function is called', () async {
      const source = '''
      local meta = {
        __index = function(table, key) return key .. " not found" end
      }
      local t = setmetatable({}, meta)
      return t.someNonexistentKey
      ''';
      expect(
        await luaExecute(source),
        luaEquals(['someNonexistentKey not found']),
      );
    });

    test('__index as table', () async {
      const source = '''
      local fallback = {
        someKey = "fallback value"
      }
      local meta = {
        __index = fallback
      }
      local t = setmetatable({}, meta)
      return t.someKey
      ''';
      expect(await luaExecute(source), luaEquals(['fallback value']));
    });

    test('__index meta-method chain', () async {
      const source = '''
      local fallback = setmetatable({
        someKey = "first level fallback"
      }, {
        __index = function() return "second level fallback" end
      })
      local meta = {
        __index = fallback
      }
      local t = setmetatable({}, meta)
      return t.someKey, t.anotherKey
      ''';
      expect(
        await luaExecute(source),
        luaEquals(['first level fallback', 'second level fallback']),
      );
    });

    test('when key is present, __index is not triggered', () async {
      const source = '''
      local meta = {
        __index = function(table, key) return key .. " not found" end
      }
      local t = setmetatable({ existingKey = "existing value" }, meta)
      return t.existingKey
      ''';
      expect(await luaExecute(source), luaEquals(['existing value']));
    });

    test('when __index meta-method is not present, return nil', () async {
      const source = '''
      local t = setmetatable({}, {})
      return t.someNonexistentKey
      ''';
      expect(await luaExecute(source), luaEquals([null]));
    });

    test('__index used for inheritance simulation', () async {
      const source = '''
      local parent = {
        parentKey = "parent value"
      }
      local meta = {
        __index = parent
      }
      local child = setmetatable({}, meta)
      return child.parentKey
      ''';
      expect(await luaExecute(source), luaEquals(['parent value']));
    });
  });
}

void testMetamethodNewindex() {
  group('__newindex meta-method', () {
    test('__newindex is called for new keys', () async {
      const source = '''
    local t = {}
    local mt = {
      __newindex = function(table, key, value)
        rawset(table, key, value * 2)
      end
    }
    setmetatable(t, mt)
    t.newKey = 10
    return t.newKey
    ''';
      expect(await luaExecute(source), luaEquals([20]));
    });

    test('__newindex is not called for existing keys', () async {
      const source = '''
    local t = { existingKey = 5 }
    local mt = {
      __newindex = function(table, key, value)
        error('__newindex should not be called for existing keys')
      end
    }
    setmetatable(t, mt)
    t.existingKey = 10
    return t.existingKey
    ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('__newindex fallback to a table when not a function', () async {
      const source = '''
    local fallback = {}
    local t = setmetatable({}, { __newindex = fallback })
    t.newKey = 'newValue'
    return fallback.newKey
    ''';
      expect(await luaExecute(source), luaEquals(['newValue']));
    });

    test('__newindex triggers another __newindex', () async {
      const source = '''
    local t1 = {}
    local t2 = {}
    local mt1 = { __newindex = t2 }
    local mt2 = {
      __newindex = function(table, key, value)
        error('__newindex on t2 should not be called')
      end
    }
    setmetatable(t1, mt1)
    setmetatable(t2, mt2)
    t1.newKey = 'newValue'
    ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__newindex uses rawset to set value explicitly', () async {
      const source = '''
    local t = {}
    local mt = {
      __newindex = function(table, key, value)
        rawset(table, key, 'processed-' .. value)
      end
    }
    setmetatable(t, mt)
    t.newKey = 'newValue'
    return t.newKey
    ''';
      expect(await luaExecute(source), luaEquals(['processed-newValue']));
    });
  });
}

void testMetamethodCall() {
  group('__call metamethod tests', () {
    test('object with __call metamethod should be callable', () async {
      const source = '''
      local obj = {}
      setmetatable(obj, {
        __call = function(self, a, b)
          return a + b
        end
      })
      return obj(10, 20)
      ''';
      expect(await luaExecute(source), luaEquals([30]));
    });

    test('__call metamethod with multiple return values', () async {
      const source = '''
      local obj = {}
      setmetatable(obj, {
        __call = function(self, a, b)
          return a, b, a + b
        end
      })
      return obj(7, 3)
      ''';
      expect(await luaExecute(source), luaEquals([7, 3, 10]));
    });

    test('object without __call metamethod should raise an error', () async {
      const source = '''
      local obj = {}
      return obj()
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__call metamethod raising an error', () async {
      const source = '''
      local obj = {}
      setmetatable(obj, {
        __call = function()
          error('This is a call error')
        end
      })
      obj()
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}
