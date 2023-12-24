import 'package:petitparser/context.dart';
import 'package:test/test.dart';
import 'package:tradaul/src/parser/ast.dart';
import 'package:tradaul/src/parser/grammar.dart';
import 'package:tradaul/src/parser/parser.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

final _p = LuaParserDefinition().build();

Result<dynamic> parse(String input) {
  return _p.parse(input);
}

Matcher pass() => const _ParseMatcher(pass: true);

Matcher notPass() => const _ParseMatcher(pass: false);

class _ParseMatcher extends Matcher {
  const _ParseMatcher({required this.pass});

  final bool pass;

  @override
  bool matches(dynamic result, Map<dynamic, dynamic> matchState) {
    if (pass) {
      return (result as Result).isSuccess;
    } else {
      return (result as Result).isFailure;
    }
  }

  @override
  Description describe(Description description) {
    return description;
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    final result = item as Result<dynamic>;
    if (pass && result.isFailure) {
      return mismatchDescription.add(result.message);
    } else if (!pass && result.isSuccess) {
      return mismatchDescription.add('Expected failure, but succeeded.');
    } else {
      return mismatchDescription;
    }
  }
}

void expectPass(String title, String input) {
  test(title, () {
    final result = _p.parse(input);
    if (result.isFailure) {
      fail('Failed parsing: $input\n'
          'Error: ${result.message} at ${result.position}');
    }
    expect(result.value, isA<Node>());
  });
}

void main() {
  group('literals', () {
    test('nil', () {
      expect(parse('a = nil + nil'), pass());
    });
    test('true', () {
      expect(parse('a = true'), pass());
    });
    test('false', () {
      expect(parse('a = false'), pass());
    });
    test('integer', () {
      expect(parse('a = 42'), pass());
    });
    test('float', () {
      expect(parse('a = 3.14'), pass());
    });
    test('string single quotes', () {
      expect(parse("a = 'hello'"), pass());
    });
    test('string double quotes', () {
      expect(parse('a = "hello"'), pass());
    });

    group('long string', () {
      for (var i = 0;
          i <= LuaGrammarDefinition.supportedLongBracketLevel;
          i++) {
        group('level $i', () {
          final open = '[${'=' * i}[';
          final close = ']${'=' * i}]';

          test('single-line', () {
            expect(
              parse('''
                  local a = $open This is a single-line string $close
                  '''),
              pass(),
            );
          });

          test('single-line at end of input', () {
            expect(
              parse('local a = $open This is a single-line string $close'),
              pass(),
            );
          });

          test('multi-line', () {
            expect(
              parse('''
            local a = $open This is a
            multi-line string
            $close
            '''),
              pass(),
            );
          });

          group('invalid long string levels', () {
            for (var j = 0;
                j <= LuaGrammarDefinition.supportedLongBracketLevel;
                j++) {
              if (i == j) {
                continue;
              }
              final close2 = ']${'=' * j}]';
              test('level $i and $j', () {
                expect(
                  () async {
                    parse('local a = $open long string $close2');
                  },
                  throwsA(isA<LuaException>()),
                );
              });
            }
          });
        });
      }
    });
  });

  group('table constructor', () {
    test('empty table', () {
      expect(parse('a = {}'), pass());
    });
    test('single field', () {
      expect(parse('a = {1}'), pass());
    });
    test('multiple fields', () {
      expect(parse('a = {1, 2, 3}'), pass());
    });
    test('multiple fields (trailing comma)', () {
      expect(parse('a = {1, 2, 3,}'), pass());
    });
    test('key-value pair', () {
      expect(parse('a = { key = "value" }'), pass());
    });
    test('multiple key-value pairs', () {
      expect(
        parse('a = { key1 = "value1", key2 = "value2", key3 = "value3" }'),
        pass(),
      );
    });
    test('multiple key-value pairs with trailing comma', () {
      expect(
        parse('a = { key1 = "value1", key2 = "value2", key3 = "value3", }'),
        pass(),
      );
    });
    test('mixed fields and key-value pairs', () {
      expect(
        parse('a = { 1, "key", key1 = "value1", 2, key2 = "value2" }'),
        pass(),
      );
    });
    test('mixed fields and key-value pairs with trailing comma', () {
      expect(
        parse('a = { 1, "key", key1 = "value1", 2, key2 = "value2", }'),
        pass(),
      );
    });
    test('nested tables', () {
      expect(
        parse('''
              a = { 1, "key", { key1 = "value1", 2, key2 = "value2" }, { 3, "key3" } }
              '''),
        pass(),
      );
    });
    test('table with brackets', () {
      expect(parse('a = { [1] = "value1", ["key"] = 2 }'), pass());
    });
    test('table with brackets and trailing comma', () {
      expect(parse('a = { [1] = "value1", ["key"] = 2, }'), pass());
    });
  });

  group('function call', () {
    test('function without arguments', () {
      expect(parse('f()'), pass());
    });
    test('function with one argument', () {
      expect(parse('f(1)'), pass());
    });
    test('function with multiple arguments', () {
      expect(parse('f(1, "string", true, nil, {})'), pass());
    });
    test('function with nested function calls', () {
      expect(parse('f1(f2(), f3(1, "string"))'), pass());
    });
    test('function with variable argument', () {
      expect(parse('f(...)'), pass());
    });
    test('function with arguments and variable argument', () {
      expect(parse('f(1, 2, ...)'), pass());
    });
    test('function with prefixexp and exp in brackets', () {
      expect(parse('myTable["key"]()'), pass());
    });
    test('function with prefixexp and name', () {
      expect(parse('myTable.key()'), pass());
    });
    test('method without arguments', () {
      expect(parse('object:method()'), pass());
    });
    test('method with one argument', () {
      expect(parse('object:method(1)'), pass());
    });
    test('method with multiple arguments', () {
      expect(parse('object:method(1, "string", true, nil, {})'), pass());
    });
    test('method with nested method calls', () {
      expect(
        parse(
          'object1:method1(object2:method2(), object3:method3(1, "string"))',
        ),
        pass(),
      );
    });
    test('nested function', () {
      expect(parse('(f)()'), pass());
    });
    test('nested function with argument', () {
      expect(parse('(f)(1)'), pass());
    });
    test('function call as argument', () {
      expect(parse('f1(f2())'), pass());
    });
    test('function with table constructor argument', () {
      expect(parse('f {1, 2, 3}'), pass());
    });
    test('function with nested table constructor argument', () {
      expect(parse('f {1, {2, 3}, 4}'), pass());
    });
    test('function with string argument', () {
      expect(parse('f("string")'), pass());
    });
    test('function with nested string argument', () {
      expect(parse('f1(f2 "string")'), pass());
    });
    test('complex function call', () {
      expect(parse('f()[1]()'), pass());
    });
    test('complex method call', () {
      expect(parse('object:method()[1]()'), pass());
    });
  });

  group('unary operator expressions', () {
    test('negation', () {
      expect(parse('a = -a'), pass());
    });
    test('not', () {
      expect(parse('a = not a'), pass());
    });
    test('length', () {
      expect(parse('a = #a'), pass());
    });
    test('bitwise not', () {
      expect(parse('a = ~a'), pass());
    });
  });

  group('binary operator expressions', () {
    test('addition', () {
      expect(parse('a = a + b'), pass());
    });
    test('subtraction', () {
      expect(parse('a = a - b'), pass());
    });
    test('multiplication', () {
      expect(parse('a = a * b'), pass());
    });
    test('division', () {
      expect(parse('a = a / b'), pass());
    });
    test('floor division', () {
      expect(parse('a = a // b'), pass());
    });
    test('exponentiation', () {
      expect(parse('a = a ^ b'), pass());
    });
    test('exponentiation and unary', () {
      expect(parse('a = a ^ -1'), pass());
    });
    test('modulus', () {
      expect(parse('a = a % b'), pass());
    });
    test('bitwise and', () {
      expect(parse('a = a & b'), pass());
    });
    test('bitwise or', () {
      expect(parse('a = a | b'), pass());
    });
    test('bitwise xor', () {
      expect(parse('a = a ~ b'), pass());
    });
    test('right shift', () {
      expect(parse('a = a >> b'), pass());
    });
    test('left shift', () {
      expect(parse('a = a << b'), pass());
    });
    test('concatenation', () {
      expect(parse('a = a .. b'), pass());
    });
    test('less than', () {
      expect(parse('a = a < b'), pass());
    });
    test('less than or equal to', () {
      expect(parse('a = a <= b'), pass());
    });
    test('greater than', () {
      expect(parse('a = a > b'), pass());
    });
    test('greater than or equal to', () {
      expect(parse('a = a >= b'), pass());
    });
    test('equality', () {
      expect(parse('a = a == b'), pass());
    });
    test('inequality', () {
      expect(parse('a = a ~= b'), pass());
    });
    test('and', () {
      expect(parse('a = a and b'), pass());
    });
    test('or', () {
      expect(parse('a = a or b'), pass());
    });
  });

  group('assignment', () {
    test('single variable assignment', () {
      expect(parse('a = 1'), pass());
    });
    test('multiple variable assignment', () {
      expect(parse('a, b = 1, 2'), pass());
    });
  });

  group('local assignment', () {
    test('single name declaration without assignment', () {
      expect(parse('local x'), pass());
    });
    test('multiple names declaration without assignment', () {
      expect(parse('local x, y, z'), pass());
    });
    test('single name declaration with assignment', () {
      expect(parse('local x = 1'), pass());
    });
    test('multiple names declaration with assignment', () {
      expect(parse('local x, y, z = 1, 2, 3'), pass());
    });
  });

  group('local assignment with attributes', () {
    test('single name declaration', () {
      expect(parse('local x<const>'), pass());
    });
    test('multiple names declaration', () {
      expect(parse('local x<const>, y<const>, z<const>'), pass());
    });
    test('single name declaration and assignment', () {
      expect(parse('local x<const> = 1'), pass());
    });
    test('multiple names declaration and assignment', () {
      expect(parse('local x<const>, y<const>, z<const> = 1, 2, 3'), pass());
    });
  });

  group('return', () {
    test('return without value', () {
      expect(parse('return'), pass());
    });
    test('return with value', () {
      expect(parse('return 1'), pass());
    });
    test('return with multiple values', () {
      expect(parse('return 1, 2'), pass());
    });
    test('return expression key-value table', () {
      expect(parse('return {[tostring("a")]=1}'), pass());
    });
  });

  group('control flow', () {
    test('label', () {
      expect(parse('::label::'), pass());
    });
    test('label with surrounding code', () {
      expect(parse('a = 1\n::label::\nb = 2'), pass());
    });
    test('break', () {
      expect(parse('break'), pass());
    });
    test('break with surrounding code', () {
      expect(parse('a = 1\nbreak\nb = 2'), pass());
    });
    test('goto', () {
      expect(parse('goto label'), pass());
    });
    test('goto with surrounding code', () {
      expect(parse('::label::\na = 1\ngoto label\nb = 2'), pass());
    });
  });

  group('do', () {
    test('do', () {
      expect(parse('do end'), pass());
    });
    test('do with surrounding code', () {
      expect(parse('a = 1\ndo\n  a = a + 1\nend\nprint(a)'), pass());
    });
  });

  group('while', () {
    test('while', () {
      expect(parse('while true do end'), pass());
    });
    test('while with surrounding code', () {
      expect(
        parse('a = 1\nwhile a < 5 do\n  a = a + 1\nend\nprint(a)'),
        pass(),
      );
    });
  });

  group('repeat', () {
    test('repeat', () {
      expect(parse('repeat until true'), pass());
    });
    test('repeat with surrounding code', () {
      expect(
        parse('a = 1\nrepeat\n  a = a + 1\nuntil a == 5\nprint(a)'),
        pass(),
      );
    });
  });

  group('for', () {
    test('numeric for', () {
      expect(parse('for i = 1, 10 do end'), pass());
    });
    test('numeric for with step', () {
      expect(parse('for i = 1, 10, 2 do end'), pass());
    });
    test('numeric for with block', () {
      expect(parse('for i = 1, 10 do\n  print(i)\nend'), pass());
    });
    test('numeric for with step and block', () {
      expect(parse('for i = 1, 10, 2 do\n  print(i)\nend'), pass());
    });
    test('generic for', () {
      expect(parse('for k,v in pairs(t) do end'), pass());
    });
    test('generic for with block', () {
      expect(parse('for k,v in pairs(t) do\n  print(k, v)\nend'), pass());
    });
  });

  group('conditional', () {
    test('if', () {
      expect(parse('if true then end'), pass());
    });
    test('if else', () {
      expect(parse('if true then else end'), pass());
    });
    test('if elseif', () {
      expect(parse('if true then elseif true then end'), pass());
    });
    test('if elseif else', () {
      expect(parse('if true then elseif true then else end'), pass());
    });
    test('if with expression', () {
      expect(
        parse('a = 5\nif a > 3 then\n  print("a is greater than 3")\nend'),
        pass(),
      );
    });
    test('if else with expression', () {
      expect(
        parse(
          'a = 2\nif a > 3 then\n  print("a is greater than 3")\nelse\n  print("a is not greater than 3")\nend',
        ),
        pass(),
      );
    });
    test('if elseif with expression', () {
      expect(
        parse(
          'a = 2\nif a > 3 then\n  print("a is greater than 3")\nelseif a == 3 then\n  print("a is 3")\nend',
        ),
        pass(),
      );
    });
    test('if elseif else with expression', () {
      expect(
        parse(
          'a = 2\nif a > 3 then\n  print("a is greater than 3")\nelseif a == 3 then\n  print("a is 3")\nelse\n  print("a is less than 3")\nend',
        ),
        pass(),
      );
    });
  });

  group('function definition', () {
    void testDefinition({required bool isLocal}) {
      final local = isLocal ? 'local ' : '';
      group('${isLocal ? 'local' : 'global'} function', () {
        test('simple function without parameters', () {
          expect(parse('$local function foo() end'), pass());
        });
        test('function with one parameter', () {
          expect(parse('$local function foo(a) end'), pass());
        });
        test('function with multiple parameters', () {
          expect(parse('$local function foo(a, b, c) end'), pass());
        });
        test('function with varargs parameter', () {
          expect(parse('$local function foo(...) end'), pass());
        });
        test('function with parameters and varargs', () {
          expect(parse('$local function foo(a, b, c, ...) end'), pass());
        });
        test('function with nested function', () {
          expect(parse('$local function foo() function bar() end end'), pass());
        });
      });
    }

    testDefinition(isLocal: true);
    testDefinition(isLocal: false);

    group('function using colon', () {
      test('without parameters', () {
        expect(parse('function obj:foo() end'), pass());
      });
      test('one parameter', () {
        expect(parse('function obj:foo(a) end'), pass());
      });
      test('multiple parameters', () {
        expect(parse('function obj:foo(a, b, c) end'), pass());
      });
      test("invalid with 'local'", () {
        expect(parse('local function obj:foo() end'), notPass());
      });
    });

    group('anonymous function', () {
      test('function assigned to a variable', () {
        expect(parse('foo = function() end'), pass());
      });
      test('function assigned to a table field', () {
        expect(parse('foo.bar = function() end'), pass());
      });
      test('function assigned to a table field via index operator', () {
        expect(parse('foo["bar"] = function() end'), pass());
      });
    });
  });

  group('comments', () {
    group("first '#' line ", () {
      test('basic', () {
        expect(
          parse('# This is a comment'),
          pass(),
        );
      });

      test("string include '#' after first line", () {
        expect(
          parse(r'# This is a comment\nprint("# comment")'),
          pass(),
        );
      });

      test('invalid after empty lines', () {
        expect(
          parse('''
          # This is a comment
          '''),
          notPass(),
        );
      });
    });

    group('short comment', () {
      test('basic', () {
        expect(
          parse('''
        -- This is a comment
        '''),
          pass(),
        );
      });

      test('empty', () {
        expect(
          parse('''
        --
        '''),
          pass(),
        );
      });

      test('at end of input', () {
        expect(parse('-- This is a comment'), pass());
      });

      test('empty at end of input', () {
        expect(parse('--'), pass());
      });

      test('after statement', () {
        expect(
          parse('''
      a = 1  -- This is a comment
      b = 2
    '''),
          pass(),
        );
      });

      test('empty after statement', () {
        expect(
          parse('''
      a = 1  --
      b = 2
    '''),
          pass(),
        );
      });

      test('after statement at end of file', () {
        expect(parse('a = 1  -- This is a comment'), pass());
      });

      test('insert between tokens', () {
        expect(
          parse('''
      a = -- This is a comment
      1
    '''),
          pass(),
        );
      });

      test('multiple, comment only', () {
        expect(
          parse('''
      -- Comment 1
      -- Comment 2
    '''),
          pass(),
        );
      });

      test('multiple', () {
        expect(
          parse('''
      -- Comment 1
      -- Comment 2
      a = 1
    '''),
          pass(),
        );
      });

      test('before block', () {
        expect(
          parse('''
      -- Comment
      do
      end
    '''),
          pass(),
        );
      });

      test('empty before block', () {
        expect(
          parse('''
      --
      do
      end
    '''),
          pass(),
        );
      });

      test('after begin keyword', () {
        expect(
          parse('''
      do -- Comment
      end
    '''),
          pass(),
        );
      });

      test('empty after begin keyword', () {
        expect(
          parse('''
      do --
      end
    '''),
          pass(),
        );
      });

      test('after end keyword', () {
        expect(
          parse('''
      do
      end -- Comment
    '''),
          pass(),
        );
      });

      test('empty after end keyword', () {
        expect(
          parse('''
      do
      end --
    '''),
          pass(),
        );
      });

      test('in block', () {
        expect(
          parse('''
      do
      -- Comment
      end
    '''),
          pass(),
        );
      });

      test('empty in block', () {
        expect(
          parse('''
      do
      --
      end
    '''),
          pass(),
        );
      });
    });

    group('long comment', () {
      for (var i = 0;
          i <= LuaGrammarDefinition.supportedLongBracketLevel;
          i++) {
        group('level $i', () {
          final open = '[${'=' * i}[';
          final close = ']${'=' * i}]';

          test('single-line', () {
            expect(
              parse('''
            --$open This is a multi-line comment $close
            '''),
              pass(),
            );
          });

          test('single-line at end of input', () {
            expect(
              parse('''--$open This is a multi-line comment $close'''),
              pass(),
            );
          });

          test('multi-line', () {
            expect(
              parse('''
      --$open This is a
      multi-line comment $close
    '''),
              pass(),
            );
          });

          test('multi-line at end of input', () {
            expect(
              parse('''
      --$open This is a
      multi-line comment $close'''),
              pass(),
            );
          });

          test('insert between tokens', () {
            expect(
              parse('''
      a =
      --$open This is a
      multi-line comment $close
      1
    '''),
              pass(),
            );
          });

          test('insert between statements', () {
            expect(
              parse('''
      a = 1
      --$open This is a
      multi-line comment $close
      b = 2
    '''),
              pass(),
            );
          });

          test('after statements at end of input', () {
            expect(
              parse('''
      a = 1
      --$open This is a
      multi-line comment $close
    '''),
              pass(),
            );
          });

          test('invalid nested multi-line comment', () {
            expect(
              parse('''
      a = 1
      --$open
      --$open This is a nested comment $close
      This is still a comment $close
      b = 2
    '''),
              notPass(),
            );
          });

          test('comment inside a table', () {
            expect(
              parse('''
      a = {
        1, -- comment
        2, --$open multi-line
        comment $close
        3
      }
    '''),
              pass(),
            );
          });

          group('invalid long comment levels', () {
            for (var j = 0;
                j <= LuaGrammarDefinition.supportedLongBracketLevel;
                j++) {
              if (i == j) {
                continue;
              }
              final close2 = ']${'=' * j}]';
              test('level $i and $j', () {
                expect(
                  () async {
                    parse('--$open comment $close2');
                  },
                  throwsA(isA<LuaException>()),
                );
              });
            }
          });
        });
      }
    });

    group('comments inside blocks', () {
      test('do-end block', () {
        expect(
          parse('''
      do
      -- This is a comment
      end
    '''),
          pass(),
        );
      });

      test('while-do-end block', () {
        expect(
          parse('''
      while true do
      -- This is a comment
      end
    '''),
          pass(),
        );
      });

      test('repeat-until block', () {
        expect(
          parse('''
      repeat
      -- This is a comment
      until true
    '''),
          pass(),
        );
      });

      test('if-then-end block', () {
        expect(
          parse('''
      if true then
      -- This is a comment
      end
    '''),
          pass(),
        );
      });

      test('if-then-else-end block', () {
        expect(
          parse('''
      if true then
      -- This is a comment in the then block
      else
      -- This is a comment in the else block
      end
    '''),
          pass(),
        );
      });

      test('for-do-end block', () {
        expect(
          parse('''
      for i=1,10 do
      -- This is a comment
      end
    '''),
          pass(),
        );
      });

      test('function-end block', () {
        expect(
          parse('''
      function testFunc()
      -- This is a comment
      end
    '''),
          pass(),
        );
      });
    });
  });

  group('UTF-8 BOM', () {
    test('BOM only', () {
      expect(parse(r'\xEF\xBB\xBF'), pass());
    });

    test('with a statement', () {
      expect(parse(r'\xEF\xBB\xBFprint(3)'), pass());
    });

    test('with first line comment', () {
      expect(parse(r'\xEF\xBB\xBF# comment!!\nprint(3)'), pass());
    });

    group('invalid BOM', () {
      test('BOM only', () {
        expect(parse(r'\xEF'), notPass());
      });

      test('with a statement', () {
        expect(parse(r'\xEFprint(3)'), notPass());
      });

      test('with first line comment', () {
        expect(parse(r'\xEF# comment!!\nprint(3)'), notPass());
      });
    });
  });

  group('example', () {
    test('example', () {
      expect(
        parse('''
     function foo (a)
       print("foo", a)
       return coroutine.yield(2*a)
     end

     co = coroutine.create(function (a,b)
           print("co-body", a, b)
           local r = foo(a+1)
           print("co-body", r)
           local r, s = coroutine.yield(a+b, a-b)
           print("co-body", r, s)
           return b, "end"
     end)

     print("main", coroutine.resume(co, 1, 10))
     print("main", coroutine.resume(co, "r"))
     print("main", coroutine.resume(co, "x", "y"))
     print("main", coroutine.resume(co, "x", "y"))
     '''),
        pass(),
      );
    });
  });
}
