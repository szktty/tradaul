import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

import 'init_context.dart';
import 'test.dart';

void main() {
  testInitContext();
  testLocalAssignment();
  testAssignment();
}

void testLocalAssignment() {
  group('local assignment', () {
    test('declaration only', () async {
      expect(
        await luaExecute('local a'),
        luaEquals(
          [],
        ),
      );
    });

    test('nil', () async {
      expect(
        await luaExecute('local a = nil'),
        luaEquals(
          [],
        ),
      );
    });

    test('boolean', () async {
      expect(
        await luaExecute('local a = true; return a'),
        luaEquals(
          [true],
        ),
      );
    });

    test('integer', () async {
      expect(
        await luaExecute('local a = 1; return a'),
        luaEquals(
          [1],
        ),
      );
    });

    test('float', () async {
      expect(
        await luaExecute('local a = 1.0; return a'),
        luaEquals(
          [LuaFloat(1)],
        ),
      );
    });

    test('string', () async {
      expect(
        await luaExecute('local a = "hello"; return a'),
        luaEquals(
          ['hello'],
        ),
      );
    });

    test('function call', () async {
      expect(
        await luaExecute('local a = itself(1); return a'),
        luaEquals(
          [1],
        ),
      );
    });

    group('multiple variables', () {
      test('left == right', () async {
        expect(
          await luaExecute('local a, b = true, false; return a, b'),
          luaEquals(
            [true, false],
          ),
        );
      });

      test('left < right', () async {
        expect(
          await luaExecute('local a = true, false; return a, b'),
          luaEquals(
            [true, null],
          ),
        );
      });

      test('left > right', () async {
        expect(
          await luaExecute('local a, b = true; return a, b'),
          luaEquals(
            [true, null],
          ),
        );
      });

      group('function call', () {
        test('single returns', () async {
          expect(
            await luaExecute('local a, b = itself(1), 2; return a, b'),
            luaEquals(
              [1, 2],
            ),
          );
        });

        test('multiple returns', () async {
          expect(
            await luaExecute('local a, b = itself(1,2,3), 4; return a, b'),
            luaEquals(
              [1, 4],
            ),
          );
        });

        group('last function call', () {
          test('single return', () async {
            expect(
              await luaExecute('local a, b = 1, itself(2); return a, b'),
              luaEquals(
                [1, 2],
              ),
            );
          });

          test('multiple returns, left == right', () async {
            expect(
              await luaExecute('local a, b = 1, itself(2,3,4); return a, b'),
              luaEquals(
                [1, 2],
              ),
            );
          });

          test('multiple returns, left < right', () async {
            expect(
              await luaExecute('local a = 1, itself(2,3,4); return a'),
              luaEquals(
                [1],
              ),
            );
          });

          test('multiple returns, left > right', () async {
            expect(
              await luaExecute(
                'local a, b, c = 1, itself(2,3,4); return a, b, c',
              ),
              luaEquals(
                [1, 2, 3],
              ),
            );
          });
        });
      });

      test('override with local variables', () async {
        const source = '''
            local a, b, c = 1, 2, 3
            local a, b, c = 4, 5, 6
            return a, b, c
          ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [4, 5, 6],
          ),
        );
      });
    });
  });
}

void testAssignment() {
  group('simple assignment', () {
    test('nil', () async {
      expect(
        await luaExecute('a = nil; return a'),
        luaEquals(
          [null],
        ),
      );
    });

    test('boolean', () async {
      expect(
        await luaExecute('a = true; return a'),
        luaEquals(
          [true],
        ),
      );
    });

    test('integer', () async {
      expect(
        await luaExecute('a = 1; return a'),
        luaEquals(
          [1],
        ),
      );
    });

    test('float', () async {
      expect(
        await luaExecute('a = 1.0; return a'),
        luaEquals(
          [LuaFloat(1)],
        ),
      );
    });

    test('string', () async {
      expect(
        await luaExecute('a = "hello"; return a'),
        luaEquals(
          ['hello'],
        ),
      );
    });

    test('multiple variables', () async {
      expect(
        await luaExecute('a, b = true, false; return a, b'),
        luaEquals(
          [true, false],
        ),
      );
    });
  });

  group('table access', () {
    group('index notation', () {
      test('access value by integer key', () async {
        expect(
          await luaExecute('t = {4, 5, 6}; return t[1]'),
          luaEquals(
            [4],
          ),
        );
      });

      test('access value by string key', () async {
        expect(
          await luaExecute('t = {a = 1, b = 2}; return t["a"]'),
          luaEquals(
            [1],
          ),
        );
      });

      test('access value by variable key', () async {
        const source = '''
        key = "a"
        t = {a = 1, b = 2}
        return t[key]
      ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [1],
          ),
        );
      });

      test('access value by expression key', () async {
        expect(
          await luaExecute('t = {a = 1, b = 2}; return t[itself("a")]'),
          luaEquals(
            [1],
          ),
        );
      });

      test('modify value by integer key', () async {
        expect(
          await luaExecute('t = {1, 2, 3}; t[1] = 5; return t[1]'),
          luaEquals(
            [5],
          ),
        );
      });

      test('modify value by string key', () async {
        expect(
          await luaExecute(
            't = {a = 1, b = 2}; t["a"] = 5; return t["a"]',
          ),
          luaEquals(
            [5],
          ),
        );
      });

      test('modify value by variable key', () async {
        const source = '''
            key = "a"
            t = {a = 1, b = 2}
            t[key] = 5; return t[key]
      ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [5],
          ),
        );
      });

      test('modify value by expression key', () async {
        expect(
          await luaExecute(
            't = {a = 1, b = 2}; t[itself("a")] = 5; return t[itself("a")]',
          ),
          luaEquals(
            [5],
          ),
        );
      });
    });

    group('dot notation', () {
      test('modify value', () async {
        expect(
          await luaExecute('t = {a = 1, b = 2}; t.a = 5; return t.a'),
          luaEquals(
            [5],
          ),
        );
      });

      test('modify nested table value', () async {
        const source = '''
        t = { a = { b = { c = 5 } } }
        t.a.b.c = 10
        return t.a.b.c
      ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [10],
          ),
        );
      });
    });
  });

  group('multiple variables', () {
    test('left == right', () async {
      expect(
        await luaExecute('a, b = true, false; return a, b'),
        luaEquals(
          [true, false],
        ),
      );
    });

    test('left < right', () async {
      expect(
        await luaExecute('a = true, false; return a, b'),
        luaEquals(
          [true, null],
        ),
      );
    });

    test('left > right', () async {
      expect(
        await luaExecute('a, b = true; return a, b'),
        luaEquals(
          [true, null],
        ),
      );
    });

    group('update local variables', () {
      test('left == right', () async {
        expect(
          await luaExecute('local a, b; a, b = true, false; return a, b'),
          luaEquals(
            [true, false],
          ),
        );
      });

      test('left < right', () async {
        expect(
          await luaExecute('local a, b; a = true, false; return a, b'),
          luaEquals(
            [true, null],
          ),
        );
      });

      test('left > right', () async {
        expect(
          await luaExecute('local a, b; a, b = true; return a, b'),
          luaEquals(
            [true, null],
          ),
        );
      });
    });

    group('function call', () {
      test('single returns', () async {
        expect(
          await luaExecute('a, b = itself(1), 2; return a, b'),
          luaEquals(
            [1, 2],
          ),
        );
      });

      test('not last', () async {
        expect(
          await luaExecute('a, b = itself(1,2,3), 4; return a, b'),
          luaEquals(
            [1, 4],
          ),
        );
      });

      group('last function call', () {
        test('single return', () async {
          expect(
            await luaExecute('a, b = 1, itself(2); return a, b'),
            luaEquals(
              [1, 2],
            ),
          );
        });

        test('multiple returns, left == right', () async {
          expect(
            await luaExecute('a, b = 1, itself(2,3,4); return a, b'),
            luaEquals(
              [1, 2],
            ),
          );
        });

        test('multiple returns, left < right', () async {
          expect(
            await luaExecute('a = 1, itself(2,3,4); return a'),
            luaEquals(
              [1],
            ),
          );
        });

        test('multiple returns, left > right', () async {
          expect(
            await luaExecute('a, b, c = 1, itself(2,3,4); return a, b, c'),
            luaEquals(
              [1, 2, 3],
            ),
          );
        });
      });
    });
  });
}
