import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_native.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

@immutable
final class LuaValueHolder {
  const LuaValueHolder(this.value);

  final LuaValue value;

  @override
  String toString() => '&#$value';

  String get luaRepresentation => value.luaRepresentation;

  @override
  bool operator ==(Object other) {
    if (other is LuaValueHolder) {
      return value.luaEquals(other.value);
    } else if (other is LuaValue) {
      return other.luaEquals(other);
    } else {
      return false;
    }
  }

  @override
  int get hashCode => value.luaHashCode;
}

final class LuaBinding extends LuaValue {
  LuaBinding({required this.onGet, this.onSet});

  final Result<LuaValue> Function() onGet;
  final LuaException? Function(LuaValue value)? onSet;

  @override
  bool luaEquals(LuaValue other) => this == other;

  @override
  int get luaHashCode => hashCode;

  @override
  LuaValueType get luaType => onGet().getOrDefault(LuaNil()).luaType;

  @override
  dynamic get rawValue => this;
}

final class LuaTable extends LuaValue {
  LuaTable();

  LuaTable.withCapacity({int arrayCapacity = 0, int hashCapacity = 0}) {
    if (arrayCapacity > 0) {
      _arrayPart = List<LuaValue?>.filled(arrayCapacity, null);
    }
  }

  LuaTable.fromList(List<LuaValue> list) {
    _arrayPart = List<LuaValue?>.filled(list.length, null);
    for (var i = 0; i < list.length; i++) {
      _arrayPart[i] = list[i];
    }
    _arraySize = list.length;
  }

  LuaTable.fromMap(Map<LuaValue, LuaValue> map) {
    for (final entry in map.entries) {
      _hashPart[LuaValueHolder(entry.key)] = entry.value;
    }
  }

  LuaTable.fromSet(Set<LuaValue> set) {
    _arrayPart = List<LuaValue?>.filled(set.length, null);
    var i = 0;
    for (final value in set) {
      _arrayPart[i++] = value;
    }
    _arraySize = set.length;
  }

  LuaTable.of(LuaTable table) {
    if (table._arraySize > 0) {
      _arrayPart = List<LuaValue?>.filled(table._arraySize, null);
      for (var i = 0; i < table._arraySize; i++) {
        _arrayPart[i] = table._arrayPart[i];
      }
      _arraySize = table._arraySize;
    }
    _hashPart.addAll(table._hashPart);
  }

  @override
  bool get isTable => true;

  String? moduleName;

  List<LuaValue?> _arrayPart = [];
  int _arraySize = 0;
  final Map<LuaValueHolder, LuaValue> _hashPart = {};
  bool _hasChanged = false;
  List<LuaValue> _iterationKeys = [];

  @override
  LuaValueType get luaType => LuaValueType.table;

  @override
  String get luaRepresentation => 'table: $hashCode';
  
  @override
  String luaToDisplayString() => luaRepresentation;

  @override
  dynamic get rawValue => this;

  LuaTable? metatable;

  LuaValue? Function(LuaValue)? onGet;
  LuaException? Function(LuaValue, LuaValue)? onSet;

  @override
  String luaToString() {
    final buffer = StringBuffer('{');
    var first = true;
    for (var i = 0; i < _arraySize; i++) {
      if (first) {
        first = false;
      } else {
        buffer.write(', ');
      }
      buffer.write(_arrayPart[i]?.luaRepresentation ?? 'nil');
    }
    for (final entry in _hashPart.entries) {
      if (first) {
        first = false;
      } else {
        buffer.write(', ');
      }
      buffer
        ..write(entry.key.luaRepresentation)
        ..write(': ')
        ..write(entry.value.luaRepresentation);
    }
    buffer.write('}');
    return buffer.toString();
  }

  @override
  bool luaEquals(LuaValue other) => this == other;

  @override
  int get luaHashCode => hashCode;

  int get simpleHashCode {
    var hash = 0;
    for (var i = 0; i < _arraySize; i++) {
      hash = hash * 31 + (_arrayPart[i]?.luaHashCode ?? 0);
    }
    for (final entry in _hashPart.entries) {
      hash = hash * 31 + entry.key.value.luaHashCode;
      hash = hash * 31 + entry.value.luaHashCode;
    }
    return hash;
  }

  void clear() {
    _arrayPart.fillRange(0, _arraySize, null);
    _arraySize = 0;
    _hashPart.clear();
    _hasChanged = true;
  }

  final Map<String, LuaBinding> _bindings = {};

  void bind(String key, LuaBinding binding) {
    _bindings[key] = binding;
  }

  void unbind(String key) {
    _bindings.remove(key);
  }

  LuaValue? _getHashPart(LuaValue key) {
    if (key.isString) {
      final binding = _bindings[(key as LuaString).value];
      if (binding != null) {
        return binding.onGet().getOrDefault(LuaNil());
      }
    }
    return _hashPart[LuaValueHolder(key)];
  }

  LuaException? _setHashPart(LuaValue key, LuaValue value) {
    if (key.isString) {
      final binding = _bindings[(key as LuaString).value];
      if (binding != null) {
        if (binding.onSet != null) {
          return binding.onSet!(value);
        }
        return null;
      }
    }
    _hashPart[LuaValueHolder(key)] = value;
    return null;
  }

  LuaException? stringKeySet(String key, LuaValue value) {
    return set(LuaString(key), value);
  }

  LuaException? set(LuaValue key, LuaValue value) {
    if (onSet != null) {
      return onSet!(key, value);
    } else {
      return basicSet(key, value);
    }
  }

  LuaException? basicSet(LuaValue key, LuaValue value) {
    LuaException? error;
    if (key is LuaInteger) {
      final intKey = key.value;
      if (intKey > 0) {
        final index = (intKey - 1).toInt();
        // Expand array to accommodate large indices
        if (index >= _arrayPart.length) {
          _ensureArrayCapacity(index + 1);
        }
        _arrayPart[index] = value;
        if (index >= _arraySize) {
          _arraySize = index + 1;
        }
      } else {
        error = _setHashPart(key, value);
      }
    } else {
      error = _setHashPart(key, value);
    }
    _hasChanged = true;
    return error;
  }

  void _ensureArrayCapacity(int minCapacity) {
    if (_arrayPart.length < minCapacity) {
      final newCapacity = _calculateNewCapacity(minCapacity);
      final newArray = List<LuaValue?>.filled(newCapacity, null);
      for (var i = 0; i < _arraySize; i++) {
        newArray[i] = _arrayPart[i];
      }
      _arrayPart = newArray;
    }
  }

  int _calculateNewCapacity(int minCapacity) {
    // Start with 8, grow by 2x up to a reasonable limit
    var newCapacity = _arrayPart.isEmpty ? 8 : (_arrayPart.length * 2);
    if (newCapacity < minCapacity) {
      newCapacity = minCapacity;
    }
    return newCapacity;
  }

  LuaValue? stringKeyGet(String key) {
    return get(LuaString(key));
  }

  LuaValue? get(LuaValue key) {
    if (onGet != null) {
      return onGet!(key);
    } else {
      return basicGet(key);
    }
  }

  LuaValue? basicGet(LuaValue key) {
    if (key is LuaInteger) {
      final intKey = key.value;
      if (intKey > 0 && intKey <= _arraySize) {
        final index = (intKey - 1).toInt();
        return _arrayPart[index];
      }
    }
    return _getHashPart(key);
  }

  // Optimized method for integer index access
  LuaValue? fastGetInt(int intKey) {
    if (intKey > 0 && intKey <= _arraySize) {
      return _arrayPart[intKey - 1];
    }
    return null;
  }

  // Optimized method for integer index set
  void fastSetInt(int intKey, LuaValue value) {
    if (intKey > 0) {
      final index = intKey - 1;
      // Always use array part for positive integers
      if (index >= _arrayPart.length) {
        _ensureArrayCapacity(index + 1);
      }
      _arrayPart[index] = value;
      if (index >= _arraySize) {
        _arraySize = index + 1;
      }
      _hasChanged = true;
    }
  }

  LuaValue? getAt(int index) {
    if (onGet != null) {
      final value = onGet!(LuaInteger.fromInt(index));
      if (value != null) {
        return value;
      }
    }

    if (index > 0 && index <= _arraySize) {
      return _arrayPart[index - 1];
    }
    return null;
  }

  void add(LuaValue value) {
    if (onSet != null) {
      onSet!.call(LuaInteger.fromInt(_arraySize + 1), value);
    }
    _ensureArrayCapacity(_arraySize + 1);
    _arrayPart[_arraySize] = value;
    _arraySize++;
    _hasChanged = true;
  }

  int get length => _arraySize;

  void addNativeCalls(
    Map<String, LuaNativeCall> nativeCalls, {
    String? moduleName,
  }) {
    for (final call in nativeCalls.entries) {
      final key = LuaString(call.key);
      final name = moduleName == null ? call.key : '$moduleName.${call.key}';
      final value = LuaNativeFunction(name, call.value);
      set(key, value);
    }
  }

  bool insert(int index, LuaValue value) {
    if (_arraySize < index) {
      return false;
    }

    if (_arraySize == index) {
      add(value);
    } else {
      _ensureArrayCapacity(_arraySize + 1);
      // Shift elements to the right
      for (var i = _arraySize; i > index; i--) {
        _arrayPart[i] = _arrayPart[i - 1];
      }
      _arrayPart[index] = value;
      _arraySize++;
      if (onSet != null) {
        onSet!.call(LuaInteger.fromInt(index), value);
      }
    }
    return true;
  }

  int get border {
    if (_arraySize == 0) return 0;

    for (var i = _arraySize; i >= 1; i--) {
      final val = _arrayPart[i - 1];
      if (val != null && !val.isNil) {
        if (i == _arraySize || _arrayPart[i] == null || _arrayPart[i]!.isNil) {
          return i;
        }
      }
    }

    return 0;
  }

  void merge(LuaTable other) {
    // TODO(improvement): remove duplicated elements
    if (other._arraySize > 0) {
      _ensureArrayCapacity(_arraySize + other._arraySize);
      for (var i = 0; i < other._arraySize; i++) {
        _arrayPart[_arraySize + i] = other._arrayPart[i];
      }
      _arraySize += other._arraySize;
    }
    _hashPart.addAll(other._hashPart);
    _hasChanged = true;
  }

  LuaValue? remove(int index) {
    if (index < 0 || index >= _arraySize) {
      return null;
    }

    final value = _arrayPart[index];
    // Shift elements to the left
    for (var i = index; i < _arraySize - 1; i++) {
      _arrayPart[i] = _arrayPart[i + 1];
    }
    _arrayPart[_arraySize - 1] = null;
    _arraySize--;
    _hasChanged = true;
    return value;
  }

  Iterable<LuaTableEntry> get entries => _EntryIterable(this);

  Iterable<LuaValue> get keys => _KeyIterable(this);

  Iterable<LuaValue> get values => _ValueIterable(this);

  Iterable<LuaSequenceEntry> get sequence => _SequenceIterable(this);

  LuaValue? nextTableIndex(LuaValue? index) {
    if (_hasChanged) {
      _iterationKeys = _hashPart.keys.map((e) => e.value).toList();
      _hasChanged = false;
    }

    if (index == null || index.isNil) {
      if (_arraySize > 0) {
        return LuaInteger.fromInt(1);
      } else {
        return _iterationKeys.firstOrNull;
      }
    } else if (index is LuaInteger) {
      final intIndex = index.value.toInt() - 1;
      if (intIndex >= 0 && intIndex < _arraySize - 1) {
        return LuaInteger.fromInt(intIndex + 2);
      } else {
        return _iterationKeys.firstOrNull;
      }
    } else {
      final keyIndex = _iterationKeys.indexOf(index);
      if (keyIndex >= 0 && keyIndex < _iterationKeys.length - 1) {
        return _iterationKeys[keyIndex + 1];
      } else {
        return null;
      }
    }
  }

  int? nextSequenceIndex(int index) {
    if (index >= 0 && index < _arraySize) {
      return index + 1;
    } else {
      return null;
    }
  }
}

final class LuaTableEntry {
  @protected
  const LuaTableEntry(this.key, this.value);

  final LuaValue key;
  final LuaValue value;
}

final class _EntryIterable extends Iterable<LuaTableEntry> {
  _EntryIterable(this.table);

  final LuaTable table;

  @override
  Iterator<LuaTableEntry> get iterator => _EntryIterator(table);
}

final class _EntryIterator implements Iterator<LuaTableEntry> {
  _EntryIterator(this.table) {
    _hashPart = table._hashPart.entries.iterator;
  }

  final LuaTable table;
  var _arrayIndex = 0;
  late final Iterator<MapEntry<LuaValueHolder, LuaValue>> _hashPart;
  LuaTableEntry? _current;

  @override
  LuaTableEntry get current {
    if (_current == null) {
      throw StateError('Iterator is not started or already finished');
    }
    return _current!;
  }

  @override
  bool moveNext() {
    if (_arrayIndex < table._arraySize) {
      final value = table._arrayPart[_arrayIndex];
      if (value != null) {
        _current = LuaTableEntry(LuaInteger.fromInt(_arrayIndex + 1), value);
        _arrayIndex++;
        return true;
      }
      _arrayIndex++;
      return moveNext();
    } else if (_hashPart.moveNext()) {
      _current =
          LuaTableEntry(_hashPart.current.key.value, _hashPart.current.value);
      return true;
    } else {
      _current = null;
      return false;
    }
  }
}

final class _KeyIterable extends Iterable<LuaValue> {
  _KeyIterable(this.table);

  final LuaTable table;

  @override
  Iterator<LuaValue> get iterator => _KeyIterator(table);
}

final class _KeyIterator implements Iterator<LuaValue> {
  _KeyIterator(LuaTable table) {
    _entries = table.entries.iterator;
  }

  late final Iterator<LuaTableEntry> _entries;

  @override
  LuaValue get current => _entries.current.key;

  @override
  bool moveNext() => _entries.moveNext();
}

final class _ValueIterable extends Iterable<LuaValue> {
  _ValueIterable(this.table);

  final LuaTable table;

  @override
  Iterator<LuaValue> get iterator => _ValueIterator(table);
}

final class _ValueIterator implements Iterator<LuaValue> {
  _ValueIterator(LuaTable table) {
    _entries = table.entries.iterator;
  }

  late final Iterator<LuaTableEntry> _entries;

  @override
  LuaValue get current => _entries.current.value;

  @override
  bool moveNext() => _entries.moveNext();
}

final class LuaSequenceEntry {
  @protected
  const LuaSequenceEntry(this.index, this.value);

  final int index;
  final LuaValue value;
}

final class _SequenceIterable extends Iterable<LuaSequenceEntry> {
  _SequenceIterable(this.table);

  final LuaTable table;

  @override
  Iterator<LuaSequenceEntry> get iterator => _SequenceIterator(table);
}

final class _SequenceIterator implements Iterator<LuaSequenceEntry> {
  _SequenceIterator(this.table);

  final LuaTable table;
  var _index = 0;
  LuaSequenceEntry? _current;

  @override
  LuaSequenceEntry get current {
    if (_current == null) {
      throw StateError('Iterator is not started or already finished');
    }
    return _current!;
  }

  @override
  bool moveNext() {
    if (_index < table._arraySize) {
      final value = table._arrayPart[_index];
      if (value != null) {
        _current = LuaSequenceEntry(_index + 1, value);
        _index++;
        return true;
      }
      _index++;
      return moveNext();
    } else {
      _current = null;
      return false;
    }
  }
}
