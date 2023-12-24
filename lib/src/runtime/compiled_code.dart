import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

final class LineInfo {
  final List<MapEntry<int, int>> _pcs = [];

  int? find(int pc) {
    for (final entry in _pcs.reversed) {
      if (entry.key <= pc) {
        return entry.value;
      }
    }
    return null;
  }

  void add(int programCounter, int lineNumber) {
    _pcs
      ..add(MapEntry(programCounter, lineNumber))
      ..sort((a, b) => a.key.compareTo(b.key));
  }
}

final class LuaCompiledCode {
  const LuaCompiledCode({
    required this.chunk,
    this.path,
    this.environment,
  });

  final String? path;
  final LuaCompiledFunction chunk;
  final LuaTable? environment;

  LuaValue toLuaValue() => LuaCustomValue(this, type: LuaValueType.string);
}

class LuaCompiledFunction {
  LuaCompiledFunction({
    required this.arity,
    required this.variadic,
    required this.method,
    required this.locals,
    required this.upvalues,
    required this.opcodes,
    required this.constants,
    required this.prototypes,
    this.path,
    this.name,
    this.firstLine,
    this.lastLine,
    this.lineInfo,
  });

  final String? path;
  final String? name;
  final int? firstLine;
  final int? lastLine;
  final int arity;
  final bool variadic;
  final bool method;
  final int locals;
  final List<String> upvalues;
  final List<int> opcodes;
  final List<LuaValue> constants;
  final List<LuaCompiledFunction> prototypes;
  final LineInfo? lineInfo;
}
