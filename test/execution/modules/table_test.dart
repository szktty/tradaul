import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

import '../language/test.dart';

void main() {
  group('table module', () {
    group('table.insert function', () {
      test('insert at the end', () async {
        const source = '''
      local t = {1, 2, 3}
      table.insert(t, 4)
      return t[1], t[2], t[3], t[4]
    ''';
        expect(await luaExecute(source), luaEquals([1, 2, 3, 4]));
      });

      test('insert at specific position', () async {
        const source = '''
      local t = {1, 2, 4}
      table.insert(t, 3, 3)
      return t[1], t[2], t[3], t[4]
    ''';
        expect(await luaExecute(source), luaEquals([1, 2, 3, 4]));
      });

      test('insert with invalid position', () async {
        const source = '''
      local t = {1, 2, 3}
      table.insert(t, 5, 4)
    ''';
        expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
      });
    });

    group('table.remove function', () {
      test('remove from the end', () async {
        const source = '''
      local t = {1, 2, 3}
      return table.remove(t), t[1], t[2], #t
    ''';
        expect(await luaExecute(source), luaEquals([3, 1, 2, 2]));
      });

      test('remove from specific position', () async {
        const source = '''
      local t = {1, 2, 3}
      return table.remove(t, 2), t[1], t[2], #t
    ''';
        expect(await luaExecute(source), luaEquals([2, 1, 3, 2]));
      });

      test('remove from "length + 1" position', () async {
        const source = '''
      local t = {1, 2, 3}
      return table.remove(t, 4), #t
    ''';
        expect(await luaExecute(source), luaEquals([null, 3]));
      });

      test('remove from empty table', () async {
        const source = '''
      local t = {}
      return table.remove(t), #t
    ''';
        expect(await luaExecute(source), luaEquals([null, 0]));
      });

      test('remove from empty table with position 0', () async {
        const source = '''
      return table.remove({}, 0)
    ''';
        expect(await luaExecute(source), luaEquals([null]));
      });

      test('remove from empty table with length + 1', () async {
        const source = '''
      return table.remove({}, 1)
    ''';
        expect(await luaExecute(source), luaEquals([null]));
      });
    });

    group('table.concat function', () {
      test('concatenate string elements', () async {
        const source = '''
      local t = {"Lua", "is", "great"}
      return table.concat(t, " ")
    ''';
        expect(await luaExecute(source), luaEquals(['Lua is great']));
      });

      test('concatenate with specific range', () async {
        const source = '''
      local t = {"Lua", "is", "great", "!"}
      return table.concat(t, " ", 1, 3)
    ''';
        expect(await luaExecute(source), luaEquals(['Lua is great']));
      });

      test('concatenate table with different types', () async {
        const source = '''
      local t = {"Lua", 5, "great"}
      return table.concat(t, " ")
    ''';
        expect(await luaExecute(source), luaEquals(['Lua 5 great']));
      });

      test('start index is greater than end index', () async {
        const source = '''
      local t = {"Lua", "is", "great"}
      return table.concat(t, " ", 5)
    ''';
        expect(await luaExecute(source), luaEquals(['']));
      });

      test('invalid end index', () async {
        const source = '''
      local t = {"Lua", "is", "great"}
      return table.concat(t, " ", 1, 5)
    ''';
        expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
      });
    });

    group('table.sort function', () {
      test('sort in ascending order', () async {
        const source = '''
      local t = {3, 1, 4, 2}
      table.sort(t)
      return t[1], t[2], t[3], t[4]
    ''';
        expect(
          await luaExecute(source),
          luaEquals([
            [1, 2, 3, 4],
          ]),
        );
      });

      test('sort with custom comparison function', () async {
        const source = '''
      local t = {3, 1, 4, 2}
      table.sort(t, function(a, b) return a > b end)
      return t[1], t[2], t[3], t[4]
    ''';
        expect(
          await luaExecute(source),
          luaEquals([
            [4, 3, 2, 1],
          ]),
        );
      });

      test('sort with invalid elements', () async {
        const source = '''
      local t = {1, "two", 3}
      table.sort(t)
    ''';
        expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
      });
    });

    group('table.pack function', () {
      test('pack multiple values', () async {
        const source = '''
      local t = table.pack(1, 2, "three", true)
      return t[1], t[2], t[3], t[4], t.n
    ''';
        expect(await luaExecute(source), luaEquals([1, 2, 'three', true, 4]));
      });

      test('pack no values', () async {
        const source = '''
      local t = table.pack()
      return #t, t.n
    ''';
        expect(await luaExecute(source), luaEquals([0, 0]));
      });

      test('pack nil values', () async {
        const source = '''
      local t = table.pack(nil, nil, nil)
      return #t, t.n
    ''';
        expect(await luaExecute(source), luaEquals([0, 3]));
      });
    });

    group('table.unpack function', () {
      test('unpack multiple values', () async {
        const source = '''
      local t = {1, 2, "three", true}
      return table.unpack(t)
    ''';
        expect(await luaExecute(source), luaEquals([1, 2, 'three', true]));
      });

      test('unpack with specified range', () async {
        const source = '''
      local t = {1, 2, "three", true}
      return table.unpack(t, 2, 3)
    ''';
        expect(await luaExecute(source), luaEquals([2, 'three']));
      });

      test('unpack empty table', () async {
        const source = '''
      local t = {}
      return table.unpack(t)
    ''';
        expect(await luaExecute(source), luaEquals([]));
      });

      test('unpack nil values', () async {
        const source = '''
      local t = {nil, nil, nil}
      return table.unpack(t)
    ''';
        expect(await luaExecute(source), luaEquals([]));
      });
    });

    group('table.move function', () {
      test('move elements within the same table', () async {
        const source = '''
      local t = {1, 2, 3, 4, 5}
      table.move(t, 2, 4, 3)
      return t[1], t[2], t[3], t[4], t[5]
    ''';
        expect(await luaExecute(source), luaEquals([1, 2, 2, 3, 4]));
      });

      test('move elements to a different table', () async {
        const source = '''
      local t1 = {1, 2, 3, 4, 5}
      local t2 = {}
      table.move(t1, 2, 4, 1, t2)
      return #t2, t2[1], t2[2], t2[3]
    ''';
        expect(await luaExecute(source), luaEquals([2, 3, 4]));
      });

      test('move elements with overlapping ranges', () async {
        const source = '''
      local t = {1, 2, 3, 4, 5}
      table.move(t, 1, 3, 2)
      return t[1], t[2], t[3], t[4], t[5]
    ''';
        expect(await luaExecute(source), luaEquals([1, 1, 2, 3, 5]));
      });

      test('move no elements', () async {
        const source = '''
      local t = {1, 2, 3, 4, 5}
      table.move(t, 2, 1, 3)
      return t[1], t[2], t[3], t[4], t[5]
    ''';
        expect(await luaExecute(source), luaEquals([1, 2, 3, 4, 5]));
      });
    });
  });
}
