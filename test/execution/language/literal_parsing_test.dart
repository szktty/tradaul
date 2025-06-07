import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_context.dart';

void main() {
  group('Literal parsing tests for official test suite', () {
    test('should parse string with escape sequences like official test', () async {
      final context = await LuaContext.create();
      
      // This test reproduces the failure from literals.lua
      const luaCode = '''
        local function dostring (x) return assert(load(x), "")() end
        dostring("x \\\\v\\\\f = \\\\t\\\\r 'a\\\\0a' \\\\v\\\\f\\\\f")
        assert(x == 'a\\0a' and string.len(x) == 3)
      ''';
      
      final result = await context.execute(luaCode);
      expect(result.isSuccess(), isTrue, 
          reason: 'Should execute without error: ${result.exceptionOrNull()}');
    });

    test('should handle basic escape sequences', () async {
      final context = await LuaContext.create();
      
      const luaCode = '''
        x = 'a\\0a'
        assert(x == 'a\\0a' and string.len(x) == 3)
      ''';
      
      final result = await context.execute(luaCode);
      expect(result.isSuccess(), isTrue,
          reason: 'Should handle null character in string: ${result.exceptionOrNull()}');
    });
  });
}