// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:tradaul/src/runtime/lua_values.dart';

// instruction
// OP: 8 bits
// A: 8 bits
// B: 8 bits
// C: 8 bits
// Ax: 24 bits
// sAx: signed Ax
// Bx: 16 bits
// sBx: signed Bx

abstract class LuaOpcode {
  // load operations
  static const int NO_OP = 0;
  static const int LOAD_NIL = 1;
  static const int LOAD_TRUE = 2;
  static const int LOAD_FALSE = 3;
  static const int LOAD_INT = 4;
  static const int LOAD_CONST = 5;
  static const int LOAD_LOCAL = 6;
  static const int LOAD_GLOBAL = 7;
  static const int LOAD_UPVALUE = 8;
  static const int LOAD_SELF = 9;
  static const int LOAD_CONTEXT = 10;
  static const int LOAD_ENV = 11;
  static const int LOAD_VARARG = 12;
  static const int LOAD_VARARG_ITEMS = 13;
  static const int LOAD_UPSTACK = 14;

  // store operations
  static const int STORE_LOCAL = 15;

  // stack operations
  static const int POP = 16;
  static const int POPS = 17;
  static const int DUP = 18;
  static const int SWAP = 19;

  // mark operations
  static const int MARK_ARG = 20;
  static const int MARK_RETURN = 21;
  static const int MARK_CLOSED = 22;

  // assignment operations
  static const int ASSIGN_FIELD = 23;
  static const int ADD_FIELD = 24;
  static const int ADD_VARARG = 25;

  // table operations
  static const int CREATE_TABLE = 26;
  static const int GET_INDEX = 27;
  static const int GET_CONST = 28;
  static const int GET_FIELD = 29;
  static const int SET_INDEX = 30;
  static const int SET_CONST = 31;
  static const int SET_FIELD = 32;

  // control flow operations
  static const int RETURN = 33;
  static const int RETURN_NONE = 34;
  static const int CALL = 35;
  static const int CALL_ALL_OUT = 36;
  static const int LOOP_HEAD = 37;
  static const int JUMP = 38;
  static const int BRANCH_TRUE = 39;
  static const int BRANCH_TRUE_POP = 40;
  static const int BRANCH_FALSE = 41;
  static const int BRANCH_FALSE_POP = 42;
  static const int BRANCH_NIL_POP = 43;

  // arithmetic operations
  static const int ADD = 44;
  static const int SUB = 45;
  static const int MUL = 46;
  static const int MOD = 47;
  static const int POW = 48;
  static const int DIV = 49;
  static const int IDIV = 50;

  // bit operations
  static const int BAND = 51;
  static const int BOR = 52;
  static const int BXOR = 53;
  static const int SHL = 54;
  static const int SHR = 55;

  // unary operations
  static const int NEG = 56;
  static const int BNOT = 57;
  static const int NOT = 58;
  static const int LEN = 59;

  // others
  static const int CONCAT = 60;
  static const int CLOSE = 61;
  static const int EQ = 62;
  static const int NEQ = 63;
  static const int LT = 64;
  static const int LE = 65;
  static const int GT = 66;
  static const int GE = 67;
  static const int CLOSURE = 68;
  static const int CHECK_NUMBER = 69;
  static const int FOR_STEP = 70;
  static const int RESET_LOCAL = 71;

  static final int maxAx = (pow(2, 25) - 1).toInt();
  static final int minSAx = -(maxAx >> 1) - 1;
  static final int maxSAx = maxAx >> 1;
  static final int maxBx = (pow(2, 17) - 1).toInt();
  static final int minSBx = -(maxBx >> 1) - 1;
  static final int maxSBx = maxBx >> 1;

  static const int mask8bits = 0xFF;
  static const int mask16bits = (1 << 16) - 1;
  static const int mask24bits = (1 << 24) - 1;

  static String getName(int opcode) {
    switch (opcode) {
      case NO_OP:
        return 'NO_OP';
      case LOAD_NIL:
        return 'LOAD_NIL';
      case LOAD_TRUE:
        return 'LOAD_TRUE';
      case LOAD_FALSE:
        return 'LOAD_FALSE';
      case LOAD_INT:
        return 'LOAD_INT';
      case LOAD_CONST:
        return 'LOAD_CONST';
      case LOAD_LOCAL:
        return 'LOAD_LOCAL';
      case LOAD_GLOBAL:
        return 'LOAD_GLOBAL';
      case LOAD_UPVALUE:
        return 'LOAD_UPVALUE';
      case LOAD_UPSTACK:
        return 'LOAD_UPSTACK';
      case LOAD_SELF:
        return 'LOAD_SELF';
      case LOAD_CONTEXT:
        return 'LOAD_CONTEXT';
      case LOAD_ENV:
        return 'LOAD_ENV';
      case LOAD_VARARG:
        return 'LOAD_VARARG';
      case LOAD_VARARG_ITEMS:
        return 'LOAD_VARARG_ITEMS';
      case MARK_ARG:
        return 'MARK_ARG';
      case MARK_RETURN:
        return 'MARK_RETURN';
      case STORE_LOCAL:
        return 'STORE_LOCAL';
      case POP:
        return 'POP';
      case POPS:
        return 'POPS';
      case CREATE_TABLE:
        return 'CREATE_TABLE';
      case GET_INDEX:
        return 'GET_INDEX';
      case GET_CONST:
        return 'GET_CONST';
      case GET_FIELD:
        return 'GET_FIELD';
      case SET_INDEX:
        return 'SET_INDEX';
      case SET_CONST:
        return 'SET_CONST';
      case SET_FIELD:
        return 'SET_FIELD';
      case ASSIGN_FIELD:
        return 'ASSIGN_FIELD';
      case ADD_FIELD:
        return 'ADD_FIELD';
      case ADD_VARARG:
        return 'ADD_VARARG';
      case RETURN:
        return 'RETURN';
      case RETURN_NONE:
        return 'RETURN_NONE';
      case CALL:
        return 'CALL';
      case CALL_ALL_OUT:
        return 'CALL_ALL_OUT';
      case LOOP_HEAD:
        return 'LOOP_HEAD';
      case CLOSURE:
        return 'CLOSURE';
      case CHECK_NUMBER:
        return 'CHECK_NUMBER';
      case FOR_STEP:
        return 'FOR_STEP';
      case RESET_LOCAL:
        return 'RESET_LOCAL';
      case DUP:
        return 'DUP';
      case SWAP:
        return 'SWAP';
      case ADD:
        return 'ADD';
      case SUB:
        return 'SUB';
      case MUL:
        return 'MUL';
      case MOD:
        return 'MOD';
      case POW:
        return 'POW';
      case DIV:
        return 'DIV';
      case IDIV:
        return 'IDIV';
      case BAND:
        return 'BAND';
      case BOR:
        return 'BOR';
      case BXOR:
        return 'BXOR';
      case SHL:
        return 'SHL';
      case SHR:
        return 'SHR';
      case NEG:
        return 'NEG';
      case BNOT:
        return 'BNOT';
      case NOT:
        return 'NOT';
      case LEN:
        return 'LEN';
      case CONCAT:
        return 'CONCAT';
      case CLOSE:
        return 'CLOSE';
      case MARK_CLOSED:
        return 'TBC';
      case BRANCH_TRUE:
        return 'BRANCH_TRUE';
      case BRANCH_TRUE_POP:
        return 'BRANCH_TRUE_POP';
      case BRANCH_FALSE:
        return 'BRANCH_FALSE';
      case BRANCH_FALSE_POP:
        return 'BRANCH_FALSE_POP';
      case BRANCH_NIL_POP:
        return 'BRANCH_NIL_POP';
      case JUMP:
        return 'JUMP';
      case EQ:
        return 'EQ';
      case NEQ:
        return 'NEQ';
      case LT:
        return 'LT';
      case LE:
        return 'LE';
      case GT:
        return 'GT';
      default:
        return 'UNKNOWN';
    }
  }

  static int bytecode(
    int op, {
    int? a,
    int? b,
    int? c,
    int? ax,
    int? sAx,
    int? bx,
    int? sBx,
  }) {
    a = a ?? 0;
    b = b ?? 0;
    c = c ?? 0;

    if (ax != null) {
      return (op & mask8bits) | (((ax & mask24bits) << 8));
    } else if (sAx != null) {
      final finalAx =
          sAx + (1 << 23); // offset by 2^23 to handle negative numbers
      return (op & mask8bits) | ((finalAx & mask24bits) << 8);
    } else if (bx != null || sBx != null) {
      final finalBx = bx ?? (sBx! + (1 << 15));
      return (op & mask8bits) |
          ((a & mask8bits) << 8) |
          ((finalBx & mask16bits) << 16);
    } else {
      return (op & mask8bits) |
          ((a & mask8bits) << 8) |
          ((b & mask8bits) << 16) |
          ((c & mask8bits) << 24);
    }
  }

  static ({
    int op,
    int a,
    int b,
    int c,
    int ax,
    int sAx,
    int bx,
    int sBx,
  }) getFields(int code) {
    final op = code & mask8bits;
    final a = (code >> 8) & mask8bits;
    final b = (code >> 16) & mask8bits;
    final c = (code >> 24) & mask8bits;
    final ax = (code >> 8) & mask24bits;
    final sAx = ax - (1 << 23);
    final bx = (code >> 16) & mask16bits;
    final sBx = bx - (1 << 15);
    return (
      op: op,
      a: a,
      b: b,
      c: c,
      ax: ax,
      sAx: sAx,
      bx: bx,
      sBx: sBx,
    );
  }

  static String getDescription(
    int opcode, {
    required int index,
    required List<LuaValue> constants,
  }) {
    // Get the fields from the instruction code
    final fields = getFields(opcode);
    // Create the base string with the opcode name
    final name = LuaOpcode.getName(fields.op);
    var str = '';
    int? bits1;
    int? bits2;
    int? bits3;

    // Depending on the opcode, add the appropriate fields
    switch (fields.op) {
      case NO_OP:
        str += 'no op';
      case LOAD_NIL:
        str += 'load nil';
      case LOAD_TRUE:
        str += 'load true';
      case LOAD_FALSE:
        str += 'load false';
      case LOAD_INT:
        bits1 = fields.sAx;
        str += 'load ${fields.sAx}';
      case LOAD_CONST:
        bits1 = fields.ax;
        str += 'load ${constants[fields.ax].luaRepresentation}';
      case LOAD_LOCAL:
        bits1 = fields.ax;
        str += 'load local ${fields.ax}';
      case LOAD_GLOBAL:
        bits1 = fields.ax;
        str += 'load global ${constants[fields.ax].luaRepresentation}';
      case LOAD_UPVALUE:
        bits1 = fields.a;
        bits2 = fields.bx;
        str += 'load upvalue[${fields.a}][${fields.bx}]';
      case LOAD_UPSTACK:
        bits1 = fields.ax;
        str += 'load upstack ${fields.ax}';
      case LOAD_SELF:
        str += 'load self';
      case LOAD_CONTEXT:
        str += 'load context';
      case LOAD_ENV:
        str += 'load env';
      case LOAD_VARARG:
        str += 'load vararg';
      case LOAD_VARARG_ITEMS:
        str += 'load vararg items';
      case STORE_LOCAL:
        bits1 = fields.ax;
        str += 'store local ${fields.ax}';
      case POP:
        str += 'pop';
      case POPS:
        bits1 = fields.ax;
        str += 'pop ${fields.ax}';
      case MARK_ARG:
        str += 'mark arg';
      case MARK_RETURN:
        str += 'mark return';
      case CREATE_TABLE:
        str += 'create table';
      case GET_INDEX:
        bits1 = fields.ax;
        str += 'get index ${fields.ax + 1}';
      case GET_FIELD:
        str += 'get field';
      case SET_FIELD:
        str += 'set field';
      case ASSIGN_FIELD:
        bits1 = fields.ax;
        str += 'assign field at ${-fields.ax}';
      case ADD_FIELD:
        str += 'add field';
      case ADD_VARARG:
        str += 'add vararg';
      case RETURN:
        str += 'return';
      case RETURN_NONE:
        str += 'return no values';
      case CALL:
        bits1 = fields.a;
        str += 'call ${fields.a} out';
      case CALL_ALL_OUT:
        str += 'call all out';
      case LOOP_HEAD:
        str += 'loop head';
      case CLOSURE:
        bits1 = fields.a;
        str += 'create closure ${fields.ax}';
      case CHECK_NUMBER:
        str += 'check number';
      case FOR_STEP:
        bits1 = fields.a;
        bits2 = fields.b;
        bits3 = fields.c;
        str += "'for' step: ${fields.a}, ${fields.b}, ${fields.c}";
      case RESET_LOCAL:
        bits1 = fields.a;
        str += 'reset ${fields.a}';
      case DUP:
        str += 'duplicate';
      case SWAP:
        str += 'swap';
      case BAND:
        str += '&';
      case BOR:
        str += '|';
      case BXOR:
        str += '^';
      case SHL:
        str += '<<';
      case SHR:
        str += '>>';
      case ADD:
        str += '+';
      case SUB:
        str += '-';
      case MUL:
        str += '*';
      case DIV:
        str += '/';
      case IDIV:
        str += '//';
      case MOD:
        str += '%';
      case POW:
        str += '^';
      case NOT:
        str += 'not';
      case EQ:
        str += '==';
      case NEQ:
        str += '~=';
      case LT:
        str += '<';
      case LE:
        str += '<=';
      case GT:
        str += '>';
      case GE:
        str += '>=';
      case NEG:
        str += '* -1';
      case BNOT:
        str += '~';
      case LEN:
        str += 'get length';
      case CONCAT:
        str += 'concatenate';
      case BRANCH_TRUE:
        bits1 = fields.sBx;
        str += 'branch true ${index + fields.sBx}';
      case BRANCH_TRUE_POP:
        bits1 = fields.sBx;
        str += 'branch true ${index + fields.sBx}; pop';
      case BRANCH_FALSE:
        bits1 = fields.sBx;
        str += 'branch false ${index + fields.sBx}';
      case BRANCH_FALSE_POP:
        bits1 = fields.sBx;
        str += 'branch false ${index + fields.sBx}; pop';
      case BRANCH_NIL_POP:
        bits1 = fields.sBx;
        str += 'branch nil ${index + fields.sBx}; pop';
      case JUMP:
        bits1 = fields.sBx;
        str += 'jump ${index + fields.sBx}';
      default:
        str += '<unknown>';
    }

    var format = '$name\t\t';
    if (bits1 != null) {
      format += ' $bits1';
      if (bits2 != null) {
        format += ' $bits2';
      }
      if (bits3 != null) {
        format += ' $bits3';
      }
    } else {
      format += '\t';
    }
    return '$format\t$str';
  }
}
