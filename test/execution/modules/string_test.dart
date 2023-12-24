import 'package:test/test.dart';

import '../language/test.dart';

void main() {
  group('string module functions', () {
    test('string.byte', () async {
      expect(await luaExecute('return string.byte("abc", 2)'), luaEquals([98]));
    });

    test('string.char', () async {
      expect(
        await luaExecute('return string.char(97, 98, 99)'),
        luaEquals(['abc']),
      );
    });

    group('string.find', () {
      test('basic pattern match', () async {
        expect(
          await luaExecute('return string.find("Hello, World!", "World")'),
          luaEquals([8, 12]),
        );
      });

      test('pattern not found', () async {
        expect(
          await luaExecute('return string.find("Hello, World!", "Lua")'),
          luaEquals([null]),
        );
      });

      test('specify start position', () async {
        expect(
          await luaExecute('return string.find("Hello, World!", "o", 5)'),
          luaEquals([5, 5]),
        );
      });

      test('negative start position', () async {
        expect(
          await luaExecute('return string.find("Hello, World!", "o", -5)'),
          luaEquals([9, 9]),
        );
      });

      test('plain search', () async {
        expect(
          await luaExecute(
            'return string.find("Hello, World!", "%a+", 1, true)',
          ),
          luaEquals([null]),
        );
      });

      test('pattern with captures', () async {
        expect(
          await luaExecute(
            'return string.find("Hello, World!", "(%a+), (%a+!)")',
          ),
          luaEquals([1, 13, 'Hello', 'World!']),
        );
      });

      test('multiple matches, first only returned', () async {
        expect(
          await luaExecute('return string.find("Hello, World, Lua!", "o")'),
          luaEquals([5, 5]),
        );
      });
    });

    group('string.gmatch', () {
      test('basic usage', () async {
        const source = '''
      local result = {}
      for w in string.gmatch("hello world from Lua", "%a+") do
        table.insert(result, w)
      end
      return result
    ''';
        expect(
          await luaExecute(source),
          luaEquals([
            ['hello', 'world', 'from', 'Lua'],
          ]),
        );
      });

      test('pattern with captures', () async {
        const source = '''
      local result = {}
      for k, v in string.gmatch("from=world, to=Lua", "(%w+)=(%w+)") do
        result[k] = v
      end
      return result
    ''';
        expect(
          await luaExecute(source),
          luaEquals([
            {'from': 'world', 'to': 'Lua'},
          ]),
        );
      });

      test('pattern without captures', () async {
        const source = '''
      local result = {}
      for m in string.gmatch("hello world", "hello") do
        table.insert(result, m)
      end
      return result
    ''';
        expect(
          await luaExecute(source),
          luaEquals([
            ['hello'],
          ]),
        );
      });

      test('specify start position', () async {
        const source = '''
      local result = {}
      for w in string.gmatch("hello world from Lua", "%a+", 7) do
        table.insert(result, w)
      end
      return result
    ''';
        expect(
          await luaExecute(source),
          luaEquals([
            ['world', 'from', 'Lua'],
          ]),
        );
      });

      test('negative start position', () async {
        const source = '''
      local result = {}
      for w in string.gmatch("hello world from Lua", "%a+", -3) do
        table.insert(result, w)
      end
      return result
    ''';
        expect(
          await luaExecute(source),
          luaEquals([
            ['Lua'],
          ]),
        );
      });

      test('no matches', () async {
        const source = '''
      local result = {}
      for w in string.gmatch("hello world from Lua", "xyz") do
        table.insert(result, w)
      end
      return result
    ''';
        expect(await luaExecute(source), luaEquals([[]]));
      });
    });

    group('string.gsub', () {
      test('basic substitution', () async {
        const source = '''
      return string.gsub("hello world", "(%w+)", "%1 %1")
    ''';
        expect(
          await luaExecute(source),
          luaEquals(['hello hello world world', 2]),
        );
      });

      test('limiting the number of substitutions', () async {
        const source = '''
      return string.gsub("hello world", "%w+", "%0 %0", 1)
    ''';
        expect(await luaExecute(source), luaEquals(['hello hello world', 1]));
      });

      test('substitution with captures', () async {
        const source = '''
      return string.gsub("hello world from Lua", "(%w+)%s*(%w+)", "%2 %1")
    ''';
        expect(
          await luaExecute(source),
          luaEquals(['world hello Lua from', 2]),
        );
      });

      test('substitution using a table', () async {
        const source = r'''
      local t = {name="lua", version="5.4"}
      return string.gsub("$name-$version.tar.gz", "%$(%w+)", t)
    ''';
        expect(await luaExecute(source), luaEquals(['lua-5.4.tar.gz', 2]));
      });

      test('substitution using a function', () async {
        const source = r'''
      return string.gsub("4+5 = $return 4+5$", "%$(.-)%$", function (s)
        return load(s)()
      end)
    ''';
        expect(await luaExecute(source), luaEquals(['4+5 = 9', 1]));
      });

      test('checking the number of substitutions', () async {
        const source = '''
      return string.gsub("hello world", "%w+", "word")
    ''';
        expect(await luaExecute(source), luaEquals(['word word', 2]));
      });

      test('behavior with no captures', () async {
        const source = '''
      return string.gsub("hello world", "hello", "hi")
    ''';
        expect(await luaExecute(source), luaEquals(['hi world', 1]));
      });
    });

    test('string.len', () async {
      expect(await luaExecute('return string.len("hello")'), luaEquals([5]));
    });

    test('string.lower', () async {
      expect(
        await luaExecute('return string.lower("HeLLo")'),
        luaEquals(['hello']),
      );
    });

    group('string.match', () {
      test('basic matching', () async {
        const source = '''
      return string.match("hello world", "world")
    ''';
        expect(await luaExecute(source), luaEquals(['world']));
      });

      test('matching with captures', () async {
        const source = '''
      return string.match("hello world", "(%w+) (%w+)")
    ''';
        expect(await luaExecute(source), luaEquals(['hello', 'world']));
      });

      test('no captures in pattern', () async {
        const source = '''
      return string.match("hello world", "%w+ %w+")
    ''';
        expect(await luaExecute(source), luaEquals(['hello world']));
      });

      test('specifying start position', () async {
        const source = '''
      return string.match("hello world", "world", 3)
    ''';
        expect(await luaExecute(source), luaEquals(['world']));
      });

      test('no match found', () async {
        const source = '''
      return string.match("hello world", "test")
    ''';
        expect(await luaExecute(source), luaEquals([null]));
      });
    });

    group('string.rep', () {
      test('replicating string multiple times', () async {
        expect(
          await luaExecute('return string.rep("ab", 3)'),
          luaEquals(['ababab']),
        );
      });

      test('replicating string zero times', () async {
        expect(await luaExecute('return string.rep("ab", 0)'), luaEquals(['']));
      });
    });

    test('string.reverse', () async {
      expect(
        await luaExecute('return string.reverse("hello")'),
        luaEquals(['olleh']),
      );
    });

    group('string.sub', () {
      test('substring with positive indices', () async {
        expect(
          await luaExecute('return string.sub("Hello, World!", 2, 5)'),
          luaEquals(['ello']),
        );
      });

      test('substring with negative indices', () async {
        expect(
          await luaExecute('return string.sub("Hello, World!", -5, -2)'),
          luaEquals(['orld']),
        );
      });

      test('substring with mixed indices', () async {
        expect(
          await luaExecute('return string.sub("Hello, World!", 2, -2)'),
          luaEquals(['ello, World']),
        );
      });
    });

    test('string.upper', () async {
      expect(
        await luaExecute('return string.upper("hello")'),
        luaEquals(['HELLO']),
      );
    });
  });
}
