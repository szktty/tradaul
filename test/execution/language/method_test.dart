import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

import 'test.dart';

void testMethodDefinition() {
  group('method definition', () {
    group('definition and call', () {
      void testBase({required bool isLocal}) {
        final local = isLocal ? 'local ' : '';
        group('${isLocal ? 'local' : 'global'} definition', () {
          test('basic method call', () async {
            final source = '''
      $local obj = {}
      function obj:hello()
          return "Hello, World!" 
      end
      return obj:hello()
      ''';
            expect(await luaExecute(source), luaEquals(['Hello, World!']));
          });

          test('dot notation vs colon notation', () async {
            final source = '''
      $local obj = {}
      function obj:greet(name) 
          return "Hello, " .. name .. "!" 
      end
      return obj.greet(obj, "Alice"), obj:greet("Alice")
      ''';
            expect(
              await luaExecute(source),
              luaEquals(['Hello, Alice!', 'Hello, Alice!']),
            );
          });

          test('method with multiple arguments', () async {
            final source = '''
      $local obj = {}
      function obj:sum(a, b) 
          return a + b 
      end
      return obj:sum(3, 4)
      ''';
            expect(await luaExecute(source), luaEquals([7]));
          });

          test('method with varargs', () async {
            final source = '''
      $local obj = {}
      function obj:getFirstArg(...) 
          return select(1, ...)
      end 
      return obj:getFirstArg(1, 2, 3, 4)
      ''';
            expect(await luaExecute(source), luaEquals([1, 2, 3, 4]));
          });
        });
      }

      testBase(isLocal: true);
      testBase(isLocal: false);
    });

    group('method chain and self', () {
      test('using self', () async {
        const source = '''
      local obj = {
        value = 5
      }
      function obj:double() 
          self.value = self.value * 2 
      end
      obj:double()
      return obj.value
      ''';
        expect(await luaExecute(source), luaEquals([10]));
      });

      test('method chaining', () async {
        const source = '''
      local obj = {
        value = 0
      }
      function obj:increment() 
          self.value = self.value + 1 
          return self 
      end
      function obj:getValue() 
          return self.value 
      end
      return obj:increment():increment():getValue()
      ''';
        expect(await luaExecute(source), luaEquals([2]));
      });

      test('method chaining starts with function', () async {
        const source = '''
      local obj = {
        value = 0
      }
      function get() 
          return obj 
      end
      function obj:increment() 
          self.value = self.value + 1 
          return self 
      end
      function obj:getValue() 
          return self.value 
      end
      return get():increment():increment():getValue()
      ''';
        expect(await luaExecute(source), luaEquals([2]));
      });

      test('method chaining without return', () async {
        const source = '''
      local obj = {
        value = 0
      }
      function obj:increment() 
          self.value = self.value + 1 
          return self 
      end
      obj:increment():increment()
      return obj.value
      ''';
        expect(await luaExecute(source), luaEquals([2]));
      });
    });

    group('error cases', () {
      test('call method on nil object', () async {
        const source = '''
      local obj = nil
      return obj:hello()
      ''';
        expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
      });

      test('call undefined method', () async {
        const source = '''
      local obj = {}
      return obj:undefinedMethod()
      ''';
        expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
      });
    });

    group('table and methods', () {
      test('calling function inside table as method', () async {
        const source = '''
      local obj = {}
      function obj:hello() 
          return "Hello from table!" 
      end
      return obj:hello()
      ''';
        expect(await luaExecute(source), luaEquals(['Hello from table!']));
      });
    });
  });
}
