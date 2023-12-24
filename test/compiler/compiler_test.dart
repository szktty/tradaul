import 'package:test/scaffolding.dart';
import 'package:tradaul/src/compiler/compiler.dart';

void expectPass(String title, String input) {
  test(title, () {
    const path = '<test>';
    final compiler = LuaCompiler(path: path);
    final code = compiler.compileSource(input);
    //expect(result.value, isA<Node>());
  });
}

void main() {
  group('basic', () {
    expectPass('empty', '');
  });
  group('local assignment', () {
    expectPass('without values', 'local a,b');
    expectPass('with nil', 'local a,b = nil');
    expectPass('with bool', 'local a,b = true,false');
    expectPass('with numbers', 'local a,b = 1,1.0');
    expectPass('with string', 'local a,b = "hello"');
    expectPass('with less arguments', 'local a,b = 1');
    expectPass('with more arguments', 'local a,b = 1,2,3');
    expectPass('with function call only', 'local a,b,c = f()');
    expectPass('with function call and values', 'local a,b,c = f(), 1');
    expectPass('with last function call', 'local a,b,c = 1, f()');
  });
  group('operators', () {
    expectPass('length', 'local a = #b');
    expectPass('concat', 'local a, b = "foo", "bar"; local c = a .. b');
  });
}
