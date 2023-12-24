import 'package:test/test.dart';

import 'test.dart';

void testGlobalVariableAccess() {
  group('global variable access', () {
    test('undefined', () async {
      expect(
        await luaExecute('return global_var1'),
        luaEquals(
          [null],
        ),
      );
    });

    test('initialization', () async {
      expect(
        await luaExecute('global_var1 = true; return global_var1'),
        luaEquals(
          [true],
        ),
      );
    });

    test('update', () async {
      expect(
        await luaExecute('global_var2 = 1; return global_var2'),
        luaEquals(
          [1],
        ),
      );
    });

    group('override', () {
      test('global overrides local', () async {
        const source = '''
          local a = 10;
          a = 2;
          return a;
        ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [2],
          ),
        );
      });

      test('local overrides global', () async {
        const source = '''
          a = 10;
          local a = 2;
          return a;
        ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [2],
          ),
        );
      });
    });
  });
}

void testTableFieldAccess() {
  group('table field access', () {
    test('basic list access', () async {
      expect(
        await luaExecute('local t = {1, 2, 3}; return t[1]'),
        luaEquals(
          [1],
        ),
      );
    });

    test('basic key-value pair access', () async {
      expect(
        await luaExecute(
          'local t = {x = "hello", y = "world"}; return t.x, t.y',
        ),
        luaEquals(
          ['hello', 'world'],
        ),
      );
    });

    test('string key access', () async {
      expect(
        await luaExecute(
          'local t = {["a"] = "apple", ["b"] = "banana"}; return t["a"]',
        ),
        luaEquals(
          ['apple'],
        ),
      );
    });

    test('numeric key access', () async {
      expect(
        await luaExecute('local t = {[10] = "ten"}; return t[10]'),
        luaEquals(
          ['ten'],
        ),
      );
    });

    test('access to non-existent key', () async {
      expect(
        await luaExecute('local t = {}; return t.x'),
        luaEquals(
          [null],
        ),
      );
    });

    test('nested table access', () async {
      expect(
        await luaExecute('local t = {a = {b = {c = "value"}}}; return t.a.b.c'),
        luaEquals(
          ['value'],
        ),
      );
    });

    test('dynamic key access', () async {
      expect(
        await luaExecute('local k = "x"; local t = {x = "hello"}; return t[k]'),
        luaEquals(
          ['hello'],
        ),
      );
    });

    test('computed key access', () async {
      expect(
        await luaExecute('local t = {[1+1] = "two"}; return t[2]'),
        luaEquals(
          ['two'],
        ),
      );
    });
  });
}
