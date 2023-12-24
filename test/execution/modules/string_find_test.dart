import 'package:test/test.dart';

import '../language/test.dart';

void main() {
  group('string.find', () {
    group('substring match', () {
      test('Simple literal search', () async {
        const source = '''
        return string.find("Hello World", "World")
      ''';
        expect(await luaExecute(source), luaEquals([7, 11]));
      });

      test('Matching at the start of the string', () async {
        const source = '''
        return string.find("Hello World", "Hello")
      ''';
        expect(await luaExecute(source), luaEquals([1, 5]));
      });

      test('Matching at the end of the string', () async {
        const source = '''
        return string.find("Hello World", "ld")
      ''';
        expect(await luaExecute(source), luaEquals([10, 11]));
      });

      test('Completely different string', () async {
        const source = '''
        return string.find("Hello World", "Test")
      ''';
        expect(await luaExecute(source), luaEquals([null]));
      });

      test('Partially matches but not completely', () async {
        const source = '''
        return string.find("Hello World", "Worlds")
      ''';
        expect(await luaExecute(source), luaEquals([null]));
      });

      test('Different case', () async {
        const source = '''
        return string.find("Hello World", "hello")
      ''';
        expect(await luaExecute(source), luaEquals([null]));
      });

      test('Empty pattern', () async {
        const source = '''
        return string.find("Hello World", "")
      ''';
        expect(await luaExecute(source), luaEquals([1, 0]));
      });
    });

    group('quantifier', () {
      group('*', () {
        test('multiple repetitions', () async {
          const source = '''
      return string.find("aaabbb", "a*")
    ''';
          expect(await luaExecute(source), luaEquals([1, 3]));
        });

        test('zero repetitions', () async {
          const source = '''
      return string.find("bbb", "a*")
    ''';
          expect(await luaExecute(source), luaEquals([1, 0]));
        });
      });

      group('+', () {
        test('one or more repetitions', () async {
          const source = '''
      return string.find("aaabbb", "a+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 3]));
        });

        test('no match for one or more repetitions', () async {
          const source = '''
      return string.find("bbb", "a+")
    ''';
          expect(await luaExecute(source), luaEquals([null]));
        });
      });

      group('-', () {
        test('shortest match', () async {
          const source = '''
      return string.find("aaabbb", "a-")
    ''';
          expect(await luaExecute(source), luaEquals([1, 0]));
        });

        test('zero repetitions even if no match', () async {
          const source = '''
      return string.find("bbb", "a-")
    ''';
          expect(await luaExecute(source), luaEquals([1, 0]));
        });
      });

      group('?', () {
        test('one or zero repetitions', () async {
          const source = '''
      return string.find("aaabbb", "a?")
    ''';
          expect(await luaExecute(source), luaEquals([1, 1]));
        });

        test('zero repetitions if no match', () async {
          const source = '''
      return string.find("bbb", "a?")
    ''';
          expect(await luaExecute(source), luaEquals([1, 0]));
        });
      });
    });

    group('character class', () {
      group('.', () {
        test('Matching any single character', () async {
          const source = '''
      return string.find("Hello World", "H.llo")
    ''';
          expect(await luaExecute(source), luaEquals([1, 5]));
        });

        test('Pattern with multiple dots', () async {
          const source = '''
      return string.find("Hello World", "He..o W.rld")
    ''';
          expect(await luaExecute(source), luaEquals([1, 11]));
        });

        test('Pattern with only dot', () async {
          const source = '''
      return string.find("Hello World", ".")
    ''';
          expect(await luaExecute(source), luaEquals([1, 1]));
        });

        test('String without matching dot pattern', () async {
          const source = '''
      return string.find("Hello World", "Test.")
    ''';
          expect(await luaExecute(source), luaEquals([null]));
        });
      });

      group('%a', () {
        test('Matching only alphabet characters', () async {
          const source = '''
      return string.find("Hello World", "%a+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 5]));
        });

        test('Alphabets mixed with non-alphabets', () async {
          const source = '''
      return string.find("123abcDEF456", "%a+")
    ''';
          expect(await luaExecute(source), luaEquals([4, 9]));
        });

        test('Groups of consecutive alphabets', () async {
          const source = '''
      return string.find("abc def ghi", "%a+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 3]));
        });

        test('No alphabets in the string', () async {
          const source = '''
      return string.find("1234567890", "%a+")
    ''';
          expect(await luaExecute(source), luaEquals([null]));
        });
      });

      group('%A', () {
        test('Matching only non-alphabet characters', () async {
          const source = '''
      return string.find("1234!@# ABC", "%A+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 8]));
        });

        test('Non-alphabets mixed with alphabets', () async {
          const source = '''
      return string.find("ABC 123 DEF", "%A+")
    ''';
          expect(await luaExecute(source), luaEquals([4, 8]));
        });

        test('Groups of consecutive non-alphabets', () async {
          const source = r'''
      return string.find("!@# $%^ &*()", "%A+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 12]));
        });

        test('No non-alphabets in the string', () async {
          const source = '''
      return string.find("HelloWorld", "%A+")
    ''';
          expect(await luaExecute(source), luaEquals([null]));
        });
      });

      group('%c', () {
        test('control character match', () async {
          const source = '''
      return string.find("Hello\nWorld", "%c+")
    ''';
          expect(await luaExecute(source), luaEquals([6, 6]));
        });

        test('multiple control characters match', () async {
          const source = '''
      return string.find("\tHello\r\nWorld", "%c+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 1]));
        });

        test('control and regular characters mix', () async {
          const source = '''
      return string.find("abc\ndef", "%c+")
    ''';
          expect(await luaExecute(source), luaEquals([4, 4]));
        });

        test('no control characters', () async {
          const source = '''
      return string.find("Hello World", "%c+")
    ''';
          expect(await luaExecute(source), luaEquals([null]));
        });
      });

      group('%C', () {
        test('non-control character match', () async {
          const source = '''
      return string.find("Hello\nWorld", "%C+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 5]));
        });

        test('non-control and control characters mix', () async {
          const source = '''
      return string.find("\tHello\r\nWorld", "%C+")
    ''';
          expect(await luaExecute(source), luaEquals([2, 6]));
        });

        test('only control characters', () async {
          const source = '''
      return string.find("\n\r\t", "%C+")
    ''';
          expect(await luaExecute(source), luaEquals([null]));
        });

        test('no control characters', () async {
          const source = '''
      return string.find("HelloWorld", "%C+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 10]));
        });
      });

      group('%d', () {
        test('digits only match', () async {
          const source = '''
      return string.find("12345", "%d+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 5]));
        });

        test('digits and non-digits mix', () async {
          const source = '''
      return string.find("abc123def", "%d+")
    ''';
          expect(await luaExecute(source), luaEquals([4, 6]));
        });

        test('multiple digit groups', () async {
          const source = '''
      return string.find("123 abc 456 def", "%d+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 3]));
        });

        test('no digits', () async {
          const source = '''
      return string.find("abcdef", "%d+")
    ''';
          expect(await luaExecute(source), luaEquals([null]));
        });
      });

      group('%g', () {
        test('non-space characters match', () async {
          const source = '''
      return string.find("abc 123", "%g+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 3]));
        });

        test('non-space characters with spaces', () async {
          const source = '''
      return string.find("  abc123  def  ", "%g+")
    ''';
          expect(await luaExecute(source), luaEquals([3, 8]));
        });

        test('multiple non-space groups', () async {
          const source = '''
      return string.find("abc def ghi", "%g+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 3]));
        });

        test('all spaces', () async {
          const source = '''
      return string.find("     ", "%g+")
    ''';
          expect(await luaExecute(source), luaEquals([null]));
        });
      });

      group('%l', () {
        test('lowercase letters only', () async {
          const source = '''
      return string.find("abcdef", "%l+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 6]));
        });

        test('lowercase and uppercase mix', () async {
          const source = '''
      return string.find("aBcDeF", "%l+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 1]));
        });

        test('multiple lowercase groups', () async {
          const source = '''
      return string.find("abc DEF ghi", "%l+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 3]));
        });

        test('no lowercase letters', () async {
          const source = '''
      return string.find("ABC DEF", "%l+")
    ''';
          expect(await luaExecute(source), luaEquals([null]));
        });
      });

      group('%p', () {
        test('punctuation match', () async {
          const source = '''
      return string.find("Hello, World!", "%p+")
    ''';
          expect(await luaExecute(source), luaEquals([6, 6]));
        });

        test('punctuation and non-punctuation mix', () async {
          const source = '''
      return string.find("abc, def.", "%p+")
    ''';
          expect(await luaExecute(source), luaEquals([4, 4]));
        });

        test('multiple punctuation groups', () async {
          const source = '''
      return string.find("Hello, World! How are you?", "%p+")
    ''';
          expect(await luaExecute(source), luaEquals([6, 6]));
        });

        test('no punctuation', () async {
          const source = '''
      return string.find("Hello World", "%p+")
    ''';
          expect(await luaExecute(source), luaEquals([null]));
        });
      });

      group('%s', () {
        test('whitespace match', () async {
          const source = '''
      return string.find("Hello World", "%s+")
    ''';
          expect(await luaExecute(source), luaEquals([6, 6]));
        });

        test('whitespace and non-whitespace mix', () async {
          const source = '''
      return string.find("Hello    World", "%s+")
    ''';
          expect(await luaExecute(source), luaEquals([6, 9]));
        });

        test('multiple whitespace groups', () async {
          const source = '''
      return string.find("Hello World  How are you?", "%s+")
    ''';
          expect(await luaExecute(source), luaEquals([6, 6]));
        });

        test('no whitespace', () async {
          const source = '''
      return string.find("HelloWorld", "%s+")
    ''';
          expect(await luaExecute(source), luaEquals([null]));
        });
      });

      group('%u', () {
        test('uppercase letters match', () async {
          const source = '''
      return string.find("ABCDEFG", "%u+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 7]));
        });

        test('uppercase and lowercase mix', () async {
          const source = '''
      return string.find("aBcDeF", "%u+")
    ''';
          expect(await luaExecute(source), luaEquals([2, 2]));
        });

        test('multiple uppercase groups', () async {
          const source = '''
      return string.find("abc DEF ghi", "%u+")
    ''';
          expect(await luaExecute(source), luaEquals([5, 7]));
        });

        test('no uppercase letters', () async {
          const source = '''
      return string.find("abc def", "%u+")
    ''';
          expect(await luaExecute(source), luaEquals([null]));
        });
      });

      group('%w', () {
        test('alphanumeric characters only', () async {
          const source = '''
      return string.find("123abcABC", "%w+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 9]));
        });

        test('alphanumeric and non-alphanumeric mix', () async {
          const source = '''
      return string.find("abc123! def456", "%w+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 6]));
        });

        test('multiple alphanumeric groups', () async {
          const source = '''
      return string.find("abc def 123", "%w+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 3]));
        });

        test('no alphanumeric characters', () async {
          const source = r'''
      return string.find("!@# $%^", "%w+")
    ''';
          expect(await luaExecute(source), luaEquals([null]));
        });
      });

      group('%x', () {
        test('hexadecimal characters only', () async {
          const source = '''
      return string.find("123abcDEF", "%x+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 9]));
        });

        test('hexadecimal and non-hexadecimal mix', () async {
          const source = '''
      return string.find("123GHI", "%x+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 3]));
        });

        test('multiple hexadecimal groups', () async {
          const source = '''
      return string.find("abc 123 def", "%x+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 3]));
        });

        test('no hexadecimal characters', () async {
          const source = '''
      return string.find("GHI JKL", "%x+")
    ''';
          expect(await luaExecute(source), luaEquals([null]));
        });
      });

      group('[set]', () {
        test('specific character set match', () async {
          const source = '''
      return string.find("Hello World", "[eol]+")
    ''';
          expect(await luaExecute(source), luaEquals([2, 5]));
        });

        test('range in character set', () async {
          const source = '''
      return string.find("123 abc", "[0-9]+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 3]));
        });

        test('composite character set', () async {
          const source = '''
      return string.find("abc123 def", "[%a%d]+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 6]));
        });

        test('character set not included', () async {
          const source = '''
      return string.find("Hello World", "[xyz]+")
    ''';
          expect(await luaExecute(source), luaEquals([null]));
        });
      });

      group('[^set]', () {
        test('negated character set match', () async {
          const source = '''
      return string.find("Hello World", "[^eol]+")
    ''';
          expect(await luaExecute(source), luaEquals([1, 1]));
        });

        test('range in negated character set', () async {
          const source = '''
      return string.find("123 abc", "[^1-3]+")
    ''';
          expect(await luaExecute(source), luaEquals([4, 7]));
        });

        test('composite negated character set', () async {
          const source = '''
      return string.find("abc def", "[^%a%d]+")
    ''';
          expect(await luaExecute(source), luaEquals([4, 4]));
        });

        test('no match for entire negated set', () async {
          const source = '''
      return string.find("Hello World", "[^a-zA-Z ]+")
    ''';
          expect(await luaExecute(source), luaEquals([null]));
        });
      });
    });

    group('other pattern items', () {
      group('%bxy', () {
        test('balanced parentheses', () async {
          const source = '''
      return string.find("a [nested [text] example]", "%b[]")
    ''';
          expect(await luaExecute(source), luaEquals([3, 25]));
        });

        test('unbalanced parentheses', () async {
          const source = '''
      return string.find("a [nested [text] example", "%b[]")
    ''';
          expect(await luaExecute(source), luaEquals([11, 16]));
        });

        test('balanced same characters', () async {
          const source = '''
      return string.find("|a b|", "%b||")
    ''';
          expect(await luaExecute(source), luaEquals([1, 5]));
        });

        test('unbalanced same characters', () async {
          const source = '''
      return string.find("|a|b|", "%b||")
    ''';
          expect(await luaExecute(source), luaEquals([1, 3]));
        });

        test('nested same characters', () async {
          const source = '''
      return string.find("|a|b|c|", "%b||")
    ''';
          expect(await luaExecute(source), luaEquals([1, 3]));
        });
      });

      group('%f[set]', () {
        test('word boundary in text', () async {
          const source = '''
      return string.find("Hello World!", "%f[%w]Wo")
    ''';
          expect(await luaExecute(source), luaEquals([7, 8]));
        });

        test('non-space boundary', () async {
          const source = '''
      return string.find("   space", "%f[%S]sp")
    ''';
          expect(await luaExecute(source), luaEquals([4, 5]));
        });

        test('non-word boundary at start', () async {
          const source = '''
      return string.find("End.", "%f[%W].")
    ''';
          expect(await luaExecute(source), luaEquals([4, 4]));
        });

        test('punctuation boundary', () async {
          const source = '''
      return string.find("one.two", "%f[%P]t")
    ''';
          expect(await luaExecute(source), luaEquals([5, 5]));
        });

        test('the beginning of boundary', () async {
          const source = '''
      return string.find("123", "%f[%d]")
    ''';
          expect(await luaExecute(source), luaEquals([1, 0]));
        });

        test('the end of boundary', () async {
          const source = '''
      return string.find("123", "%f[%D]")
    ''';
          expect(await luaExecute(source), luaEquals([4, 3]));
        });
      });
    });

    group('capture', () {
      test('single capture', () async {
        const source = '''
      return string.find("Hello World", "(World)")
    ''';
        expect(await luaExecute(source), luaEquals([7, 11, 'World']));
      });

      test('multiple captures', () async {
        const source = '''
      return string.find("Hello World", "(He)(llo)")
    ''';
        expect(await luaExecute(source), luaEquals([1, 5, 'He', 'llo']));
      });

      test('nested capture', () async {
        const source = '''
      return string.find("Hello (World (Lua))", "(%b())")
    ''';
        expect(await luaExecute(source), luaEquals([7, 19, '(World (Lua))']));
      });

      test('captured reference', () async {
        const source = '''
      return string.find("word word", "(%w+) %1")
    ''';
        expect(await luaExecute(source), luaEquals([1, 9, 'word']));
      });

      group('index capture', () {
        test('only', () async {
          const source = '''
      return string.find("Hello World", "()")
    ''';
          expect(await luaExecute(source), luaEquals([1, 0, 1]));
        });

        test('prefix', () async {
          const source = '''
      return string.find("Hello World", "()Hello")
    ''';
          expect(await luaExecute(source), luaEquals([1, 5, 1]));
        });

        test('suffix', () async {
          const source = '''
      return string.find("Hello World", "Hello()")
    ''';
          expect(await luaExecute(source), luaEquals([1, 5, 6]));
        });

        test('multiple', () async {
          const source = '''
      return string.find("flaaap", "()aa()")
    ''';
          expect(await luaExecute(source), luaEquals([3, 4, 3, 5]));
        });
      });

      test('complex capture pattern', () async {
        const source = '''
      return string.find("aaa word more words", "(a*(.)%w(%s*))")
    ''';
        expect(await luaExecute(source), luaEquals([1, 5, 'aaa w', ' ', '']));
      });
    });
  });
}
