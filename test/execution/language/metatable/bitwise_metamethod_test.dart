import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

import '../test.dart';

void main() {
  testMetamethodBand();
  testMetamethodBor();
  testMetamethodBxor();
  testMetamethodBnot();
  testMetamethodShl();
  testMetamethodShr();
}

void testMetamethodBand() {
  group('"__band" meta method', () {
    test('both operands have __band meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__band = function(a, b) return 10 end
      meta2.__band = function(a, b) return 20 end
      return t1 & t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only first operand has __band meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__band = function(a, b) return 10 end
      return t & 5
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only second operand has __band meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__band = function(a, b) return 10 end
      return 5 & t
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands do not have __band meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      return t1 & t2
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only first operand does not have __band meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return t & 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only second operand does not have __band meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return 5 & t
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__band meta-method throws an error', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__band = function(a, b) error("This is an error") end
      return t & 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}

void testMetamethodBor() {
  group('"__bor" meta method', () {
    test('both operands have __bor meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__bor = function(a, b) return 10 end
      meta2.__bor = function(a, b) return 20 end
      return t1 | t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only first operand has __bor meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__bor = function(a, b) return 10 end
      return t | 5
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only second operand has __bor meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__bor = function(a, b) return 10 end
      return 5 | t
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands do not have __bor meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      return t1 | t2
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only first operand does not have __bor meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return t | 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only second operand does not have __bor meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return 5 | t
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__bor meta-method throws an error', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__bor = function(a, b) error("This is an error") end
      return t | 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}

void testMetamethodBxor() {
  group('"__bxor" meta method', () {
    test('both operands have __bxor meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__bxor = function(a, b) return 10 end
      meta2.__bxor = function(a, b) return 20 end
      return t1 ~ t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only first operand has __bxor meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__bxor = function(a, b) return 10 end
      return t ~ 5
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only second operand has __bxor meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__bxor = function(a, b) return 10 end
      return 5 ~ t
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands do not have __bxor meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      return t1 ~ t2
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only first operand does not have __bxor meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return t ~ 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only second operand does not have __bxor meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return 5 ~ t
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__bxor meta-method throws an error', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__bxor = function(a, b) error("This is an error") end
      return t ~ 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}

void testMetamethodShl() {
  group('"__shl" meta method', () {
    test('both operands have __shl meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__shl = function(a, b) return 10 end
      meta2.__shl = function(a, b) return 20 end
      return t1 << t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only first operand has __shl meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__shl = function(a, b) return 10 end
      return t << 5
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only second operand has __shl meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__shl = function(a, b) return 10 end
      return 5 << t
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands do not have __shl meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      return t1 << t2
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only first operand does not have __shl meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return t << 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only second operand does not have __shl meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return 5 << t
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__shl meta-method throws an error', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__shl = function(a, b) error("This is an error") end
      return t << 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}

void testMetamethodShr() {
  group('"__shr" meta method', () {
    test('both operands have __shr meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      meta1.__shr = function(a, b) return 10 end
      meta2.__shr = function(a, b) return 20 end
      return t1 >> t2
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only first operand has __shr meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__shr = function(a, b) return 10 end
      return t >> 5
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('only second operand has __shr meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__shr = function(a, b) return 10 end
      return 5 >> t
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('both operands do not have __shr meta-method', () async {
      const source = '''
      local meta1 = {}
      local meta2 = {}
      local t1 = setmetatable({}, meta1)
      local t2 = setmetatable({}, meta2)
      return t1 >> t2
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only first operand does not have __shr meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return t >> 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('only second operand does not have __shr meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return 5 >> t
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__shr meta-method throws an error', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__shr = function(a, b) error("This is an error") end
      return t >> 5
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}

void testMetamethodBnot() {
  group('"__bnot" meta method', () {
    test('operand has __bnot meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__bnot = function(a) return 10 end
      return ~t
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('operand does not have __bnot meta-method', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      return ~t
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('__bnot meta-method throws an error', () async {
      const source = '''
      local meta = {}
      local t = setmetatable({}, meta)
      meta.__bnot = function(a) error("This is an error") end
      return ~t
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });
}
