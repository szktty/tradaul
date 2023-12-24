// dummy function
import 'package:result_dart/result_dart.dart';
import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_native.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';
import 'package:tradaul/src/runtime/thread.dart';

import 'test.dart';

Future<LuaCallResult?> _luaItself(
  LuaContext context,
  LuaArguments arguments,
) async {
  return Success(arguments.arguments);
}

// dummy function
// 副作用のある関数。グローバル環境に影響を及ぼす
Future<LuaCallResult?> _luaUpdate(
  LuaContext context,
  LuaArguments arguments,
) async {
  // カウントを増やす
  final count =
      (context.environment.variables.stringKeyGet('count')! as LuaInteger)
              .value
              .toInt() +
          1;
  final luaCount = LuaInteger.fromInt(count);
  context.environment.variables.stringKeySet('count', luaCount);
  return Success([luaCount]);
}

// for custom coroutine test
Future<LuaCallResult?> _luaRange(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length != 2) {
    return Failure(
      LuaException.notEnoughArguments(
        function: 'range',
        expected: 2,
        actual: arguments.arguments.length,
      ),
    );
  }

  final start = arguments.getInt(0);
  if (start == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'range',
        order: 1,
        expected: 'int',
        actual: arguments.getTypeName(0),
      ),
    );
  }

  final end = arguments.getInt(1);
  if (end == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'range',
        order: 2,
        expected: 'int',
        actual: arguments.getTypeName(1),
      ),
    );
  }

  final range = RangeIterator(start, end);

  Future<LuaCustomCoroutineResult> callback(
    LuaContext context,
    LuaArguments arguments,
  ) async {
    final step = arguments.getInt(0) ?? 1;
    if (range.hasNext) {
      final next = LuaInteger.fromInt(range.next(step));
      if (range.isFinished) {
        return LuaCustomCoroutineResult.success(
          [next],
        );
      } else {
        return LuaCustomCoroutineResult.luaYield([next], callback);
      }
    } else {
      return LuaCustomCoroutineResult.failure(
        LuaException(
          LuaExceptionType.runtimeError,
          'range iterator is already finished',
        ),
      );
    }
  }

  final coroutine = LuaCustomCoroutine(context, callback);
  return Success(
    [coroutine],
  );
}

final class RangeIterator {
  RangeIterator(this.start, this.end) : current = start;
  final int start;
  final int end;

  int current;

  bool get hasNext => current <= end;

  bool get isFinished => current > end;

  int next(int step) {
    current += step;
    return current - step;
  }
}

Future<LuaCallResult?> _luaObject(
  LuaContext context,
  LuaArguments arguments,
) async {
  final object = LuaTable()
    ..addNativeCalls({
      'itself': _luaItself,
    });
  return Success([object]);
}

void _initContext() {
  luaSetOnInitContext((context) {
    context.environment.variables
      ..addNativeCalls({
        'itself': _luaItself,
        'update': _luaUpdate,
        'range': _luaRange,
        'object': _luaObject,
      })
      ..stringKeySet('count', LuaInteger.fromInt(0));
  });
}

void testInitContext() {
  _initContext();

  group('init Lua context', () {
    test('itself()', () async {
      expect(
        await luaExecute('return itself(1)'),
        luaEquals([1]),
      );
    });
    test('update()', () async {
      const source = '''
          update()
          return count
        ''';
      expect(
        await luaExecute(source),
        luaEquals([1]),
      );
    });
    test('error()', () async {
      expect(
        () async => luaExecute('error("message")'),
        luaThrows(LuaExceptionType.userError),
      );
    });
  });
}
