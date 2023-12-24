import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/runtime/execution.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_module.dart';
import 'package:tradaul/src/runtime/lua_native.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';
import 'package:tradaul/src/runtime/thread.dart';

class LuaCoroutineModule extends LuaNativeModule {
  LuaCoroutineModule() : super(name: 'coroutine');

  @override
  Future<LuaValueResult> load(LuaContext context, LuaValue? argument) async {
    if (!context.options.permissions.library.coroutine) {
      return Success(LuaNil());
    }

    final module = LuaTable()
      ..addNativeCalls({
        'create': _luaCreate,
        'status': _luaStatus,
        'resume': _luaResume,
        'running': _luaRunning,
        'yield': _luaYield,
        'isyieldable': _luaIsYieldable,
        'wrap': _luaWrap,
      });
    context.environment.variables.stringKeySet('coroutine', module);
    return Success(module);
  }
}

Future<LuaCallResult?> _luaCreate(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (context.mainThread == null) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'main thread is not found',
      ),
    );
  }
  if (arguments.arguments.firstOrNull is! LuaClosure) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'coroutine.create',
        order: 1,
        expected: 'function',
        actual: arguments.arguments.firstOrNull?.luaType.name,
      ),
    );
  }

  final closure = arguments.arguments[0] as LuaClosure;
  final coroutine = CompiledCoroutine(context.mainThread!, closure.code);
  return Success([LuaCompiledCoroutine(coroutine)]);
}

Future<LuaCallResult?> _luaStatus(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.arguments.firstOrNull is! LuaCoroutine) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'coroutine.status',
        order: 1,
        expected: 'thread',
        actual: arguments.arguments.firstOrNull?.luaType.name,
      ),
    );
  }

  final coroutine = arguments.arguments[0] as LuaCoroutine;
  return Success([LuaString(coroutine.state.luaName)]);
}

Future<LuaCallResult?> _luaResume(
  LuaContext context,
  LuaArguments arguments,
) async {
  final coroutine = arguments.get<LuaCoroutine>(0);
  if (coroutine == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'coroutine.resume',
        order: 1,
        expected: 'thread',
        actual: arguments.getTypeName(0),
      ),
    );
  }

  final result = await coroutine.resume(arguments.arguments.sublist(1));
  if (result.isError()) {
    final error = result.exceptionOrNull()!;
    return Success([LuaFalse(), LuaString(error.message)]);
  } else {
    return Success([LuaTrue(), ...result.getOrThrow()]);
  }
}

Future<LuaCallResult?> _luaRunning(
  LuaContext context,
  LuaArguments arguments,
) async {
  final coroutine = context.runningCoroutine;
  if (coroutine == null) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'coroutine.running(): running coroutine is not found',
      ),
    );
  }
  if (coroutine is CustomCoroutine) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'coroutine.running(): native coroutine is not supported',
      ),
    );
  }

  return Success([
    LuaCompiledCoroutine(coroutine as CompiledCoroutine),
    LuaBoolean.fromBool(coroutine.thread.isMain),
  ]);
}

Future<LuaCallResult?> _luaYield(
  LuaContext context,
  LuaArguments arguments,
) async {
  final coroutine = context.runningCoroutine;
  if (coroutine == null) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'attempt to yield from outside a coroutine',
      ),
    );
  }

  if (coroutine is CompiledCoroutine) {
    await coroutine.luaYield(arguments.arguments);
    return const Success([]);
  } else {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'attempt to yield from invalid coroutine ${coroutine.runtimeType}',
      ),
    );
  }
}

Future<LuaCallResult?> _luaIsYieldable(
  LuaContext context,
  LuaArguments arguments,
) async {
  final coroutine = context.runningCoroutine;
  if (coroutine == null) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'coroutine.running(): running coroutine is not found',
      ),
    );
  }
  if (coroutine is CustomCoroutine) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'coroutine.running(): native coroutine is not supported',
      ),
    );
  }

  return Success([LuaBoolean.fromBool(coroutine != context.mainCoroutine)]);
}

Future<LuaCallResult?> _luaWrap(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (context.mainThread == null) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'main thread is not found',
      ),
    );
  }
  if (arguments.arguments.firstOrNull is! LuaClosure) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'coroutine.wrap',
        order: 1,
        expected: 'function',
        actual: arguments.arguments.firstOrNull?.luaType.name,
      ),
    );
  }

  final closure = arguments.arguments[0] as LuaClosure;
  final coroutine = CompiledCoroutine(context.mainThread!, closure.code);
  final wrapped = LuaNativeFunction(null, (context, args) {
    return coroutine.resume(args.arguments);
  });
  return Success([wrapped]);
}
