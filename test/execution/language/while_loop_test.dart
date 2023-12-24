import 'package:test/test.dart';

import 'test.dart';

void testWhileLoop() {
  group('while statement', () {
    group('basic loop', () {
      test('loop 5 times', () async {
        const source = '''
        local count = 0
        while count < 5 do
          count = count + 1
        end
        return count;
      ''';
        expect(
          await luaExecute(source),
          luaEquals([5]),
        );
      });
    });

    group('variable scope', () {
      test('inside loop', () async {
        const source = '''
        local outside = 1
        while outside < 3 do
          local inside = 1
          outside = outside + inside
        end
        return outside, inside;
      ''';
        expect(
          await luaExecute(source),
          luaEquals([3, null]),
        );
      });

      test('inside nested loop', () async {
        const source = '''
        local outside = 1
        while outside < 3 do
          local inside1 = 1
          while inside1 < 3 do
            local inside2 = 1
            inside1 = inside1 + inside2
          end
          outside = outside + inside1
        end
        return outside, inside1, inside2;
      ''';
        expect(
          await luaExecute(source),
          luaEquals([4, null, null]),
        );
      });
    });

    group('false condition initially', () {
      test('condition false from the start', () async {
        const source = '''
        local count = 0
        while count > 10 do
          count = count + 1
        end
        return count;
      ''';
        expect(
          await luaExecute(source),
          luaEquals([0]),
        );
      });
    });

    group('break statement', () {
      test('break out of the loop', () async {
        const source = '''
        local count = 0
        while count < 10 do
          count = count + 1
          if count == 5 then
             break
          end
        end
        return count;
      ''';
        expect(
          await luaExecute(source),
          luaEquals([5]),
        );
      });
    });

    group('emulating continue', () {
      test('continue-like behavior with goto', () async {
        const source = '''
        local count = 0
        local total = 0
        while count < 10 do
          count = count + 1
          if count == 5 then
             goto continue
          end
          total = total + count
          ::continue::
        end
        return total;
      ''';
        expect(
          await luaExecute(source),
          luaEquals([50]),
        );
      });
    });

    group('nested while loop', () {
      test('nested loop', () async {
        const source = '''
        local outer = 0
        while outer < 3 do
          local inner = 0
          while inner < 2 do
             inner = inner + 1
          end
          outer = outer + 1
        end
        return outer;
      ''';
        expect(
          await luaExecute(source),
          luaEquals([3]),
        );
      });
    });
  });
}
