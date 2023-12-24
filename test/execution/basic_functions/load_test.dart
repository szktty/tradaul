import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_context_options.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

import '../language/test.dart';

void main() {
  String getFile(String name) {
    return path.join(searchDir, 'load', '$name.lua');
  }

  group('"load" function', () {
    test('basic load and execute', () async {
      const source = '''
    local chunk = load("return 5 + 5")
    return chunk()
    ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('global variable access', () async {
      const source = '''
    value = 7
    local chunk = load("return value + 3")
    return chunk()
    ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('lacking local variable access', () async {
      const source = '''
    local function outer()
      local value = 7
      local chunk = load("return value + 3")
      return chunk()
    end
    return outer()
    ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('global environment', () async {
      const source = '''
    x = 10
    local chunk = load("return x + 5")
    return chunk()
    ''';
      expect(await luaExecute(source), luaEquals([15]));
    });

    test('overriding global environment', () async {
      const source = '''
    x = 10
    local chunk = load("return x + 5", 'chunk', 't', {x=5})
    return chunk()
    ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    group('error cases', () {
      test('compile error', () async {
        const source = '''
    local chunk = load("return 5 +")
    return chunk
    ''';
        expect(await luaExecute(source), luaEquals([null]));
      });

      test('runtime error', () async {
        const source = '''
    local chunk = load("return nil + nil")
    return chunk()
    ''';
        expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
      });

      test('security error', () async {
        const source = '''
    local chunk = load("return 5")
    return chunk
    ''';
        expect(
          () async => luaExecute(
            source,
            options: const LuaContextOptions(
              permissions: LuaPermissions(module: false),
            ),
          ),
          throwsA(isA<LuaException>()),
        );
      });
    });
  });

  group('"loadfile" function', () {
    test('basic load from file', () async {
      final file = getFile('test');
      final source = '''
    return loadfile('$file')
    ''';
      expect(await luaExecute(source), luaEquals([isA<LuaFunction>()]));
    });

    test('basic load and execute from file', () async {
      final file = getFile('test');
      final source = '''
    local chunk = loadfile('$file')
    return chunk()
    ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('syntax error in file', () async {
      final file = getFile('syntax_error');
      final source = '''
    return loadfile('$file')
    ''';
      expect(await luaExecute(source), luaEquals([null, isA<LuaString>()]));
    });

    test('file not found', () async {
      const source = '''
    return loadfile('nonexistent.lua')
    ''';
      expect(await luaExecute(source), luaEquals([null, isA<LuaString>()]));
    });

    test('runtime error in file', () async {
      final file = getFile('runtime_error');
      final source = '''
    local chunk = loadfile('$file')
    return chunk()
    ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('specifying environment for file execution', () async {
      final file = getFile('return_x');
      final source = '''
    local env = {x = 5}
    local chunk = loadfile('$file', 't', env)
    return chunk()
    ''';
      expect(await luaExecute(source), luaEquals([5]));
    });
  });

  group('"dofile" function', () {
    test('execute a file', () async {
      final source = '''
      return dofile("${getFile('test')}")
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('file not found error', () async {
      const source = '''
      dofile("path/to/nonexistent.lua")
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('syntax error in Lua file', () async {
      final source = '''
      dofile("${getFile('syntax_error')}")
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('access and modify global environment', () async {
      final source = '''
      x = 10
      dofile("${getFile('modify_global')}")
      return x
      ''';
      expect(await luaExecute(source), luaEquals([20]));
    });
  });

  group('dofile function', () {
    test('execute a Lua file', () async {
      final source = '''
      return dofile("${getFile('test')}")
      ''';
      expect(await luaExecute(source), luaEquals([10]));
    });

    test('file not found error', () async {
      const source = '''
      dofile("path/to/nonexistent.lua")
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('syntax error in Lua file', () async {
      final source = '''
      dofile(${getFile('syntax_error')})
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('access and modify global environment', () async {
      final source = '''
      x = 10
      local chunk = dofile("${getFile('return_x')}")
      return chunk() 
      ''';
      expect(await luaExecute(source), luaEquals([15]));
    });
  });
}
