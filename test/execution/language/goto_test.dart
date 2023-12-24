import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

import 'test.dart';

void main() {
  testGoto();
}

void testGoto() {
  group('goto statement', () {
    group('basic behavior', () {
      test('undefined label', () async {
        const source = '''
        goto myLabel
        ''';
        expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
      });

      test('invalid multiple definition of labels', () async {
        const source = '''
        ::myLabel::
        ::myLabel::
        ''';
        expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
      });

      test('jump to a forward label', () async {
        const source = '''
        local result = 0
        goto myLabel
        result = 1
        ::myLabel::
        return result
        ''';
        expect(await luaExecute(source), luaEquals([0]));
      });

      test('jump to a previous label', () async {
        const source = '''
  local x = 1
  goto label2
  ::label1::
  x = x + 1
  goto exit
  ::label2::
  x = x + 2
  goto label1
  ::exit::
  return x
  ''';
        expect(await luaExecute(source), luaEquals([4]));
      });

      test('invalid jump into inner scope', () async {
        const source = '''
        goto l1
        local aa
        ::l1::
        print(3)
        ''';
        expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
      });
    });

    group('multiple labels', () {
      test('jumping between multiple labels', () async {
        const source = '''
        local result = 0
        goto secondLabel
        ::firstLabel::
        result = 1
        goto endTest
        ::secondLabel::
        result = 2
        goto endTest
        ::thirdLabel::
        result = 3
        ::endTest::
        return result
        ''';
        expect(await luaExecute(source), luaEquals([2]));
      });
    });

    group('label scope', () {
      group('definition', () {
        test('if block', () async {
          const source = '''
        if true then
          ::myLabel::
        end
        if true then
          ::myLabel::
        end
        ::myLabel::
        ''';
          expect(await luaExecute(source), luaEquals([]));
        });

        test('invalid if block', () async {
          const source = '''
        ::myLabel::
        if true then
          ::myLabel::
        end
        ''';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });

        test('do block', () async {
          const source = '''
        do
          ::myLabel::
        end
        do
          ::myLabel::
        end
        ::myLabel::
        ''';
          expect(await luaExecute(source), luaEquals([]));
        });

        test('invalid do block', () async {
          const source = '''
        ::myLabel::
        do
          ::myLabel::
        end
        ''';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });

        test('for loop', () async {
          const source = '''
        for i=1, 2 do
          ::myLabelFor::
        end
        ::myLabelFor::
        ''';
          expect(await luaExecute(source), luaEquals([]));
        });

        test('invalid for loop', () async {
          const source = '''
        ::myLabelFor::
        for i=1, 2 do
          ::myLabelFor::
        end
        ''';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });

        test('while loop', () async {
          const source = '''
        local i = 1
        while i <= 2 do
          ::myLabelWhile::
          i = i + 1
        end
        ::myLabelWhile::
        ''';
          expect(await luaExecute(source), luaEquals([]));
        });

        test('invalid while loop', () async {
          const source = '''
        ::myLabelWhile::
        local i = 1
        while i <= 2 do
          ::myLabelWhile::
          i = i + 1
        end
        ''';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });

        test('repeat-until loop', () async {
          const source = '''
        local i = 1
        repeat
          ::myLabelRepeat::
          i = i + 1
        until i > 2
        ::myLabelRepeat::
        ''';
          expect(await luaExecute(source), luaEquals([]));
        });

        test('invalid repeat-until loop', () async {
          const source = '''
        ::myLabelRepeat::
        local i = 1
        repeat
          ::myLabelRepeat::
          i = i + 1
        until i > 2
        ''';
          expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
        });
      });

      group('block', () {
        test('to outer backward block', () async {
          const source = '''
        do
          local x = false
          ::myLabel::
          if false then
            x = true
            goto myLabel
          end
        end
        return 1
        ''';
          expect(await luaExecute(source), luaEquals([1]));
        });
      });

      test('to outer forward block', () async {
        const source = '''
        local x = 0
        do
          if true then
             x = 1
            goto myLabel
          end
          x = 2
        end
        ::myLabel::
        return x
        ''';
        expect(await luaExecute(source), luaEquals([1]));
      });

      test('jump over local declaration to end of block', () async {
        const source = '''
do
  goto l1
  local a = 23
  x = a
  ::l1::;
end
        ''';
        expect(await luaExecute(source), luaEquals([]));
      });
    });
  });
}
