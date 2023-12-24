import 'package:petitparser/core.dart';
import 'package:test/test.dart';
import 'package:tradaul/src/parser/grammar.dart';

void expectPass(String title, Parser parser, String input) {
  test(title, () {
    final result = parser.parse(input);
    if (result.isFailure) {
      fail(
        'Failed parsing: $input\nError: ${result.message} at ${result.position}',
      );
    }
  });
}

void expectNotPass(String title, Parser parser, String input) {
  test(title, () {
    final result = parser.parse(input);
    if (result.isSuccess) {
      fail('Should not pass: $input');
    }
  });
}

void main() {
  group('reserved words', () {
    final p = LuaIdentifierGrammarDefinition().build();
    expectNotPass('and', p, 'and');
    expectNotPass('break', p, 'break');
    expectNotPass('do', p, 'do');
    expectNotPass('else', p, 'else');
    expectNotPass('elseif', p, 'elseif');
    expectNotPass('end', p, 'end');
    expectNotPass('false', p, 'false');
    expectNotPass('for', p, 'for');
    expectNotPass('function', p, 'function');
    expectNotPass('goto', p, 'goto');
    expectNotPass('if', p, 'if');
    expectNotPass('in', p, 'in');
    expectNotPass('local', p, 'local');
    expectNotPass('nil', p, 'nil');
    expectNotPass('not', p, 'not');
    expectNotPass('or', p, 'or');
    expectNotPass('repeat', p, 'repeat');
    expectNotPass('return', p, 'return');
    expectNotPass('then', p, 'then');
    expectNotPass('true', p, 'true');
    expectNotPass('until', p, 'until');
    expectNotPass('while', p, 'while');
  });

  group('identifier', () {
    final p = LuaIdentifierGrammarDefinition().build();
    expectPass('basic identifier with alphabets', p, 'identifierName');
    expectPass('identifier starting with underscore', p, '_identifier');
    expectPass('identifier with underscore and numbers', p, 'id_123_name');
    expectPass('identifier with multiple underscores', p, '__init__');
    expectPass('mixed case identifier', p, 'IdEnTiFiEr');
    expectNotPass('identifier starting with a number', p, '123identifier');
    expectPass(
      'mixed alphabets, underscores, and numbers',
      p,
      'id_1_name_2_end',
    );
    expectPass(
      'long identifier',
      p,
      'thisIsALongIdentifierNameJustForTestingPurposes',
    );
  });

  group('literal', () {
    final p = LuaLiteralGrammarDefinition().build();
    expectPass('nil', p, 'nil');
    expectPass('true', p, 'true');
    expectPass('false', p, 'false');

    group('integer', () {
      expectPass('1 digit', p, '3');
      expectPass('n digit', p, '345');
      expectPass('1 hex', p, '0xff');
      expectPass('n hex', p, '0xBEBADA');
    });

    group('float', () {
      group('basic', () {
        expectPass('basic', p, '3.0');
        expectPass('fractional', p, '3.1416');
        expectPass('negative exponent', p, '314.16e-2');
        expectPass('positive exponent', p, '0.31416E1');
        expectPass('larger exponent', p, '34e1');
      });
      group('part only', () {
        expectPass('integer part only', p, '0.');
        expectPass('fractional part only', p, '.0');
        expectPass('fraction with exponent', p, '.2e2');
      });
      group('hex', () {
        expectPass('basic', p, '0x0.1');
        expectPass('exponent', p, '0x0.1E');
        expectPass('negative exponent', p, '0xA23p-4');
        expectPass('positive exponent', p, '0X1.921FB54442D18P+1');
        expectPass('positive power-of-2 exponent', p, '0x0p12');
        expectPass('negative power-of-2 exponent', p, '0x.0p-3');
        expectPass('large fractional part', p, '0x.FfffFFFF');
        expectPass('large power-of-2 exponent', p, '0x.ABCDEFp+24');
      });
    });

    group('string', () {
      expectPass('empty single quote', p, "''");
      expectPass('empty double quote', p, '""');
      expectPass('single quote', p, '\'alo\\n123"\'');
      expectPass('double quote', p, r'"alo\n123\""');
      expectPass('char code', p, '\'\\97lo\\10\\04923"\'');
      expectPass('long bracket 0', p, '[[alo\n123"]]');
      expectPass('long bracket n', p, '[==[\nalo\n123"]==]');
      expectPass('long bracket with equals', p, '[=[alo\n"123"]=]');
      expectPass('long bracket nested', p, '[===[alo[==[123]==]]===]');
      expectPass('escape hex', p, r'"\x41"'); // 'A'
      expectPass('escape unicode', p, r'"\u{41}"'); // 'A'
      expectPass('multiple escape sequences', p, r'"\x41\u{42}\065"'); // 'ABA'
      expectPass('complex', p, r'"\xEF\xBB\xBF# comment!!\nprint(3)"');

      group('non ascii characters', () {
        expectPass('special symbols', p, r'"@#$%^&*()_+"');
        expectPass('punctuation symbols', p, '".,;:?!/"');
        expectPass('brackets and braces', p, '"{}[]()"');
        expectPass('emoji', p, '"😀😃😄😁"');
      });
    });
  });

  group('table constructor', () {
    final p = LuaLiteralGrammarDefinition().build();
    expectPass('empty table', p, '{}');
    expectPass('single field (numeric)', p, '{1}');
    expectPass('single field (string)', p, '{ "key" }');
    expectPass('multiple fields (numeric)', p, '{1, 2, 3}');
    expectPass(
      'multiple fields (numeric with trailing comma)',
      p,
      '{1, 2, 3,}',
    );
    expectPass('multiple fields (string)', p, '{ "key1", "key2", "key3" }');
    expectPass(
      'multiple fields (string with trailing comma)',
      p,
      '{ "key1", "key2", "key3", }',
    );
    expectPass('mixed fields', p, '{ 1, "key" }');
    expectPass('mixed fields with trailing comma', p, '{ 1, "key", }');
    expectPass('key-value pair', p, '{ key = "value" }');
    expectPass(
      'multiple key-value pairs',
      p,
      '{ key1 = "value1", key2 = "value2", key3 = "value3" }',
    );
    expectPass(
      'multiple key-value pairs with trailing comma',
      p,
      '{ key1 = "value1", key2 = "value2", key3 = "value3", }',
    );
    expectPass(
      'mixed fields and key-value pairs',
      p,
      '{ 1, "key", key1 = "value1", 2, key2 = "value2" }',
    );
    expectPass(
      'mixed fields and key-value pairs with trailing comma',
      p,
      '{ 1, "key", key1 = "value1", 2, key2 = "value2", }',
    );
    expectPass(
      'nested tables',
      p,
      '{ 1, "key", { key1 = "value1", 2, key2 = "value2" }, { 3, "key3" } }',
    );
    expectPass('table with separators', p, '{1,2,3; "key1","key2","key3"}');
    expectPass(
      'table with separators and trailing comma',
      p,
      '{1,2,3; "key1","key2","key3",}',
    );
    expectPass('table with brackets', p, '{ [1] = "value1", ["key"] = 2 }');
    expectPass(
      'table with brackets and trailing comma',
      p,
      '{ [1] = "value1", ["key"] = 2, }',
    );
  });

  group('function call', () {
    final p = LuaPrimaryExpGrammarDefinition().build();
    expectNotPass('error 1', p, '(');
    expectNotPass('error 2', p, 'f(');
    expectNotPass('error 3', p, 'f(()');
    expectNotPass('error 4', p, 'f())');
    expectNotPass('error 5', p, 'f(1');
    expectNotPass('error 6', p, 'f(1,');
    expectNotPass('error 7', p, 'object:()');
    expectNotPass('error 8', p, ':method()');

    expectPass('function without arguments', p, 'f()');
    expectPass('function with one argument', p, 'f(1)');
    expectPass(
      'function with multiple arguments',
      p,
      'f(1, "string", true, nil, {})',
    );
    expectPass(
      'function with nested function calls',
      p,
      'f1(f2(), f3(1, "string"))',
    );
    expectPass('function with variable argument', p, 'f(...)');
    expectPass(
      'function with arguments and variable argument',
      p,
      'f(1, 2, ...)',
    );
    expectPass(
      'function with prefixexp and exp in brackets',
      p,
      'myTable["key"]()',
    );
    expectPass('function with prefixexp and Name', p, 'myTable.key()');

    expectPass('method without arguments', p, 'object:method()');
    expectPass('method with one argument', p, 'object:method(1)');
    expectPass(
      'method with multiple arguments',
      p,
      'object:method(1, "string", true, nil, {})',
    );
    expectPass(
      'method with nested method calls',
      p,
      'object1:method1(object2:method2(), object3:method3(1, "string"))',
    );

    expectPass('nested function', p, '(f)()');
    expectPass('nested function with argument', p, '(f)(1)');
    expectPass('function call as argument', p, 'f1(f2())');

    expectPass('function with table constructor argument', p, 'f {1, 2, 3}');
    expectPass(
      'function with nested table constructor argument',
      p,
      'f {1, {2, 3}, 4}',
    );

    expectPass('function with string argument', p, 'f("string")');
    expectPass('function with nested string argument', p, 'f1(f2 "string")');

    expectPass('complex function call', p, 'f()[1]()');
    expectPass('complex method call', p, 'object:method()[1]()');
  });

  group('unary operator expressions', () {
    final p = LuaExpGrammarDefinition().build();
    expectPass('negation', p, '-a');
    expectPass('not', p, 'not a');
    expectPass('length', p, '#a');
    expectPass('bitwise not', p, '~a');
  });

  group('binary operator expressions', () {
    final p = LuaExpGrammarDefinition().build();
    expectPass('addition', p, 'a + b');
    expectPass('subtraction', p, 'a - b');
    expectPass('multiplication', p, 'a * b');
    expectPass('division', p, 'a / b');
    expectPass('floor division', p, 'a // b');
    expectPass('exponentiation', p, 'a ^ b');
    expectPass('modulus', p, 'a % b');
    expectPass('bitwise and', p, 'a & b');
    expectPass('bitwise or', p, 'a | b');
    expectPass('bitwise xor', p, 'a ~ b');
    expectPass('right shift', p, 'a >> b');
    expectPass('left shift', p, 'a << b');
    expectPass('concatenation', p, 'a .. b');
    expectPass('less than', p, 'a < b');
    expectPass('less than or equal to', p, 'a <= b');
    expectPass('greater than', p, 'a > b');
    expectPass('greater than or equal to', p, 'a >= b');
    expectPass('equality', p, 'a == b');
    expectPass('inequality', p, 'a ~= b');
    expectPass('and', p, 'a and b');
    expectPass('or', p, 'a or b');
  });

  group('space', () {
    final p = LuaCommentGrammarDefinition().build();
    expectPass('whitespace1', p, '     ');
    expectPass('whitespace2', p, 'f(  )');
    expectPass('whitespace3', p, '  f()');
    expectPass('whitespace4', p, 'f()  ');
    expectPass('whitespace5', p, '  f()  ');
    expectPass('newline1', p, 'f()\r');
    expectPass('newline2', p, 'f()\n');
    expectPass('newline3', p, 'f()\r\n');
    expectPass('newline4', p, '\rf()');
    expectPass('newline5', p, '\nf()');
    expectPass('newline6', p, '\r\nf()');
  });

  group('assignment', () {
    final p = LuaStatGrammarDefinition().build();

    expectPass('single variable assignment', p, 'a = 1');
    expectPass('multiple variable assignment', p, 'a, b = 1, 2');
  });

  group('local assignment', () {
    final p = LuaStatGrammarDefinition().build();

    expectPass('single name declaration without assignment', p, 'local x');
    expectPass(
      'multiple names declaration without assignment',
      p,
      'local x, y, z',
    );
    expectPass('single name declaration with assignment', p, 'local x = 1');
    expectPass(
      'multiple names declaration with assignment',
      p,
      'local x, y, z = 1, 2, 3',
    );
    expectPass(
      'multiple names declaration with assignment of different types',
      p,
      'local x, y, z = 1, "2", {3}',
    );
    expectPass(
      'multiple names declaration with assignment of function calls',
      p,
      'local x, y, z = f(), g(), h()',
    );
  });

  group('local assignment with attributes', () {
    final p = LuaStatGrammarDefinition().build();

    expectPass('single name declaration', p, 'local x<const>');
    expectPass(
      'multiple names declaration',
      p,
      'local x<const>, y<const>, z<const>',
    );
    expectPass(
      'single name declaration and assignment',
      p,
      'local x<const> = 1',
    );
    expectPass(
      'multiple names declaration and assignment',
      p,
      'local x<const>, y<const>, z<const> = 1, 2, 3',
    );
  });

  group('return', () {
    final p = LuaStatGrammarDefinition().build();

    expectPass('return without value', p, 'return');
    expectPass('return with value', p, 'return 1');
    expectPass('return with multiple values', p, 'return 1, 2');
  });

  group('control flow', () {
    final p = LuaStatGrammarDefinition().build();

    expectPass('label', p, '::label::');
    expectPass('label with surrounding code', p, 'a = 1\n::label::\nb = 2');
    expectPass('break', p, 'break');
    expectPass('break with surrounding code', p, 'a = 1\nbreak\nb = 2');
    expectPass('goto', p, 'goto label');
    expectPass(
      'goto with surrounding code',
      p,
      '::label::\na = 1\ngoto label\nb = 2',
    );
  });

  group('do', () {
    final p = LuaStatGrammarDefinition().build();

    expectPass('do', p, 'do end');
    expectPass(
      'do with surrounding code',
      p,
      'a = 1\ndo\n  a = a + 1\nend\nprint(a)',
    );
  });

  group('while', () {
    final p = LuaStatGrammarDefinition().build();

    expectPass('while', p, 'while true do end');
    expectPass(
      'while with surrounding code',
      p,
      'a = 1\nwhile a < 5 do\n  a = a + 1\nend\nprint(a)',
    );
  });

  group('repeat', () {
    final p = LuaStatGrammarDefinition().build();

    expectPass('repeat', p, 'repeat until true');
    expectPass(
      'repeat with surrounding code',
      p,
      'a = 1\nrepeat\n  a = a + 1\nuntil a == 5\nprint(a)',
    );
  });

  group('for', () {
    final p = LuaStatGrammarDefinition().build();

    expectPass('numeric for', p, 'for i = 1, 10 do end');
    expectPass('numeric for with step', p, 'for i = 1, 10, 2 do end');

    expectPass(
      'numeric for with block',
      p,
      'for i = 1, 10 do\n  print(i)\nend',
    );
    expectPass(
      'numeric for with step and block',
      p,
      'for i = 1, 10, 2 do\n  print(i)\nend',
    );

    expectPass('generic for', p, 'for k,v in pairs(t) do end');
    expectPass(
      'generic for with block',
      p,
      'for k,v in pairs(t) do\n  print(k, v)\nend',
    );
  });

  group('conditional', () {
    final p = LuaStatGrammarDefinition().build();

    // if
    expectPass('if', p, 'if true then end');
    expectPass('if else', p, 'if true then else end');
    expectPass('if elseif', p, 'if true then elseif true then end');
    expectPass('if elseif else', p, 'if true then elseif true then else end');

    // if with expressions
    expectPass(
      'if with expression',
      p,
      'a = 5\nif a > 3 then\n  print("a is greater than 3")\nend',
    );
    expectPass(
      'if else with expression',
      p,
      'a = 2\nif a > 3 then\n  print("a is greater than 3")\nelse\n  print("a is not greater than 3")\nend',
    );
    expectPass(
      'if elseif with expression',
      p,
      'a = 2\nif a > 3 then\n  print("a is greater than 3")\nelseif a == 3 then\n  print("a is 3")\nend',
    );
    expectPass(
      'if elseif else with expression',
      p,
      'a = 2\nif a > 3 then\n  print("a is greater than 3")\nelseif a == 3 then\n  print("a is 3")\nelse\n  print("a is less than 3")\nend',
    );
  });

  group('function', () {
    final p = LuaStatGrammarDefinition().build();

    expectPass('simple function without parameters', p, 'function foo() end');
    expectPass('function with one parameter', p, 'function foo(a) end');
    expectPass(
      'function with multiple parameters',
      p,
      'function foo(a, b, c) end',
    );
    expectPass('function with varargs parameter', p, 'function foo(...) end');
    expectPass(
      'function with parameters and varargs',
      p,
      'function foo(a, b, c, ...) end',
    );
    expectPass(
      'function with nested function',
      p,
      'function foo() function bar() end end',
    );
    expectPass('function assigned to a variable', p, 'foo = function() end');
    expectPass(
      'function assigned to a table field',
      p,
      'foo.bar = function() end',
    );
    expectPass(
      'function assigned to a table field via index operator',
      p,
      'foo["bar"] = function() end',
    );
  });

  group('example', () {
    final p = LuaGrammarDefinition().build();

    // copy from official document
    expectPass('example', p, '''
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
     ''');
  });
}
