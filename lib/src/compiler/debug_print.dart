import 'package:tradaul/src/runtime/compiled_code.dart';
import 'package:tradaul/src/runtime/lua_system/lua_system.dart';
import 'package:tradaul/src/runtime/lua_values.dart';
import 'package:tradaul/src/runtime/opcodes.dart';

abstract class DebugPrint {
  static void compiledFunction({
    required dynamic code,
    String? name,
    int? firstLine,
    int? lastLine,
    int arity = 0,
    bool variadic = false,
    bool method = false,
    int maxStackSize = 0,
    List<int> opcodes = const [],
    List<LuaValue> constants = const [],
    List<String> locals = const [],
    int innerLocals = 0,
    List<String> upvalues = const [],
    List<LuaCompiledFunction> protos = const [],
    LineInfo? lineInfo,
    Map<int, String>? comments,
  }) {
    final system = LuaSystem.shared;

    final hashCode = code.hashCode;
    system
      ..writeLine(
        '${method ? 'method' : 'function'} $name (line ${firstLine ?? '-'}-${lastLine ?? '-'}) (${opcodes.length} instructions at $hashCode)',
      )
      ..writeLine(
        '$arity${variadic ? '+' : ''} params, $maxStackSize slots, ${upvalues.length} upvalues, ${locals.length + innerLocals} locals, ${constants.length} constants, ${protos.length} functions',
      );

    for (var i = 0; i < opcodes.length; i++) {
      final desc = LuaOpcode.getDescription(
        opcodes[i],
        index: i + 1,
        constants: constants,
      );
      final line = lineInfo?.find(i);
      final comment = comments?[i];
      system.writeLine(
        '\t${i + 1}\t[${line ?? '-'}]\t$desc\t${comment != null ? '\t; $comment' : ''}',
      );
    }

    if (constants.isNotEmpty) {
      system.writeLine('constants (${constants.length}) for $hashCode:');
      for (var i = 0; i < constants.length; i++) {
        system.writeLine('\t$i\t${constants[i].luaRepresentation}');
      }
    }

    if (locals.isNotEmpty) {
      system.writeLine('locals (${locals.length}) for $hashCode:');
      for (var i = 0; i < locals.length; i++) {
        system.writeLine(
          '\t$i\t${locals[i]}\t$firstLine\t$lastLine',
        );
      }
    }

    if (upvalues.isNotEmpty) {
      system.writeLine('upvalues (${upvalues.length}) for $hashCode:');
      for (var i = 0; i < upvalues.length; i++) {
        system.writeLine('\t$i\t${upvalues[i]}');
      }
    }

    if (protos.isNotEmpty) {
      system.writeLine('functions (${protos.length}) for $hashCode:');
      for (final proto in protos) {
        system.writeLine('');
        DebugPrint.compiledFunction(
          code: proto,
          name: proto.name,
          firstLine: proto.firstLine,
          lastLine: proto.lastLine,
          arity: proto.arity,
          variadic: proto.variadic,
          opcodes: proto.opcodes,
          constants: proto.constants,
          protos: proto.prototypes,
        );
      }
    }
  }
}
