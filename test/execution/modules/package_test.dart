import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_context_options.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

import '../language/test.dart';

void main() {
  group('"package" module', () {
    test('"config"', () async {
      const source = 'return package.config';
      expect(
        await luaExecute(source),
        luaEquals(['${Platform.isWindows ? r'\' : '/'}\n;\n?\n!\n-\n']),
      );
    });

    test('"cpath"', () async {
      const source = 'return package.cpath';
      expect(await luaExecute(source), luaEquals(['']));
    });

    test('"path"', () async {
      const source = 'return package.path';
      expect(
        await luaExecute(
          source,
          options: const LuaContextOptions(userModuleSearchPath: ['a', 'b']),
        ),
        luaEquals(['a;b']),
      );
    });

    group('"searchpath"', () {
      group('positive cases', () {
        test('basic search', () async {
          final source = '''
      return package.searchpath("foo", "$luaSearchPathString")
      ''';
          expect(
            await luaExecute(source),
            luaEquals([path.join(searchDir, 'foo.lua')]),
          );
        });

        test('template replacement', () async {
          final source = '''
      return package.searchpath("foo.bar.baz", "$luaSearchPathString")
      ''';
          expect(
            await luaExecute(source),
            luaEquals([path.join(searchDir, 'foo', 'bar', 'baz.lua')]),
          );
        });

        test('custom separator and replacement', () async {
          final source = '''
      return package.searchpath("foo", "$luaSearchPathString", "foo", "baz")
      ''';
          expect(
            await luaExecute(source),
            luaEquals([path.join(searchDir, 'foo', 'bar', 'baz.lua')]),
          );
        });
      });

      group('negative cases', () {
        test('file does not exist', () async {
          const source = '''
      return package.searchpath("nonexistent", "./?.lua")
      ''';
          expect(
            await luaExecute(source),
            luaEquals([null, luaIsA<LuaString>()]),
          );
        });
      });
    });

    test('"loadlib"', () async {
      const source = 'return package.loadlib("a", "b")';
      expect(await luaExecute(source), luaEquals([null]));
    });

    test('"preload"', () async {
      const source = 'return package.preload';
      expect(await luaExecute(source), luaEquals([luaIsA<LuaTable>()]));
    });

    test('"loaded"', () async {
      const source = 'return package.loaded';
      expect(await luaExecute(source), luaEquals([luaIsA<LuaTable>()]));
    });

    test('"preload"', () async {
      const source = '''
        local function f()
          return 12345
        end
        package.preload['test'] = f
        return package.preload['test']()
        ''';
      expect(await luaExecute(source), luaEquals([12345]));
    });

    group('"searchers"', () {
      const moduleValue = 12345;

      group('user module', () {
        test('found', () async {
          final options = LuaContextOptions(userModuleSearchPath: searchPath);
          const source = 'return package.searchers[2]("return_value")';
          expect(
            await luaExecute(source, options: options),
            luaEquals([luaIsA<LuaFunction>(), luaIsA<LuaString>()]),
          );
        });

        test('found (dot separated)', () async {
          final options = LuaContextOptions(userModuleSearchPath: searchPath);
          const source = 'return package.searchers[2]("foo.bar.baz")';
          expect(
            await luaExecute(source, options: options),
            luaEquals([luaIsA<LuaFunction>(), luaIsA<LuaString>()]),
          );
        });

        test('not found', () async {
          final options = LuaContextOptions(userModuleSearchPath: searchPath);
          const source = 'return package.searchers[2]("_no_test_module")';
          expect(
            await luaExecute(source, options: options),
            luaEquals([luaIsA<LuaString>()]),
          );
        });

        test('loader', () async {
          final options = LuaContextOptions(userModuleSearchPath: searchPath);
          const source = '''
          local loader = package.searchers[2]("return_value")
          return loader()
          ''';
          expect(
            await luaExecute(source, options: options),
            luaEquals([moduleValue]),
          );
        });
      });

      test('cpath', () async {
        final options = LuaContextOptions(userModuleSearchPath: searchPath);
        const source = 'return package.searchers[3]("foo")';
        expect(
          await luaExecute(source, options: options),
          luaEquals([luaIsA<LuaString>()]),
        );
      });

      test('all-in-one loader', () async {
        final options = LuaContextOptions(userModuleSearchPath: searchPath);
        const source = 'return package.searchers[4]("foo")';
        expect(
          await luaExecute(source, options: options),
          luaEquals([luaIsA<LuaString>()]),
        );
      });
    });
  });
}
