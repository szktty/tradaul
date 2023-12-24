import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

import '../language/test.dart';

void main() {
  group('string.gsub function tests', () {
    test('basic substitution', () async {
      const source = '''
        return string.gsub("hello world", "world", "Dart")
      ''';
      expect(await luaExecute(source), luaEquals(['hello Dart', 1]));
    });

    test('no match', () async {
      const source = '''
        return string.gsub("hello world", "abc", "Dart")
      ''';
      expect(await luaExecute(source), luaEquals(['hello world', 0]));
    });

    test('escape character', () async {
      const source = '''
        return string.gsub("hello world", "hello", "%%")
      ''';
      expect(await luaExecute(source), luaEquals(['% world', 1]));
    });

    test('pattern matching', () async {
      const source = '''
        return string.gsub("hello world", "%a+", "X")
      ''';
      expect(await luaExecute(source), luaEquals(['X X', 2]));
    });

    test('substitution with captures', () async {
      const source = '''
        return string.gsub("hello world", "(%w+) (%w+)", "%2 %1")
      ''';
      expect(await luaExecute(source), luaEquals(['world hello', 1]));
    });

    test('multiple substitution', () async {
      const source = '''
        return string.gsub("banana", "a", "o")
      ''';
      expect(await luaExecute(source), luaEquals(['bonono', 3]));
    });

    test('substitution with limit', () async {
      const source = '''
        return string.gsub("banana", "a", "o", 2)
      ''';
      expect(await luaExecute(source), luaEquals(['bonona', 2]));
    });

    test('special characters', () async {
      const source = '''
        return string.gsub("one + one = two", "%+", "plus")
      ''';
      expect(await luaExecute(source), luaEquals(['one plus one = two', 1]));
    });

    test('substitution using function', () async {
      const source = '''
    return string.gsub("1 2 3 4 5", "(%d)", function (s)
          return tonumber(s) * 2
        end)
  ''';
      expect(await luaExecute(source), luaEquals(['2 4 6 8 10', 5]));
    });

    test('no match behavior', () async {
      const source = '''
        return string.gsub("hello world", "bye", "hi")
      ''';
      expect(await luaExecute(source), luaEquals(['hello world', 0]));
    });

    test('substitution using table', () async {
      const source = r'''
        local t = {name="lua", version="5.3"}
        return string.gsub("$name-$version.tar.gz", "%$(%w+)", t)
      ''';
      expect(await luaExecute(source), luaEquals(['lua-5.3.tar.gz', 2]));
    });

    test('invalid pattern error', () async {
      const source = '''
        return string.gsub("hello world", "[%w+", "X")
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('replacement with %d captures', () async {
      const source = '''
      return string.gsub("hello world", "(%w+) (%w+)", "%2 %1", 1)
    ''';
      expect(await luaExecute(source), luaEquals(['world hello', 1]));
    });

    test('replacement with %0 for whole match', () async {
      const source = '''
      return string.gsub("hello world", "%w+", "%0 %0", 1)
    ''';
      expect(await luaExecute(source), luaEquals(['hello hello world', 1]));
    });

    test('escaping % with %% in replacement string', () async {
      const source = '''
      return string.gsub("hello world", "(%w+)", "%%1%1", 1)
    ''';
      expect(await luaExecute(source), luaEquals(['%1hello world', 1]));
    });

    test('table replacement with 1st capture as key', () async {
      const source = '''
      local t = {hello = "hi", world = "earth"}
      return string.gsub("hello world", "(%w+)", t)
    ''';
      expect(await luaExecute(source), luaEquals(['hi earth', 2]));
    });

    test('function replacement with all captures as arguments', () async {
      const source = '''
      return string.gsub("hello world", "(%w+) (%w+)", function(a, b)
            return b..a
          end)
    ''';
      expect(await luaExecute(source), luaEquals(['worldhello', 1]));
    });

    test('no substitution for false or nil return from table or function',
        () async {
      const source = '''
      local t = {hello = "hi", world = nil}
      return string.gsub("hello world", "(%w+)", t)
    ''';
      expect(await luaExecute(source), luaEquals(['hi world', 2]));
    });
  });
}
