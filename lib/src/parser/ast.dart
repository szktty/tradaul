import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:petitparser/core.dart';
import 'package:tradaul/src/compiler/string_parser.dart';

part 'ast.freezed.dart';

// ignore_for_file: require_trailing_commas
// ignore_for_file: prefer_constructors_over_static_methods

@freezed
class LuaLocation with _$LuaLocation {
  const factory LuaLocation(int line, int column) = _LuaLocation;

  static LuaLocation empty = const LuaLocation(0, 0);

  static LuaLocation fromToken(Token<dynamic> token) {
    return LuaLocation(token.line, token.column);
  }

  static LuaLocation parse(String string, int offset) {
    final substring = string.substring(0, offset);
    final lines = substring.split(RegExp(r'\r\n|\r|\n'));
    final line = lines.length;
    final column = lines.last.length + 1;
    return LuaLocation(line, column);
  }
}

extension LuaLocationExtension on LuaLocation {
  String toDisplayString() {
    return 'line $line, column $column';
  }
}

abstract class Node {
  LuaLocation get location;

  static bool isFunctionCall(Node node) {
    if (node is FunctionCallStat) {
      return true;
    } else if (node is PrimaryExp) {
      return node.isLastFunctionCall;
    } else {
      return false;
    }
  }
}

@freezed
class Chunk with _$Chunk implements Node {
  const factory Chunk({required LuaLocation location, required Block block}) =
      _Chunk;
}

@freezed
class Block with _$Block implements Node {
  const factory Block(
      {required LuaLocation location,
      required List<Node> stats,
      Return? return_}) = _Block;
}

@freezed
class Empty with _$Empty implements Node {
  const factory Empty({required LuaLocation location}) = _Empty;
}

@freezed
class FunctionCallStat with _$FunctionCallStat implements Node {
  const factory FunctionCallStat({
    required LuaLocation location,
    required Node exp,
  }) = _FunctionCallStat;
}

@freezed
class Assignment with _$Assignment implements Node {
  const factory Assignment(
      {required LuaLocation location,
      required List<Node> varList,
      required List<Node> expList}) = _Assignment;
}

@freezed
class LocalAssignment with _$LocalAssignment implements Node {
  const factory LocalAssignment(
      {required LuaLocation location,
      required List<AttrName> attrNameList,
      required List<Node> expList}) = _LocalAssignment;
}

@freezed
class AttrName with _$AttrName implements Node {
  const factory AttrName({
    required LuaLocation location,
    required Name name,
    Name? attr,
  }) = _AttrName;
}

@freezed
class NumericFor with _$NumericFor implements Node {
  const factory NumericFor(
      {required LuaLocation location,
      required Name name,
      required Node start,
      required Node end,
      required Block block,
      Node? step}) = _NumericFor;
}

@freezed
class GenericFor with _$GenericFor implements Node {
  const factory GenericFor(
      {required LuaLocation location,
      required List<Name> names,
      required List<Node> exps,
      required Block block}) = _GenericFor;
}

@freezed
class BinExp with _$BinExp implements Node {
  const factory BinExp(
      {required LuaLocation location,
      required Node left,
      required BinOp op,
      required Node right}) = _BinExp;
}

@freezed
class UnExp with _$UnExp implements Node {
  const factory UnExp(
      {required LuaLocation location,
      required UnOp op,
      required Node exp}) = _UnExp;
}

@freezed
class Label with _$Label implements Node {
  const factory Label({required LuaLocation location, required Name name}) =
      _Label;
}

@freezed
class Break with _$Break implements Node {
  const factory Break({required LuaLocation location}) = _Break;
}

@freezed
class Goto with _$Goto implements Node {
  const factory Goto({required LuaLocation location, required Name label}) =
      _Goto;
}

@freezed
class Do with _$Do implements Node {
  const factory Do({required LuaLocation location, required Block block}) = _Do;
}

@freezed
class While with _$While implements Node {
  const factory While(
      {required LuaLocation location,
      required Node condition,
      required Block block}) = _While;
}

@freezed
class Repeat with _$Repeat implements Node {
  const factory Repeat(
      {required LuaLocation location,
      required Block block,
      required Node condition}) = _Repeat;
}

@freezed
class If with _$If implements Node {
  const factory If({
    required LuaLocation location,
    required List<IfCondition> conditions,
    Node? else_,
  }) = _If;
}

@freezed
class IfCondition with _$IfCondition implements Node {
  const factory IfCondition(
      {required LuaLocation location,
      required Node condition,
      required Block block}) = _IfCondition;
}

@freezed
class LiteralNil with _$LiteralNil implements Node {
  const factory LiteralNil({required LuaLocation location}) = _LiteralNil;
}

@freezed
class LiteralString with _$LiteralString implements Node {
  const factory LiteralString(
      {required LuaLocation location, required String value}) = _LiteralString;
}

extension LiteralStringExtension on LiteralString {
  String parse() {
    return LiteralStringParser.parse(value).getOrThrow();
  }
}

@freezed
class LiteralBoolean with _$LiteralBoolean implements Node {
  const factory LiteralBoolean(
      {required LuaLocation location, required bool value}) = _LiteralBoolean;
}

@freezed
class LiteralInteger with _$LiteralInteger implements Node {
  const factory LiteralInteger(
      {required LuaLocation location, required String value}) = _LiteralInteger;
}

@freezed
class LiteralFloat with _$LiteralFloat implements Node {
  const factory LiteralFloat(
      {required LuaLocation location, required String value}) = _LiteralFloat;
}

@freezed
class PrimaryExp with _$PrimaryExp implements Node {
  const factory PrimaryExp(
      {required LuaLocation location,
      required Node primary,
      required List<Node> suffixes}) = _PrimaryExp;
}

extension PrimaryExpExtension on PrimaryExp {
  bool get isLastFunctionCall {
    final last = suffixes.lastOrNull;
    if (last != null) {
      return last is Args;
    } else {
      return false;
    }
  }
}

@freezed
class Subscript with _$Subscript implements Node {
  const factory Subscript(
      {required LuaLocation location, required Node index}) = _Subscript;
}

@freezed
class VarList with _$VarList implements Node {
  const factory VarList(
      {required LuaLocation location, required List<Var> vars}) = _VarList;
}

@freezed
class Var with _$Var implements Node {
  const factory Var({required LuaLocation location, required Name name}) = _Var;
}

@freezed
class VarPath with _$VarPath implements Node {
  const factory VarPath({required LuaLocation location, required Name name}) =
      _VarPath;
}

@freezed
class MethodCall with _$MethodCall implements Node {
  const factory MethodCall({
    required LuaLocation location,
    required Name name,
    required Args args,
  }) = _MethodCall;
}

@freezed
class Name with _$Name implements Node {
  const factory Name({required LuaLocation location, required String name}) =
      _Name;
}

@freezed
class Args with _$Args implements Node {
  const factory Args(
      {required LuaLocation location, required List<Node> args}) = _Args;
}

@freezed
class VarArg with _$VarArg implements Node {
  const factory VarArg({required LuaLocation location}) = _VarArg;
}

@freezed
class TableConstructor with _$TableConstructor implements Node {
  const factory TableConstructor(
      {required LuaLocation location, List<Field>? fields}) = _TableConstructor;
}

@freezed
class Field with _$Field implements Node {
  const factory Field(
      {required LuaLocation location, required Node value, Node? key}) = _Field;
}

@freezed
class FunctionDef with _$FunctionDef implements Node {
  const factory FunctionDef({
    required LuaLocation location,
    required FuncBody body,
    FuncName? name,
  }) = _FunctionDef;
}

@freezed
class FuncName with _$FuncName implements Node {
  const factory FuncName(
      {required LuaLocation location,
      required List<Name> path,
      required Name? method}) = _FuncName;
}

@freezed
class LocalFunctionDef with _$LocalFunctionDef implements Node {
  const factory LocalFunctionDef(
      {required LuaLocation location,
      required Name name,
      required FuncBody body}) = _LocalFunctionDef;
}

@freezed
class FuncBody with _$FuncBody implements Node {
  const factory FuncBody(
      {required LuaLocation location,
      required ParamList? paramList,
      required Block block}) = _FuncBody;
}

@freezed
class ParamList with _$ParamList implements Node {
  const factory ParamList(
      {required LuaLocation location,
      required List<Name> names,
      required bool variadic}) = _ParamList;
}

enum BinOp {
  add,
  sub,
  mul,
  div,
  floorDiv,
  pow,
  mod,
  band,
  bnot,
  bor,
  bxor,
  rshift,
  lshift,
  concat,
  lt,
  le,
  gt,
  ge,
  eq,
  neq,
  and,
  or
}

enum UnOp { neg, not, len, bnot }

@freezed
class Return with _$Return implements Node {
  const factory Return({required LuaLocation location, List<Node>? expList}) =
      _Return;
}
