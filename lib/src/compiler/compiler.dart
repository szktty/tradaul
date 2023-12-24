import 'package:collection/collection.dart';
import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/compiler/debug_print.dart';
import 'package:tradaul/src/compiler/number_parser.dart';
import 'package:tradaul/src/compiler/string_parser.dart';
import 'package:tradaul/src/parser/ast.dart' as ast;
import 'package:tradaul/src/parser/parser.dart';
import 'package:tradaul/src/runtime/compiled_code.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_values.dart';
import 'package:tradaul/src/runtime/opcodes.dart';
import 'package:tradaul/src/utils/errors.dart';

// ignore_for_file: no_default_cases, require_trailing_commas

class BlockContext {
  bool get isChunk => false;

  Stack stack = Stack();
}

class ChunkContext extends BlockContext {
  @override
  bool get isChunk => true;

  List<String> globals = [];
  List<FunctionContext> functions = [];
}

class FunctionContext extends BlockContext {
  FunctionContext(this.parent) {
    if (parent != null) {
      upvalueStacks
        ..addAll(parent!.upvalueStacks)
        ..add(parent!);

      for (final upvalue in parent!.upvalues) {
        addUpvalue(upvalue);
      }
    }

    final baseScope = VariableScope(context: this);
    scopes.add(baseScope);
    usedScopes.add(baseScope);
  }

  FunctionContext? parent;
  String? name;
  bool isMethod = false;
  int? firstLine;
  int? lastLine;
  int arity = 0;
  bool variadic = false;
  List<int> opcodes = [];
  List<LuaValue> constants = [];
  List<LuaCompiledFunction> prototypes = [];
  List<FunctionContext> upvalueStacks = [];
  List<String> upvalues = [];

  late final List<VariableScope> scopes = [];
  final List<VariableScope> usedScopes = [];

  VariableScope get currentScope => scopes.last;

  final Map<int, String> _opcodeComments = {};
  final lineInfo = LineInfo();

  void addLineInfo(int line) {
    lineInfo.add(opcodes.length, line);
  }

  // increase when local variable is defined
  // check label forward jump
  int _localState = 0;

  int get localState => parent?._localState ?? _localState;

  void updateLocalState() {
    if (parent != null) {
      parent!.updateLocalState();
    } else {
      _localState++;
    }
  }

  int addConst(LuaValue value) {
    final index = constants.indexWhere((v) => v.luaEquals(value));
    if (index >= 0) {
      return index;
    }
    constants.add(value);
    return constants.length - 1;
  }

  void addUpvalue(String name) {
    if (!upvalues.contains(name)) {
      upvalues.add(name);
    }
  }

  int get opcodeIndex => opcodes.length - 1;

  int addOpcode(
    int op, {
    int? a,
    int? b,
    int? c,
    int? ax,
    int? sAx,
    int? bx,
    int? sBx,
    String? comment,
  }) {
    final bc = LuaOpcode.bytecode(op,
        a: a, b: b, c: c, ax: ax, sAx: sAx, bx: bx, sBx: sBx);
    opcodes.add(bc);

    if (comment != null) {
      _opcodeComments[opcodes.length - 1] = comment;
    }

    return opcodeIndex;
  }

  void replaceOpcode(
    int index, {
    required int op,
    int? a,
    int? b,
    int? c,
    int? ax,
    int? sAx,
    int? bx,
    int? sBx,
  }) {
    opcodes[index] = LuaOpcode.bytecode(
      op,
      a: a,
      b: b,
      c: c,
      ax: ax,
      sAx: sAx,
      bx: bx,
      sBx: sBx,
    );
  }

  void beginScope({bool loop = false}) {
    scopes.add(VariableScope(context: this, parent: scopes.last, loop: loop));
  }

  void endScope() {
    final scope = scopes.removeLast()..finish();
    usedScopes.add(scope);
  }

  List<ast.Node> nestedLoops = [];

  ast.Node? get currentLoop => nestedLoops.lastOrNull;

  Map<ast.Node, List<int>> breakPcMap = {};

  void beginLoop(ast.Node node) {
    beginScope(loop: true);
    nestedLoops.add(node);
  }

  void endLoop(int endPc) {
    endScope();

    final node = nestedLoops.removeLast();
    final breakPcs = breakPcMap[node] ?? [];
    for (final breakPc in breakPcs) {
      replaceOpcode(breakPc, op: LuaOpcode.JUMP, sBx: endPc - breakPc + 1);
    }
    breakPcMap.remove(node);
  }

  void addBreak(int breakPc) {
    final block = currentLoop;
    if (block == null) {
      throw LuaException(LuaExceptionType.compilerError, 'break outside loop');
    }
    breakPcMap.putIfAbsent(block, () => []).add(breakPc);
  }

  void finish() {
    for (final scope in usedScopes) {
      scope.resolveLabelJumps();
    }
  }

  void debugPrint() {
    DebugPrint.compiledFunction(
      code: this,
      name: name,
      firstLine: firstLine,
      lastLine: lastLine,
      arity: arity,
      variadic: variadic,
      method: isMethod,
      maxStackSize: stack.maxSize,
      opcodes: opcodes,
      constants: constants,
      locals: currentScope.localNames,
      upvalues: upvalues,
      protos: prototypes,
      innerLocals: currentScope.innerLocals,
      lineInfo: lineInfo,
      comments: _opcodeComments,
    );
  }
}

class FunctionCallContext {
  FunctionCallContext({
    this.savedReturns,
  });

  final int? savedReturns;
}

final class LocalVariable {
  LocalVariable(this.name, {required this.index});

  final String name;
  final int index;
  final List<String> attributes = [];

  @override
  String toString() {
    return '{$name, $index, $attributes}';
  }
}

final class LabelInfo {
  LabelInfo({
    required this.name,
    required this.pc,
    required this.localState,
  });

  final String name;
  final int pc;
  final int localState;
}

final class LabelJumpInfo {
  LabelJumpInfo({
    required this.pc,
    required this.label,
    required this.location,
    required this.localState,
  });

  final int pc;
  final String label;
  final ast.LuaLocation? location;
  final int localState;
}

final class VariableScope {
  VariableScope({required this.context, this.loop = false, this.parent});

  final VariableScope? parent;
  final FunctionContext context;
  final List<LocalVariable> locals = [];
  final bool loop;

  // number of local variables in used inner scope
  // keep stack spaces to avoid overwriting unexpected spaces
  int innerLocals = 0;

  List<LabelInfo> labelPcs = [];
  List<LabelJumpInfo> labelJumps = [];

  List<String> get localNames => locals.map((e) => e.name).toList();

  int get allLocals => (parent?.allLocals ?? 0) + locals.length + innerLocals;

  int get nextLocal => allLocals;

  int get level => parent != null ? parent!.level + 1 : 0;

  int _tempLocals = 0;

  int addLocal(String name) {
    final newLocal = LocalVariable(name, index: nextLocal);
    locals.add(newLocal);
    context.updateLocalState();
    return newLocal.index;
  }

  // create new internal local variable
  int addTemporaryLocal() {
    final name = '\$$_tempLocals';
    _tempLocals++;
    return addLocal(name);
  }

  int? findLocal(String name) {
    final local = locals.lastWhereOrNull((e) => e.name == name);
    if (local != null) {
      return local.index;
    } else {
      return parent?.findLocal(name);
    }
  }

  void setLocalAttr(String name, String attr) {
    final local = locals.lastWhere((e) => e.name == name);
    local.attributes.add(attr);
  }

  (int, int)? findUpValue(String name) {
    for (var i = 0; i < context.upvalueStacks.length; i++) {
      final stack = context.upvalueStacks[i];
      final index = stack.currentScope.findLocal(name);
      if (index != null) {
        return (i, index);
      }
    }
    return null;
  }

  void addLabel(int pc, String label) {
    labelPcs.add(LabelInfo(
      name: label,
      pc: pc,
      localState: context.localState,
    ));
  }

  void addLabelJump(int pc, String label, {required ast.LuaLocation location}) {
    labelJumps.add(LabelJumpInfo(
      pc: pc,
      label: label,
      location: location,
      localState: context.localState,
    ));
  }

  LabelInfo? findLabel(String name) {
    return labelPcs.firstWhereOrNull((info) => info.name == name) ??
        parent?.findLabel(name);
  }

  LabelJumpInfo? findLabelJump(String label) {
    return labelJumps.firstWhereOrNull((e) => e.label == label) ??
        parent?.findLabelJump(label);
  }

  void finish() {
    parent?.innerLocals += locals.length + innerLocals;
  }

  void resolveLabelJumps() {
    for (final source in labelJumps) {
      final destination = findLabel(source.label);
      if (destination == null) {
        throw LuaException.compilerError(
            location: source.location,
            message: "label '${source.label}' not defined");
      } else if (source.localState < destination.localState) {
        throw LuaException.compilerError(
            location: source.location,
            message: 'jumps into to different scope');
      } else {
        context.replaceOpcode(source.pc,
            op: LuaOpcode.JUMP, sBx: destination.pc - source.pc + 1);
      }
    }
  }
}

class Stack {
  int _index = -1;
  int maxSize = 0;

  int get index => _index;

  set index(int value) {
    _index = value;
    if (value > maxSize) {
      maxSize = value;
    }
  }

  int push() {
    index++;
    return _index;
  }

  void pop() {
    index--;
  }

  void pops(int n) {
    index -= n;
  }
}

final class LuaCompilerContext {
  LuaCompilerContext(this.path) {
    mainContext = FunctionContext(null);
  }

  String? path;
  late FunctionContext mainContext;
}

typedef LuaCompilerResult = Result<LuaCompiledCode, LuaException>;

class LuaCompiler {
  LuaCompiler({this.path});

  String? path;

  late LuaCompilerContext _context;

  LuaCompilerResult compileSource(String input) {
    final parser = LuaParser(path: path, input: input);
    final result = parser.parse();
    if (result.isSuccess()) {
      final chunk = result.getOrThrow();
      return compileChunk(chunk);
    } else {
      return Failure(result.exceptionOrNull()!);
    }
  }

  LuaCompilerResult compileChunk(ast.Chunk chunk) {
    _context = LuaCompilerContext(path);

    final funcContext = FunctionContext(null);
    final funcComp = LuaFunctionCompiler(_context, funcContext);
    try {
      funcComp.compile(chunk.block);
      funcContext.finish();
      final chunkCode = funcComp.generateCode();
      final code = LuaCompiledCode(path: path, chunk: chunkCode);
      return Success(code);
    } on LuaException catch (e) {
      return Failure(e);
    } on Exception {
      rethrow;
    }
  }
}

class LuaFunctionCompiler {
  LuaFunctionCompiler(this.compiler, this.context);

  LuaCompilerContext compiler;
  FunctionContext context;

  LuaCompiledFunction generateCode() {
    return LuaCompiledFunction(
      path: compiler.path,
      name: context.name,
      firstLine: context.firstLine,
      lastLine: context.lastLine,
      arity: context.arity,
      variadic: context.variadic,
      method: context.isMethod,
      locals:
          context.currentScope.locals.length + context.currentScope.innerLocals,
      upvalues: context.upvalues,
      opcodes: context.opcodes,
      constants: context.constants,
      prototypes: context.prototypes,
      lineInfo: context.lineInfo,
    );
  }

  void finish() {
    final lastOp = context.opcodes.lastOrNull;
    if (lastOp == null) {
      context.addOpcode(LuaOpcode.RETURN_NONE);
      return;
    }

    final op = LuaOpcode.getFields(lastOp).op;
    if (op != LuaOpcode.RETURN) {
      context.addOpcode(LuaOpcode.RETURN_NONE);
    }

    context.currentScope.finish();
  }

  void compile(ast.Block block) {
    _compileBlock(block);
    finish();

    //context.debugPrint();
  }

  void _compileNode(ast.Node node, {FunctionCallContext? callContext}) {
    context.addLineInfo(node.location.line);

    if (node is ast.Chunk) {
      throw UnreachableError();
    } else if (node is ast.Block) {
      _compileBlock(node);
    } else if (node is ast.Empty) {
      // do nothing
    } else if (node is ast.FunctionCallStat) {
      _compileFunctionCallStat(node);
    } else if (node is ast.Assignment) {
      _compileAssignment(node);
    } else if (node is ast.LocalAssignment) {
      _compileLocalAssignment(node);
    } else if (node is ast.If) {
      _compileIf(node);
    } else if (node is ast.While) {
      _compileWhile(node);
    } else if (node is ast.Break) {
      _compileBreak(node);
    } else if (node is ast.Goto) {
      _compileGoto(node);
    } else if (node is ast.Label) {
      _compileLabel(node);
    } else if (node is ast.Do) {
      _compileDo(node);
    } else if (node is ast.Repeat) {
      _compileRepeat(node);
    } else if (node is ast.NumericFor) {
      _compileNumericFor(node);
    } else if (node is ast.GenericFor) {
      _compileGenericFor(node);
    } else if (node is ast.FunctionDef) {
      _compileFunctionDef(node);
    } else if (node is ast.LocalFunctionDef) {
      _compileLocalFunctionDef(node);
    } else if (node is ast.PrimaryExp) {
      _compilePrimaryExp(node, callContext);
    } else if (node is ast.VarPath) {
      _compileVarPath(node);
    } else if (node is ast.Subscript) {
      _compileSubscript(node);
    } else if (node is ast.Name) {
      _compileName(node);
    } else if (node is ast.Args) {
      _compileArgs(node, callContext);
    } else if (node is ast.MethodCall) {
      _compileMethodCall(node, callContext);
    } else if (node is ast.UnExp) {
      _compileUnExp(node);
    } else if (node is ast.BinExp) {
      _compileBinExp(node);
    } else if (node is ast.LiteralNil) {
      _compileNil(node);
    } else if (node is ast.LiteralBoolean) {
      _compileBoolean(node);
    } else if (node is ast.LiteralInteger) {
      _compileInteger(node);
    } else if (node is ast.LiteralFloat) {
      _compileFloat(node);
    } else if (node is ast.LiteralString) {
      _compileString(node);
    } else if (node is ast.TableConstructor) {
      _compileTableConstructor(node);
    } else if (node is ast.VarArg) {
      _compileVarArg(node);
    } else {
      throw UnimplementedError('${node.runtimeType}');
    }
  }

  void _compileBlock(ast.Block node) {
    for (final stat in node.stats) {
      _compileNode(stat);
    }
    if (node.return_ != null) {
      _compileReturn(node.return_!);
    }
  }

  void _compileReturn(ast.Return node) {
    context.addOpcode(LuaOpcode.MARK_RETURN);

    final exps = node.expList ?? const [];
    for (final exp in exps) {
      _compileNode(exp);
    }

    context.addOpcode(LuaOpcode.RETURN);
  }

  void _compileFunctionCallStat(ast.FunctionCallStat node) {
    _compileNode(node.exp, callContext: FunctionCallContext(savedReturns: 0));
  }

  /* Lua Assignment Patterns:

1. Simple Variable:
Assigns a value to a general variable.
Example: x = 10

2. Table Access (Using Index):
Assigns a value to a specific key in a table.
Example: t[1] = "value"

3. Table Access (Using Dot Notation):
Assigns a value to a specific field of a table.
Example: t.field = "value"

4. Global Variable:
In the absence of a local variable declaration, the assignment is considered to be for a global variable.
Example: globalVar = "global"

5. Multiple Variable Assignment:
Lua supports assigning values to multiple variables in a single statement.
Example: x, y, z = 1, 2, 3
   */
  void _compileAssignment(ast.Assignment node) {
    for (final va in node.varList) {
      final primExp = va as ast.PrimaryExp;
      final primary = primExp.primary;

      if (primExp.suffixes.isEmpty) {
        if (primary is ast.Name) {
          final local = context.currentScope.findLocal(primary.name);
          if (local != null) {
            context
              ..addOpcode(LuaOpcode.LOAD_CONTEXT)
              ..addOpcode(LuaOpcode.LOAD_INT, sAx: local);
            continue;
          }

          final upvalue = context.currentScope.findUpValue(primary.name);
          if (upvalue != null) {
            context.addUpvalue(primary.name);
            final (stackIndex, localIndex) = upvalue;
            context
              ..addOpcode(LuaOpcode.LOAD_UPSTACK, ax: stackIndex)
              ..addOpcode(LuaOpcode.LOAD_INT, sAx: localIndex);
            continue;
          }

          final key = context.addConst(LuaString(primary.name));
          context
            ..addOpcode(LuaOpcode.LOAD_ENV)
            ..addOpcode(LuaOpcode.LOAD_CONST, ax: key);
        } else {
          throw LuaException(LuaExceptionType.fatalError, 'invalid assignment');
        }
      } else {
        _compileNode(primary,
            callContext: FunctionCallContext(savedReturns: 1));

        final suffixes = primExp.suffixes;
        for (var i = 0; i < suffixes.length; i++) {
          final suffix = suffixes[i];
          if (i + 1 == suffixes.length) {
            if (suffix is ast.Subscript) {
              _compileNode(suffix.index,
                  callContext: FunctionCallContext(savedReturns: 1));
            } else if (suffix is ast.VarPath) {
              final key = context.addConst(LuaString(suffix.name.name));
              context.addOpcode(LuaOpcode.LOAD_CONST, ax: key);
            } else {
              throw LuaException(LuaExceptionType.fatalError,
                  'invalid primary expression suffix ${suffix.runtimeType}');
            }
          } else {
            _compileNode(suffix,
                callContext: FunctionCallContext(savedReturns: 1));
          }
        }
      }
    }

    for (var i = 0; i < node.expList.length; i++) {
      final exp = node.expList[i];

      if (i + 1 == node.expList.length && ast.Node.isFunctionCall(exp)) {
        final diff = node.varList.length - node.expList.length;
        var savedReturns = 1;
        if (diff == 0) {
          savedReturns = 1;
        } else if (diff > 0) {
          savedReturns = 1 + diff;
        } else {
          savedReturns = 0;
        }

        _compileNode(exp,
            callContext: FunctionCallContext(savedReturns: savedReturns));

        for (var j = 0; j < savedReturns; j++) {
          context.addOpcode(
            LuaOpcode.ASSIGN_FIELD,
            ax: (j * 2) + savedReturns - j,
          );
        }
      } else {
        _compileNode(exp, callContext: FunctionCallContext(savedReturns: 1));
        if (i < node.varList.length) {
          context.addOpcode(
            LuaOpcode.ASSIGN_FIELD,
            ax: (node.varList.length - i) * 2 - 1,
          );
        } else {
          context.addOpcode(LuaOpcode.POP);
        }
      }
    }

    context.addOpcode(LuaOpcode.POPS, ax: node.varList.length * 2);
  }

  void _compileLocalAssignment(ast.LocalAssignment node) {
    final start = context.currentScope.nextLocal;
    final locals = node.attrNameList.length;

    final names = <String>[];
    for (final attrName in node.attrNameList) {
      names.add(attrName.name.name);
      context.currentScope.addLocal(attrName.name.name);
      if (attrName.attr != null) {
        context.currentScope
            .setLocalAttr(attrName.name.name, attrName.attr!.name);
      }
    }

    final expCount = node.expList.length;
    if (expCount > 0) {
      for (var i = 0; i < expCount; i++) {
        final exp = node.expList[i];
        if (i + 1 == expCount && ast.Node.isFunctionCall(exp)) {
          // last argument
          if (locals < expCount) {
            _compileNode(exp,
                callContext: FunctionCallContext(savedReturns: 0));
          } else if (locals == expCount) {
            _compileNode(exp,
                callContext: FunctionCallContext(savedReturns: 1));
            context.addOpcode(LuaOpcode.STORE_LOCAL,
                ax: start + i, comment: '"${names[i]}"');
          } else {
            final remains = locals - expCount + 1;
            _compileNode(exp,
                callContext: FunctionCallContext(savedReturns: remains));
            for (var j = remains; j > 0; j--) {
              final n = i - 1 + j;
              context.addOpcode(LuaOpcode.STORE_LOCAL,
                  ax: start + n, comment: '"${names[n]}"');
            }
          }
        } else if (i + 1 == expCount && exp is ast.VarArg) {
          final remains = locals - expCount + 1;
          for (var j = 0; j < remains; j++) {
            final n = i + j;
            context
              ..addOpcode(LuaOpcode.LOAD_VARARG)
              ..addOpcode(LuaOpcode.GET_INDEX, ax: j)
              ..addOpcode(LuaOpcode.STORE_LOCAL,
                  ax: start + n, comment: '"${names[n]}"');
          }
        } else {
          _compileNode(exp, callContext: FunctionCallContext(savedReturns: 1));
          if (i < locals) {
            context.addOpcode(LuaOpcode.STORE_LOCAL,
                ax: start + i, comment: '"${names[i]}"');
          } else {
            context.addOpcode(LuaOpcode.POP);
          }
        }
      }
    }
  }

  void _compileIf(ast.If node) {
    if (node.conditions.isEmpty) {
      throw LuaException.compilerError(
        location: node.location,
        message: 'if statement must have at least one condition',
      );
    }

    context.beginScope();

    final toEnd = <int>[];
    for (final condition in node.conditions) {
      _compileNode(condition.condition);
      final branch = context.addOpcode(LuaOpcode.NO_OP, comment: 'if');
      _compileBlock(condition.block);
      final end = context.addOpcode(LuaOpcode.NO_OP, comment: 'end if');
      toEnd.add(end);
      context.replaceOpcode(branch,
          op: LuaOpcode.BRANCH_FALSE_POP, sBx: end - branch + 1);
    }

    if (node.else_ != null) {
      _compileNode(node.else_!);
    }

    final end = context.opcodeIndex;
    for (final index in toEnd) {
      context.replaceOpcode(index, op: LuaOpcode.JUMP, sBx: end - index + 1);
    }

    context.endScope();
  }

  void _compileWhile(ast.While node) {
    context.beginLoop(node);

    final start = context.opcodeIndex;
    _compileNode(node.condition);
    final branch = context.addOpcode(LuaOpcode.NO_OP, comment: 'while');
    _compileBlock(node.block);
    context
      ..addOpcode(LuaOpcode.JUMP, sBx: start - context.opcodeIndex)
      ..replaceOpcode(branch,
          op: LuaOpcode.BRANCH_FALSE_POP, sBx: context.opcodeIndex - branch + 1)
      ..endLoop(context.opcodeIndex);
  }

  void _compileBreak(ast.Break node) {
    final breakPc = context.addOpcode(LuaOpcode.NO_OP, comment: 'break');
    context.addBreak(breakPc);
  }

  void _compileGoto(ast.Goto node) {
    context
      ..addOpcode(LuaOpcode.NO_OP, comment: 'goto ${node.label.name}')
      ..currentScope.addLabelJump(
        context.opcodeIndex,
        node.label.name,
        location: node.location,
      );
  }

  void _compileLabel(ast.Label node) {
    final name = node.name.name;
    if (context.currentScope.findLabel(name) != null) {
      throw LuaException.compilerError(
          location: node.location, message: "label '$name' already defined");
    }
    context.currentScope.addLabel(context.opcodeIndex, name);
  }

  void _compileDo(ast.Do node) {
    context.beginScope();
    _compileBlock(node.block);
    context.endScope();
  }

  void _compileRepeat(ast.Repeat node) {
    context.beginLoop(node);

    final start = context.opcodeIndex;
    _compileBlock(node.block);
    _compileNode(node.condition);
    context
      ..addOpcode(LuaOpcode.BRANCH_FALSE_POP, sBx: start - context.opcodeIndex)
      ..endLoop(context.opcodeIndex);
  }

  void _compileNumericFor(ast.NumericFor node) {
    // ```lua
    // do
    //   local var, limit, step = tonumber(e1), tonumber(e2), tonumber(e3)
    //   if not (var and limit and step) then error() end
    //   var = var - step
    //   while true do
    //     var = var + step
    //     if (step >= 0 and var > limit) or (step < 0 and var < limit) then
    //       break
    //     end
    //     local v = var
    //     block
    //   end
    // end

    context.beginLoop(node);

    // ```lua
    // local var, limit, step = tonumber(e1), tonumber(e2), tonumber(e3)
    // if not (var and limit and step) then error() end
    // ```
    final index = context.currentScope.addTemporaryLocal();
    final limit = context.currentScope.addTemporaryLocal();
    final step = context.currentScope.addTemporaryLocal();
    final current = context.currentScope.addLocal(node.name.name);

    _compileNode(node.start);
    context
      ..addOpcode(LuaOpcode.CHECK_NUMBER, comment: "'for' start")
      ..addOpcode(LuaOpcode.STORE_LOCAL, ax: index);
    _compileNode(node.end);
    context
      ..addOpcode(LuaOpcode.CHECK_NUMBER, comment: "'for' end")
      ..addOpcode(LuaOpcode.STORE_LOCAL, ax: limit);
    if (node.step != null) {
      _compileNode(node.step!);
      context
        ..addOpcode(LuaOpcode.CHECK_NUMBER, comment: "'for' step")
        ..addOpcode(LuaOpcode.STORE_LOCAL, ax: step);
    } else {
      context
        ..addOpcode(LuaOpcode.LOAD_INT, sAx: 1)
        ..addOpcode(LuaOpcode.STORE_LOCAL, ax: step);
    }

    // ```lua
    // var = var - step
    // ```
    context
      ..addOpcode(LuaOpcode.LOAD_LOCAL, ax: index)
      ..addOpcode(LuaOpcode.LOAD_LOCAL, ax: step)
      ..addOpcode(LuaOpcode.SUB)
      ..addOpcode(LuaOpcode.STORE_LOCAL, ax: index);

    // ```lua
    // var = var + step
    // if (step >= 0 and var > limit) or (step < 0 and var < limit) then
    //   break
    // end
    // ```
    final loopStart = context.opcodeIndex;
    context.addOpcode(LuaOpcode.FOR_STEP, a: index, b: limit, c: step);
    final toEnd = context.addOpcode(LuaOpcode.NO_OP, comment: 'end for');

    // ```lua
    // local v = var
    // block
    // ```
    context
      ..addOpcode(LuaOpcode.LOAD_LOCAL, ax: index)
      ..addOpcode(LuaOpcode.STORE_LOCAL, ax: current);
    _compileBlock(node.block);

    // reset locals inside loop
    for (final local in context.currentScope.locals) {
      if (local.index != index && local.index != limit && local.index != step) {
        context.addOpcode(LuaOpcode.RESET_LOCAL, ax: local.index);
      }
    }

    context.addOpcode(LuaOpcode.JUMP, sBx: loopStart - context.opcodeIndex);
    final loopEnd = context.opcodeIndex;
    context
      ..replaceOpcode(toEnd,
          op: LuaOpcode.BRANCH_FALSE_POP, sBx: loopEnd - toEnd + 1)
      ..endLoop(loopEnd);
  }

  void _compileGenericFor(ast.GenericFor node) {
    // ```lua
    // do
    //   local f, s, var = explist
    //   while true do
    //     local var_1, ···, var_n = f(s, var)
    //     if var_1 == nil then break end
    //     var = var_1
    //     block
    //   end
    // end
    // ```
    const iterComment = '<for> "f")';
    const stateComment = '<for> "s")';
    const previousComment = '<for> "var")';

    context.beginLoop(node);

    final iter = context.currentScope.addTemporaryLocal();
    final state = context.currentScope.addTemporaryLocal();
    final previous = context.currentScope.addTemporaryLocal();

    final vars = <int>[];
    for (final name in node.names) {
      vars.add(context.currentScope.addLocal(name.name));
    }

    final expCount = node.exps.length;
    for (var i = 0; i < expCount; i++) {
      final exp = node.exps[i];
      if (i + 1 == expCount) {
        _compileNode(exp,
            callContext: FunctionCallContext(savedReturns: 3 - i));
      } else {
        _compileNode(exp, callContext: FunctionCallContext(savedReturns: 1));
      }
    }
    context
      ..addOpcode(LuaOpcode.STORE_LOCAL, ax: previous, comment: previousComment)
      ..addOpcode(LuaOpcode.STORE_LOCAL, ax: state, comment: stateComment)
      ..addOpcode(LuaOpcode.STORE_LOCAL, ax: iter, comment: iterComment);

    final loopStart = context.opcodeIndex;
    context
      ..addOpcode(LuaOpcode.LOAD_LOCAL, ax: iter, comment: iterComment)
      ..addOpcode(LuaOpcode.MARK_ARG)
      ..addOpcode(LuaOpcode.LOAD_LOCAL, ax: state, comment: stateComment)
      ..addOpcode(LuaOpcode.LOAD_LOCAL, ax: previous, comment: previousComment)
      ..addOpcode(LuaOpcode.CALL, a: vars.length, comment: '<for> f(s, var)');
    for (var i = vars.length - 1; i >= 0; i--) {
      context.addOpcode(LuaOpcode.STORE_LOCAL,
          ax: vars[i], comment: '"${node.names[i].name}"');
    }

    context.addOpcode(LuaOpcode.LOAD_LOCAL,
        ax: vars[0], comment: '"${node.names[0].name}"');
    final toEnd = context.addOpcode(LuaOpcode.NO_OP, comment: '<for> break');

    context
      ..addOpcode(LuaOpcode.LOAD_LOCAL,
          ax: vars[0], comment: '"${node.names[0].name}"')
      ..addOpcode(LuaOpcode.STORE_LOCAL,
          ax: previous, comment: previousComment);
    _compileBlock(node.block);
    context.addOpcode(LuaOpcode.JUMP,
        sBx: loopStart - context.opcodeIndex, comment: '<for> continue');

    final loopEnd = context.opcodeIndex;
    context
      ..replaceOpcode(toEnd,
          op: LuaOpcode.BRANCH_NIL_POP, sBx: loopEnd - toEnd + 1)
      ..endLoop(loopEnd);
  }

  void _compileFunctionDef(ast.FunctionDef node) {
    final name = node.name;
    final body = node.body;
    _compileFunctionDefBase(
      isLocal: false,
      path: name?.path.map((e) => e.name).toList(),
      arity: body.paramList?.names.length ?? 0,
      method: name?.method?.name,
      firstLine: node.location.line,
      lastLine: node.location.line,
      body: body,
    );
  }

  void _compileLocalFunctionDef(ast.LocalFunctionDef node) {
    final name = node.name;
    final body = node.body;
    _compileFunctionDefBase(
      isLocal: true,
      path: [name.name],
      arity: body.paramList?.names.length ?? 0,
      method: null,
      firstLine: node.location.line,
      lastLine: node.location.line,
      body: body,
    );
  }

  void _compileFunctionDefBase({
    required bool isLocal,
    required List<String>? path,
    required int arity,
    required String? method,
    required int firstLine,
    required int lastLine,
    required ast.FuncBody body,
  }) {
    final isMethod = method != null;
    final lastName = path?.lastOrNull ?? '<anonymous>';
    final name = isMethod ? '$lastName:$method' : lastName;
    final arity = (body.paramList?.names.length ?? 0) + (isMethod ? 1 : 0);
    final newContext = FunctionContext(context)
      ..name = name
      ..isMethod = method != null
      ..firstLine = firstLine
      ..lastLine = lastLine
      ..arity = arity;

    if (isMethod) {
      // self (local 0)
      newContext.currentScope.addTemporaryLocal();
    }

    if (body.paramList != null) {
      for (final name in body.paramList!.names) {
        newContext.currentScope.addLocal(name.name);
      }

      // variable arguments
      newContext.variadic = body.paramList!.variadic;
    }

    // assign local function to local variable for recursive call
    int? funcLocal;
    if (isLocal) {
      funcLocal = context.currentScope.addLocal(path!.last);
    }

    // compile body
    final funcComp = LuaFunctionCompiler(compiler, newContext)
      ..compile(body.block);
    final funcCode = funcComp.generateCode();
    context.prototypes.add(funcCode);
    final funcIndex = context.prototypes.length - 1;

    // assigned destination
    if (isLocal) {
      context
        ..addOpcode(LuaOpcode.CLOSURE, ax: funcIndex)
        ..addOpcode(LuaOpcode.STORE_LOCAL, ax: funcLocal);
    } else if (path != null) {
      for (var i = 0; i < path.length; i++) {
        final pathComp = path[i];
        if (i == 0) {
          // first path component

          if (isMethod) {
            // load local variable to assign method
            final index = context.currentScope.findLocal(pathComp);
            if (index != null) {
              context.addOpcode(LuaOpcode.LOAD_LOCAL,
                  ax: index, comment: '"$pathComp"');
              continue;
            }

            // ..or upvalue
            final upvalue = context.currentScope.findUpValue(pathComp);
            if (upvalue != null) {
              final (stackIndex, localIndex) = upvalue;
              context.addOpcode(LuaOpcode.LOAD_UPVALUE,
                  a: stackIndex, bx: localIndex, comment: '"$pathComp"');
              continue;
            }

            // ..or global variable
            final nameIndex = context.addConst(LuaString(pathComp));
            context
              ..addOpcode(LuaOpcode.LOAD_ENV)
              ..addOpcode(LuaOpcode.LOAD_CONST, ax: nameIndex)
              ..addOpcode(LuaOpcode.GET_FIELD);
          } else if (path.length > 1) {
            // load global variable to assign function
            context.addOpcode(LuaOpcode.LOAD_ENV);
            final nameIndex = context.addConst(LuaString(pathComp));
            context
              ..addOpcode(LuaOpcode.LOAD_CONST, ax: nameIndex)
              ..addOpcode(LuaOpcode.GET_FIELD);
          } else {
            // load global environment to assign function
            final nameIndex = context.addConst(LuaString(pathComp));
            context
              ..addOpcode(LuaOpcode.LOAD_ENV)
              ..addOpcode(LuaOpcode.LOAD_CONST, ax: nameIndex);
          }
        } else {
          final nameIndex = context.addConst(LuaString(pathComp));
          context.addOpcode(LuaOpcode.LOAD_CONST, ax: nameIndex);
          if (i + 1 == path.length && method == null) {
            // do nothing
          } else {
            context.addOpcode(LuaOpcode.GET_FIELD);
          }
        }
      }

      if (isMethod) {
        final nameIndex = context.addConst(LuaString(method));
        context.addOpcode(LuaOpcode.LOAD_CONST, ax: nameIndex);
      }
      context
        ..addOpcode(LuaOpcode.CLOSURE, ax: funcIndex)
        ..addOpcode(LuaOpcode.SET_FIELD)
        ..addOpcode(LuaOpcode.POP);
    } else {
      context.addOpcode(LuaOpcode.CLOSURE, ax: funcIndex);
    }
  }

  void _compilePrimaryExp(
      ast.PrimaryExp node, FunctionCallContext? callContext) {
    /*
      Parser primaryExp() =>
      (ref0(name) | ref0(wrappedExp)) &
      (ref0(subscript) | ref0(varPath) | ref0(args) | ref0(methodCall)).star();
     */
    if (node.suffixes.isEmpty) {
      _compileNode(node.primary, callContext: callContext);
    } else {
      _compileNode(node.primary,
          callContext: FunctionCallContext(savedReturns: 1));

      for (var i = 0; i < node.suffixes.length; i++) {
        final suffix = node.suffixes[i];
        if (i + 1 < node.suffixes.length) {
          _compileNode(suffix,
              callContext: FunctionCallContext(savedReturns: 1));
        } else {
          _compileNode(suffix, callContext: callContext);
        }
      }
    }
  }

  void _compileVarPath(ast.VarPath node) {
    final nameIndex = context.addConst(LuaString(node.name.name));
    context
      ..addOpcode(LuaOpcode.LOAD_CONST, ax: nameIndex)
      ..addOpcode(LuaOpcode.GET_FIELD);
  }

  void _compileSubscript(ast.Subscript node) {
    _compileNode(node.index, callContext: FunctionCallContext(savedReturns: 1));
    context.addOpcode(LuaOpcode.GET_FIELD);
  }

  void _compileName(ast.Name name) {
    // self
    if (context.isMethod && name.name == 'self') {
      context.addOpcode(LuaOpcode.LOAD_SELF);
      return;
    }

    // local variable
    final index = context.currentScope.findLocal(name.name);
    if (index != null) {
      context.addOpcode(LuaOpcode.LOAD_LOCAL,
          ax: index, comment: '"${name.name}"');
      return;
    }

    // upvalue
    final upvalue = context.currentScope.findUpValue(name.name);
    if (upvalue != null) {
      context.addUpvalue(name.name);
      final (stackIndex, localIndex) = upvalue;
      context.addOpcode(LuaOpcode.LOAD_UPVALUE,
          a: stackIndex, bx: localIndex, comment: '"${name.name}"');
      return;
    }

    // global variable (_ENV)
    final nameIndex = context.addConst(LuaString(name.name));
    context.addOpcode(LuaOpcode.LOAD_GLOBAL, ax: nameIndex);
  }

  void _compileArgs(ast.Args node, FunctionCallContext? callContext,
      {bool mark = true}) {
    if (mark) {
      context.addOpcode(LuaOpcode.MARK_ARG);
    }

    for (final arg in node.args) {
      _compileNode(arg, callContext: FunctionCallContext(savedReturns: 1));
    }

    if (callContext?.savedReturns != null) {
      context.addOpcode(LuaOpcode.CALL, a: callContext!.savedReturns);
    } else {
      context.addOpcode(LuaOpcode.CALL_ALL_OUT);
    }
  }

  void _compileMethodCall(
      ast.MethodCall node, FunctionCallContext? callContext) {
    context.addOpcode(LuaOpcode.DUP);

    final nameIndex = context.addConst(LuaString(node.name.name));
    context
      ..addOpcode(LuaOpcode.LOAD_CONST, ax: nameIndex)
      ..addOpcode(LuaOpcode.GET_FIELD)
      ..addOpcode(LuaOpcode.SWAP)
      ..addOpcode(LuaOpcode.MARK_ARG)
      ..addOpcode(LuaOpcode.SWAP);

    _compileArgs(node.args, callContext, mark: false);
  }

  void _compileUnExp(ast.UnExp node) {
    _compileNode(node.exp);

    int op;
    switch (node.op) {
      case ast.UnOp.neg:
        op = LuaOpcode.NEG;
      case ast.UnOp.not:
        op = LuaOpcode.NOT;
      case ast.UnOp.len:
        op = LuaOpcode.LEN;
      case ast.UnOp.bnot:
        op = LuaOpcode.BNOT;
    }
    context.addOpcode(op);
  }

  void _compileBinExp(ast.BinExp node) {
    _compileNode(node.left);

    // short-circuit evaluation (and, or)
    if (node.op == ast.BinOp.and) {
      final branch = context.addOpcode(LuaOpcode.NO_OP, comment: 'and (left)');
      context.addOpcode(LuaOpcode.POP);
      _compileNode(node.right);
      final jump = context.addOpcode(LuaOpcode.NO_OP, comment: 'and (right)');
      context
        ..replaceOpcode(
          branch,
          op: LuaOpcode.BRANCH_FALSE,
          sBx: context.opcodeIndex - branch,
        )
        ..replaceOpcode(
          jump,
          op: LuaOpcode.JUMP,
          sBx: context.opcodeIndex - jump + 1,
        );
      return;
    } else if (node.op == ast.BinOp.or) {
      final branch = context.addOpcode(LuaOpcode.NO_OP, comment: 'or (left)');
      context.addOpcode(LuaOpcode.POP);
      _compileNode(node.right);
      final jump = context.addOpcode(LuaOpcode.NO_OP, comment: 'or (right)');
      context
        ..replaceOpcode(
          branch,
          op: LuaOpcode.BRANCH_TRUE,
          sBx: context.opcodeIndex - branch,
        )
        ..replaceOpcode(
          jump,
          op: LuaOpcode.JUMP,
          sBx: context.opcodeIndex - jump + 1,
        );
      return;
    }

    _compileNode(node.right);

    int op;
    switch (node.op) {
      case ast.BinOp.concat:
        op = LuaOpcode.CONCAT;
      case ast.BinOp.add:
        op = LuaOpcode.ADD;
      case ast.BinOp.sub:
        op = LuaOpcode.SUB;
      case ast.BinOp.mul:
        op = LuaOpcode.MUL;
      case ast.BinOp.div:
        op = LuaOpcode.DIV;
      case ast.BinOp.floorDiv:
        op = LuaOpcode.IDIV;
      case ast.BinOp.mod:
        op = LuaOpcode.MOD;
      case ast.BinOp.pow:
        op = LuaOpcode.POW;
      case ast.BinOp.band:
        op = LuaOpcode.BAND;
      case ast.BinOp.bor:
        op = LuaOpcode.BOR;
      case ast.BinOp.bxor:
        op = LuaOpcode.BXOR;
      case ast.BinOp.lshift:
        op = LuaOpcode.SHL;
      case ast.BinOp.rshift:
        op = LuaOpcode.SHR;
      case ast.BinOp.eq:
        op = LuaOpcode.EQ;
      case ast.BinOp.neq:
        op = LuaOpcode.NEQ;
      case ast.BinOp.lt:
        op = LuaOpcode.LT;
      case ast.BinOp.le:
        op = LuaOpcode.LE;
      case ast.BinOp.gt:
        op = LuaOpcode.GT;
      case ast.BinOp.ge:
        op = LuaOpcode.GE;
      default:
        throw UnimplementedError('compile bin op ${node.op}');
    }

    context.addOpcode(op);
  }

  void _compileNil(ast.LiteralNil node) {
    context.stack.push();

    context.addOpcode(LuaOpcode.LOAD_NIL);
  }

  void _compileBoolean(ast.LiteralBoolean node) {
    context.stack.push();

    if (node.value) {
      context.addOpcode(LuaOpcode.LOAD_TRUE);
    } else {
      context.addOpcode(LuaOpcode.LOAD_FALSE);
    }
  }

  void _compileInteger(ast.LiteralInteger node) {
    final n = NumberParser.parseInt64(node.value);
    if (n == null) {
      throw LuaException(LuaExceptionType.compilerError,
          "invalid integer literal '${node.value}'");
    }
    final primN = n.toInt();
    if (LuaOpcode.minSAx <= primN && primN <= LuaOpcode.maxSAx) {
      context.addOpcode(
        LuaOpcode.LOAD_INT,
        sAx: n.toInt(),
      );
    } else {
      _compileConst(LuaInteger(n));
    }
  }

  void _compileConst(LuaValue value, {String? comment}) {
    final constIndex = context.addConst(value);
    context.stack.push();
    context.addOpcode(
      LuaOpcode.LOAD_CONST,
      ax: constIndex,
      comment: comment,
    );
  }

  void _compileFloat(ast.LiteralFloat node) {
    final value = NumberParser.parseDouble(node.value)!;
    _compileConst(LuaFloat(value));
  }

  void _compileString(ast.LiteralString node) {
    final s = LiteralStringParser.parse(node.value).getOrThrow();
    _compileConst(LuaString(s));
  }

  void _compileTableConstructor(ast.TableConstructor node) {
    context.addOpcode(LuaOpcode.CREATE_TABLE);

    final callContext = FunctionCallContext(savedReturns: 1);
    if (node.fields != null) {
      for (final field in node.fields!) {
        final key = field.key;
        if (key != null) {
          if (key is ast.Name) {
            _compileConst(LuaString(key.name));
          } else {
            _compileNode(key, callContext: callContext);
          }
          _compileNode(field.value, callContext: callContext);
          context.addOpcode(LuaOpcode.SET_FIELD);
        } else {
          if (field.value is ast.VarArg) {
            context.addOpcode(LuaOpcode.ADD_VARARG);
          } else {
            _compileNode(field.value, callContext: callContext);
            context.addOpcode(LuaOpcode.ADD_FIELD);
          }
        }
      }
    }
  }

  void _compileVarArg(ast.VarArg node) {
    if (!context.variadic) {
      throw LuaException(LuaExceptionType.runtimeError,
          "cannot use '...' outside a vararg function");
    }
    context.addOpcode(LuaOpcode.LOAD_VARARG_ITEMS);
  }
}
