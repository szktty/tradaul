import 'package:test/test.dart';

import 'test.dart';

void testConditional() {
  group('if statement', () {
    group('only if', () {
      test('with true condition', () async {
        const source = '''
        if true then
          return 1;
        end
        return 0;
      ''';
        expect(
          await luaExecute(source),
          luaEquals([1]),
        );
      });

      test('with false condition', () async {
        const source = '''
        if false then
          return 1;
        end
        return 0;
      ''';
        expect(
          await luaExecute(source),
          luaEquals([0]),
        );
      });
    });

    group('if and else', () {
      test('if and else with true condition', () async {
        const source = '''
        if true then
          return 1;
        else
          return 2;
        end
      ''';
        expect(
          await luaExecute(source),
          luaEquals([1]),
        );
      });

      group('if and elseif', () {
        test('if true, and elseif', () async {
          const source = '''
        if true then
          return 1;
        elseif false then
          return 2;
        end
        return 0;
      ''';
          expect(
            await luaExecute(source),
            luaEquals([1]),
          );
        });

        test('if false, and elseif true', () async {
          const source = '''
        if false then
          return 1;
        elseif true then
          return 2;
        end
        return 0;
      ''';
          expect(
            await luaExecute(source),
            luaEquals([2]),
          );
        });

        test('if false, and elseif false', () async {
          const source = '''
        if false then
          return 1;
        elseif false then
          return 2;
        end
        return 0;
      ''';
          expect(
            await luaExecute(source),
            luaEquals([0]),
          );
        });

        test('multiple elseifs with the last being true', () async {
          const source = '''
        if false then
          return 1;
        elseif false then
          return 2;
        elseif true then
          return 3;
        end
        return 0;
      ''';
          expect(
            await luaExecute(source),
            luaEquals([3]),
          );
        });
      });

      test('if and else with false condition', () async {
        const source = '''
        if false then
          return 1;
        else
          return 2;
        end
      ''';
        expect(
          await luaExecute(source),
          luaEquals([2]),
        );
      });
    });

    group('if, elseif and else', () {
      test('first true condition with elseif', () async {
        const source = '''
        if true then
          return 1;
        elseif true then
          return 2;
        else
          return 3;
        end
      ''';
        expect(
          await luaExecute(source),
          luaEquals([1]),
        );
      });

      test('second true condition with elseif', () async {
        const source = '''
        if false then
          return 1;
        elseif true then
          return 2;
        else
          return 3;
        end
      ''';
        expect(
          await luaExecute(source),
          luaEquals([2]),
        );
      });

      test('no true condition with elseif', () async {
        const source = '''
        if false then
          return 1;
        elseif false then
          return 2;
        else
          return 3;
        end
      ''';
        expect(
          await luaExecute(source),
          luaEquals([3]),
        );
      });
    });

    group('operators', () {
      test('and operator both true', () async {
        const source = '''
        if true and true then
          return 1;
        end
        return 0;
      ''';
        expect(
          await luaExecute(source),
          luaEquals([1]),
        );
      });

      test('and operator with one false', () async {
        const source = '''
        if true and false then
          return 1;
        end
        return 0;
      ''';
        expect(
          await luaExecute(source),
          luaEquals([0]),
        );
      });

      test('or operator with one true', () async {
        const source = '''
        if false or true then
          return 1;
        end
        return 0;
      ''';
        expect(
          await luaExecute(source),
          luaEquals([1]),
        );
      });

      test('or operator both false', () async {
        const source = '''
        if false or false then
          return 1;
        end
        return 0;
      ''';
        expect(
          await luaExecute(source),
          luaEquals([0]),
        );
      });
    });

    group('nested if', () {
      test('nested if with inner true', () async {
        const source = '''
        if true then
          if true then
            return 1;
          end
        end
        return 0;
      ''';
        expect(
          await luaExecute(source),
          luaEquals([1]),
        );
      });

      test('nested if with inner false', () async {
        const source = '''
        if true then
          if false then
            return 1;
          end
        end
        return 0;
      ''';
        expect(
          await luaExecute(source),
          luaEquals([0]),
        );
      });
    });

    group('assign inside if', () {
      test('assign inside if', () async {
        const source = '''
        local x;
        if true then
          x = 1;
        else
          x = 2;
        end
        return x;
      ''';
        expect(
          await luaExecute(source),
          luaEquals([1]),
        );
      });
    });

    test('assign inside else', () async {
      const source = '''
        local x;
        if false then
          x = 1;
        else
          x = 2;
        end
        return x;
      ''';
      expect(
        await luaExecute(source),
        luaEquals([2]),
      );
    });
  });
}
