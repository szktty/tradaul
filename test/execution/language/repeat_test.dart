import 'package:test/test.dart';

import 'test.dart';

void testRepeatLoop() {
  group('repeat-until statement', () {
    group('basic loop', () {
      test('loop until condition is true', () async {
        const source = '''
        local count = 0
        repeat
          count = count + 1
        until count == 5
        return count;
      ''';
        expect(await luaExecute(source), luaEquals([5]));
      });
    });

    group('variable scope', () {
      test('inside loop', () async {
        const source = '''
        local outside = 1
        repeat
          local inside = outside + 1
          outside = outside + inside
        until outside >= 5
        return outside, inside;
      ''';
        expect(await luaExecute(source), luaEquals([7, null]));
      });
    });

    group('true condition initially', () {
      test('condition true from the start', () async {
        const source = '''
        local count = 10
        repeat
          count = count + 1
        until count > 5
        return count;
      ''';
        expect(await luaExecute(source), luaEquals([11]));
      });
    });

    group('break statement', () {
      test('break out of the loop', () async {
        const source = '''
        local count = 0
        repeat
          count = count + 1
          if count == 5 then
             break
          end
        until count == 10
        return count;
      ''';
        expect(await luaExecute(source), luaEquals([5]));
      });
    });

    group('nested repeat-until loop', () {
      test('nested loop', () async {
        const source = '''
        local outer = 0
        repeat
          local inner = 0
          repeat
             inner = inner + 1
          until inner == 2
          outer = outer + 1
        until outer == 3
        return outer;
      ''';
        expect(await luaExecute(source), luaEquals([3]));
      });
    });

    group('loop with complex condition', () {
      test('multiple conditions', () async {
        const source = '''
        local x, y = 0, 0
        repeat
          x = x + 1
          y = y + 2
        until x == 5 or y == 10
        return x, y;
      ''';
        expect(await luaExecute(source), luaEquals([5, 10]));
      });
    });

    group('loop without body', () {
      test('empty loop body', () async {
        const source = '''
        local count = 0
        repeat
        until count == 0
        return count;
      ''';
        expect(await luaExecute(source), luaEquals([0]));
      });
    });

    group('condition at the end', () {
      test('evaluated after body', () async {
        const source = '''
        local count = 0
        repeat
          count = 5
        until count == 5
        return count;
      ''';
        expect(await luaExecute(source), luaEquals([5]));
      });
    });
  });
}
