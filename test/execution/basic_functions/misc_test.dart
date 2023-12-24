import 'dart:async';

import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_system/lua_system.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

import '../language/test.dart';

void main() {
  test('_VERSION', () async {
    const source = '''
        return _VERSION
      ''';
    expect(
      await luaExecute(source),
      luaEquals(['Lua ${LuaContext.luaVersion}']),
    );
  });

  test('_G', () async {
    const source = '''
        return _G
      ''';
    expect(await luaExecute(source), luaEquals([luaIsA<LuaTable>()]));
  });

  group('assert function', () {
    test('assert success', () async {
      const source = '''
        return assert(true)
      ''';
      expect(await luaExecute(source), luaEquals([true]));
    });

    test('assert success with message', () async {
      const source = '''
        return assert(true, 'hello')
      ''';
      expect(await luaExecute(source), luaEquals([true, 'hello']));
    });

    test('assert failure with nil', () async {
      const source = '''
        assert(nil)
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('assert failure with false', () async {
      const source = '''
        assert(false)
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });

  group('error function', () {
    test('error with message', () async {
      const source = '''
        error('message')
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });

    test('error with level ', () async {
      const source = '''
        error('message', 1)
      ''';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });

  group('collectgarbage function (not supported)', () {
    test('collectgarbage("step") returns false', () async {
      const source = 'return collectgarbage("step")';
      expect(await luaExecute(source), luaEquals([false]));
    });

    test('collectgarbage("isrunning") returns false', () async {
      const source = 'return collectgarbage("isrunning")';
      expect(await luaExecute(source), luaEquals([false]));
    });

    group('collectgarbage with other options returns 0', () {
      const otherOptions = [
        'count',
        'collect',
        'stop',
        'restart',
        'setpause',
        'setstepmul',
      ];
      for (final option in otherOptions) {
        test('collectgarbage("$option") returns 0', () async {
          final source = 'return collectgarbage("$option")';
          expect(await luaExecute(source), luaEquals([0]));
        });
      }
    });
  });

  group('type function tests', () {
    test('type of nil', () async {
      expect(await luaExecute('return type(nil)'), luaEquals(['nil']));
    });

    test('type of number', () async {
      expect(await luaExecute('return type(10)'), luaEquals(['number']));
    });

    test('type of string', () async {
      expect(await luaExecute('return type("hello")'), luaEquals(['string']));
    });

    test('type of table', () async {
      expect(await luaExecute('return type({})'), luaEquals(['table']));
    });

    test('type of function', () async {
      expect(
        await luaExecute('return type(function() end)'),
        luaEquals(['function']),
      );
    });

    test('type of thread', () async {
      expect(
        await luaExecute('return type(coroutine.create(function() end))'),
        luaEquals(['thread']),
      );
    });

    test('type of boolean', () async {
      expect(await luaExecute('return type(true)'), luaEquals(['boolean']));
    });

    test('type of user data', () async {
      expect(
        await luaExecute(
          'return type(custom)',
          onInit: (context) {
            context.environment.variables.stringKeySet(
              'custom',
              LuaCustomValue(
                123,
                type: LuaValueType.userdata,
              ),
            );
          },
        ),
        luaEquals(['userdata']),
      );
    });
  });

  group('print function', () {
    test('return nil', () async {
      expect(await luaExecute('print("hello")'), luaEquals([]));
    });

    test('output', () async {
      const s = 'hello';
      final controller = StreamController<List<int>>();
      final system = LuaSystem(stdout: controller.sink);
      controller.stream.listen((event) {
        expect(String.fromCharCodes(event), '$s${system.lineTerminator}');
      });
      await luaExecute('print("$s")', system: system);
    });

    test('output multiple values', () async {
      const words = ['hello', ',', ' ', 'world'];
      final controller = StreamController<List<int>>();
      final system = LuaSystem(stdout: controller.sink);
      controller.stream.listen((event) {
        expect(
          String.fromCharCodes(event),
          '${words.join("\t")}${system.lineTerminator}',
        );
      });
      await luaExecute(
        'print(${words.map((e) => '"$e"').join(',')})',
        system: system,
      );
    });
  });

  group('select function', () {
    test('returns the total number of arguments', () async {
      const source = 'return select("#", 1, 2, 3, 4, 5)';
      expect(await luaExecute(source), luaEquals([5]));
    });

    test('returns all arguments after the given index', () async {
      const source = 'return select(2, "a", "b", "c", "d")';
      expect(await luaExecute(source), luaEquals(['b', 'c', 'd']));
    });

    test('out-of-bounds index returns no values', () async {
      const source = 'return select(10, "a", "b", "c")';
      expect(await luaExecute(source), luaEquals([]));
    });

    test('out-of-bounds index returns no values', () async {
      const source = 'return select(10, "a", "b", "c")';
      expect(await luaExecute(source), luaEquals([]));
    });

    test('negative index returns arguments from the end', () async {
      const source = 'return select(-1, "a", "b", "c")';
      expect(await luaExecute(source), luaEquals(['c']));
    });

    test('0 index raises bad argument error', () async {
      const source = 'return select(0, "a", "b", "c")';
      expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
    });
  });

  group('pcall function', () {
    test('pcall without errors', () async {
      const source = '''
  local function testFunction()
    return "No Error", true
  end

  local success, message, flag = pcall(testFunction)
  return success, message, flag
  ''';
      expect(await luaExecute(source), luaEquals([true, 'No Error', true]));
    });

    test('pcall with an error', () async {
      const source = '''
  local function testFunction()
    error("This is an error")
  end

  local success, message = pcall(testFunction)
  return success, message
  ''';
      final result = await luaExecute(source);
      expect(await luaExecute(source), luaEquals([false, isA<LuaString>()]));
    });

    test('pcall with invalid function', () async {
      const source = '''
  local success, message = pcall("not a function")
  return success, message
  ''';
      expect(await luaExecute(source), luaEquals([false, isA<LuaString>()]));
    });
  });

  group('xpcall function', () {
    test('xpcall with a function that does not error', () async {
      const source = '''
  local function noErrorFunc()
    return "No error"
  end
  local errorHandler = function() return "Error handled" end
  local success, message = xpcall(noErrorFunc, errorHandler)
  return success, message
  ''';
      expect(await luaExecute(source), luaEquals([true, 'No error']));
    });

    test('xpcall with a function that errors', () async {
      const source = '''
  local function errorFunc()
    error("This is an error")
  end
  local errorHandler = function(err)
    return "Error handled: " .. err
  end
  return xpcall(errorFunc, errorHandler)
  ''';
      expect(await luaExecute(source), luaEquals([false, isA<LuaString>()]));
    });

    test('xpcall returns multiple results from function', () async {
      const source = '''
  local function multiReturnFunc()
    return 1, 2, 3
  end
  local errorHandler = function() end
  return xpcall(multiReturnFunc, errorHandler)
  ''';
      expect(await luaExecute(source), luaEquals([true, 1, 2, 3]));
    });
  });
}
