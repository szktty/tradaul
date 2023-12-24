import 'package:test/test.dart';
import 'package:tradaul/src/runtime/thread.dart';

import 'test.dart';

void testCoroutine() {
  group('coroutine', () {
    test('basic creation', () async {
      expect(
        await luaExecute('return coroutine.create(function() return 42 end)'),
        luaEquals(
          [luaIsA<LuaCompiledCoroutine>()],
        ),
      );
    });

    group('coroutine.resume', () {
      test('no arguments', () async {
        expect(
          await luaExecute('co = coroutine.create(function() return 42 end); '
              'return coroutine.resume(co)'),
          luaEquals(
            [true, 42],
          ),
        );
      });

      test('arguments and return values', () async {
        expect(
          await luaExecute(
              'co = coroutine.create(function(a, b) return a + b end); '
              'return coroutine.resume(co, 10, 20)'),
          luaEquals(
            [true, 30],
          ),
        );
      });
    });

    group('coroutine.yield', () {
      test('paused', () async {
        expect(
          await luaExecute(
            'co = coroutine.create(function() coroutine.yield("paused"); return "completed" end); return coroutine.resume(co)',
          ),
          luaEquals(
            [true, 'paused'],
          ),
        );
      });
      test('completed', () async {
        const source = '''
    co = coroutine.create(function() 
      coroutine.yield('paused')
      return 'completed'
    end)
    coroutine.resume(co)
    return coroutine.resume(co)
    ''';
        expect(
          await luaExecute(source),
          luaEquals([true, 'completed']),
        );
      });
    });

    group('coroutine.status', () {
      test('suspended', () async {
        expect(
          await luaExecute('''
            co = coroutine.create(function() end)
                return coroutine.status(co)
                '''),
          luaEquals(
            ['suspended'],
          ),
        );
      });

      test('dead', () async {
        expect(
          await luaExecute('''
co = coroutine.create(function() end)
coroutine.resume(co)
return coroutine.status(co)
'''),
          luaEquals(
            ['dead'],
          ),
        );
      });
    });

    group('coroutine.running', () {
      test('main thread', () async {
        expect(
          await luaExecute('return coroutine.running()'),
          luaEquals(
            [luaIsA<LuaCompiledCoroutine>(), true],
          ),
        );
      });

      test('not main thread', () async {
        expect(
          await luaExecute('''
                co = coroutine.create(function() return coroutine.running() end)
                return coroutine.resume(co)
                '''),
          luaEquals(
            [true, luaIsA<LuaCompiledCoroutine>(), false],
          ),
        );
      });
    });

    test('error handling', () async {
      expect(
        await luaExecute('''
            co = coroutine.create(function() error(12345) end)
            return coroutine.resume(co)
            '''),
        luaEquals(
          [false, '12345'],
        ),
      );
    });

    test('nested coroutines', () async {
      expect(
        await luaExecute('''
    local outer = coroutine.create(function()
      local inner = coroutine.create(function() coroutine.yield("inner paused"); return "inner resumed" end)
      local innerStatus, innerValue = coroutine.resume(inner)
      return "outer resumed", innerStatus, innerValue
    end)
    return coroutine.resume(outer)
    '''),
        luaEquals(
          [
            true,
            'outer resumed',
            true,
            'inner paused',
          ],
        ),
      );
    });

    group('coroutine.isyieldable', () {
      test('from main thread', () async {
        expect(
          await luaExecute('return coroutine.isyieldable()'),
          luaEquals(
            [false],
          ),
        );
      });

      test('from yieldable coroutine', () async {
        const source = '''
      local co = coroutine.create(function()
        return coroutine.isyieldable()
      end)
      return coroutine.resume(co)
    ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [true, true],
          ),
        );
      });
    });

    group('coroutine.wrap', () {
      test('no arguments', () async {
        expect(
          await luaExecute('''
wrapped = coroutine.wrap(function() return "wrapped" end)
return wrapped()
'''),
          luaEquals(
            ['wrapped'],
          ),
        );
      });

      test('multiple return values', () async {
        expect(
          await luaExecute('''
wrapped = coroutine.wrap(function() return "a", "b", "c" end)
return wrapped()
'''),
          luaEquals(
            [
              'a',
              'b',
              'c',
            ],
          ),
        );
      });

      test('arguments', () async {
        expect(
          await luaExecute('''
wrapped = coroutine.wrap(function(a, b) return a + b end)
return wrapped(3, 4)
'''),
          luaEquals(
            [7],
          ),
        );
      });

      test('coroutine.wrap with yield', () async {
        expect(
          await luaExecute('''
wrapped = coroutine.wrap(function() coroutine.yield("yielded") end)
return wrapped(), wrapped()
'''),
          luaEquals(
            ['yielded'],
          ),
        );
      });
    });
  });
}

void testCustomCoroutine() {
  group('custom coroutine', () {
    test('creation', () async {
      expect(
        await luaExecute('return range(0, 3)'),
        luaEquals(
          [luaIsA<LuaCustomCoroutine>()],
        ),
      );
    });

    group('resume', () {
      test('single resume', () async {
        const source = '''
    local co = range(1, 3)
    return coroutine.resume(co)
    ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [true, 1],
          ),
        );
      });

      test('basic functionality', () async {
        const source = '''
    local co = range(1, 3)
    local _, a = coroutine.resume(co)
    local _, b = coroutine.resume(co)
    local _, c = coroutine.resume(co)
    return a, b, c
    ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [1, 2, 3],
          ),
        );
      });

      test('end of coroutine', () async {
        const source = '''
    local co = range(1, 1)
    local _, a = coroutine.resume(co)
    local b, _ = coroutine.resume(co)
    return a, b
    ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [1, false],
          ),
        );
      });

      test('resume arguments', () async {
        const source = '''
    local co = range(1, 6)
    local _, a = coroutine.resume(co, 2)
    local _, b = coroutine.resume(co, 2)
    local _, c = coroutine.resume(co, 2)
    return a, b, c
    ''';
        expect(
          await luaExecute(source),
          luaEquals(
            [1, 3, 5],
          ),
        );
      });

      test('status', () async {
        const source = '''
    local co = range(1, 3)
    coroutine.resume(co)
    local status_while_running = coroutine.status(co)
    coroutine.resume(co)
    coroutine.resume(co)
    local status_after_end = coroutine.status(co)
    return status_while_running, status_after_end
    ''';
        expect(
          await luaExecute(source),
          luaEquals(
            ['suspended', 'dead'],
          ),
        );
      });
    });
  });
}
