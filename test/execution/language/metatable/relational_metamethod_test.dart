import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

import '../test.dart';

void main() {
  testMetamethodEq();
  testMetamethodLt();
  testMetamethodLe();
}

void testMetamethodEq() {
  group('__eq meta-method', () {
    test('both operands have __eq meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__eq = function(a, b) return true end
      meta2.__eq = function(a, b) return false end
      return t1 == t2
      ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('only first operand has __eq meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__eq = function(a, b) return true end
      return t == {}
      ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('only second operand has __eq meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__eq = function(a, b) return true end
      return {} == t
      ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('operands are not tables or full userdata', () async {
      const source = 'return 5 == 5';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('operands are not primitively equal', () async {
      const source = 'return {} == {}';
      expect(await luaExecute(source), luaEquals([false]));
    });

    test('__eq meta-method returns non-boolean (true)', () async {
      const source = '''
      local meta = {}
      local t1 = setmetatable({}, meta)
      local t2 = setmetatable({}, meta)
      meta.__eq = function(a, b) return "not a boolean" end
      return t1 == t2
      ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('__eq meta-method returns non-boolean (false)', () async {
      const source = '''
      local meta = {}
      local t1 = setmetatable({}, meta)
      local t2 = setmetatable({}, meta)
      meta.__eq = function(a, b) return nil end
      return t1 == t2
      ''';
      expect(await luaExecute(source), luaEquals([false]));
    });
  });
}

void testMetamethodLt() {
  group('__lt meta-method', () {
    test('both operands have __lt meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__lt = function(a, b) return true end
      meta2.__lt = function(a, b) return false end
      return t1 < t2
      ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('only first operand has __lt meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__lt = function(a, b) return true end
      return t < 1
      ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('only second operand has __lt meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__lt = function(a, b) return true end
      return 1 < t
      ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('operands are not primitively equal', () async {
      const source = 'return {} < {}';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__lt meta-method returns non-boolean (true)', () async {
      const source = '''
      local meta = {}
      local t1 = setmetatable({}, meta)
      local t2 = setmetatable({}, meta)
      meta.__lt = function(a, b) return "not a boolean" end
      return t1 < t2
      ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('__lt meta-method returns non-boolean (false)', () async {
      const source = '''
      local meta = {}
      local t1 = setmetatable({}, meta)
      local t2 = setmetatable({}, meta)
      meta.__lt = function(a, b) return nil end
      return t1 < t2
      ''';
      expect(await luaExecute(source), luaEquals([false]));
    });
  });
}

void testMetamethodLe() {
  group('__le meta-method', () {
    test('both operands have __le meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__le = function(a, b) return true end
      meta2.__le = function(a, b) return false end
      return t1 <= t2
      ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('only left operand has __le meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__le = function(a, b) return b == 1 end
      return t <= 1
      ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('only right operand has __le meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__le = function(a, b) return a == 1 end
      return 1 <= t
      ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('only left operand has __lt meta-method', () async {
      const source = '''
      local meta = {}
      meta.__lt = function(a, b) return a.value < b.value end
      local t1 = setmetatable({value = 1}, meta)
      local t2 = {value = 2}
      return t1 <= t2
      ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('only right operand has __lt meta-method', () async {
      const source = '''
      local meta = {}
      meta.__lt = function(a, b) return b.value < a.value end
      local t1 = {value = 1}
      local t2 = setmetatable({value = 2}, meta)
      return t1 <= t2
      ''';
      expect(await luaExecute(source), luaEquals([false]));
    });

    test('__le meta-method returns non-boolean (true)', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__le = function(a, b) return "not a boolean" end
      return t <= {}
      ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('__le meta-method returns non-boolean (false)', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__le = function(a, b) return nil end
      return t <= {}
      ''';
      expect(await luaExecute(source), luaEquals([false]));
    });
  });
}
