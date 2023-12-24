import 'package:petitparser/debug.dart';
import 'package:petitparser/petitparser.dart';
import 'package:result_dart/result_dart.dart' as r;
import 'package:tradaul/src/parser/ast.dart';
import 'package:tradaul/src/parser/grammar.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

// ignore_for_file: argument_type_not_assignable
// ignore_for_file: for_in_of_invalid_type
// ignore_for_file: non_bool_condition
// ignore_for_file: avoid_dynamic_calls

typedef LuaParserResult = r.Result<Chunk, LuaException>;

class LuaParser {
  LuaParser({required this.input, this.path}) {
    _grammarDefinition = LuaGrammarDefinition();
    _parserDefinition = LuaParserDefinition();
    _grammar = _grammarDefinition.build();
    _parser = _parserDefinition.build();
  }

  final String? path;
  final String input;
  late final LuaGrammarDefinition _grammarDefinition;
  late final LuaParserDefinition _parserDefinition;
  late final Parser _grammar;
  late final Parser _parser;

  LuaParserResult parse({bool checkOnly = false, bool debug = false}) {
    final parser = checkOnly ? _grammar : _parser;
    try {
      final result = (debug ? trace(parser) : parser).parse(input);
      if (result.isSuccess) {
        return r.Success(result.value);
      } else {
        return r.Failure(
          LuaException.parserError(
            message: result.message,
            location: LuaLocation.parse(input, result.position),
          ),
        );
      }
    } on LuaException catch (e) {
      return r.Failure(e);
    } on Exception catch (e) {
      return r.Failure(LuaException.wrap(e));
    }
  }
}

class LuaParserDefinition extends LuaGrammarDefinition {
  List<T> _castListOpt<T>(dynamic values) => values != null
      ? (values.isEmpty ? <T>[] : values.cast<T>() as List<T>)
      : <T>[];

  T? _castOpt<T>(dynamic value) => value != null ? value as T : null;

  @override
  Parser start() => super.start().map((values) => values[2]);

  @override
  Parser chunk() => super.chunk().map((block) {
        return Chunk(location: block.location, block: block);
      });

  @override
  Parser block() => super.block().map((values) {
        final stats = _castListOpt<Node>(values[1]);
        final retStat = _castOpt<Return>(values[2]);
        var location = LuaLocation.empty;
        if (stats.isNotEmpty) {
          location = stats[0].location;
        } else if (retStat != null) {
          location = retStat.location;
        }
        return Block(location: location, stats: stats, return_: retStat);
      });

  @override
  Parser emptyStat() => super.emptyStat().map((token) {
        return Empty(location: LuaLocation.fromToken(token));
      });

  @override
  Parser assignStat() => super.assignStat().map((values) {
        final varList = _castListOpt<Node>(values[0]);
        final expList = _castListOpt<Node>(values[2]);
        final location = varList[0].location;
        return Assignment(
          location: location,
          varList: varList,
          expList: expList,
        );
      });

  @override
  Parser localAssignStat() => super.localAssignStat().map((values) {
        final token = values[0] as Token;
        final names = _castListOpt<AttrName>(values[1]);
        var exps = <Node>[];
        if (values[2] != null) {
          exps = _castListOpt<Node>(values[2][1]);
        }
        return LocalAssignment(
          location: LuaLocation.fromToken(token),
          attrNameList: names,
          expList: exps,
        );
      });

  @override
  Parser attrNameList() => super.attrNameList().map((sepList) {
        return sepList.elements;
      });

  @override
  Parser attrName() => super.attrName().map((values) {
        final name = values[0] as Name;
        final attr = _castOpt<Name>(values[1]);
        return AttrName(location: name.location, name: name, attr: attr);
      });

  @override
  Parser attr() => super.attr().map((values) => values[1]);

  @override
  Parser nameList() => super.nameList().map((sepList) => sepList.elements);

  @override
  Parser labelStat() => super.labelStat().map((values) {
        final token = values[0] as Token;
        final name = values[1] as Name;
        return Label(location: LuaLocation.fromToken(token), name: name);
      });

  @override
  Parser breakStat() => super.breakStat().map((value) {
        final token = value as Token;
        return Break(location: LuaLocation.fromToken(token));
      });

  @override
  Parser gotoStat() => super.gotoStat().map((values) {
        final token = values[0] as Token;
        final label = values[1] as Name;
        return Goto(location: LuaLocation.fromToken(token), label: label);
      });

  @override
  Parser doStat() => super.doStat().map((values) {
        final token = values[0] as Token;
        final block = values[1] as Block;
        return Do(location: LuaLocation.fromToken(token), block: block);
      });

  @override
  Parser whileStat() => super.whileStat().map((values) {
        final token = values[0] as Token;
        final exp = values[1] as Node;
        final block = values[3] as Block;
        return While(
          location: LuaLocation.fromToken(token),
          condition: exp,
          block: block,
        );
      });

  @override
  Parser repeatStat() => super.repeatStat().map((values) {
        final token = values[0] as Token;
        final block = values[1] as Block;
        final exp = values[3] as Node;
        return Repeat(
          location: LuaLocation.fromToken(token),
          block: block,
          condition: exp,
        );
      });

  @override
  Parser forStat() => super.forStat().map((values) {
        final token = values[0] as Token;
        final name = values[1] as Name;
        final start = values[3] as Node;
        final end = values[5] as Node;
        final step = _castOpt<Node>(values[6]);
        final block = values[8] as Block;
        return NumericFor(
          location: LuaLocation.fromToken(token),
          name: name,
          start: start,
          end: end,
          step: step,
          block: block,
        );
      });

  @override
  Parser forStep() => super.forStep().map((values) => values[1]);

  @override
  Parser forInStat() => super.forInStat().map((values) {
        final token = values[0] as Token;
        final names = _castListOpt<Name>(values[1]);
        final exps = _castListOpt<Node>(values[3]);
        final block = values[5] as Block;
        return GenericFor(
          location: LuaLocation.fromToken(token),
          names: names,
          exps: exps,
          block: block,
        );
      });

  @override
  Parser ifStat() => super.ifStat().map((values) {
        final token = values[0] as Token;
        final exp = values[1] as Node;
        final block = values[3] as Block;
        final elseIfs = _castListOpt<IfCondition>(values[4]);
        final else_ = _castOpt<Node>(values[5]);
        final conditions = [
          IfCondition(
            location: LuaLocation.fromToken(token),
            condition: exp,
            block: block,
          ),
        ];
        conditions.addAll(elseIfs);
        return If(
          location: LuaLocation.fromToken(token),
          conditions: conditions,
          else_: else_,
        );
      });

  @override
  Parser ifElseIf() => super.ifElseIf().map((values) {
        final token = values[0] as Token;
        final exp = values[1] as Node;
        final block = values[3] as Block;
        return IfCondition(
          location: LuaLocation.fromToken(token),
          condition: exp,
          block: block,
        );
      });

  @override
  Parser ifElse() => super.ifElse().map((values) => values[1]);

  @override
  Parser returnStat() => super.returnStat().map((values) {
        final token = values[0] as Token;
        final exps = _castListOpt<Node>(values[1]);
        return Return(location: LuaLocation.fromToken(token), expList: exps);
      });

  @override
  Parser functionStat() => super.functionStat().map((values) {
        final token = values[0] as Token;
        final funcName = values[1] as FuncName;
        final funcBody = values[2] as FuncBody;
        return FunctionDef(
          location: LuaLocation.fromToken(token),
          name: funcName,
          body: funcBody,
        );
      });

  @override
  Parser localFunctionStat() => super.localFunctionStat().map((values) {
        final token = values[0] as Token;
        final name = values[2] as Name;
        final funcBody = values[3] as FuncBody;
        return LocalFunctionDef(
          location: LuaLocation.fromToken(token),
          name: name,
          body: funcBody,
        );
      });

  @override
  Parser functionDef() => super.functionDef().map((values) {
        final token = values[0] as Token;
        final funcBody = values[1] as FuncBody;
        return FunctionDef(
          location: LuaLocation.fromToken(token),
          body: funcBody,
        );
      });

  @override
  Parser funcNameBase() =>
      super.funcNameBase().map((seplist) => seplist.elements);

  @override
  Parser funcNameSuffix() => super.funcNameSuffix().map((values) => values[1]);

  @override
  Parser funcName() => super.funcName().map((values) {
        final path = _castListOpt<Name>(values[0]);
        final method = _castOpt<Name>(values[1]);
        return FuncName(
          location: path.first.location,
          path: path,
          method: method,
        );
      });

  @override
  Parser funcBody() => super.funcBody().map((values) {
        final token = values[0] as Token;
        final paramList = _castOpt<ParamList>(values[1]);
        final block = values[3] as Block;
        return FuncBody(
          location: LuaLocation.fromToken(token),
          paramList: paramList,
          block: block,
        );
      });

  @override
  Parser varParamList() => super.varParamList().map(
        (value) =>
            ParamList(location: value.location, names: [], variadic: true),
      );

  @override
  Parser namedParamList() => super.namedParamList().map((values) {
        final names = _castListOpt<Name>(values[0]);
        final variadic = values[1] != null;
        return ParamList(
          location: names[0].location,
          names: names,
          variadic: variadic,
        );
      });

  @override
  Parser primaryExp() => super.primaryExp().map((values) {
        final primary = values[0] as Node;
        final suffixes = _castListOpt<Node>(values[1]);
        return PrimaryExp(
          location: primary.location,
          primary: primary,
          suffixes: suffixes,
        );
      });

  @override
  Parser wrappedExp() => super.wrappedExp().map((values) => values[1] as Node);

  @override
  Parser expArgs() => super.expArgs().map((values) {
        final token = values[0] as Token;
        final exps = _castListOpt<Node>(values[1]);
        return Args(location: LuaLocation.fromToken(token), args: exps);
      });

  @override
  Parser singleArg() => super.singleArg().map((value) {
        final exp = value as Node;
        return Args(location: exp.location, args: [exp]);
      });

  @override
  Parser expList() => super.expList().map((sepList) => sepList.elements);

  Node _buildBinExpLeft(dynamic values) {
    final valuesList = _castListOpt<dynamic>(values);

    var left = valuesList.first as Node;
    final rightList = _castListOpt<dynamic>(values[1]);
    for (var i = 0; i < rightList.length; i++) {
      final pair = _castListOpt<dynamic>(rightList[i]);
      final token = pair[0] as Token;
      final op = _parseBinOp(token);
      final right = pair[1] as Node;
      left = BinExp(
        location: left.location,
        op: op,
        left: left,
        right: right,
      );
    }
    return left;
  }

  Node _buildBinExpRight(dynamic values) {
    final left = values[0] as Node;
    final pair = _castListOpt<dynamic>(values[1]);
    if (pair.isEmpty) {
      return left;
    }
    final token = pair[0] as Token;
    final op = _parseBinOp(token);
    final right = pair[1] as Node;
    return BinExp(location: left.location, op: op, left: left, right: right);
  }

  @override
  Parser logicalOrExp() => super.logicalOrExp().map(_buildBinExpLeft);

  @override
  Parser logicalAndExp() => super.logicalAndExp().map(_buildBinExpLeft);

  @override
  Parser bitwiseOrExp() => super.bitwiseOrExp().map(_buildBinExpLeft);

  @override
  Parser bitwiseXorExp() => super.bitwiseXorExp().map(_buildBinExpLeft);

  @override
  Parser bitwiseAndExp() => super.bitwiseAndExp().map(_buildBinExpLeft);

  @override
  Parser relationalExp() => super.relationalExp().map(_buildBinExpLeft);

  @override
  Parser shiftExp() => super.shiftExp().map(_buildBinExpLeft);

  @override
  Parser concatenationExp() => super.concatenationExp().map(_buildBinExpRight);

  @override
  Parser additiveExp() => super.additiveExp().map(_buildBinExpLeft);

  @override
  Parser multiplicativeExp() => super.multiplicativeExp().map(_buildBinExpLeft);

  @override
  Parser unaryExp() => super.unaryExp().map((values) {
        final unOps = _castListOpt<Token<dynamic>>(values[0]).reversed.toList();
        var exp = values[1] as Node;
        if (unOps.isEmpty) {
          return exp;
        }

        for (final token in unOps) {
          final op = _parseUnOp(token);
          final location = LuaLocation.fromToken(token);
          exp = UnExp(location: location, op: op, exp: exp);
        }

        return exp;
      });

  @override
  Parser powerExp() => super.powerExp().map(_buildBinExpRight);

  @override
  Parser varArg() => super.varArg().map((token) {
        return VarArg(location: LuaLocation.fromToken(token));
      });

  UnOp _parseUnOp(Token<dynamic> op) {
    switch (op.input) {
      case '-':
        return UnOp.neg;
      case 'not':
        return UnOp.not;
      case '#':
        return UnOp.len;
      case '~':
        return UnOp.bnot;
      default:
        throw LuaException.parserError(
          message: "invalid unary operator '${op.input}'",
          location: LuaLocation.fromToken(op),
        );
    }
  }

  BinOp _parseBinOp(Token<dynamic> op) {
    switch (op.input) {
      case '+':
        return BinOp.add;
      case '-':
        return BinOp.sub;
      case '*':
        return BinOp.mul;
      case '/':
        return BinOp.div;
      case '//':
        return BinOp.floorDiv;
      case '^':
        return BinOp.pow;
      case '%':
        return BinOp.mod;
      case '&':
        return BinOp.band;
      case '~':
        return BinOp.bxor;
      case '|':
        return BinOp.bor;
      case '>>':
        return BinOp.rshift;
      case '<<':
        return BinOp.lshift;
      case '..':
        return BinOp.concat;
      case '<':
        return BinOp.lt;
      case '<=':
        return BinOp.le;
      case '>':
        return BinOp.gt;
      case '>=':
        return BinOp.ge;
      case '==':
        return BinOp.eq;
      case '~=':
        return BinOp.neq;
      case 'and':
        return BinOp.and;
      case 'or':
        return BinOp.or;
      default:
        throw LuaException.parserError(
          message: "invalid binary operator '${op.input}'",
          location: LuaLocation.fromToken(op),
        );
    }
  }

  @override
  Parser varList() =>
      super.varList().map((sepList) => sepList.elements.cast<Node>());

  @override
  Parser varPath() => super
      .varPath()
      .map((values) => VarPath(location: values[1].location, name: values[1]));

  @override
  Parser subscript() => super.subscript().map(
        (values) => Subscript(location: values[1].location, index: values[1]),
      );

  @override
  Parser methodCall() => super.methodCall().map(
        (values) => MethodCall(
          location: values[1].location,
          name: values[1],
          args: values[2],
        ),
      );

  @override
  Parser functionCallStat() => super.functionCallStat().map((value) {
        final node = value as Node;
        return FunctionCallStat(location: node.location, exp: node);
      });

  @override
  Parser literalNil() => super
      .literalNil()
      .token()
      .map((token) => LiteralNil(location: LuaLocation.fromToken(token)));

  @override
  Parser literalTrue() => super.literalTrue().token().map(
        (token) =>
            LiteralBoolean(location: LuaLocation.fromToken(token), value: true),
      );

  @override
  Parser literalFalse() => super.literalFalse().token().map(
        (token) => LiteralBoolean(
          location: LuaLocation.fromToken(token),
          value: false,
        ),
      );

  @override
  Parser literalString() => super.literalString().token().map(
        (token) => LiteralString(
          location: LuaLocation.fromToken(token),
          value: token.input,
        ),
      );

  @override
  Parser invalidLongLiteralString() =>
      super.invalidLongLiteralString().map((values) {
        final longBracket = values[0];
        throw LuaException.parserError(
          message:
              'unfinished long string (starting at line ${longBracket.line})',
          location: LuaLocation.fromToken(longBracket),
        );
      });

  @override
  Parser decimalInteger() => super.decimalInteger().token().map(
        (token) => LiteralInteger(
          location: LuaLocation.fromToken(token),
          value: token.input.trim(),
        ),
      );

  @override
  Parser hexdecimalInteger() => super.hexdecimalInteger().token().map(
        (token) => LiteralInteger(
          location: LuaLocation.fromToken(token),
          value: token.input.trim(),
        ),
      );

  @override
  Parser decimalFloat() => super.decimalFloat().token().map(
        (token) => LiteralFloat(
          location: LuaLocation.fromToken(token),
          value: token.input.trim(),
        ),
      );

  @override
  Parser hexdecimalFloat() => super.hexdecimalFloat().token().map(
        (token) => LiteralFloat(
          location: LuaLocation.fromToken(token),
          value: token.input.trim(),
        ),
      );

  @override
  Parser tableConstructor() => super.tableConstructor().map((values) {
        final location = LuaLocation.fromToken(values[0]);
        final fields = _castListOpt<Field>(values[1]);
        return TableConstructor(location: location, fields: fields);
      });

  @override
  Parser fieldList() => super.fieldList().map((values) {
        final fields = [values[0] as Field];
        for (final next in values[1]) {
          fields.add(next[1] as Field);
        }
        return fields;
      });

  @override
  Parser indexedField() => super.indexedField().map((values) {
        final open = values[0] as Token;
        final key = values[1] as Node;
        final value = values[4] as Node;
        return Field(
          location: LuaLocation.fromToken(open),
          key: key,
          value: value,
        );
      });

  @override
  Parser namedField() => super.namedField().map((values) {
        final name = values[0] as Name;
        final value = values[2] as Node;
        return Field(location: name.location, key: name, value: value);
      });

  @override
  Parser valueField() => super.valueField().map((value) {
        return Field(location: value.location, value: value);
      });

  @override
  Parser name() => super.name().map(
        (token) =>
            Name(location: LuaLocation.fromToken(token), name: token.input),
      );

  @override
  Parser invalidLongComment() => super.invalidLongComment().map((values) {
        final longBracket = values[0];
        throw LuaException.parserError(
          message:
              'unfinished long comment (starting at line ${longBracket.line})',
          location: LuaLocation.fromToken(longBracket),
        );
      });
}
