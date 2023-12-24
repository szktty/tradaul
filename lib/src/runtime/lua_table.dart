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

  final Result<LuaValue, LuaException> Function() onGet;
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

  LuaTable.fromList(List<LuaValue> list) {
    _arrayPart.addAll(list);
  }

  LuaTable.fromMap(Map<LuaValue, LuaValue> map) {
    for (final entry in map.entries) {
      _hashPart[LuaValueHolder(entry.key)] = entry.value;
    }
  }

  LuaTable.fromSet(Set<LuaValue> set) {
    for (final value in set) {
      _arrayPart.add(value);
    }
  }

  LuaTable.of(LuaTable table) {
    _arrayPart.addAll(table._arrayPart);
    _hashPart.addAll(table._hashPart);
  }

  @override
  bool get isTable => true;

  String? moduleName;

  final List<LuaValue> _arrayPart = [];
  final Map<LuaValueHolder, LuaValue> _hashPart = {};
  bool _hasChanged = false;
  List<LuaValue> _iterationKeys = [];

  @override
  LuaValueType get luaType => LuaValueType.table;

  @override
  String get luaRepresentation => 'table: $hashCode';

  @override
  dynamic get rawValue => this;

  LuaTable? metatable;

  LuaValue? Function(LuaValue)? onGet;
  LuaException? Function(LuaValue, LuaValue)? onSet;

  @override
  String luaToString() {
    final buffer = StringBuffer('{');
    var first = true;
    for (final value in _arrayPart) {
      if (first) {
        first = false;
      } else {
        buffer.write(', ');
      }
      buffer.write(value.luaRepresentation);
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
    for (final value in _arrayPart) {
      hash = hash * 31 + value.luaHashCode;
    }
    for (final entry in _hashPart.entries) {
      hash = hash * 31 + entry.key.value.luaHashCode;
      hash = hash * 31 + entry.value.luaHashCode;
    }
    return hash;
  }

  void clear() {
    _arrayPart.clear();
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
      if (intKey > 0 && intKey <= _arrayPart.length + 1) {
        if (intKey > _arrayPart.length) {
          _arrayPart.add(value);
        } else {
          _arrayPart[(intKey - 1).toInt()] = value;
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
    if (key is LuaInteger && key.value > 0) {
      final intKey = key.value;
      if (intKey > 0 && intKey <= _arrayPart.length) {
        return _arrayPart[(intKey - 1).toInt()];
      }
    }
    return _getHashPart(key);
  }

  LuaValue? getAt(int index) {
    if (onGet != null) {
      final value = onGet!(LuaInteger.fromInt(index));
      if (value != null) {
        return value;
      }
    }

    if (index > 0 && index <= _arrayPart.length) {
      return _arrayPart[index - 1];
    }
    return null;
  }

  void add(LuaValue value) {
    if (onSet != null) {
      onSet!.call(LuaInteger.fromInt(_arrayPart.length + 1), value);
    }
    _arrayPart.add(value);
    _hasChanged = true;
  }

  int get length => _arrayPart.length;

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
    if (_arrayPart.length < index) {
      return false;
    }

    if (_arrayPart.length == index) {
      add(value);
    } else {
      _arrayPart.insert(index, value);
      if (onSet != null) {
        onSet!.call(LuaInteger.fromInt(index), value);
      }
    }
    return true;
  }

  int get border {
    if (_arrayPart.isEmpty) return 0;

    for (var i = _arrayPart.length; i >= 1; i--) {
      if (!_arrayPart[i - 1].isNil) {
        if (i == _arrayPart.length || _arrayPart[i].isNil) {
          return i;
        }
      }
    }

    return 0;
  }

  void merge(LuaTable other) {
    // TODO: remove duplicated elements
    _arrayPart.addAll(other._arrayPart);
    _hashPart.addAll(other._hashPart);
    _hasChanged = true;
  }

  LuaValue? remove(int index) {
    if (index < 0 || index >= _arrayPart.length) {
      return null;
    }

    final value = _arrayPart.removeAt(index);
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
      if (_arrayPart.isNotEmpty) {
        return LuaInteger.fromInt(1);
      } else {
        return _iterationKeys.firstOrNull;
      }
    } else if (index is LuaInteger) {
      final intIndex = index.value.toInt() - 1;
      if (intIndex >= 0 && intIndex < _arrayPart.length - 1) {
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
    if (index >= 0 && index < _arrayPart.length) {
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
    _arrayPart = table._arrayPart.iterator;
    _hashPart = table._hashPart.entries.iterator;
    moveNext();
  }

  final LuaTable table;
  late final Iterator<LuaValue> _arrayPart;
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
    if (_arrayPart.moveNext()) {
      _current =
          LuaTableEntry(LuaInteger.fromInt(_arrayIndex), _arrayPart.current);
      _arrayIndex++;
      return true;
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
  _SequenceIterator(this.table) {
    _arrayPart = table._arrayPart.iterator;
  }

  final LuaTable table;
  late final Iterator<LuaValue> _arrayPart;
  var _index = 1;

  @override
  LuaSequenceEntry get current => LuaSequenceEntry(_index, _arrayPart.current);

  @override
  bool moveNext() {
    if (_arrayPart.moveNext()) {
      _index++;
      return true;
    } else {
      return false;
    }
  }
}
