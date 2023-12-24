import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

import 'test.dart';

void testFunctionCall() {
  group('function call', () {
    group('no return value', () {
      test('no arguments', () async {
        expect(
          await luaExecute('itself()'),
          luaEquals(
            [],
          ),
        );
      });
      test('1 argument', () async {
        expect(
          await luaExecute('itself(1)'),
          luaEquals(
            [],
          ),
        );
      });
      test('multiple arguments', () async {
        expect(
          await luaExecute('itself(1,2,3)'),
          luaEquals(
            [],
          ),
        );
      });
      test('pass a variable', () async {
        expect(
          await luaExecute('local a = "hello"; itself(a)'),
          luaEquals(
            [],
          ),
        );
      });
    });

    group('function call (with a return value)', () {
      test('return directly', () async {
        expect(
          await luaExecute('return itself(1)'),
          luaEquals(
            [1],
          ),
        );
      });

      test('assign to a local variable', () async {
        expect(
          await luaExecute('local a = itself(1); return a'),
          luaEquals(
            [1],
          ),
        );
      });

      test('assign to local variables', () async {
        expect(
          await luaExecute(
            'local x, y, z = itself(1), itself(2), itself(3); return x, y, z',
          ),
          luaEquals(
            [1, 2, 3],
          ),
        );
      });
    });

    group('with return values', () {
      test('discard', () async {
        expect(
          await luaExecute('itself(1,2,3)'),
          luaEquals(
            [],
          ),
        );
      });
      test('return directly', () async {
        expect(
          await luaExecute('return itself(1,2,3)'),
          luaEquals(
            [1, 2, 3],
          ),
        );
      });
      test('assign each of values', () async {
        expect(
          await luaExecute('local a,b,c = itself(1,2,3); return a,b,c'),
          luaEquals(
            [1, 2, 3],
          ),
        );
      });
      test('assign first value only', () async {
        expect(
          await luaExecute('local f = itself(1,2,3); return f'),
          luaEquals(
            [1],
          ),
        );
      });
    });

    group('function call statement', () {
      test('call chain', () async {
        expect(
          await luaExecute('''
            local t = {f=itself}
            itself(t).f()
            '''),
          luaEquals([]),
        );
      });
    });
  });
}

void testFunctionDefinition() {
  testFunctionDefinitionBase(isLocal: false);
}

void testLocalFunctionDefinition() {
  testFunctionDefinitionBase(isLocal: true);
}

void testFunctionDefinitionBase({required bool isLocal}) {
  final local = isLocal ? 'local' : '';

  group('$local function definition', () {
    test('compile', () async {
      expect(
        await luaExecute('$local function simpleFunction() end'),
        luaEquals([]),
      );
    });

    test('function without arguments', () async {
      expect(
        await luaExecute(
          '$local function noArgs() return "noArgs" end; return noArgs()',
        ),
        luaEquals(['noArgs']),
      );
    });

    test('function with a single argument', () async {
      expect(
        await luaExecute('''
          $local function singleArg(a)
            return a
          end
          return singleArg("argValue")
          '''),
        luaEquals(
          ['argValue'],
        ),
      );
    });

    test('function with multiple arguments', () async {
      expect(
        await luaExecute('''
          $local function multipleArgs(a, b) return a, b end
          local x, y = multipleArgs("arg1", "arg2")
          return x
          '''),
        luaEquals(
          ['arg1'],
        ),
      );
    });

    test('function without return statement', () async {
      expect(
        await luaExecute('$local function noReturn() end; return noReturn()'),
        luaEquals(
          [],
        ),
      );
    });

    test('function with return but no return value', () async {
      expect(
        await luaExecute(
          '$local function returnNoValue() return end; return returnNoValue()',
        ),
        luaEquals(
          [],
        ),
      );
    });

    test('function returning an unrelated literal', () async {
      expect(
        await luaExecute(
          '$local function returnLiteral() return "literal" end; return returnLiteral()',
        ),
        luaEquals(
          ['literal'],
        ),
      );
    });

    test('function called twice', () async {
      expect(
        await luaExecute(
          '$local function twiceCall() return "called" end; twiceCall(); return twiceCall()',
        ),
        luaEquals(
          ['called'],
        ),
      );
    });

    test('function with no return followed by a return in the next line',
        () async {
      expect(
        await luaExecute(
          '$local function noReturnFunction() end; noReturnFunction(); return "afterFunction"',
        ),
        luaEquals(
          ['afterFunction'],
        ),
      );
    });

    group('$local function with upvalues', () {
      test('captures a single upvalue', () async {
        final source = '''
        local outerVar = 10
        $local function innerFunc() 
          return outerVar 
        end
        return innerFunc()
      ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [10],
          ),
        );
      });

      test('captures multiple upvalues', () async {
        final source = '''
        local a, b = 10, 20
        $local function innerFunc() 
          return a + b 
        end
        return innerFunc()
      ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [30],
          ),
        );
      });

      test('modifies an upvalue', () async {
        final source = '''
        local value = 10
        $local function addToValue(v) 
          value = value + v 
        end
        addToValue(5)
        return value
      ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [15],
          ),
        );
      });

      test('nested function upvalue capture', () async {
        final source = '''
        local outer = 10
        $local function middleFunc() 
          local middle = 20
          $local function innerFunc()
            return outer + middle 
          end
          return innerFunc()
        end
        return middleFunc()
      ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [30],
          ),
        );
      });

      test('upvalue shared among functions in the same scope', () async {
        final source = '''
        local shared = 10
        $local function funcA() 
          shared = shared + 10 
        end
        $local function funcB() 
          shared = shared * 2 
        end
        funcA()
        funcB()
        return shared
      ''';
        expect(await luaExecute(source), luaEquals([40]));
      });

      test('upvalue capture in loop function definitions', () async {
        final source = '''
        local funcs = {}
        for i=1, 3 do
          local loopVar = i
          $local function loopFunc()
            return loopVar
          end
          funcs[i] = loopFunc
        end
        return funcs[1](), funcs[2](), funcs[3]()
      ''';
        expect(await luaExecute(source), luaEquals([1, 2, 3]));
      });

      test('function redefinition and upvalue', () async {
        final source = '''
        local value = 10
        $local function func() 
          return value 
        end
        value = 20
        $local function func() 
          return value + 10 
        end
        return func()
      ''';
        expect(await luaExecute(source), luaEquals([30]));
      });

      test('closure recursion and upvalue', () async {
        final source = '''
        local value = 3
        $local function recursiveFunc(n)
          if n <= 0 then return value end
          value = value - 1
          return recursiveFunc(n-1)
        end
        return recursiveFunc(2)
      ''';
        expect(await luaExecute(source), luaEquals([1]));
      });

      test(
          'effects of modifying an upvalue shared among multiple inner functions',
          () async {
        final source = '''
        local shared = 10
        $local function funcA() 
          shared = shared + 5 
        end
        $local function funcB() 
          return shared 
        end
        funcA()
        return funcB()
      ''';
        expect(await luaExecute(source), luaEquals([15]));
      });
    });

    group('variable arguments', () {
      test('basic use of varargs', () async {
        final source = '''
    $local function foo(...)
      local a, b, c = ...
      return a, b, c
    end
    return foo(1, 2, 3)
    ''';
        expect(await luaExecute(source), luaEquals([1, 2, 3]));
      });

      test('function with only varargs', () async {
        final source = '''
    $local function bar(...)
      return ...
    end
    return bar(4, 5, 6)
    ''';
        expect(await luaExecute(source), luaEquals([4, 5, 6]));
      });

      test('mixed fixed and varargs', () async {
        final source = '''
    $local function baz(a, b, ...)
      local c, d = ...
      return a, b, c, d
    end
    return baz(7, 8, 9, 10)
    ''';
        expect(await luaExecute(source), luaEquals([7, 8, 9, 10]));
      });

      test('pass varargs to another function', () async {
        final source = '''
    $local function bar(...)
      local a, b = ...
      return a, b
    end
    
    $local function foo(...)
      return bar(...)
    end
  
    return foo(11, 12)
    ''';
        expect(await luaExecute(source), luaEquals([11, 12]));
      });

      test('use varargs as table', () async {
        final source = '''
    $local function baz(...)
      local args = {...}
      return args[1], args[2], args[3]
    end
    return baz(13, 14, 15)
    ''';
        expect(await luaExecute(source), luaEquals([13, 14, 15]));
      });

      test('incorrect use of varargs', () async {
        final source = '''
    $local function errFunc(..., ...)
      return ...
    end
    return errFunc(16, 17)
    ''';
        expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
      });
    });
  });

  group('variable scope in function', () {
    group('global variables', () {
      test('get', () async {
        final source = '''
          global_var3 = 10;
          $local function get_global_var3()
            return global_var3;
          end
          return get_global_var3();
        ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [10],
          ),
        );
      });

      test('update', () async {
        final source = '''
        global_var4 = 0;
        $local function modify_var4()
          global_var4 = 3;
        end
        modify_var4();
        return global_var4;
      ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [3],
          ),
        );
      });

      test('local overrides global', () async {
        final source = '''
          global_var3 = 10;
          $local function get_global_var3()
            local global_var3 = 2;
          end
          return global_var3;
        ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [10],
          ),
        );
      });

      test('as function parameter', () async {
        final source = '''
        global_var5 = 3;
        $local function use_global_as_parameter(var)
          return var * 2;
        end
        return use_global_as_parameter(global_var5);
      ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [6],
          ),
        );
      });
    });
  });
}
