import 'package:test/test.dart';

import 'test.dart';

void testTableConstructors() {
  group('table constructors', () {
    test('empty', () async {
      expect(
        await luaExecute('return {}'),
        luaEquals(
          [<dynamic>{}],
        ),
      );
    });

    test('list', () async {
      expect(
        await luaExecute('return {1, 2, 3}'),
        luaEquals(
          [
            [1, 2, 3],
          ],
        ),
      );
    });

    test('key-value', () async {
      expect(
        await luaExecute('return {a = 1, b = 2}'),
        luaEquals(
          [
            {'a': 1, 'b': 2},
          ],
        ),
      );
    });

    test('expression key-value (literal)', () async {
      expect(
        await luaExecute('return {["a"] = 1, ["b"] = 2}'),
        luaEquals(
          [
            {'a': 1, 'b': 2},
          ],
        ),
      );
    });

    test('expression key-value (function call)', () async {
      expect(
        await luaExecute('return {[itself("a")]=1}'),
        luaEquals(
          [
            {'a': 1},
          ],
        ),
      );
    });
  });

  group('multiple values', () {
    test('2 values', () async {
      expect(
        await luaExecute('return nil, true'),
        luaEquals(
          [null, true],
        ),
      );
    });

    test('3 values', () async {
      expect(
        await luaExecute('return nil, true, false'),
        luaEquals(
          [null, true, false],
        ),
      );
    });

    test('4 values', () async {
      expect(
        await luaExecute('return nil, true, false, 1'),
        luaEquals(
          [null, true, false, 1],
        ),
      );
    });

    test('5 values', () async {
      expect(
        await luaExecute('return nil, true, false, 1, 2'),
        luaEquals(
          [null, true, false, 1, 2],
        ),
      );
    });
  });
}
