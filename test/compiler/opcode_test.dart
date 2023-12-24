import 'package:test/test.dart';
import 'package:tradaul/src/runtime/opcodes.dart';

void main() {
  group('LuaOpcode', () {
    const opcode = 123;
    const a = 12;
    const b = 34;
    const c = 56;
    const ax = 789;
    const sAx = -789;
    const bx = 456;
    const sBx = -456;

    test('Ax format consistency', () {
      final code = LuaOpcode.bytecode(opcode, ax: ax);
      final fields = LuaOpcode.getFields(code);
      expect(fields.op, opcode);
      expect(fields.ax, ax);
    });

    test('sAx format consistency', () {
      final code = LuaOpcode.bytecode(opcode, sAx: sAx);
      final fields = LuaOpcode.getFields(code);
      expect(fields.op, opcode);
      expect(fields.sAx, sAx);
    });

    test('Bx format consistency', () {
      final code = LuaOpcode.bytecode(opcode, a: a, bx: bx);
      final fields = LuaOpcode.getFields(code);
      expect(fields.op, opcode);
      expect(fields.a, a);
      expect(fields.bx, bx);
    });

    test('sBx format consistency', () {
      final code = LuaOpcode.bytecode(opcode, a: a, sBx: sBx);
      final fields = LuaOpcode.getFields(code);
      expect(fields.op, opcode);
      expect(fields.a, a);
      expect(fields.sBx, sBx);
    });

    test('ABC format consistency', () {
      final code = LuaOpcode.bytecode(opcode, a: a, b: b, c: c);
      final fields = LuaOpcode.getFields(code);
      expect(fields.op, opcode);
      expect(fields.a, a);
      expect(fields.b, b);
      expect(fields.c, c);
    });
  });
}
