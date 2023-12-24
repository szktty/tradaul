import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

import '../test.dart';

void main() {
  testMetamethodAdd();
  testMetamethodSub();
  testMetamethodMul();
  testMetamethodDiv();
  testMetamethodMod();
  testMetamethodPow();
  testMetamethodIDiv();
  testMetamethodUnm();
}

void testMetamethodAdd() {
  group('"__add" meta method', () {
    test('both operands have __add meta-method', () async {
      const source = '''
    local meta1 = {}
    local meta2 = {}
    local t1 = setmetatable({}, meta1)
    local t2 = setmetatable({}, meta2)
    meta1.__add = function(a, b) return 10 end
    meta2.__add = function(a, b) return 20 end
    return t1 + t2
    ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only first operand has __add meta-method', () async {
      const source = '''
    local meta = {}
    local t = setmetatable({}, meta)
    meta.__add = function(a, b) return 10 end
    return t + 5
    ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only second operand has __add meta-method', () async {
      const source = '''
    local meta = {}
    local t = setmetatable({}, meta)
    meta.__add = function(a, b) return 10 end
    return 5 + t
    ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands have __add meta-methods', () async {
      const source = '''
    local meta1 = {}
    local meta2 = {}
    local t1 = setmetatable({}, meta1)
    local t2 = setmetatable({}, meta2)
    meta1.__add = function(a, b) return 10 end
    meta2.__add = function(a, b) return 20 end
    return t1 + t2
    ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands do not have __add meta-method', () async {
      const source = '''
    local meta1 = {}
    local meta2 = {}
    local t1 = setmetatable({}, meta1)
    local t2 = setmetatable({}, meta2)
    return t1 + t2
    ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only first operand does not have __add meta-method', () async {
      const source = '''
    local meta = {}
    local t = setmetatable({}, meta)
    return t + 5
    ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only second operand does not have __add meta-method', () async {
      const source = '''
    local meta = {}
    local t = setmetatable({}, meta)
    return 5 + t
    ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__add meta-method throws an error', () async {
      const source = '''
    local meta = {}
    local t = setmetatable({}, meta)
    meta.__add = function(a, b) error("This is an error") end
    return t + 5
    ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}

void testMetamethodSub() {
  group('"__sub" meta method', () {
    test('both operands have __sub meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__sub = function(a, b) return 10 end
      meta2.__sub = function(a, b) return 20 end
      return t1 - t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only first operand has __sub meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__sub = function(a, b) return 10 end
      return t - 5
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only second operand has __sub meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__sub = function(a, b) return 10 end
      return 5 - t
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands have __sub meta-methods', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__sub = function(a, b) return 10 end
      meta2.__sub = function(a, b) return 20 end
      return t1 - t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands do not have __sub meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      return t1 - t2
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only first operand does not have __sub meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return t - 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only second operand does not have __sub meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return 5 - t
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__sub meta-method throws an error', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__sub = function(a, b) error("This is an error") end
      return t - 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}

void testMetamethodMul() {
  group('"__mul" meta method', () {
    test('both operands have __mul meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__mul = function(a, b) return 10 end
      meta2.__mul = function(a, b) return 20 end
      return t1 * t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only first operand has __mul meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__mul = function(a, b) return 10 end
      return t * 5
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only second operand has __mul meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__mul = function(a, b) return 10 end
      return 5 * t
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands have different __mul meta-methods', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__mul = function(a, b) return 10 end
      meta2.__mul = function(a, b) return 20 end
      return t1 * t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands do not have __mul meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      return t1 * t2
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only first operand does not have __mul meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return t * 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only second operand does not have __mul meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return 5 * t
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__mul meta-method throws an error', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__mul = function(a, b) error("This is an error") end
      return t * 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}

void testMetamethodDiv() {
  group('"__div" meta method', () {
    test('both operands have __div meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__div = function(a, b) return 10 end
      meta2.__div = function(a, b) return 20 end
      return t1 / t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only first operand has __div meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__div = function(a, b) return 10 end
      return t / 5
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only second operand has __div meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__div = function(a, b) return 10 end
      return 5 / t
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands have different __div meta-methods', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__div = function(a, b) return 10 end
      meta2.__div = function(a, b) return 20 end
      return t1 / t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands do not have __div meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      return t1 / t2
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only first operand does not have __div meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return t / 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only second operand does not have __div meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return 5 / t
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__div meta-method throws an error', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__div = function(a, b) error("This is an error") end
      return t / 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}

void testMetamethodMod() {
  group('"__mod" meta method', () {
    test('both operands have __mod meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__mod = function(a, b) return 10 end
      meta2.__mod = function(a, b) return 20 end
      return t1 % t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only first operand has __mod meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__mod = function(a, b) return 10 end
      return t % 5
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only second operand has __mod meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__mod = function(a, b) return 10 end
      return 5 % t
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands have different __mod meta-methods', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__mod = function(a, b) return 10 end
      meta2.__mod = function(a, b) return 20 end
      return t1 % t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands do not have __mod meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      return t1 % t2
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only first operand does not have __mod meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return t % 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only second operand does not have __mod meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return 5 % t
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__mod meta-method throws an error', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__mod = function(a, b) error("This is an error") end
      return t % 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}

void testMetamethodPow() {
  group('"__pow" meta method', () {
    test('both operands have __pow meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__pow = function(a, b) return 10 end
      meta2.__pow = function(a, b) return 20 end
      return t1 ^ t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only first operand has __pow meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__pow = function(a, b) return 10 end
      return t ^ 5
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only second operand has __pow meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__pow = function(a, b) return 10 end
      return 5 ^ t
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands have different __pow meta-methods', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__pow = function(a, b) return 10 end
      meta2.__pow = function(a, b) return 20 end
      return t1 ^ t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands do not have __pow meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      return t1 ^ t2
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only first operand does not have __pow meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return t ^ 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only second operand does not have __pow meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return 5 ^ t
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__pow meta-method throws an error', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__pow = function(a, b) error("This is an error") end
      return t ^ 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}

void testMetamethodIDiv() {
  group('"__idiv" meta method', () {
    test('both operands have __idiv meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__idiv = function(a, b) return 10 end
      meta2.__idiv = function(a, b) return 20 end
      return t1 // t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only first operand has __idiv meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__idiv = function(a, b) return 10 end
      return t // 5
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only second operand has __idiv meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__idiv = function(a, b) return 10 end
      return 5 // t
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands have different __idiv meta-methods', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__idiv = function(a, b) return 10 end
      meta2.__idiv = function(a, b) return 20 end
      return t1 // t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands do not have __idiv meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      return t1 // t2
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only first operand does not have __idiv meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return t // 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only second operand does not have __idiv meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return 5 // t
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__idiv meta-method throws an error', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__idiv = function(a, b) error("This is an error") end
      return t // 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}

void testMetamethodUnm() {
  group('"__unm" meta method', () {
    test('operand has __unm meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__unm = function(a) return 10 end
      return -t
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('operand does not have __unm meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return -t
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__unm meta-method arguments', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__unm = function(a, b) return a == b end
      return -t
      ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('__unm meta-method throws an error', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__unm = function(a) error("This is an error") end
      return -t
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}
