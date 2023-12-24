import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/compiler/number_parser.dart';
import 'package:tradaul/src/runtime/compiled_code.dart';
import 'package:tradaul/src/runtime/lua_comparator.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_context_options.dart';
import 'package:tradaul/src/runtime/lua_environment.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_invocation.dart';
import 'package:tradaul/src/runtime/lua_native.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';
import 'package:tradaul/src/runtime/opcodes.dart';
import 'package:tradaul/src/runtime/operators.dart';
import 'package:tradaul/src/runtime/stack.dart';
import 'package:tradaul/src/runtime/thread.dart';
import 'package:tradaul/src/utils/errors.dart';
import 'package:tradaul/src/utils/number.dart';

enum ExecutionContextState {
  running,
  suspended,
  completed,
}

// a wrapper for FunctionContext to put on the stack
final class LuaExecutionContext extends LuaValue {
  LuaExecutionContext(this.context);

  final CompiledExecutionContext context;

  @override
  String toString() {
    return 'ExecutionContext($context)';
  }

  @override
  bool luaEquals(LuaValue other) => this == other;

  @override
  LuaValueType get luaType => LuaValueType.userdata;

  @override
  int get luaHashCode => hashCode;

  @override
  dynamic get rawValue => context;
}

abstract class LuaMark extends LuaValue {
  LuaMark(this.index);

  int index;

  @override
  bool luaEquals(LuaValue other) => this == other;

  @override
  int get luaHashCode => hashCode;

  @override
  LuaValueType get luaType => LuaValueType.userdata;

  @override
  dynamic get rawValue => this;
}

final class LuaArgMark extends LuaMark {
  LuaArgMark(super.index);

  @override
  String get luaRepresentation => '@arg';
}

final class LuaReturnMark extends LuaMark {
  LuaReturnMark(super.index);

  @override
  String get luaRepresentation => '@return';
}

final class LuaAssignMark extends LuaMark {
  LuaAssignMark(super.index, this.depth) {
    remainDepth = depth;
  }

  final int depth;
  late int remainDepth;

  bool get finished => remainDepth <= 0;

  void pop() {
    if (finished) {
      throw LuaException(
        LuaExceptionType.runtimeError,
        'cannot pop: assign mark is already finished',
      );
    }
    remainDepth--;
  }

  @override
  String get luaRepresentation => '@assign';
}

final class LuaClosure extends LuaFunction {
  LuaClosure({
    required this.code,
    required this.upvalueStacks,
    this.environment,
  });

  final LuaCompiledFunction code;

  final List<LuaStack> upvalueStacks;

  final LuaEnvironment? environment;

  @override
  bool luaEquals(LuaValue other) {
    return other is LuaClosure && other.code == code;
  }

  @override
  int get luaHashCode => code.hashCode;

  @override
  String get luaRepresentation => 'function: $hashCode';

  @override
  dynamic get rawValue => code;
}

final class LuaUpvalueStack extends LuaValue {
  LuaUpvalueStack(this.stack);

  final LuaStack stack;

  @override
  bool luaEquals(LuaValue other) => this == other;

  @override
  int get luaHashCode => hashCode;

  @override
  LuaValueType get luaType => LuaValueType.userdata;

  @override
  String get luaRepresentation => 'upvalue stack: $hashCode';

  @override
  dynamic get rawValue => stack;
}

final class SuspendedContext {
  SuspendedContext({
    required this.pc,
    required this.luaYield,
  });

  final int pc;
  final List<LuaValue> luaYield;
}

abstract class ExecutionContext {
  ExecutionContext({
    required this.coroutine,
    this.parent,
    List<LuaValue>? arguments,
  }) {
    parent?.child = this;
    this.arguments = arguments ?? const [];
  }

  final CompiledCoroutine coroutine;
  final ExecutionContext? parent;
  ExecutionContext? child;
  late final List<LuaValue> arguments;

  Thread get thread => coroutine.thread;

  LuaContext get luaContext => coroutine.thread.luaContext;

  void finish() {
    parent?.child = null;
  }
}

final class NativeExecutionContext extends ExecutionContext {
  NativeExecutionContext({
    required super.coroutine,
    required this.code,
    super.parent,
    super.arguments,
  }) : super();

  final LuaNativeFunction code;
}

final class CompiledExecutionContext extends ExecutionContext {
  CompiledExecutionContext({
    required super.coroutine,
    required this.code,
    required this.environment,
    super.parent,
    super.arguments,
    List<LuaStack>? upvalueStacks,
  }) : super() {
    for (var i = 0; i < code.arity; i++) {
      _stack.push(arguments.elementAtOrNull(i) ?? LuaNil());
    }

    for (var i = 0; i < code.locals; i++) {
      _stack.push(LuaNil());
    }

    _upvalueStacks = upvalueStacks ?? [];

    if (code.variadic) {
      _varargs = LuaTable.fromList(arguments.sublist(code.arity).toList());
    } else {
      _varargs = null;
    }
  }

  CompiledExecutionContext get thisParent =>
      parent! as CompiledExecutionContext;

  var _state = ExecutionContextState.suspended;

  ExecutionContextState get state => _state;

  final LuaStack _stack = LuaStack();

  late final LuaCompiledFunction code;

  late List<LuaStack> _upvalueStacks = [];
  late final LuaTable? _varargs;
  int _pc = 0;
  List<LuaValue>? __returns;
  SuspendedContext? _suspendedContext;

  final LuaEnvironment environment;

  LuaPermissions get _permissions => thread.luaContext.options.permissions;

  void _setReturn(List<LuaValue> values, {required bool isCompleted}) {
    __returns = values;
    if (isCompleted) {
      _state = ExecutionContextState.completed;
    }
  }

  Future<LuaCallResult> resume(List<LuaValue> values) async {
    switch (state) {
      case ExecutionContextState.running:
        throw LuaException(
          LuaExceptionType.runtimeError,
          'cannot resume: execution context is already running',
        );
      case ExecutionContextState.completed:
        throw LuaException(
          LuaExceptionType.runtimeError,
          'cannot resume: execution context is already completed',
        );
      case ExecutionContextState.suspended:
        break;
    }

    _state = ExecutionContextState.running;
    _suspendedContext = null;
    _stack.pushAll(values);

    try {
      await _execute();
      return Success(__returns ?? const []);
    } catch (e) {
      if (e is LuaException) {
        return Failure(e);
      } else {
        return Failure(
          LuaException(LuaExceptionType.runtimeError, e.toString()),
        );
      }
    }
  }

  Future<void> luaYield(List<LuaValue> values) async {
    _state = ExecutionContextState.suspended;
    _suspendedContext = SuspendedContext(pc: _pc, luaYield: values);
  }

  Future<void> _execute() async {
    final opcodes = code.opcodes;

    for (; _pc < opcodes.length; _pc++) {
      switch (state) {
        case ExecutionContextState.running:
          break;
        case ExecutionContextState.suspended:
          if (_suspendedContext != null) {
            _setReturn(_suspendedContext!.luaYield, isCompleted: false);
          }
          return;
        case ExecutionContextState.completed:
          return;
      }

      final opcode = opcodes[_pc];
      final fields = LuaOpcode.getFields(opcode);

      //print('eval ${_pc + 1} ${LuaOpcode.getName(fields.op)}, ${fields.op}');
      //_stack.debugPrint();

      switch (fields.op) {
        case LuaOpcode.NO_OP:
          // do nothing
          break;

        case LuaOpcode.LOAD_NIL:
          _stack.push(LuaNil());

        case LuaOpcode.LOAD_TRUE:
          _stack.push(LuaTrue());

        case LuaOpcode.LOAD_FALSE:
          _stack.push(LuaFalse());

        case LuaOpcode.LOAD_INT:
          _stack.push(LuaInteger.fromInt(fields.sAx));

        case LuaOpcode.LOAD_CONST:
          _stack.push(code.constants[fields.ax]);

        case LuaOpcode.LOAD_LOCAL:
          _stack.push(_stack[fields.ax]);

        case LuaOpcode.LOAD_GLOBAL:
          final name = code.constants[fields.ax];
          final value = environment.variables.get(name) ?? LuaNil();
          _stack.push(value);

        case LuaOpcode.LOAD_UPVALUE:
          final upvalue = _upvalueStacks[fields.a][fields.bx];
          _stack.push(upvalue);

        case LuaOpcode.LOAD_UPSTACK:
          final upStack = _upvalueStacks[fields.a];
          _stack.push(LuaUpvalueStack(upStack));

        case LuaOpcode.LOAD_CONTEXT:
          _stack.push(LuaExecutionContext(this));

        case LuaOpcode.LOAD_ENV:
          _stack.push(environment.variables);

        case LuaOpcode.LOAD_VARARG:
          if (_varargs == null) {
            throw LuaException(
              LuaExceptionType.fatalError,
              'LOAD_VARARG: function is not variadic',
            );
          }

          _stack.push(_varargs!);

        case LuaOpcode.LOAD_VARARG_ITEMS:
          if (_varargs == null) {
            throw LuaException(
              LuaExceptionType.fatalError,
              'LOAD_VARARG_ITEMS: function is not variadic',
            );
          }

          for (final entry in _varargs!.sequence) {
            _stack.push(entry.value);
          }

        case LuaOpcode.LOAD_SELF:
          _stack.push(_stack[0]);

        case LuaOpcode.STORE_LOCAL:
          final value = _stack.pop();
          _stack[fields.ax] = value;

        case LuaOpcode.POP:
          _stack.pop();

        case LuaOpcode.POPS:
          _stack.pops(fields.ax);

        case LuaOpcode.MARK_ARG:
          _stack.push(LuaArgMark(_stack.topIndex + 1));

        case LuaOpcode.MARK_RETURN:
          _stack.push(LuaReturnMark(_stack.topIndex + 1));
        //_stack.debugPrint();

        case LuaOpcode.CREATE_TABLE:
          _stack.push(LuaTable());

        case LuaOpcode.GET_INDEX:
          final table = _stack.pop() as LuaTable;
          final value = table.getAt(fields.ax + 1) ?? LuaNil();
          _stack.push(value);

        case LuaOpcode.GET_FIELD:
          final key = _stack.pop();
          final table = _stack.pop();
          final result = await tableGet(table, key);
          _stack.pushOrThrow(result);

        case LuaOpcode.SET_FIELD:
          final value = _stack.pop();
          final key = _stack.pop();
          final table = _stack.top;
          final error = await tableSet(table, key, value);
          if (error != null) {
            throw error;
          }

        case LuaOpcode.ASSIGN_FIELD:
          final assignValue = _stack.pop();
          final offset = _stack.topIndex - fields.ax;
          final dest = _stack[offset];
          final field = _stack[offset + 1];

          if (dest is LuaTable) {
            final error = await tableSet(dest, field, assignValue);
            if (error != null) {
              throw error;
            }
          } else if (dest is LuaExecutionContext) {
            if (field is LuaInteger) {
              dest.context._stack[field.value.toInt()] = assignValue;
            } else {
              throw LuaException(
                LuaExceptionType.runtimeError,
                'invalid local context field ${field.luaToDisplayString()}',
              );
            }
          } else if (dest is LuaUpvalueStack) {
            if (field is LuaInteger) {
              dest.stack[field.value.toInt()] = assignValue;
            } else {
              throw LuaException(
                LuaExceptionType.runtimeError,
                'invalid upvalue index ${field.luaToDisplayString()}',
              );
            }
          } else {
            throw LuaException(
              LuaExceptionType.runtimeError,
              'invalid assigned destination ${dest.luaToDisplayString()}',
            );
          }

        case LuaOpcode.ADD_FIELD:
          final value = _stack.pop();
          final table = _stack.top as LuaTable;
          table.add(value);

        case LuaOpcode.ADD_VARARG:
          if (_varargs == null) {
            throw LuaException(
              LuaExceptionType.fatalError,
              'ADD_VARARG: function is not variadic',
            );
          }

          final table = _stack.top as LuaTable;
          for (final entry in _varargs!.sequence) {
            table.add(entry.value);
          }

        case LuaOpcode.RETURN:
          final returns = _stack.popToMark<LuaReturnMark>();
          if (returns == null) {
            throw LuaException(LuaExceptionType.runtimeError, 'no return mark');
          }
          _setReturn(returns.reversed.toList(), isCompleted: true);

        case LuaOpcode.RETURN_NONE:
          _setReturn(const [], isCompleted: true);

        case LuaOpcode.CALL:
        case LuaOpcode.CALL_ALL_OUT:
          final savedReturns =
              opcode == LuaOpcode.CALL_ALL_OUT ? null : fields.a;
          final args = _stack.popToMark<LuaArgMark>()?.reversed.toList();
          if (args == null) {
            throw LuaException(LuaExceptionType.runtimeError, 'no arg mark');
          }

          final func = _stack.pop();
          final result = await invoke(func, args);

          if (result.isError()) {
            throw result.exceptionOrNull()!;
          }

          final calledReturns = result.getOrThrow();
          if (savedReturns != null) {
            if (calledReturns.length >= savedReturns) {
              _stack.pushAll(calledReturns.sublist(0, savedReturns));
            } else {
              _stack.pushAll(calledReturns);
              for (var i = calledReturns.length; i < savedReturns; i++) {
                _stack.push(LuaNil());
              }
            }
          } else {
            _stack.pushAll(calledReturns);
          }

        //print('END CALL: returns = $calledReturns');
        //_stack.debugPrint();

        case LuaOpcode.CLOSURE:
          final proto = code.prototypes[fields.a];
          final captured = [
            LuaStack.from(_stack),
            ..._upvalueStacks.map(LuaStack.from),
          ];
          final closure = LuaClosure(code: proto, upvalueStacks: captured);
          _stack.push(closure);

        case LuaOpcode.BAND:
          final right = _stack.pop();
          final left = _stack.pop();
          final result = await _evaluateArithmeticBinOp(
            LuaOperator.bitwiseAnd,
            left,
            right,
          );
          _stack.pushOrThrow(result);

        case LuaOpcode.BOR:
          final right = _stack.pop();
          final left = _stack.pop();
          final result = await _evaluateArithmeticBinOp(
            LuaOperator.bitwiseOr,
            left,
            right,
          );
          _stack.pushOrThrow(result);

        case LuaOpcode.BXOR:
          final right = _stack.pop();
          final left = _stack.pop();
          final result = await _evaluateArithmeticBinOp(
            LuaOperator.bitwiseXor,
            left,
            right,
          );
          _stack.pushOrThrow(result);

        case LuaOpcode.SHL:
          final right = _stack.pop();
          final left = _stack.pop();
          final result = await _evaluateArithmeticBinOp(
            LuaOperator.bitwiseLeftShift,
            left,
            right,
          );
          _stack.pushOrThrow(result);

        case LuaOpcode.SHR:
          final right = _stack.pop();
          final left = _stack.pop();
          final result = await _evaluateArithmeticBinOp(
            LuaOperator.bitwiseRightShift,
            left,
            right,
          );
          _stack.pushOrThrow(result);

        case LuaOpcode.ADD:
          final right = _stack.pop();
          final left = _stack.pop();
          final result =
              await _evaluateArithmeticBinOp(LuaOperator.plus, left, right);
          _stack.pushOrThrow(result);

        case LuaOpcode.SUB:
          final right = _stack.pop();
          final left = _stack.pop();
          final result =
              await _evaluateArithmeticBinOp(LuaOperator.minus, left, right);
          _stack.pushOrThrow(result);

        case LuaOpcode.MUL:
          final right = _stack.pop();
          final left = _stack.pop();
          final result =
              await _evaluateArithmeticBinOp(LuaOperator.multiply, left, right);
          _stack.pushOrThrow(result);

        case LuaOpcode.DIV:
          final right = _stack.pop();
          final left = _stack.pop();
          final result =
              await _evaluateArithmeticBinOp(LuaOperator.divide, left, right);
          _stack.pushOrThrow(result);

        case LuaOpcode.IDIV:
          final right = _stack.pop();
          final left = _stack.pop();
          final result = await _evaluateArithmeticBinOp(
            LuaOperator.floorDivide,
            left,
            right,
          );
          _stack.pushOrThrow(result);

        case LuaOpcode.MOD:
          final right = _stack.pop();
          final left = _stack.pop();
          final result =
              await _evaluateArithmeticBinOp(LuaOperator.modulo, left, right);
          _stack.pushOrThrow(result);

        case LuaOpcode.POW:
          final right = _stack.pop();
          final left = _stack.pop();
          final result =
              await _evaluateArithmeticBinOp(LuaOperator.power, left, right);
          _stack.pushOrThrow(result);

        case LuaOpcode.NEG:
          final value = _stack.pop();
          final result = await _evaluateNegation(value);
          _stack.pushOrThrow(result);

        case LuaOpcode.BNOT:
          final value = _stack.pop();
          final result = await _evaluateBitwiseNegation(value);
          _stack.pushOrThrow(result);

        case LuaOpcode.CONCAT:
          final right = _stack.pop();
          final left = _stack.pop();
          final result = await _evaluateConcatOp(left, right);
          _stack.pushOrThrow(result);

        case LuaOpcode.NOT:
          final value = _stack.pop();
          if (!value.isFalse && !value.isNil) {
            _stack.push(LuaFalse());
          } else {
            _stack.push(LuaTrue());
          }

        case LuaOpcode.EQ:
          final right = _stack.pop();
          final left = _stack.pop();
          final result = await _evaluateEqualOp(left, right);
          _stack.pushOrThrow(result);

        case LuaOpcode.NEQ:
          final right = _stack.pop();
          final left = _stack.pop();
          final result = await _evaluateNotEqualOp(left, right);
          _stack.pushOrThrow(result);

        case LuaOpcode.LT:
          final right = _stack.pop();
          final left = _stack.pop();
          final result = await _evaluateLtOp(left, right);
          _stack.pushOrThrow(result);

        case LuaOpcode.LE:
          final right = _stack.pop();
          final left = _stack.pop();
          final result = await _evaluateLeOp(left, right);
          _stack.pushOrThrow(result);

        case LuaOpcode.GT:
          final right = _stack.pop();
          final left = _stack.pop();
          final result = await _evaluateGtOp(left, right);
          _stack.pushOrThrow(result);

        case LuaOpcode.GE:
          final right = _stack.pop();
          final left = _stack.pop();
          final result = await _evaluateGeOp(left, right);
          _stack.pushOrThrow(result);

        case LuaOpcode.LEN:
          final value = _stack.pop();
          final result = await _evaluateLenOp(value);
          _stack.pushOrThrow(result);

        case LuaOpcode.BRANCH_FALSE:
          final condition = _stack.top;
          if (condition.isFalse || condition.isNil) {
            _pc += fields.sBx - 1;
          }

        case LuaOpcode.BRANCH_FALSE_POP:
          final condition = _stack.pop();
          if (condition.isFalse || condition.isNil) {
            _pc += fields.sBx - 1;
          }

        case LuaOpcode.BRANCH_TRUE:
          final condition = _stack.top;
          if (!condition.isFalse && !condition.isNil) {
            _pc += fields.sBx - 1;
          }

        case LuaOpcode.BRANCH_TRUE_POP:
          final condition = _stack.pop();
          if (!condition.isFalse && !condition.isNil) {
            _pc += fields.sBx - 1;
          }

        case LuaOpcode.BRANCH_NIL_POP:
          final condition = _stack.pop();
          if (condition.isNil) {
            _pc += fields.sBx - 1;
          }

        case LuaOpcode.JUMP:
          _pc += fields.sBx - 1;

        case LuaOpcode.CHECK_NUMBER:
          final value = _stack.top;
          if (value is! LuaNumber) {
            _stack.pop();
            throw LuaException(
              LuaExceptionType.runtimeError,
              "bad 'for' step (number expected, got ${value.luaType.name}",
            );
          }

        case LuaOpcode.FOR_STEP:
          final index = _stack[fields.a] as LuaNumber;
          final limit = _stack[fields.b] as LuaNumber;
          final step = _stack[fields.c] as LuaNumber;

          // TODO: invoke addition operator to call metamethod
          final rawIndex = index.rawValue;
          final rawLimit = limit.rawValue;
          final rawStep = step.rawValue;
          final nextIndex = ArithmeticOperatorDispatcher.addition
              .dispatch(rawIndex, rawStep) as LuaNumber;
          _stack[fields.a] = nextIndex;

          final indexDouble = nextIndex.toDouble();
          final limitDouble = limit.toDouble();
          final stepDouble = step.toDouble();
          final break_ = (stepDouble >= 0 && indexDouble > limitDouble) ||
              (stepDouble < 0 && indexDouble < limitDouble);
          _stack.push(LuaBoolean.fromBool(!break_));

        case LuaOpcode.RESET_LOCAL:
          _stack.reset(fields.a);

        case LuaOpcode.DUP:
          _stack.push(_stack.top);

        case LuaOpcode.SWAP:
          final a = _stack.pop();
          final b = _stack.pop();
          _stack.push(a);
          _stack.push(b);

        default:
          throw LuaException(
              LuaExceptionType.fatalError,
              'unknown or unimplemented opcode ${fields.op} '
              '(${LuaOpcode.getName(fields.op)})');
      }

      //_stack.debugPrint();
    }
  }

  Future<void> _invokeBinOp(
    LuaInvocation Function(LuaValue, LuaValue) f,
  ) async {
    final right = _stack.pop();
    final left = _stack.pop();
    final inv = f(left, right);
    final result = await invokeWithInvocation(inv);
    if (result.isError()) {
      throw result.exceptionOrNull()!;
    }
    _stack.push(result.getOrThrow().first);
  }

  Future<LuaCallResult> invoke(
    LuaValue func,
    List<LuaValue> args, {
    bool isRaw = false,
  }) async {
    if (func is LuaNativeFunction) {
      // TODO: needed?
      /*
      final newContext = NativeExecutionContext(
        coroutine: coroutine,
        parent: this,
        code: func,
        arguments: args,
      );
       */
      final argWrap = LuaArguments(args);
      final result =
          await func.callback(thread.luaContext, argWrap) ?? Result.success([]);
      // newContext.finish();
      return result;
    } else if (func is LuaClosure) {
      final newContext = CompiledExecutionContext(
        coroutine: coroutine,
        parent: this,
        code: func.code,
        arguments: args,
        upvalueStacks: func.upvalueStacks,
        environment: func.environment ?? environment,
      );
      final result = newContext.resume(const []);
      newContext.finish();
      return result;
    } else if (func is LuaTable) {
      final result = await invokeMetamethod(
        target: func,
        name: LuaMetamethodNames.call,
        arguments: [func, ...args],
      );
      if (result != null) {
        return result;
      } else {
        return Failure(LuaException.nonCallable(actual: func.luaType.name));
      }
    } else {
      return Failure(LuaException.nonCallable(actual: func.luaType.name));
    }
  }

  Future<LuaCallResult?> invokeMetamethod({
    required LuaTable target,
    required String name,
    required List<LuaValue> arguments,
  }) async {
    final field = environment.getMetafield(target, name);
    if (field != null) {
      return invoke(field, arguments);
    } else {
      return null;
    }
  }

  Future<LuaCallResult> invokeWithInvocation(LuaInvocation invocation) async {
    return switch (invocation) {
      (final LuaFunctionInvocation invocation) => await _findAndInvokeFunction(
          invocation.name,
          invocation.arguments,
          isRaw: invocation.isRaw,
        ),
      (final LuaMethodInvocation invocation) => await _findAndInvokeMethod(
          invocation.target,
          invocation.name,
          invocation.arguments,
          isRaw: invocation.isRaw,
        ),
      (final LuaValueInvocation invocation) => await invoke(
          invocation.target,
          invocation.arguments,
          isRaw: invocation.isRaw,
        ),
      (final LuaBinaryInvocation invocation) => (await _evaluateBinOp(
          invocation.operator,
          invocation.arguments[0],
          invocation.arguments[1],
          isRaw: invocation.isRaw,
        ))
            .toLuaCallResult(),
      (final LuaUnaryInvocation invocation) => (await _evaluateUnOp(
          invocation.operator,
          invocation.arguments.first,
          isRaw: invocation.isRaw,
        ))
            .toLuaCallResult(),
      (final LuaInvocation invocation) => Failure(
          LuaException(
            LuaExceptionType.runtimeError,
            'invalid invocation $invocation',
          ),
        ),
    };
  }

  Future<LuaCallResult> _findAndInvokeFunction(
    String name,
    List<LuaValue> arguments, {
    bool isRaw = false,
  }) async {
    final func = environment.variables.stringKeyGet(name);
    if (func == null) {
      return Failure(LuaException.nonCallable());
    }
    return invoke(func, arguments, isRaw: isRaw);
  }

  Future<LuaCallResult> _findAndInvokeMethod(
    LuaTable target,
    String name,
    List<LuaValue> arguments, {
    bool isRaw = false,
  }) async {
    final funcGet = await tableGet(target, LuaString(name), isRaw: isRaw);
    if (funcGet.isError()) {
      return Failure(funcGet.exceptionOrNull()!);
    }

    return invoke(funcGet.getOrThrow(), arguments, isRaw: isRaw);
  }

  Future<LuaValueResult> _evaluateBinOp(
    LuaOperator operator,
    LuaValue a,
    LuaValue b, {
    bool isRaw = false,
  }) async {
    if (operator.isArithmetic) {
      return _evaluateArithmeticBinOp(operator, a, b, isRaw: isRaw);
    } else if (operator.isBitwise) {
      return _evaluateBitwiseBinOp(operator, a, b, isRaw: isRaw);
    } else if (operator.isRelational) {
      return _evaluateRelationalBinOp(operator, a, b, isRaw: isRaw);
    } else if (operator == LuaOperator.concat) {
      return _evaluateConcatOp(a, b, isRaw: isRaw);
    } else {
      throw UnimplementedError('evaluateBinOp: $operator');
    }
  }

  Future<LuaValueResult> _evaluateArithmeticBinOp(
    LuaOperator operator,
    LuaValue a,
    LuaValue b, {
    bool isRaw = false,
  }) async {
    final error = LuaException(
      LuaExceptionType.runtimeError,
      'attempt to perform arithmetic on '
      '${a.luaType.name} and ${b.luaType.name} values',
    );

    final (dispatcher, metamethod) = switch (operator) {
      LuaOperator.plus => (
          ArithmeticOperatorDispatcher.addition,
          LuaMetamethodNames.add
        ),
      LuaOperator.minus => (
          ArithmeticOperatorDispatcher.subtraction,
          LuaMetamethodNames.sub
        ),
      LuaOperator.multiply => (
          ArithmeticOperatorDispatcher.multiplication,
          LuaMetamethodNames.mul
        ),
      LuaOperator.divide => (
          ArithmeticOperatorDispatcher.division,
          LuaMetamethodNames.div
        ),
      LuaOperator.floorDivide => (
          ArithmeticOperatorDispatcher.floorDivision,
          LuaMetamethodNames.idiv
        ),
      LuaOperator.modulo => (
          ArithmeticOperatorDispatcher.modulus,
          LuaMetamethodNames.mod
        ),
      LuaOperator.power => (
          ArithmeticOperatorDispatcher.exponentiation,
          LuaMetamethodNames.pow
        ),
      LuaOperator.bitwiseAnd => (
          ArithmeticOperatorDispatcher.bitwiseAnd,
          LuaMetamethodNames.band
        ),
      LuaOperator.bitwiseOr => (
          ArithmeticOperatorDispatcher.bitwiseOr,
          LuaMetamethodNames.bor
        ),
      LuaOperator.bitwiseXor => (
          ArithmeticOperatorDispatcher.bitwiseXor,
          LuaMetamethodNames.bxor
        ),
      LuaOperator.bitwiseLeftShift => (
          ArithmeticOperatorDispatcher.leftShift,
          LuaMetamethodNames.shl
        ),
      LuaOperator.bitwiseRightShift => (
          ArithmeticOperatorDispatcher.rightShift,
          LuaMetamethodNames.shr
        ),
      _ => throw UnimplementedError('invokeBinOp: $operator'),
    };

    if ((a is LuaNumber || a is LuaString) &&
        (b is LuaNumber || b is LuaString)) {
      final rawA = a.rawValue;
      final rawB = b.rawValue;
      if (dispatcher.validate(rawA, rawB) == null) {
        return Success(dispatcher.dispatch(rawA, rawB));
      }
    }

    if (!isRaw) {
      if (a is LuaTable) {
        return (await invokeMetamethod(
              target: a,
              name: metamethod,
              arguments: [a, b],
            ))
                ?.toLuaValueResult() ??
            Failure(error);
      } else if (b is LuaTable) {
        return (await invokeMetamethod(
              target: b,
              name: metamethod,
              arguments: [b, a],
            ))
                ?.toLuaValueResult() ??
            Failure(error);
      }
    }

    return Failure(error);
  }

  Future<LuaValueResult> _evaluateBitwiseBinOp(
    LuaOperator operator,
    LuaValue a,
    LuaValue b, {
    bool isRaw = false,
  }) async {
    final error = LuaException(
      LuaExceptionType.runtimeError,
      'attempt to perform bitwise operation on '
      '${a.luaType.name} and ${b.luaType.name} values',
    );

    final (dispatcher, metamethod) = switch (operator) {
      LuaOperator.bitwiseAnd => (
          ArithmeticOperatorDispatcher.bitwiseAnd,
          LuaMetamethodNames.band
        ),
      LuaOperator.bitwiseOr => (
          ArithmeticOperatorDispatcher.bitwiseOr,
          LuaMetamethodNames.bor
        ),
      LuaOperator.bitwiseXor => (
          ArithmeticOperatorDispatcher.bitwiseXor,
          LuaMetamethodNames.bxor
        ),
      LuaOperator.bitwiseLeftShift => (
          ArithmeticOperatorDispatcher.leftShift,
          LuaMetamethodNames.shl
        ),
      LuaOperator.bitwiseRightShift => (
          ArithmeticOperatorDispatcher.rightShift,
          LuaMetamethodNames.shr
        ),
      _ => throw UnimplementedError('invokeBinOp: $operator'),
    };

    if ((a is LuaInteger || a is LuaString) &&
        (b is LuaInteger || b is LuaString)) {
      final rawA = a.rawValue;
      final rawB = b.rawValue;
      if (dispatcher.validate(rawA, rawB) == null) {
        return Success(dispatcher.dispatch(rawA, rawB));
      }
    }

    if (!isRaw) {
      if (a is LuaTable) {
        return (await invokeMetamethod(
              target: a,
              name: metamethod,
              arguments: [a, b],
            ))
                ?.toLuaValueResult() ??
            Failure(error);
      } else if (b is LuaTable) {
        return (await invokeMetamethod(
              target: b,
              name: metamethod,
              arguments: [b, a],
            ))
                ?.toLuaValueResult() ??
            Failure(error);
      }
    }

    return Failure(error);
  }

  Future<LuaValueResult> _evaluateRelationalBinOp(
    LuaOperator operator,
    LuaValue a,
    LuaValue b, {
    bool isRaw = false,
  }) async {
    switch (operator) {
      case LuaOperator.equal:
        return _evaluateEqualOp(a, b, isRaw: isRaw);
      case LuaOperator.lessThan:
        return _evaluateLtOp(a, b, isRaw: isRaw);
      case LuaOperator.lessThanOrEqual:
        return _evaluateLeOp(a, b, isRaw: isRaw);
      case LuaOperator.greaterThan:
        return _evaluateGtOp(a, b, isRaw: isRaw);
      case LuaOperator.greaterThanOrEqual:
        return _evaluateGeOp(a, b, isRaw: isRaw);
      default:
        throw UnimplementedError('evaluate relational bin op: $operator');
    }
  }

  Future<LuaValueResult> _evaluateEqualOp(
    LuaValue a,
    LuaValue b, {
    bool isRaw = false,
  }) async {
    if (!isRaw && a is LuaTable && b is LuaTable) {
      final result = await invokeMetamethod(
            target: a,
            name: LuaMetamethodNames.eq,
            arguments: [a, b],
          ) ??
          await invokeMetamethod(
            target: b,
            name: LuaMetamethodNames.eq,
            arguments: [b, a],
          );
      if (result != null) {
        if (result.isSuccess()) {
          return Success(
            LuaBoolean.fromBool(result.getOrThrow().first.luaToBoolean),
          );
        } else {
          return Failure(result.exceptionOrNull()!);
        }
      }
    }
    return Success(LuaBoolean.fromBool(a.luaEquals(b)));
  }

  Future<LuaValueResult> _evaluateNotEqualOp(
    LuaValue a,
    LuaValue b, {
    bool isRaw = false,
  }) async {
    if (!isRaw && a is LuaTable && b is LuaTable) {
      final result = await invokeMetamethod(
            target: a,
            name: LuaMetamethodNames.eq,
            arguments: [a, b],
          ) ??
          await invokeMetamethod(
            target: b,
            name: LuaMetamethodNames.eq,
            arguments: [b, a],
          );
      if (result != null) {
        if (result.isSuccess()) {
          return Success(
            LuaBoolean.fromBool(!result.getOrThrow().first.luaToBoolean),
          );
        } else {
          return Failure(result.exceptionOrNull()!);
        }
      }
    }
    return Success(LuaBoolean.fromBool(!a.luaEquals(b)));
  }

  Future<LuaValueResult> _evaluateLtOp(
    LuaValue a,
    LuaValue b, {
    bool isRaw = false,
  }) async {
    if ((a is LuaNumber && b is LuaNumber) ||
        (a is LuaString && b is LuaString)) {
      final result = LuaComparator(a, b).compare(LuaComparisonType.lt);
      return Success(LuaBoolean.fromBool(result));
    }

    if (!isRaw) {
      LuaCallResult? result;
      if (a is LuaTable) {
        result = await invokeMetamethod(
          target: a,
          name: LuaMetamethodNames.lt,
          arguments: [a, b],
        );
      }
      if (result == null && b is LuaTable) {
        result = await invokeMetamethod(
          target: b,
          name: LuaMetamethodNames.lt,
          arguments: [b, a],
        );
      }
      if (result != null) {
        if (result.isSuccess()) {
          return Success(
            LuaBoolean.fromBool(result.getOrThrow().first.luaToBoolean),
          );
        } else {
          return Failure(result.exceptionOrNull()!);
        }
      }
    }

    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'attempt to compare ${a.luaType.name} with ${b.luaType.name}',
      ),
    );
  }

  Future<LuaValueResult> _evaluateLeOp(
    LuaValue a,
    LuaValue b, {
    bool isRaw = false,
  }) async {
    if ((a is LuaNumber && b is LuaNumber) ||
        (a is LuaString && b is LuaString)) {
      final result = LuaComparator(a, b).compare(LuaComparisonType.le);
      return Success(LuaBoolean.fromBool(result));
    }

    if (!isRaw) {
      LuaCallResult? result;
      if (a is LuaTable) {
        result = await invokeMetamethod(
          target: a,
          name: LuaMetamethodNames.le,
          arguments: [a, b],
        );
      }
      if (result == null && b is LuaTable) {
        result = await invokeMetamethod(
          target: b,
          name: LuaMetamethodNames.le,
          arguments: [a, b],
        );
      }
      if (result != null) {
        if (result.isSuccess()) {
          return Success(
            LuaBoolean.fromBool(result.getOrThrow().first.luaToBoolean),
          );
        } else {
          return Failure(result.exceptionOrNull()!);
        }
      }

      if (a is LuaTable) {
        result = await invokeMetamethod(
          target: a,
          name: LuaMetamethodNames.lt,
          arguments: [b, a],
        );
      }
      if (result == null && b is LuaTable) {
        result = await invokeMetamethod(
          target: b,
          name: LuaMetamethodNames.lt,
          arguments: [b, a],
        );
      }
      if (result != null) {
        if (result.isSuccess()) {
          return Success(
            LuaBoolean.fromBool(!result.getOrThrow().first.luaToBoolean),
          );
        } else {
          return Failure(result.exceptionOrNull()!);
        }
      }
    }

    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'attempt to compare ${a.luaType.name} with ${b.luaType.name}',
      ),
    );
  }

  Future<LuaValueResult> _evaluateGtOp(
    LuaValue a,
    LuaValue b, {
    bool isRaw = false,
  }) async {
    if ((a is LuaNumber && b is LuaNumber) ||
        (a is LuaString && b is LuaString)) {
      final result = LuaComparator(b, a).compare(LuaComparisonType.lt);
      return Success(LuaBoolean.fromBool(result));
    }

    if (!isRaw) {
      LuaCallResult? result;
      if (b is LuaTable) {
        result = await invokeMetamethod(
          target: b,
          name: LuaMetamethodNames.lt,
          arguments: [b, a],
        );
      }
      if (result == null && a is LuaTable) {
        result = await invokeMetamethod(
          target: a,
          name: LuaMetamethodNames.le,
          arguments: [a, b],
        );
        if (result != null) {
          if (result.isSuccess()) {
            // `not (b <= a)`
            return Success(
              LuaBoolean.fromBool(!result.getOrThrow().first.luaToBoolean),
            );
          } else {
            return Failure(result.exceptionOrNull()!);
          }
        }
      }
      if (result != null) {
        if (result.isSuccess()) {
          return Success(
            LuaBoolean.fromBool(result.getOrThrow().first.luaToBoolean),
          );
        } else {
          return Failure(result.exceptionOrNull()!);
        }
      }
    }

    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'attempt to compare ${a.luaType.name} with ${b.luaType.name}',
      ),
    );
  }

  Future<LuaValueResult> _evaluateGeOp(
    LuaValue a,
    LuaValue b, {
    bool isRaw = false,
  }) async {
    if ((a is LuaNumber && b is LuaNumber) ||
        (a is LuaString && b is LuaString)) {
      final result = LuaComparator(b, a).compare(LuaComparisonType.le);
      return Success(LuaBoolean.fromBool(result));
    }

    if (!isRaw) {
      LuaCallResult? result;
      if (b is LuaTable) {
        result = await invokeMetamethod(
          target: b,
          name: LuaMetamethodNames.le,
          arguments: [b, a],
        );
      }
      if (result == null && a is LuaTable) {
        result = await invokeMetamethod(
          target: a,
          name: LuaMetamethodNames.lt,
          arguments: [a, b],
        );
        if (result != null) {
          if (result.isSuccess()) {
            // `not (a < b)`
            return Success(
              LuaBoolean.fromBool(!result.getOrThrow().first.luaToBoolean),
            );
          } else {
            return Failure(result.exceptionOrNull()!);
          }
        }
      }
      if (result != null) {
        if (result.isSuccess()) {
          return Success(
            LuaBoolean.fromBool(result.getOrThrow().first.luaToBoolean),
          );
        } else {
          return Failure(result.exceptionOrNull()!);
        }
      }
    }

    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'attempt to compare ${a.luaType.name} with ${b.luaType.name}',
      ),
    );
  }

  Future<LuaValueResult> _evaluateConcatOp(
    LuaValue a,
    LuaValue b, {
    bool isRaw = false,
  }) async {
    final error = LuaException(
      LuaExceptionType.runtimeError,
      'attempt to concatenate ${a.luaType.name} with ${b.luaType.name}',
    );

    if ((a is LuaString || a is LuaNumber) &&
        (b is LuaString || b is LuaNumber)) {
      final value = StringOperatorDispatcher.concatenation
          .dispatch(a.rawValue, b.rawValue);
      return Success(value);
    }

    if (!isRaw) {
      LuaCallResult? result;
      if (a is LuaTable) {
        result = await invokeMetamethod(
          target: a,
          name: LuaMetamethodNames.concat,
          arguments: [a, b],
        );
      }
      if (result == null && b is LuaTable) {
        result = await invokeMetamethod(
          target: b,
          name: LuaMetamethodNames.concat,
          arguments: [a, b],
        );
      }

      if (result != null) {
        return result.toLuaValueResult();
      }
    }

    return Failure(error);
  }

  Future<LuaValueResult> _evaluateUnOp(
    LuaOperator operator,
    LuaValue value, {
    bool isRaw = false,
  }) async {
    switch (operator) {
      case LuaOperator.negation:
        return _evaluateNegation(value, isRaw: isRaw);
      case LuaOperator.bitwiseNot:
        return _evaluateBitwiseNegation(value, isRaw: isRaw);
      case LuaOperator.length:
        return _evaluateLenOp(value, isRaw: isRaw);
      default:
        throw UnimplementedError('invokeUnOp: $operator');
    }
  }

  Future<LuaValueResult> _evaluateNegation(
    LuaValue value, {
    bool isRaw = false,
  }) async {
    final error = LuaException(
      LuaExceptionType.runtimeError,
      'attempt to perform arithmetic on a ${value.luaType.name} value',
    );

    if (value is LuaInteger) {
      return Success(LuaInteger(-value.value));
    } else if (value is LuaFloat) {
      return Success(LuaFloat(-value.value));
    } else if (value is LuaString) {
      final intValue = NumberParser.parseInt64(value.value);
      if (intValue != null) {
        return Success(LuaInteger(-intValue));
      }
      final doubleValue = NumberParser.parseDouble(value.value);
      if (doubleValue != null) {
        return Success(LuaFloat(-doubleValue));
      }
      return Failure(error);
    } else if (!isRaw && value is LuaTable) {
      return (await invokeMetamethod(
            target: value,
            name: LuaMetamethodNames.unm,
            arguments: [value, value],
          ))
              ?.toLuaValueResult() ??
          Failure(error);
    } else {
      return Failure(error);
    }
  }

  Future<LuaValueResult> _evaluateBitwiseNegation(
    LuaValue value, {
    bool isRaw = false,
  }) async {
    final error = LuaException(
      LuaExceptionType.runtimeError,
      'attempt to perform bitwise operation on a ${value.luaType.name} value',
    );

    if (value is LuaNumber) {
      final intValue = NumberUtils.toIntRepresentation(value.rawValue);
      if (intValue != null) {
        return Success(LuaInteger(~intValue));
      } else {
        return Failure(error);
      }
    } else if (value is LuaString) {
      final intValue = NumberParser.parseInt64(value.value);
      if (intValue != null) {
        return Success(LuaInteger(-intValue));
      } else {
        return Failure(error);
      }
    } else if (!isRaw && value is LuaTable) {
      return (await invokeMetamethod(
            target: value,
            name: LuaMetamethodNames.bnot,
            arguments: [value, value],
          ))
              ?.toLuaValueResult() ??
          Failure(error);
    } else {
      return Failure(error);
    }
  }

  Future<LuaValueResult> _evaluateLenOp(
    LuaValue value, {
    bool isRaw = false,
  }) async {
    if (value is LuaString) {
      return Success(LuaInteger.fromInt(value.length));
    }

    if (value is LuaTable) {
      if (!isRaw) {
        final result = await invokeMetamethod(
          target: value,
          name: LuaMetamethodNames.len,
          arguments: [value],
        );
        if (result != null) {
          if (result.isSuccess()) {
            return Success(result.getOrThrow().first);
          } else {
            return Failure(result.exceptionOrNull()!);
          }
        }
      }
      return Success(LuaInteger.fromInt(value.border));
    }

    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'attempt to get length of a ${value.luaType.name} value',
      ),
    );
  }

  Future<LuaValueResult> tableGet(
    LuaValue table,
    LuaValue key, {
    bool isRaw = false,
  }) async {
    final error = LuaException.invalidIndex(actual: table.luaType.name);

    if (table is LuaTable) {
      final value = table.get(key);
      if (value != null) {
        return Success(value);
      } else if (isRaw) {
        return Success(LuaNil());
      } else {
        final field = environment.getMetafield(table, LuaMetamethodNames.index);
        if (field != null) {
          if (field is LuaTable) {
            return tableGet(field, key);
          } else if (field is LuaFunction) {
            return (await invoke(field, [table, key])).toLuaValueResult();
          } else {
            return Failure(error);
          }
        } else {
          return Success(LuaNil());
        }
      }
    } else {
      return Failure(error);
    }
  }

  Future<LuaException?> tableSet(
    LuaValue table,
    LuaValue key,
    LuaValue value, {
    bool isRaw = false,
  }) async {
    final error = LuaException.invalidIndex(actual: table.luaType.name);

    if (table is LuaTable) {
      if (!luaContext.options.permissions.overwrite &&
          table == environment.variables) {
        return LuaException(
          LuaExceptionType.runtimeError,
          'attempt to overwrite global variable ${key.luaToString}',
        );
      }

      if (table.get(key) != null) {
        return table.set(key, value);
      } else if (isRaw) {
        return table.set(key, value);
      } else {
        final field =
            environment.getMetafield(table, LuaMetamethodNames.newindex);
        if (field != null) {
          if (field is LuaTable) {
            return tableSet(field, key, value);
          } else if (field is LuaFunction) {
            final result = await invoke(field, [table, key, value]);
            return result.exceptionOrNull();
          } else if (field is LuaNil) {
            return table.set(key, value);
          } else {
            return error;
          }
        } else {
          return table.set(key, value);
        }
      }
    } else {
      return error;
    }
  }

  LuaStackTrace trace() {
    final entries = <LuaStackTraceEntry>[];
    ExecutionContext? context = this;
    while (context != null) {
      LuaStackTraceEntry? entry;
      if (context is CompiledExecutionContext) {
        final code = context.code;
        entry = LuaStackTraceEntry(
          path: code.path,
          line: code.lineInfo?.find(context._pc),
        );
      } else if (context is NativeExecutionContext) {
        entry = LuaStackTraceEntry(path: context.code.name);
      } else {
        throw UnreachableError();
      }
      entries.add(entry);
      context = context.parent;
    }
    return LuaStackTrace(entries);
  }
}
