import 'package:test/test.dart';

import 'test.dart';

void testDoBlock() {
  group('do statement', () {
    group('basic scope verification', () {
      test('variable defined inside block not accessible outside', () async {
        const source = '''
        do
          local inside = 1
        end
        return inside;
      ''';
        expect(await luaExecute(source), luaEquals([null]));
      });
    });

    group('access to parent scope', () {
      test('access variable from parent scope', () async {
        const source = '''
        local outside = 1
        do
          outside = outside + 1
        end
        return outside;
      ''';
        expect(await luaExecute(source), luaEquals([2]));
      });
    });

    group('modifying parent scope variable', () {
      test('modify variable from parent scope', () async {
        const source = '''
        local outside = 1
        do
          outside = 5
        end
        return outside;
      ''';
        expect(await luaExecute(source), luaEquals([5]));
      });
    });

    group('variable shadowing', () {
      test('shadow variable from parent scope', () async {
        const source = '''
        local x = 1
        do
          local x = 5
          x = x + 1
        end
        return x;
      ''';
        expect(await luaExecute(source), luaEquals([1]));
      });
    });

    group('nesting', () {
      test('nested do blocks', () async {
        const source = '''
        local x = 1
        do
          local y = 2
          do
            local z = 3
          end
          y = y + 1
        end
        return x, y, z;
      ''';
        expect(await luaExecute(source), luaEquals([1, null, null]));
      });
    });

    group('do block with return statement', () {
      test('return inside do block', () async {
        const source = '''
        do
          return 5
        end
        return 1;
      ''';
        expect(await luaExecute(source), luaEquals([5]));
      });
    });
  });
}
