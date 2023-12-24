import 'package:test/test.dart';

import 'test.dart';

void testNumericForLoop() {
  group('numeric for loop', () {
    test('basic loop', () async {
      const source = '''
        local result = 0
        for i = 1, 5 do
          result = result + i
        end
        return result;
      ''';
      expect(await luaExecute(source), luaEquals([15]));
    });

    group('step value loop', () {
      test('ascending loop with step value', () async {
        const source = '''
        local result = 0
        for i = 1, 5, 2 do
          result = result + i
        end
        return result;
      ''';
        expect(await luaExecute(source), luaEquals([9]));
      });

      test('descending loop with step value', () async {
        const source = '''
        local result = 0
        for i = 5, 1, -2 do
          result = result + i
        end
        return result;
      ''';
        expect(await luaExecute(source), luaEquals([9]));
      });
    });

    test('loop with start value greater than end', () async {
      const source = '''
        local result = 0
        for i = 5, 1 do
          result = result + 1
        end
        return result;
      ''';
      expect(await luaExecute(source), luaEquals([0]));
    });

    test('nested for loop', () async {
      const source = '''
        local result = 0
        for i = 1, 2 do
          for j = 1, 2 do
            result = result + 1
          end
        end
        return result;
      ''';
      expect(await luaExecute(source), luaEquals([4]));
    });

    test('variable scope inside loop', () async {
      const source = '''
        local result = 0
        for i = 1, 2 do
          local inner = i * 2
          result = result + inner
        end
        return result, inner;
      ''';
      expect(await luaExecute(source), luaEquals([6, null]));
    });

    test('break out of the loop', () async {
      const source = '''
        local result = 0
        for i = 1, 5 do
          if i == 3 then
            break
          end
          result = result + i
        end
        return result;
      ''';
      expect(await luaExecute(source), luaEquals([3])); // 1 + 2
    });

    test('for loop without body', () async {
      const source = '''
        for i = 1, 3 do end
        return i;
      ''';
      expect(await luaExecute(source), luaEquals([null]));
    });
  });

  test('exit for loop using goto', () async {
    const source = '''
    local result = 0
    for i = 1, 5 do
      if i == 3 then
        goto exitLoop
      end
      result = result + i
      ::continueLoop::
    end
    ::exitLoop::
    return result;
  ''';
    expect(await luaExecute(source), luaEquals([3]));
  });
}
