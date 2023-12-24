import 'package:tradaul/src/runtime/execution.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

final class LuaStackSlot {
  LuaStackSlot(this.value);

  LuaValue value;
}

final class LuaStack {
  LuaStack();

  factory LuaStack.from(LuaStack other) {
    return LuaStack()
      .._slots = List.from(other._slots)
      ..topIndex = other.topIndex;
  }

  late List<LuaStackSlot> _slots = [];

  List<LuaStackSlot> get slots => _slots;

  int topIndex = -1;

  void grow(int size) {
    if (_slots.length < size) {
      for (var i = _slots.length; i < size; i++) {
        _slots.add(LuaStackSlot(LuaNil()));
      }
    }
  }

  int get size => _slots.length;

  LuaValue get top => _slots[topIndex].value;

  LuaValue operator [](int index) => _slots[index].value;

  void operator []=(int index, LuaValue value) => _slots[index].value = value;

  void reset(int index) {
    _slots[index] = LuaStackSlot(LuaNil());
  }

  void move(int from, int to) {
    _slots[to] = _slots[from];
  }

  void push(LuaValue value) {
    topIndex++;
    if (_slots.length < topIndex + 1) {
      _slots.add(LuaStackSlot(value));
    } else {
      this[topIndex] = value;
    }
  }

  void pushAll(List<LuaValue> values) {
    for (final value in values) {
      push(value);
    }
  }

  void pushOrThrow(LuaValueResult result) {
    if (result.isSuccess()) {
      push(result.getOrThrow());
    } else {
      throw result.exceptionOrNull()!;
    }
  }

  LuaValue pop() {
    final result = _slots[topIndex];
    topIndex--;
    return result.value;
  }

  List<LuaValue> pops(int count) {
    final result = _slots.sublist(topIndex - count + 1, topIndex + 1).toList();
    topIndex -= count;
    return result.map((e) => e.value).toList();
  }

  List<LuaValue>? popToMark<T>({bool noReturn = false}) {
    List<LuaValue>? result;
    if (!noReturn) {
      result = [];
    }

    for (var i = topIndex; i >= 0; i--) {
      if (_slots[i].value is T) {
        topIndex = i - 1;
        return result;
      }
      result?.add(_slots[i].value);
    }
    return null;
  }

  Mark? findMark<Mark extends LuaMark>() {
    for (var i = topIndex; i >= 0; i--) {
      final value = this[i];
      if (value is Mark) {
        return value;
      }
    }
    return null;
  }

  void debugPrint() {
    print('current stack:');
    for (var i = 0; i <= topIndex; i++) {
      print('\t$i\t${this[i].luaRepresentation}');
    }
  }
}
