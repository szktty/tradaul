import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_context_options.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

import '../language/test.dart';

void main() {
  group('"require" function', () {
    final options = LuaContextOptions(
      userModuleSearchPath: searchPath,
    );

    group('search and load', () {
      test('not found', () async {
        const source = '''
        return require('_')
        ''';
        expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
      });

      test('load', () async {
        const source = '''
        return require('foo')
        ''';
        expect(
          await luaExecute(source, options: options),
          luaEquals([fooModuleValue, path.join(searchDir, 'foo.lua')]),
        );
      });

      test('use module contents', () async {
        const source = '''
        require('foo')
        return foo()
        ''';
        expect(
          await luaExecute(source, options: options),
          luaEquals([fooModuleValue]),
        );
      });

      test('load path (dot-separated)', () async {
        const source = '''
        return require('foo.bar.baz')
        ''';
        expect(
          await luaExecute(source, options: options),
          luaEquals([
            fooBarBazModuleValue,
            path.join(searchDir, 'foo', 'bar', 'baz.lua'),
          ]),
        );
      });
    });

    group('cache loaded module', () {
      test('basic', () async {
        const source = '''
        require('count')
        return count
        ''';
        expect(await luaExecute(source, options: options), luaEquals([1]));
      });

      test('cache', () async {
        const source = '''
        require('count')
        require('count')
        return count
        ''';
        expect(await luaExecute(source, options: options), luaEquals([1]));
      });
    });

    group('"package.loaded"', () {
      test('not loaded', () async {
        const source = '''
        return package.loaded['foo']
        ''';
        expect(await luaExecute(source, options: options), luaEquals([null]));
      });

      test('load', () async {
        const source = '''
        require 'foo'
        return package.loaded['foo']
        ''';
        expect(
          await luaExecute(source, options: options),
          luaEquals([fooModuleValue]),
        );
      });
    });

    group('cyclic reference', () {
      test('cross reference', () async {
        const source = '''
        require 'a'
        ''';
        expect(
          () async => luaExecute(
            source,
            options: LuaContextOptions(
              userModuleSearchPath: [path.join(searchDir, 'cyclic')],
            ),
          ),
          throwsA(isA<LuaException>()),
        );
      });

      test('cyclic reference', () async {
        const source = '''
        require 'self'
        ''';
        expect(
          () async => luaExecute(
            source,
            options: LuaContextOptions(
              userModuleSearchPath: [path.join(searchDir, 'cyclic')],
            ),
          ),
          throwsA(isA<LuaException>()),
        );
      });
    });
  });
}
