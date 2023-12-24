import 'package:test/test.dart';

import 'test.dart';

void testLiterals() {
  group('basic return', () {
    test('no value', () async {
      expect(
        await luaExecute('return'),
        luaEquals(
          [],
        ),
      );
    });
  });

  group('literals', () {
    test('nil', () async {
      expect(
        await luaExecute('return nil'),
        luaEquals(
          [null],
        ),
      );
    });

    test('true', () async {
      expect(
        await luaExecute('return true'),
        luaEquals(
          [true],
        ),
      );
    });

    test('false', () async {
      expect(
        await luaExecute('return false'),
        luaEquals(
          [false],
        ),
      );
    });

    test('integer', () async {
      expect(
        await luaExecute('return 1'),
        luaEquals(
          [1],
        ),
      );
    });

    test('float', () async {
      expect(
        await luaExecute('return 1.0'),
        luaEquals(
          [1.0],
        ),
      );
    });

    group('string', () {
      test('simple', () async {
        expect(await luaExecute('return "hello"'), luaEquals(['hello']));
      });
    });
  });
}
