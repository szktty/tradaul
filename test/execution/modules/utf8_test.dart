import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

import '../language/test.dart';

void main() {
  group('utf8 module', () {
    group('utf8.char', () {
      test('valid codepoints', () async {
        expect(
          await luaExecute('return utf8.char(0x1F600, 0x1F602, 0x1F604)'),
          luaEquals(['😀😂😄']),
        );
      });

      test('invalid codepoint', () async {
        expect(
          () async => luaExecute('return utf8.char(0x110000)'),
          throwsA(isA<LuaException>()),
        );
      });
    });

    group('utf8.charpattern tests', () {
      test('utf8.charpattern is a string', () async {
        const source = '''
        return utf8.charpattern
      ''';
        expect(await luaExecute(source), luaEquals([isA<LuaString>()]));
      });

      test('Find first character using utf8.charpattern', () async {
        const source = '''
        local str = "こんにちは"
        local firstPos, lastPos = string.find(str, utf8.charpattern)
        return string.sub(str, firstPos, lastPos)
      ''';
        expect(await luaExecute(source), luaEquals(['こ']));
      });
    });

    group('utf8.codes', () {
      test('valid UTF-8 string', () async {
        const source = '''
    local result = {}
    for p, c in utf8.codes("😀😂😄") do
      table.insert(result, {p, c})
    end
    return result
    ''';
        expect(
          await luaExecute(source),
          luaEquals([
            [1, 0x1F600],
            [5, 0x1F602],
            [9, 0x1F604],
          ]),
        );
      });

      test('invalid UTF-8 string', () async {
        expect(
          () async =>
              await luaExecute('for p, c in utf8.codes("\xC3\x28") do end'),
          throwsA(isA<LuaException>()),
        );
      });
    });

    group('utf8.codepoint', () {
      test('valid position', () async {
        expect(
          await luaExecute('return utf8.codepoint("😀😂😄", 1)'),
          luaEquals([0x1F600]),
        );
      });

      test('invalid position', () async {
        expect(
          () async => await luaExecute('return utf8.codepoint("abc", 10)'),
          throwsA(isA<LuaException>()),
        );
      });
    });

    group('utf8.len', () {
      test('valid UTF-8 string', () async {
        expect(await luaExecute('return utf8.len("😀😂😄")'), luaEquals([3]));
      });

      test('invalid UTF-8 string', () async {
        expect(
          () async => await luaExecute('return utf8.len("\xC3\x28")'),
          throwsA(isA<LuaException>()),
        );
      });
    });

    group('utf8.offset', () {
      test('valid offset', () async {
        expect(
          await luaExecute('return utf8.offset("😀😂😄", 2)'),
          luaEquals([5]),
        );
      });

      test('invalid offset', () async {
        expect(
          await luaExecute('return utf8.offset("😀😂😄", 10)'),
          luaEquals([null]),
        );
      });
    });
  });
}
