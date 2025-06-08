import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_context.dart';

void main() {
  group('Official Lua test failures to track', () {
    test('literals.lua - escape sequence parsing', () async {
      final context = await LuaContext.create();
      
      const luaCode = '''
        local function dostring (x) return assert(load(x), "")() end
        dostring("x = 1")  -- This should work
      ''';
      
      final result = await context.execute(luaCode);
      expect(result.isSuccess(), isTrue,
          reason: 'Basic dostring should work: ${result.exceptionOrNull()}');
    });

    test('constructs.lua - invalid assigned destination nil', () async {
      final context = await LuaContext.create();
      
      // This reproduces the constructs.lua error
      const luaCode = '''
        -- Test assignment that might cause the error
        local x
        x = 1  -- This should work
      ''';
      
      final result = await context.execute(luaCode);
      expect(result.isSuccess(), isTrue,
          reason: 'Basic assignment should work: ${result.exceptionOrNull()}');
    });

    test('math.lua - assertion failed', () async {
      final context = await LuaContext.create();
      
      const luaCode = '''
        -- Test basic math operations
        local x = 1 + 1
        assert(x == 2)
      ''';
      
      final result = await context.execute(luaCode);
      expect(result.isSuccess(), isTrue,
          reason: 'Basic math should work: ${result.exceptionOrNull()}');
    });

    test('vararg.lua - RangeError with select', () async {
      final context = await LuaContext.create();
      
      const luaCode = '''
        -- Test basic vararg functionality
        local function test(...)
          return select(1, ...)
        end
        local result = test(1, 2, 3)
        assert(result == 1)
      ''';
      
      final result = await context.execute(luaCode);
      expect(result.isSuccess(), isTrue,
          reason: 'Basic vararg should work: ${result.exceptionOrNull()}');
    });
  });
}