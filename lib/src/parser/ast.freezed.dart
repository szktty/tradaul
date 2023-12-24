// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ast.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LuaLocation {
  int get line => throw _privateConstructorUsedError;
  int get column => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LuaLocationCopyWith<LuaLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LuaLocationCopyWith<$Res> {
  factory $LuaLocationCopyWith(
          LuaLocation value, $Res Function(LuaLocation) then) =
      _$LuaLocationCopyWithImpl<$Res, LuaLocation>;
  @useResult
  $Res call({int line, int column});
}

/// @nodoc
class _$LuaLocationCopyWithImpl<$Res, $Val extends LuaLocation>
    implements $LuaLocationCopyWith<$Res> {
  _$LuaLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? line = null,
    Object? column = null,
  }) {
    return _then(_value.copyWith(
      line: null == line
          ? _value.line
          : line // ignore: cast_nullable_to_non_nullable
              as int,
      column: null == column
          ? _value.column
          : column // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LuaLocationCopyWith<$Res>
    implements $LuaLocationCopyWith<$Res> {
  factory _$$_LuaLocationCopyWith(
          _$_LuaLocation value, $Res Function(_$_LuaLocation) then) =
      __$$_LuaLocationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int line, int column});
}

/// @nodoc
class __$$_LuaLocationCopyWithImpl<$Res>
    extends _$LuaLocationCopyWithImpl<$Res, _$_LuaLocation>
    implements _$$_LuaLocationCopyWith<$Res> {
  __$$_LuaLocationCopyWithImpl(
      _$_LuaLocation _value, $Res Function(_$_LuaLocation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? line = null,
    Object? column = null,
  }) {
    return _then(_$_LuaLocation(
      null == line
          ? _value.line
          : line // ignore: cast_nullable_to_non_nullable
              as int,
      null == column
          ? _value.column
          : column // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_LuaLocation implements _LuaLocation {
  const _$_LuaLocation(this.line, this.column);

  @override
  final int line;
  @override
  final int column;

  @override
  String toString() {
    return 'LuaLocation(line: $line, column: $column)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LuaLocation &&
            (identical(other.line, line) || other.line == line) &&
            (identical(other.column, column) || other.column == column));
  }

  @override
  int get hashCode => Object.hash(runtimeType, line, column);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LuaLocationCopyWith<_$_LuaLocation> get copyWith =>
      __$$_LuaLocationCopyWithImpl<_$_LuaLocation>(this, _$identity);
}

abstract class _LuaLocation implements LuaLocation {
  const factory _LuaLocation(final int line, final int column) = _$_LuaLocation;

  @override
  int get line;
  @override
  int get column;
  @override
  @JsonKey(ignore: true)
  _$$_LuaLocationCopyWith<_$_LuaLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Chunk {
  LuaLocation get location => throw _privateConstructorUsedError;
  Block get block => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChunkCopyWith<Chunk> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChunkCopyWith<$Res> {
  factory $ChunkCopyWith(Chunk value, $Res Function(Chunk) then) =
      _$ChunkCopyWithImpl<$Res, Chunk>;
  @useResult
  $Res call({LuaLocation location, Block block});

  $LuaLocationCopyWith<$Res> get location;
  $BlockCopyWith<$Res> get block;
}

/// @nodoc
class _$ChunkCopyWithImpl<$Res, $Val extends Chunk>
    implements $ChunkCopyWith<$Res> {
  _$ChunkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? block = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BlockCopyWith<$Res> get block {
    return $BlockCopyWith<$Res>(_value.block, (value) {
      return _then(_value.copyWith(block: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ChunkCopyWith<$Res> implements $ChunkCopyWith<$Res> {
  factory _$$_ChunkCopyWith(_$_Chunk value, $Res Function(_$_Chunk) then) =
      __$$_ChunkCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Block block});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $BlockCopyWith<$Res> get block;
}

/// @nodoc
class __$$_ChunkCopyWithImpl<$Res> extends _$ChunkCopyWithImpl<$Res, _$_Chunk>
    implements _$$_ChunkCopyWith<$Res> {
  __$$_ChunkCopyWithImpl(_$_Chunk _value, $Res Function(_$_Chunk) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? block = null,
  }) {
    return _then(_$_Chunk(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
    ));
  }
}

/// @nodoc

class _$_Chunk implements _Chunk {
  const _$_Chunk({required this.location, required this.block});

  @override
  final LuaLocation location;
  @override
  final Block block;

  @override
  String toString() {
    return 'Chunk(location: $location, block: $block)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Chunk &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.block, block) || other.block == block));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, block);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChunkCopyWith<_$_Chunk> get copyWith =>
      __$$_ChunkCopyWithImpl<_$_Chunk>(this, _$identity);
}

abstract class _Chunk implements Chunk {
  const factory _Chunk(
      {required final LuaLocation location,
      required final Block block}) = _$_Chunk;

  @override
  LuaLocation get location;
  @override
  Block get block;
  @override
  @JsonKey(ignore: true)
  _$$_ChunkCopyWith<_$_Chunk> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Block {
  LuaLocation get location => throw _privateConstructorUsedError;
  List<Node> get stats => throw _privateConstructorUsedError;
  Return? get return_ => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BlockCopyWith<Block> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockCopyWith<$Res> {
  factory $BlockCopyWith(Block value, $Res Function(Block) then) =
      _$BlockCopyWithImpl<$Res, Block>;
  @useResult
  $Res call({LuaLocation location, List<Node> stats, Return? return_});

  $LuaLocationCopyWith<$Res> get location;
  $ReturnCopyWith<$Res>? get return_;
}

/// @nodoc
class _$BlockCopyWithImpl<$Res, $Val extends Block>
    implements $BlockCopyWith<$Res> {
  _$BlockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? stats = null,
    Object? return_ = freezed,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as List<Node>,
      return_: freezed == return_
          ? _value.return_
          : return_ // ignore: cast_nullable_to_non_nullable
              as Return?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ReturnCopyWith<$Res>? get return_ {
    if (_value.return_ == null) {
      return null;
    }

    return $ReturnCopyWith<$Res>(_value.return_!, (value) {
      return _then(_value.copyWith(return_: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_BlockCopyWith<$Res> implements $BlockCopyWith<$Res> {
  factory _$$_BlockCopyWith(_$_Block value, $Res Function(_$_Block) then) =
      __$$_BlockCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, List<Node> stats, Return? return_});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $ReturnCopyWith<$Res>? get return_;
}

/// @nodoc
class __$$_BlockCopyWithImpl<$Res> extends _$BlockCopyWithImpl<$Res, _$_Block>
    implements _$$_BlockCopyWith<$Res> {
  __$$_BlockCopyWithImpl(_$_Block _value, $Res Function(_$_Block) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? stats = null,
    Object? return_ = freezed,
  }) {
    return _then(_$_Block(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      stats: null == stats
          ? _value._stats
          : stats // ignore: cast_nullable_to_non_nullable
              as List<Node>,
      return_: freezed == return_
          ? _value.return_
          : return_ // ignore: cast_nullable_to_non_nullable
              as Return?,
    ));
  }
}

/// @nodoc

class _$_Block implements _Block {
  const _$_Block(
      {required this.location, required final List<Node> stats, this.return_})
      : _stats = stats;

  @override
  final LuaLocation location;
  final List<Node> _stats;
  @override
  List<Node> get stats {
    if (_stats is EqualUnmodifiableListView) return _stats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stats);
  }

  @override
  final Return? return_;

  @override
  String toString() {
    return 'Block(location: $location, stats: $stats, return_: $return_)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Block &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other._stats, _stats) &&
            (identical(other.return_, return_) || other.return_ == return_));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location,
      const DeepCollectionEquality().hash(_stats), return_);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BlockCopyWith<_$_Block> get copyWith =>
      __$$_BlockCopyWithImpl<_$_Block>(this, _$identity);
}

abstract class _Block implements Block {
  const factory _Block(
      {required final LuaLocation location,
      required final List<Node> stats,
      final Return? return_}) = _$_Block;

  @override
  LuaLocation get location;
  @override
  List<Node> get stats;
  @override
  Return? get return_;
  @override
  @JsonKey(ignore: true)
  _$$_BlockCopyWith<_$_Block> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Empty {
  LuaLocation get location => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EmptyCopyWith<Empty> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmptyCopyWith<$Res> {
  factory $EmptyCopyWith(Empty value, $Res Function(Empty) then) =
      _$EmptyCopyWithImpl<$Res, Empty>;
  @useResult
  $Res call({LuaLocation location});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$EmptyCopyWithImpl<$Res, $Val extends Empty>
    implements $EmptyCopyWith<$Res> {
  _$EmptyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_EmptyCopyWith<$Res> implements $EmptyCopyWith<$Res> {
  factory _$$_EmptyCopyWith(_$_Empty value, $Res Function(_$_Empty) then) =
      __$$_EmptyCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_EmptyCopyWithImpl<$Res> extends _$EmptyCopyWithImpl<$Res, _$_Empty>
    implements _$$_EmptyCopyWith<$Res> {
  __$$_EmptyCopyWithImpl(_$_Empty _value, $Res Function(_$_Empty) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
  }) {
    return _then(_$_Empty(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
    ));
  }
}

/// @nodoc

class _$_Empty implements _Empty {
  const _$_Empty({required this.location});

  @override
  final LuaLocation location;

  @override
  String toString() {
    return 'Empty(location: $location)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Empty &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EmptyCopyWith<_$_Empty> get copyWith =>
      __$$_EmptyCopyWithImpl<_$_Empty>(this, _$identity);
}

abstract class _Empty implements Empty {
  const factory _Empty({required final LuaLocation location}) = _$_Empty;

  @override
  LuaLocation get location;
  @override
  @JsonKey(ignore: true)
  _$$_EmptyCopyWith<_$_Empty> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FunctionCallStat {
  LuaLocation get location => throw _privateConstructorUsedError;
  Node get exp => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FunctionCallStatCopyWith<FunctionCallStat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FunctionCallStatCopyWith<$Res> {
  factory $FunctionCallStatCopyWith(
          FunctionCallStat value, $Res Function(FunctionCallStat) then) =
      _$FunctionCallStatCopyWithImpl<$Res, FunctionCallStat>;
  @useResult
  $Res call({LuaLocation location, Node exp});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$FunctionCallStatCopyWithImpl<$Res, $Val extends FunctionCallStat>
    implements $FunctionCallStatCopyWith<$Res> {
  _$FunctionCallStatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? exp = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      exp: null == exp
          ? _value.exp
          : exp // ignore: cast_nullable_to_non_nullable
              as Node,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_FunctionCallStatCopyWith<$Res>
    implements $FunctionCallStatCopyWith<$Res> {
  factory _$$_FunctionCallStatCopyWith(
          _$_FunctionCallStat value, $Res Function(_$_FunctionCallStat) then) =
      __$$_FunctionCallStatCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Node exp});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_FunctionCallStatCopyWithImpl<$Res>
    extends _$FunctionCallStatCopyWithImpl<$Res, _$_FunctionCallStat>
    implements _$$_FunctionCallStatCopyWith<$Res> {
  __$$_FunctionCallStatCopyWithImpl(
      _$_FunctionCallStat _value, $Res Function(_$_FunctionCallStat) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? exp = null,
  }) {
    return _then(_$_FunctionCallStat(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      exp: null == exp
          ? _value.exp
          : exp // ignore: cast_nullable_to_non_nullable
              as Node,
    ));
  }
}

/// @nodoc

class _$_FunctionCallStat implements _FunctionCallStat {
  const _$_FunctionCallStat({required this.location, required this.exp});

  @override
  final LuaLocation location;
  @override
  final Node exp;

  @override
  String toString() {
    return 'FunctionCallStat(location: $location, exp: $exp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FunctionCallStat &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.exp, exp) || other.exp == exp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, exp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FunctionCallStatCopyWith<_$_FunctionCallStat> get copyWith =>
      __$$_FunctionCallStatCopyWithImpl<_$_FunctionCallStat>(this, _$identity);
}

abstract class _FunctionCallStat implements FunctionCallStat {
  const factory _FunctionCallStat(
      {required final LuaLocation location,
      required final Node exp}) = _$_FunctionCallStat;

  @override
  LuaLocation get location;
  @override
  Node get exp;
  @override
  @JsonKey(ignore: true)
  _$$_FunctionCallStatCopyWith<_$_FunctionCallStat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Assignment {
  LuaLocation get location => throw _privateConstructorUsedError;
  List<Node> get varList => throw _privateConstructorUsedError;
  List<Node> get expList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AssignmentCopyWith<Assignment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssignmentCopyWith<$Res> {
  factory $AssignmentCopyWith(
          Assignment value, $Res Function(Assignment) then) =
      _$AssignmentCopyWithImpl<$Res, Assignment>;
  @useResult
  $Res call({LuaLocation location, List<Node> varList, List<Node> expList});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$AssignmentCopyWithImpl<$Res, $Val extends Assignment>
    implements $AssignmentCopyWith<$Res> {
  _$AssignmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? varList = null,
    Object? expList = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      varList: null == varList
          ? _value.varList
          : varList // ignore: cast_nullable_to_non_nullable
              as List<Node>,
      expList: null == expList
          ? _value.expList
          : expList // ignore: cast_nullable_to_non_nullable
              as List<Node>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_AssignmentCopyWith<$Res>
    implements $AssignmentCopyWith<$Res> {
  factory _$$_AssignmentCopyWith(
          _$_Assignment value, $Res Function(_$_Assignment) then) =
      __$$_AssignmentCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, List<Node> varList, List<Node> expList});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_AssignmentCopyWithImpl<$Res>
    extends _$AssignmentCopyWithImpl<$Res, _$_Assignment>
    implements _$$_AssignmentCopyWith<$Res> {
  __$$_AssignmentCopyWithImpl(
      _$_Assignment _value, $Res Function(_$_Assignment) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? varList = null,
    Object? expList = null,
  }) {
    return _then(_$_Assignment(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      varList: null == varList
          ? _value._varList
          : varList // ignore: cast_nullable_to_non_nullable
              as List<Node>,
      expList: null == expList
          ? _value._expList
          : expList // ignore: cast_nullable_to_non_nullable
              as List<Node>,
    ));
  }
}

/// @nodoc

class _$_Assignment implements _Assignment {
  const _$_Assignment(
      {required this.location,
      required final List<Node> varList,
      required final List<Node> expList})
      : _varList = varList,
        _expList = expList;

  @override
  final LuaLocation location;
  final List<Node> _varList;
  @override
  List<Node> get varList {
    if (_varList is EqualUnmodifiableListView) return _varList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_varList);
  }

  final List<Node> _expList;
  @override
  List<Node> get expList {
    if (_expList is EqualUnmodifiableListView) return _expList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expList);
  }

  @override
  String toString() {
    return 'Assignment(location: $location, varList: $varList, expList: $expList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Assignment &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other._varList, _varList) &&
            const DeepCollectionEquality().equals(other._expList, _expList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      location,
      const DeepCollectionEquality().hash(_varList),
      const DeepCollectionEquality().hash(_expList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AssignmentCopyWith<_$_Assignment> get copyWith =>
      __$$_AssignmentCopyWithImpl<_$_Assignment>(this, _$identity);
}

abstract class _Assignment implements Assignment {
  const factory _Assignment(
      {required final LuaLocation location,
      required final List<Node> varList,
      required final List<Node> expList}) = _$_Assignment;

  @override
  LuaLocation get location;
  @override
  List<Node> get varList;
  @override
  List<Node> get expList;
  @override
  @JsonKey(ignore: true)
  _$$_AssignmentCopyWith<_$_Assignment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LocalAssignment {
  LuaLocation get location => throw _privateConstructorUsedError;
  List<AttrName> get attrNameList => throw _privateConstructorUsedError;
  List<Node> get expList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LocalAssignmentCopyWith<LocalAssignment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalAssignmentCopyWith<$Res> {
  factory $LocalAssignmentCopyWith(
          LocalAssignment value, $Res Function(LocalAssignment) then) =
      _$LocalAssignmentCopyWithImpl<$Res, LocalAssignment>;
  @useResult
  $Res call(
      {LuaLocation location, List<AttrName> attrNameList, List<Node> expList});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$LocalAssignmentCopyWithImpl<$Res, $Val extends LocalAssignment>
    implements $LocalAssignmentCopyWith<$Res> {
  _$LocalAssignmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? attrNameList = null,
    Object? expList = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      attrNameList: null == attrNameList
          ? _value.attrNameList
          : attrNameList // ignore: cast_nullable_to_non_nullable
              as List<AttrName>,
      expList: null == expList
          ? _value.expList
          : expList // ignore: cast_nullable_to_non_nullable
              as List<Node>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LocalAssignmentCopyWith<$Res>
    implements $LocalAssignmentCopyWith<$Res> {
  factory _$$_LocalAssignmentCopyWith(
          _$_LocalAssignment value, $Res Function(_$_LocalAssignment) then) =
      __$$_LocalAssignmentCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LuaLocation location, List<AttrName> attrNameList, List<Node> expList});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_LocalAssignmentCopyWithImpl<$Res>
    extends _$LocalAssignmentCopyWithImpl<$Res, _$_LocalAssignment>
    implements _$$_LocalAssignmentCopyWith<$Res> {
  __$$_LocalAssignmentCopyWithImpl(
      _$_LocalAssignment _value, $Res Function(_$_LocalAssignment) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? attrNameList = null,
    Object? expList = null,
  }) {
    return _then(_$_LocalAssignment(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      attrNameList: null == attrNameList
          ? _value._attrNameList
          : attrNameList // ignore: cast_nullable_to_non_nullable
              as List<AttrName>,
      expList: null == expList
          ? _value._expList
          : expList // ignore: cast_nullable_to_non_nullable
              as List<Node>,
    ));
  }
}

/// @nodoc

class _$_LocalAssignment implements _LocalAssignment {
  const _$_LocalAssignment(
      {required this.location,
      required final List<AttrName> attrNameList,
      required final List<Node> expList})
      : _attrNameList = attrNameList,
        _expList = expList;

  @override
  final LuaLocation location;
  final List<AttrName> _attrNameList;
  @override
  List<AttrName> get attrNameList {
    if (_attrNameList is EqualUnmodifiableListView) return _attrNameList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attrNameList);
  }

  final List<Node> _expList;
  @override
  List<Node> get expList {
    if (_expList is EqualUnmodifiableListView) return _expList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expList);
  }

  @override
  String toString() {
    return 'LocalAssignment(location: $location, attrNameList: $attrNameList, expList: $expList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LocalAssignment &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality()
                .equals(other._attrNameList, _attrNameList) &&
            const DeepCollectionEquality().equals(other._expList, _expList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      location,
      const DeepCollectionEquality().hash(_attrNameList),
      const DeepCollectionEquality().hash(_expList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LocalAssignmentCopyWith<_$_LocalAssignment> get copyWith =>
      __$$_LocalAssignmentCopyWithImpl<_$_LocalAssignment>(this, _$identity);
}

abstract class _LocalAssignment implements LocalAssignment {
  const factory _LocalAssignment(
      {required final LuaLocation location,
      required final List<AttrName> attrNameList,
      required final List<Node> expList}) = _$_LocalAssignment;

  @override
  LuaLocation get location;
  @override
  List<AttrName> get attrNameList;
  @override
  List<Node> get expList;
  @override
  @JsonKey(ignore: true)
  _$$_LocalAssignmentCopyWith<_$_LocalAssignment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AttrName {
  LuaLocation get location => throw _privateConstructorUsedError;
  Name get name => throw _privateConstructorUsedError;
  Name? get attr => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AttrNameCopyWith<AttrName> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttrNameCopyWith<$Res> {
  factory $AttrNameCopyWith(AttrName value, $Res Function(AttrName) then) =
      _$AttrNameCopyWithImpl<$Res, AttrName>;
  @useResult
  $Res call({LuaLocation location, Name name, Name? attr});

  $LuaLocationCopyWith<$Res> get location;
  $NameCopyWith<$Res> get name;
  $NameCopyWith<$Res>? get attr;
}

/// @nodoc
class _$AttrNameCopyWithImpl<$Res, $Val extends AttrName>
    implements $AttrNameCopyWith<$Res> {
  _$AttrNameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? name = null,
    Object? attr = freezed,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Name,
      attr: freezed == attr
          ? _value.attr
          : attr // ignore: cast_nullable_to_non_nullable
              as Name?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NameCopyWith<$Res> get name {
    return $NameCopyWith<$Res>(_value.name, (value) {
      return _then(_value.copyWith(name: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NameCopyWith<$Res>? get attr {
    if (_value.attr == null) {
      return null;
    }

    return $NameCopyWith<$Res>(_value.attr!, (value) {
      return _then(_value.copyWith(attr: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_AttrNameCopyWith<$Res> implements $AttrNameCopyWith<$Res> {
  factory _$$_AttrNameCopyWith(
          _$_AttrName value, $Res Function(_$_AttrName) then) =
      __$$_AttrNameCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Name name, Name? attr});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $NameCopyWith<$Res> get name;
  @override
  $NameCopyWith<$Res>? get attr;
}

/// @nodoc
class __$$_AttrNameCopyWithImpl<$Res>
    extends _$AttrNameCopyWithImpl<$Res, _$_AttrName>
    implements _$$_AttrNameCopyWith<$Res> {
  __$$_AttrNameCopyWithImpl(
      _$_AttrName _value, $Res Function(_$_AttrName) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? name = null,
    Object? attr = freezed,
  }) {
    return _then(_$_AttrName(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Name,
      attr: freezed == attr
          ? _value.attr
          : attr // ignore: cast_nullable_to_non_nullable
              as Name?,
    ));
  }
}

/// @nodoc

class _$_AttrName implements _AttrName {
  const _$_AttrName({required this.location, required this.name, this.attr});

  @override
  final LuaLocation location;
  @override
  final Name name;
  @override
  final Name? attr;

  @override
  String toString() {
    return 'AttrName(location: $location, name: $name, attr: $attr)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AttrName &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.attr, attr) || other.attr == attr));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, name, attr);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AttrNameCopyWith<_$_AttrName> get copyWith =>
      __$$_AttrNameCopyWithImpl<_$_AttrName>(this, _$identity);
}

abstract class _AttrName implements AttrName {
  const factory _AttrName(
      {required final LuaLocation location,
      required final Name name,
      final Name? attr}) = _$_AttrName;

  @override
  LuaLocation get location;
  @override
  Name get name;
  @override
  Name? get attr;
  @override
  @JsonKey(ignore: true)
  _$$_AttrNameCopyWith<_$_AttrName> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NumericFor {
  LuaLocation get location => throw _privateConstructorUsedError;
  Name get name => throw _privateConstructorUsedError;
  Node get start => throw _privateConstructorUsedError;
  Node get end => throw _privateConstructorUsedError;
  Block get block => throw _privateConstructorUsedError;
  Node? get step => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NumericForCopyWith<NumericFor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NumericForCopyWith<$Res> {
  factory $NumericForCopyWith(
          NumericFor value, $Res Function(NumericFor) then) =
      _$NumericForCopyWithImpl<$Res, NumericFor>;
  @useResult
  $Res call(
      {LuaLocation location,
      Name name,
      Node start,
      Node end,
      Block block,
      Node? step});

  $LuaLocationCopyWith<$Res> get location;
  $NameCopyWith<$Res> get name;
  $BlockCopyWith<$Res> get block;
}

/// @nodoc
class _$NumericForCopyWithImpl<$Res, $Val extends NumericFor>
    implements $NumericForCopyWith<$Res> {
  _$NumericForCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? name = null,
    Object? start = null,
    Object? end = null,
    Object? block = null,
    Object? step = freezed,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Name,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as Node,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as Node,
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
      step: freezed == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as Node?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NameCopyWith<$Res> get name {
    return $NameCopyWith<$Res>(_value.name, (value) {
      return _then(_value.copyWith(name: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BlockCopyWith<$Res> get block {
    return $BlockCopyWith<$Res>(_value.block, (value) {
      return _then(_value.copyWith(block: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_NumericForCopyWith<$Res>
    implements $NumericForCopyWith<$Res> {
  factory _$$_NumericForCopyWith(
          _$_NumericFor value, $Res Function(_$_NumericFor) then) =
      __$$_NumericForCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LuaLocation location,
      Name name,
      Node start,
      Node end,
      Block block,
      Node? step});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $NameCopyWith<$Res> get name;
  @override
  $BlockCopyWith<$Res> get block;
}

/// @nodoc
class __$$_NumericForCopyWithImpl<$Res>
    extends _$NumericForCopyWithImpl<$Res, _$_NumericFor>
    implements _$$_NumericForCopyWith<$Res> {
  __$$_NumericForCopyWithImpl(
      _$_NumericFor _value, $Res Function(_$_NumericFor) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? name = null,
    Object? start = null,
    Object? end = null,
    Object? block = null,
    Object? step = freezed,
  }) {
    return _then(_$_NumericFor(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Name,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as Node,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as Node,
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
      step: freezed == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as Node?,
    ));
  }
}

/// @nodoc

class _$_NumericFor implements _NumericFor {
  const _$_NumericFor(
      {required this.location,
      required this.name,
      required this.start,
      required this.end,
      required this.block,
      this.step});

  @override
  final LuaLocation location;
  @override
  final Name name;
  @override
  final Node start;
  @override
  final Node end;
  @override
  final Block block;
  @override
  final Node? step;

  @override
  String toString() {
    return 'NumericFor(location: $location, name: $name, start: $start, end: $end, block: $block, step: $step)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NumericFor &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end) &&
            (identical(other.block, block) || other.block == block) &&
            (identical(other.step, step) || other.step == step));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, location, name, start, end, block, step);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NumericForCopyWith<_$_NumericFor> get copyWith =>
      __$$_NumericForCopyWithImpl<_$_NumericFor>(this, _$identity);
}

abstract class _NumericFor implements NumericFor {
  const factory _NumericFor(
      {required final LuaLocation location,
      required final Name name,
      required final Node start,
      required final Node end,
      required final Block block,
      final Node? step}) = _$_NumericFor;

  @override
  LuaLocation get location;
  @override
  Name get name;
  @override
  Node get start;
  @override
  Node get end;
  @override
  Block get block;
  @override
  Node? get step;
  @override
  @JsonKey(ignore: true)
  _$$_NumericForCopyWith<_$_NumericFor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GenericFor {
  LuaLocation get location => throw _privateConstructorUsedError;
  List<Name> get names => throw _privateConstructorUsedError;
  List<Node> get exps => throw _privateConstructorUsedError;
  Block get block => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GenericForCopyWith<GenericFor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenericForCopyWith<$Res> {
  factory $GenericForCopyWith(
          GenericFor value, $Res Function(GenericFor) then) =
      _$GenericForCopyWithImpl<$Res, GenericFor>;
  @useResult
  $Res call(
      {LuaLocation location, List<Name> names, List<Node> exps, Block block});

  $LuaLocationCopyWith<$Res> get location;
  $BlockCopyWith<$Res> get block;
}

/// @nodoc
class _$GenericForCopyWithImpl<$Res, $Val extends GenericFor>
    implements $GenericForCopyWith<$Res> {
  _$GenericForCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? names = null,
    Object? exps = null,
    Object? block = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      names: null == names
          ? _value.names
          : names // ignore: cast_nullable_to_non_nullable
              as List<Name>,
      exps: null == exps
          ? _value.exps
          : exps // ignore: cast_nullable_to_non_nullable
              as List<Node>,
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BlockCopyWith<$Res> get block {
    return $BlockCopyWith<$Res>(_value.block, (value) {
      return _then(_value.copyWith(block: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_GenericForCopyWith<$Res>
    implements $GenericForCopyWith<$Res> {
  factory _$$_GenericForCopyWith(
          _$_GenericFor value, $Res Function(_$_GenericFor) then) =
      __$$_GenericForCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LuaLocation location, List<Name> names, List<Node> exps, Block block});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $BlockCopyWith<$Res> get block;
}

/// @nodoc
class __$$_GenericForCopyWithImpl<$Res>
    extends _$GenericForCopyWithImpl<$Res, _$_GenericFor>
    implements _$$_GenericForCopyWith<$Res> {
  __$$_GenericForCopyWithImpl(
      _$_GenericFor _value, $Res Function(_$_GenericFor) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? names = null,
    Object? exps = null,
    Object? block = null,
  }) {
    return _then(_$_GenericFor(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      names: null == names
          ? _value._names
          : names // ignore: cast_nullable_to_non_nullable
              as List<Name>,
      exps: null == exps
          ? _value._exps
          : exps // ignore: cast_nullable_to_non_nullable
              as List<Node>,
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
    ));
  }
}

/// @nodoc

class _$_GenericFor implements _GenericFor {
  const _$_GenericFor(
      {required this.location,
      required final List<Name> names,
      required final List<Node> exps,
      required this.block})
      : _names = names,
        _exps = exps;

  @override
  final LuaLocation location;
  final List<Name> _names;
  @override
  List<Name> get names {
    if (_names is EqualUnmodifiableListView) return _names;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_names);
  }

  final List<Node> _exps;
  @override
  List<Node> get exps {
    if (_exps is EqualUnmodifiableListView) return _exps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exps);
  }

  @override
  final Block block;

  @override
  String toString() {
    return 'GenericFor(location: $location, names: $names, exps: $exps, block: $block)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GenericFor &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other._names, _names) &&
            const DeepCollectionEquality().equals(other._exps, _exps) &&
            (identical(other.block, block) || other.block == block));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      location,
      const DeepCollectionEquality().hash(_names),
      const DeepCollectionEquality().hash(_exps),
      block);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GenericForCopyWith<_$_GenericFor> get copyWith =>
      __$$_GenericForCopyWithImpl<_$_GenericFor>(this, _$identity);
}

abstract class _GenericFor implements GenericFor {
  const factory _GenericFor(
      {required final LuaLocation location,
      required final List<Name> names,
      required final List<Node> exps,
      required final Block block}) = _$_GenericFor;

  @override
  LuaLocation get location;
  @override
  List<Name> get names;
  @override
  List<Node> get exps;
  @override
  Block get block;
  @override
  @JsonKey(ignore: true)
  _$$_GenericForCopyWith<_$_GenericFor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BinExp {
  LuaLocation get location => throw _privateConstructorUsedError;
  Node get left => throw _privateConstructorUsedError;
  BinOp get op => throw _privateConstructorUsedError;
  Node get right => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BinExpCopyWith<BinExp> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BinExpCopyWith<$Res> {
  factory $BinExpCopyWith(BinExp value, $Res Function(BinExp) then) =
      _$BinExpCopyWithImpl<$Res, BinExp>;
  @useResult
  $Res call({LuaLocation location, Node left, BinOp op, Node right});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$BinExpCopyWithImpl<$Res, $Val extends BinExp>
    implements $BinExpCopyWith<$Res> {
  _$BinExpCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? left = null,
    Object? op = null,
    Object? right = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      left: null == left
          ? _value.left
          : left // ignore: cast_nullable_to_non_nullable
              as Node,
      op: null == op
          ? _value.op
          : op // ignore: cast_nullable_to_non_nullable
              as BinOp,
      right: null == right
          ? _value.right
          : right // ignore: cast_nullable_to_non_nullable
              as Node,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_BinExpCopyWith<$Res> implements $BinExpCopyWith<$Res> {
  factory _$$_BinExpCopyWith(_$_BinExp value, $Res Function(_$_BinExp) then) =
      __$$_BinExpCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Node left, BinOp op, Node right});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_BinExpCopyWithImpl<$Res>
    extends _$BinExpCopyWithImpl<$Res, _$_BinExp>
    implements _$$_BinExpCopyWith<$Res> {
  __$$_BinExpCopyWithImpl(_$_BinExp _value, $Res Function(_$_BinExp) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? left = null,
    Object? op = null,
    Object? right = null,
  }) {
    return _then(_$_BinExp(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      left: null == left
          ? _value.left
          : left // ignore: cast_nullable_to_non_nullable
              as Node,
      op: null == op
          ? _value.op
          : op // ignore: cast_nullable_to_non_nullable
              as BinOp,
      right: null == right
          ? _value.right
          : right // ignore: cast_nullable_to_non_nullable
              as Node,
    ));
  }
}

/// @nodoc

class _$_BinExp implements _BinExp {
  const _$_BinExp(
      {required this.location,
      required this.left,
      required this.op,
      required this.right});

  @override
  final LuaLocation location;
  @override
  final Node left;
  @override
  final BinOp op;
  @override
  final Node right;

  @override
  String toString() {
    return 'BinExp(location: $location, left: $left, op: $op, right: $right)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BinExp &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.left, left) || other.left == left) &&
            (identical(other.op, op) || other.op == op) &&
            (identical(other.right, right) || other.right == right));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, left, op, right);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BinExpCopyWith<_$_BinExp> get copyWith =>
      __$$_BinExpCopyWithImpl<_$_BinExp>(this, _$identity);
}

abstract class _BinExp implements BinExp {
  const factory _BinExp(
      {required final LuaLocation location,
      required final Node left,
      required final BinOp op,
      required final Node right}) = _$_BinExp;

  @override
  LuaLocation get location;
  @override
  Node get left;
  @override
  BinOp get op;
  @override
  Node get right;
  @override
  @JsonKey(ignore: true)
  _$$_BinExpCopyWith<_$_BinExp> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UnExp {
  LuaLocation get location => throw _privateConstructorUsedError;
  UnOp get op => throw _privateConstructorUsedError;
  Node get exp => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UnExpCopyWith<UnExp> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnExpCopyWith<$Res> {
  factory $UnExpCopyWith(UnExp value, $Res Function(UnExp) then) =
      _$UnExpCopyWithImpl<$Res, UnExp>;
  @useResult
  $Res call({LuaLocation location, UnOp op, Node exp});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$UnExpCopyWithImpl<$Res, $Val extends UnExp>
    implements $UnExpCopyWith<$Res> {
  _$UnExpCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? op = null,
    Object? exp = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      op: null == op
          ? _value.op
          : op // ignore: cast_nullable_to_non_nullable
              as UnOp,
      exp: null == exp
          ? _value.exp
          : exp // ignore: cast_nullable_to_non_nullable
              as Node,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_UnExpCopyWith<$Res> implements $UnExpCopyWith<$Res> {
  factory _$$_UnExpCopyWith(_$_UnExp value, $Res Function(_$_UnExp) then) =
      __$$_UnExpCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, UnOp op, Node exp});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_UnExpCopyWithImpl<$Res> extends _$UnExpCopyWithImpl<$Res, _$_UnExp>
    implements _$$_UnExpCopyWith<$Res> {
  __$$_UnExpCopyWithImpl(_$_UnExp _value, $Res Function(_$_UnExp) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? op = null,
    Object? exp = null,
  }) {
    return _then(_$_UnExp(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      op: null == op
          ? _value.op
          : op // ignore: cast_nullable_to_non_nullable
              as UnOp,
      exp: null == exp
          ? _value.exp
          : exp // ignore: cast_nullable_to_non_nullable
              as Node,
    ));
  }
}

/// @nodoc

class _$_UnExp implements _UnExp {
  const _$_UnExp({required this.location, required this.op, required this.exp});

  @override
  final LuaLocation location;
  @override
  final UnOp op;
  @override
  final Node exp;

  @override
  String toString() {
    return 'UnExp(location: $location, op: $op, exp: $exp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UnExp &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.op, op) || other.op == op) &&
            (identical(other.exp, exp) || other.exp == exp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, op, exp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UnExpCopyWith<_$_UnExp> get copyWith =>
      __$$_UnExpCopyWithImpl<_$_UnExp>(this, _$identity);
}

abstract class _UnExp implements UnExp {
  const factory _UnExp(
      {required final LuaLocation location,
      required final UnOp op,
      required final Node exp}) = _$_UnExp;

  @override
  LuaLocation get location;
  @override
  UnOp get op;
  @override
  Node get exp;
  @override
  @JsonKey(ignore: true)
  _$$_UnExpCopyWith<_$_UnExp> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Label {
  LuaLocation get location => throw _privateConstructorUsedError;
  Name get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LabelCopyWith<Label> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabelCopyWith<$Res> {
  factory $LabelCopyWith(Label value, $Res Function(Label) then) =
      _$LabelCopyWithImpl<$Res, Label>;
  @useResult
  $Res call({LuaLocation location, Name name});

  $LuaLocationCopyWith<$Res> get location;
  $NameCopyWith<$Res> get name;
}

/// @nodoc
class _$LabelCopyWithImpl<$Res, $Val extends Label>
    implements $LabelCopyWith<$Res> {
  _$LabelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Name,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NameCopyWith<$Res> get name {
    return $NameCopyWith<$Res>(_value.name, (value) {
      return _then(_value.copyWith(name: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LabelCopyWith<$Res> implements $LabelCopyWith<$Res> {
  factory _$$_LabelCopyWith(_$_Label value, $Res Function(_$_Label) then) =
      __$$_LabelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Name name});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $NameCopyWith<$Res> get name;
}

/// @nodoc
class __$$_LabelCopyWithImpl<$Res> extends _$LabelCopyWithImpl<$Res, _$_Label>
    implements _$$_LabelCopyWith<$Res> {
  __$$_LabelCopyWithImpl(_$_Label _value, $Res Function(_$_Label) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? name = null,
  }) {
    return _then(_$_Label(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Name,
    ));
  }
}

/// @nodoc

class _$_Label implements _Label {
  const _$_Label({required this.location, required this.name});

  @override
  final LuaLocation location;
  @override
  final Name name;

  @override
  String toString() {
    return 'Label(location: $location, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Label &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LabelCopyWith<_$_Label> get copyWith =>
      __$$_LabelCopyWithImpl<_$_Label>(this, _$identity);
}

abstract class _Label implements Label {
  const factory _Label(
      {required final LuaLocation location,
      required final Name name}) = _$_Label;

  @override
  LuaLocation get location;
  @override
  Name get name;
  @override
  @JsonKey(ignore: true)
  _$$_LabelCopyWith<_$_Label> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Break {
  LuaLocation get location => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BreakCopyWith<Break> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreakCopyWith<$Res> {
  factory $BreakCopyWith(Break value, $Res Function(Break) then) =
      _$BreakCopyWithImpl<$Res, Break>;
  @useResult
  $Res call({LuaLocation location});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$BreakCopyWithImpl<$Res, $Val extends Break>
    implements $BreakCopyWith<$Res> {
  _$BreakCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_BreakCopyWith<$Res> implements $BreakCopyWith<$Res> {
  factory _$$_BreakCopyWith(_$_Break value, $Res Function(_$_Break) then) =
      __$$_BreakCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_BreakCopyWithImpl<$Res> extends _$BreakCopyWithImpl<$Res, _$_Break>
    implements _$$_BreakCopyWith<$Res> {
  __$$_BreakCopyWithImpl(_$_Break _value, $Res Function(_$_Break) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
  }) {
    return _then(_$_Break(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
    ));
  }
}

/// @nodoc

class _$_Break implements _Break {
  const _$_Break({required this.location});

  @override
  final LuaLocation location;

  @override
  String toString() {
    return 'Break(location: $location)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Break &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BreakCopyWith<_$_Break> get copyWith =>
      __$$_BreakCopyWithImpl<_$_Break>(this, _$identity);
}

abstract class _Break implements Break {
  const factory _Break({required final LuaLocation location}) = _$_Break;

  @override
  LuaLocation get location;
  @override
  @JsonKey(ignore: true)
  _$$_BreakCopyWith<_$_Break> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Goto {
  LuaLocation get location => throw _privateConstructorUsedError;
  Name get label => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GotoCopyWith<Goto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GotoCopyWith<$Res> {
  factory $GotoCopyWith(Goto value, $Res Function(Goto) then) =
      _$GotoCopyWithImpl<$Res, Goto>;
  @useResult
  $Res call({LuaLocation location, Name label});

  $LuaLocationCopyWith<$Res> get location;
  $NameCopyWith<$Res> get label;
}

/// @nodoc
class _$GotoCopyWithImpl<$Res, $Val extends Goto>
    implements $GotoCopyWith<$Res> {
  _$GotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? label = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as Name,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NameCopyWith<$Res> get label {
    return $NameCopyWith<$Res>(_value.label, (value) {
      return _then(_value.copyWith(label: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_GotoCopyWith<$Res> implements $GotoCopyWith<$Res> {
  factory _$$_GotoCopyWith(_$_Goto value, $Res Function(_$_Goto) then) =
      __$$_GotoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Name label});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $NameCopyWith<$Res> get label;
}

/// @nodoc
class __$$_GotoCopyWithImpl<$Res> extends _$GotoCopyWithImpl<$Res, _$_Goto>
    implements _$$_GotoCopyWith<$Res> {
  __$$_GotoCopyWithImpl(_$_Goto _value, $Res Function(_$_Goto) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? label = null,
  }) {
    return _then(_$_Goto(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as Name,
    ));
  }
}

/// @nodoc

class _$_Goto implements _Goto {
  const _$_Goto({required this.location, required this.label});

  @override
  final LuaLocation location;
  @override
  final Name label;

  @override
  String toString() {
    return 'Goto(location: $location, label: $label)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Goto &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.label, label) || other.label == label));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, label);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GotoCopyWith<_$_Goto> get copyWith =>
      __$$_GotoCopyWithImpl<_$_Goto>(this, _$identity);
}

abstract class _Goto implements Goto {
  const factory _Goto(
      {required final LuaLocation location,
      required final Name label}) = _$_Goto;

  @override
  LuaLocation get location;
  @override
  Name get label;
  @override
  @JsonKey(ignore: true)
  _$$_GotoCopyWith<_$_Goto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Do {
  LuaLocation get location => throw _privateConstructorUsedError;
  Block get block => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DoCopyWith<Do> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DoCopyWith<$Res> {
  factory $DoCopyWith(Do value, $Res Function(Do) then) =
      _$DoCopyWithImpl<$Res, Do>;
  @useResult
  $Res call({LuaLocation location, Block block});

  $LuaLocationCopyWith<$Res> get location;
  $BlockCopyWith<$Res> get block;
}

/// @nodoc
class _$DoCopyWithImpl<$Res, $Val extends Do> implements $DoCopyWith<$Res> {
  _$DoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? block = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BlockCopyWith<$Res> get block {
    return $BlockCopyWith<$Res>(_value.block, (value) {
      return _then(_value.copyWith(block: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_DoCopyWith<$Res> implements $DoCopyWith<$Res> {
  factory _$$_DoCopyWith(_$_Do value, $Res Function(_$_Do) then) =
      __$$_DoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Block block});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $BlockCopyWith<$Res> get block;
}

/// @nodoc
class __$$_DoCopyWithImpl<$Res> extends _$DoCopyWithImpl<$Res, _$_Do>
    implements _$$_DoCopyWith<$Res> {
  __$$_DoCopyWithImpl(_$_Do _value, $Res Function(_$_Do) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? block = null,
  }) {
    return _then(_$_Do(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
    ));
  }
}

/// @nodoc

class _$_Do implements _Do {
  const _$_Do({required this.location, required this.block});

  @override
  final LuaLocation location;
  @override
  final Block block;

  @override
  String toString() {
    return 'Do(location: $location, block: $block)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Do &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.block, block) || other.block == block));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, block);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DoCopyWith<_$_Do> get copyWith =>
      __$$_DoCopyWithImpl<_$_Do>(this, _$identity);
}

abstract class _Do implements Do {
  const factory _Do(
      {required final LuaLocation location,
      required final Block block}) = _$_Do;

  @override
  LuaLocation get location;
  @override
  Block get block;
  @override
  @JsonKey(ignore: true)
  _$$_DoCopyWith<_$_Do> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$While {
  LuaLocation get location => throw _privateConstructorUsedError;
  Node get condition => throw _privateConstructorUsedError;
  Block get block => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WhileCopyWith<While> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WhileCopyWith<$Res> {
  factory $WhileCopyWith(While value, $Res Function(While) then) =
      _$WhileCopyWithImpl<$Res, While>;
  @useResult
  $Res call({LuaLocation location, Node condition, Block block});

  $LuaLocationCopyWith<$Res> get location;
  $BlockCopyWith<$Res> get block;
}

/// @nodoc
class _$WhileCopyWithImpl<$Res, $Val extends While>
    implements $WhileCopyWith<$Res> {
  _$WhileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? condition = null,
    Object? block = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as Node,
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BlockCopyWith<$Res> get block {
    return $BlockCopyWith<$Res>(_value.block, (value) {
      return _then(_value.copyWith(block: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_WhileCopyWith<$Res> implements $WhileCopyWith<$Res> {
  factory _$$_WhileCopyWith(_$_While value, $Res Function(_$_While) then) =
      __$$_WhileCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Node condition, Block block});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $BlockCopyWith<$Res> get block;
}

/// @nodoc
class __$$_WhileCopyWithImpl<$Res> extends _$WhileCopyWithImpl<$Res, _$_While>
    implements _$$_WhileCopyWith<$Res> {
  __$$_WhileCopyWithImpl(_$_While _value, $Res Function(_$_While) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? condition = null,
    Object? block = null,
  }) {
    return _then(_$_While(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as Node,
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
    ));
  }
}

/// @nodoc

class _$_While implements _While {
  const _$_While(
      {required this.location, required this.condition, required this.block});

  @override
  final LuaLocation location;
  @override
  final Node condition;
  @override
  final Block block;

  @override
  String toString() {
    return 'While(location: $location, condition: $condition, block: $block)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_While &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.block, block) || other.block == block));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, condition, block);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WhileCopyWith<_$_While> get copyWith =>
      __$$_WhileCopyWithImpl<_$_While>(this, _$identity);
}

abstract class _While implements While {
  const factory _While(
      {required final LuaLocation location,
      required final Node condition,
      required final Block block}) = _$_While;

  @override
  LuaLocation get location;
  @override
  Node get condition;
  @override
  Block get block;
  @override
  @JsonKey(ignore: true)
  _$$_WhileCopyWith<_$_While> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Repeat {
  LuaLocation get location => throw _privateConstructorUsedError;
  Block get block => throw _privateConstructorUsedError;
  Node get condition => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RepeatCopyWith<Repeat> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepeatCopyWith<$Res> {
  factory $RepeatCopyWith(Repeat value, $Res Function(Repeat) then) =
      _$RepeatCopyWithImpl<$Res, Repeat>;
  @useResult
  $Res call({LuaLocation location, Block block, Node condition});

  $LuaLocationCopyWith<$Res> get location;
  $BlockCopyWith<$Res> get block;
}

/// @nodoc
class _$RepeatCopyWithImpl<$Res, $Val extends Repeat>
    implements $RepeatCopyWith<$Res> {
  _$RepeatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? block = null,
    Object? condition = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as Node,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BlockCopyWith<$Res> get block {
    return $BlockCopyWith<$Res>(_value.block, (value) {
      return _then(_value.copyWith(block: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_RepeatCopyWith<$Res> implements $RepeatCopyWith<$Res> {
  factory _$$_RepeatCopyWith(_$_Repeat value, $Res Function(_$_Repeat) then) =
      __$$_RepeatCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Block block, Node condition});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $BlockCopyWith<$Res> get block;
}

/// @nodoc
class __$$_RepeatCopyWithImpl<$Res>
    extends _$RepeatCopyWithImpl<$Res, _$_Repeat>
    implements _$$_RepeatCopyWith<$Res> {
  __$$_RepeatCopyWithImpl(_$_Repeat _value, $Res Function(_$_Repeat) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? block = null,
    Object? condition = null,
  }) {
    return _then(_$_Repeat(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as Node,
    ));
  }
}

/// @nodoc

class _$_Repeat implements _Repeat {
  const _$_Repeat(
      {required this.location, required this.block, required this.condition});

  @override
  final LuaLocation location;
  @override
  final Block block;
  @override
  final Node condition;

  @override
  String toString() {
    return 'Repeat(location: $location, block: $block, condition: $condition)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Repeat &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.block, block) || other.block == block) &&
            (identical(other.condition, condition) ||
                other.condition == condition));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, block, condition);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RepeatCopyWith<_$_Repeat> get copyWith =>
      __$$_RepeatCopyWithImpl<_$_Repeat>(this, _$identity);
}

abstract class _Repeat implements Repeat {
  const factory _Repeat(
      {required final LuaLocation location,
      required final Block block,
      required final Node condition}) = _$_Repeat;

  @override
  LuaLocation get location;
  @override
  Block get block;
  @override
  Node get condition;
  @override
  @JsonKey(ignore: true)
  _$$_RepeatCopyWith<_$_Repeat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$If {
  LuaLocation get location => throw _privateConstructorUsedError;
  List<IfCondition> get conditions => throw _privateConstructorUsedError;
  Node? get else_ => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $IfCopyWith<If> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IfCopyWith<$Res> {
  factory $IfCopyWith(If value, $Res Function(If) then) =
      _$IfCopyWithImpl<$Res, If>;
  @useResult
  $Res call({LuaLocation location, List<IfCondition> conditions, Node? else_});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$IfCopyWithImpl<$Res, $Val extends If> implements $IfCopyWith<$Res> {
  _$IfCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? conditions = null,
    Object? else_ = freezed,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      conditions: null == conditions
          ? _value.conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as List<IfCondition>,
      else_: freezed == else_
          ? _value.else_
          : else_ // ignore: cast_nullable_to_non_nullable
              as Node?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_IfCopyWith<$Res> implements $IfCopyWith<$Res> {
  factory _$$_IfCopyWith(_$_If value, $Res Function(_$_If) then) =
      __$$_IfCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, List<IfCondition> conditions, Node? else_});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_IfCopyWithImpl<$Res> extends _$IfCopyWithImpl<$Res, _$_If>
    implements _$$_IfCopyWith<$Res> {
  __$$_IfCopyWithImpl(_$_If _value, $Res Function(_$_If) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? conditions = null,
    Object? else_ = freezed,
  }) {
    return _then(_$_If(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      conditions: null == conditions
          ? _value._conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as List<IfCondition>,
      else_: freezed == else_
          ? _value.else_
          : else_ // ignore: cast_nullable_to_non_nullable
              as Node?,
    ));
  }
}

/// @nodoc

class _$_If implements _If {
  const _$_If(
      {required this.location,
      required final List<IfCondition> conditions,
      this.else_})
      : _conditions = conditions;

  @override
  final LuaLocation location;
  final List<IfCondition> _conditions;
  @override
  List<IfCondition> get conditions {
    if (_conditions is EqualUnmodifiableListView) return _conditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conditions);
  }

  @override
  final Node? else_;

  @override
  String toString() {
    return 'If(location: $location, conditions: $conditions, else_: $else_)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_If &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality()
                .equals(other._conditions, _conditions) &&
            (identical(other.else_, else_) || other.else_ == else_));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location,
      const DeepCollectionEquality().hash(_conditions), else_);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_IfCopyWith<_$_If> get copyWith =>
      __$$_IfCopyWithImpl<_$_If>(this, _$identity);
}

abstract class _If implements If {
  const factory _If(
      {required final LuaLocation location,
      required final List<IfCondition> conditions,
      final Node? else_}) = _$_If;

  @override
  LuaLocation get location;
  @override
  List<IfCondition> get conditions;
  @override
  Node? get else_;
  @override
  @JsonKey(ignore: true)
  _$$_IfCopyWith<_$_If> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$IfCondition {
  LuaLocation get location => throw _privateConstructorUsedError;
  Node get condition => throw _privateConstructorUsedError;
  Block get block => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $IfConditionCopyWith<IfCondition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IfConditionCopyWith<$Res> {
  factory $IfConditionCopyWith(
          IfCondition value, $Res Function(IfCondition) then) =
      _$IfConditionCopyWithImpl<$Res, IfCondition>;
  @useResult
  $Res call({LuaLocation location, Node condition, Block block});

  $LuaLocationCopyWith<$Res> get location;
  $BlockCopyWith<$Res> get block;
}

/// @nodoc
class _$IfConditionCopyWithImpl<$Res, $Val extends IfCondition>
    implements $IfConditionCopyWith<$Res> {
  _$IfConditionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? condition = null,
    Object? block = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as Node,
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BlockCopyWith<$Res> get block {
    return $BlockCopyWith<$Res>(_value.block, (value) {
      return _then(_value.copyWith(block: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_IfConditionCopyWith<$Res>
    implements $IfConditionCopyWith<$Res> {
  factory _$$_IfConditionCopyWith(
          _$_IfCondition value, $Res Function(_$_IfCondition) then) =
      __$$_IfConditionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Node condition, Block block});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $BlockCopyWith<$Res> get block;
}

/// @nodoc
class __$$_IfConditionCopyWithImpl<$Res>
    extends _$IfConditionCopyWithImpl<$Res, _$_IfCondition>
    implements _$$_IfConditionCopyWith<$Res> {
  __$$_IfConditionCopyWithImpl(
      _$_IfCondition _value, $Res Function(_$_IfCondition) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? condition = null,
    Object? block = null,
  }) {
    return _then(_$_IfCondition(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as Node,
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
    ));
  }
}

/// @nodoc

class _$_IfCondition implements _IfCondition {
  const _$_IfCondition(
      {required this.location, required this.condition, required this.block});

  @override
  final LuaLocation location;
  @override
  final Node condition;
  @override
  final Block block;

  @override
  String toString() {
    return 'IfCondition(location: $location, condition: $condition, block: $block)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_IfCondition &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.block, block) || other.block == block));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, condition, block);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_IfConditionCopyWith<_$_IfCondition> get copyWith =>
      __$$_IfConditionCopyWithImpl<_$_IfCondition>(this, _$identity);
}

abstract class _IfCondition implements IfCondition {
  const factory _IfCondition(
      {required final LuaLocation location,
      required final Node condition,
      required final Block block}) = _$_IfCondition;

  @override
  LuaLocation get location;
  @override
  Node get condition;
  @override
  Block get block;
  @override
  @JsonKey(ignore: true)
  _$$_IfConditionCopyWith<_$_IfCondition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LiteralNil {
  LuaLocation get location => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LiteralNilCopyWith<LiteralNil> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiteralNilCopyWith<$Res> {
  factory $LiteralNilCopyWith(
          LiteralNil value, $Res Function(LiteralNil) then) =
      _$LiteralNilCopyWithImpl<$Res, LiteralNil>;
  @useResult
  $Res call({LuaLocation location});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$LiteralNilCopyWithImpl<$Res, $Val extends LiteralNil>
    implements $LiteralNilCopyWith<$Res> {
  _$LiteralNilCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LiteralNilCopyWith<$Res>
    implements $LiteralNilCopyWith<$Res> {
  factory _$$_LiteralNilCopyWith(
          _$_LiteralNil value, $Res Function(_$_LiteralNil) then) =
      __$$_LiteralNilCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_LiteralNilCopyWithImpl<$Res>
    extends _$LiteralNilCopyWithImpl<$Res, _$_LiteralNil>
    implements _$$_LiteralNilCopyWith<$Res> {
  __$$_LiteralNilCopyWithImpl(
      _$_LiteralNil _value, $Res Function(_$_LiteralNil) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
  }) {
    return _then(_$_LiteralNil(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
    ));
  }
}

/// @nodoc

class _$_LiteralNil implements _LiteralNil {
  const _$_LiteralNil({required this.location});

  @override
  final LuaLocation location;

  @override
  String toString() {
    return 'LiteralNil(location: $location)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LiteralNil &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LiteralNilCopyWith<_$_LiteralNil> get copyWith =>
      __$$_LiteralNilCopyWithImpl<_$_LiteralNil>(this, _$identity);
}

abstract class _LiteralNil implements LiteralNil {
  const factory _LiteralNil({required final LuaLocation location}) =
      _$_LiteralNil;

  @override
  LuaLocation get location;
  @override
  @JsonKey(ignore: true)
  _$$_LiteralNilCopyWith<_$_LiteralNil> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LiteralString {
  LuaLocation get location => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LiteralStringCopyWith<LiteralString> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiteralStringCopyWith<$Res> {
  factory $LiteralStringCopyWith(
          LiteralString value, $Res Function(LiteralString) then) =
      _$LiteralStringCopyWithImpl<$Res, LiteralString>;
  @useResult
  $Res call({LuaLocation location, String value});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$LiteralStringCopyWithImpl<$Res, $Val extends LiteralString>
    implements $LiteralStringCopyWith<$Res> {
  _$LiteralStringCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LiteralStringCopyWith<$Res>
    implements $LiteralStringCopyWith<$Res> {
  factory _$$_LiteralStringCopyWith(
          _$_LiteralString value, $Res Function(_$_LiteralString) then) =
      __$$_LiteralStringCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, String value});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_LiteralStringCopyWithImpl<$Res>
    extends _$LiteralStringCopyWithImpl<$Res, _$_LiteralString>
    implements _$$_LiteralStringCopyWith<$Res> {
  __$$_LiteralStringCopyWithImpl(
      _$_LiteralString _value, $Res Function(_$_LiteralString) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? value = null,
  }) {
    return _then(_$_LiteralString(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_LiteralString implements _LiteralString {
  const _$_LiteralString({required this.location, required this.value});

  @override
  final LuaLocation location;
  @override
  final String value;

  @override
  String toString() {
    return 'LiteralString(location: $location, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LiteralString &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LiteralStringCopyWith<_$_LiteralString> get copyWith =>
      __$$_LiteralStringCopyWithImpl<_$_LiteralString>(this, _$identity);
}

abstract class _LiteralString implements LiteralString {
  const factory _LiteralString(
      {required final LuaLocation location,
      required final String value}) = _$_LiteralString;

  @override
  LuaLocation get location;
  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$_LiteralStringCopyWith<_$_LiteralString> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LiteralBoolean {
  LuaLocation get location => throw _privateConstructorUsedError;
  bool get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LiteralBooleanCopyWith<LiteralBoolean> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiteralBooleanCopyWith<$Res> {
  factory $LiteralBooleanCopyWith(
          LiteralBoolean value, $Res Function(LiteralBoolean) then) =
      _$LiteralBooleanCopyWithImpl<$Res, LiteralBoolean>;
  @useResult
  $Res call({LuaLocation location, bool value});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$LiteralBooleanCopyWithImpl<$Res, $Val extends LiteralBoolean>
    implements $LiteralBooleanCopyWith<$Res> {
  _$LiteralBooleanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LiteralBooleanCopyWith<$Res>
    implements $LiteralBooleanCopyWith<$Res> {
  factory _$$_LiteralBooleanCopyWith(
          _$_LiteralBoolean value, $Res Function(_$_LiteralBoolean) then) =
      __$$_LiteralBooleanCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, bool value});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_LiteralBooleanCopyWithImpl<$Res>
    extends _$LiteralBooleanCopyWithImpl<$Res, _$_LiteralBoolean>
    implements _$$_LiteralBooleanCopyWith<$Res> {
  __$$_LiteralBooleanCopyWithImpl(
      _$_LiteralBoolean _value, $Res Function(_$_LiteralBoolean) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? value = null,
  }) {
    return _then(_$_LiteralBoolean(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_LiteralBoolean implements _LiteralBoolean {
  const _$_LiteralBoolean({required this.location, required this.value});

  @override
  final LuaLocation location;
  @override
  final bool value;

  @override
  String toString() {
    return 'LiteralBoolean(location: $location, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LiteralBoolean &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LiteralBooleanCopyWith<_$_LiteralBoolean> get copyWith =>
      __$$_LiteralBooleanCopyWithImpl<_$_LiteralBoolean>(this, _$identity);
}

abstract class _LiteralBoolean implements LiteralBoolean {
  const factory _LiteralBoolean(
      {required final LuaLocation location,
      required final bool value}) = _$_LiteralBoolean;

  @override
  LuaLocation get location;
  @override
  bool get value;
  @override
  @JsonKey(ignore: true)
  _$$_LiteralBooleanCopyWith<_$_LiteralBoolean> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LiteralInteger {
  LuaLocation get location => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LiteralIntegerCopyWith<LiteralInteger> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiteralIntegerCopyWith<$Res> {
  factory $LiteralIntegerCopyWith(
          LiteralInteger value, $Res Function(LiteralInteger) then) =
      _$LiteralIntegerCopyWithImpl<$Res, LiteralInteger>;
  @useResult
  $Res call({LuaLocation location, String value});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$LiteralIntegerCopyWithImpl<$Res, $Val extends LiteralInteger>
    implements $LiteralIntegerCopyWith<$Res> {
  _$LiteralIntegerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LiteralIntegerCopyWith<$Res>
    implements $LiteralIntegerCopyWith<$Res> {
  factory _$$_LiteralIntegerCopyWith(
          _$_LiteralInteger value, $Res Function(_$_LiteralInteger) then) =
      __$$_LiteralIntegerCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, String value});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_LiteralIntegerCopyWithImpl<$Res>
    extends _$LiteralIntegerCopyWithImpl<$Res, _$_LiteralInteger>
    implements _$$_LiteralIntegerCopyWith<$Res> {
  __$$_LiteralIntegerCopyWithImpl(
      _$_LiteralInteger _value, $Res Function(_$_LiteralInteger) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? value = null,
  }) {
    return _then(_$_LiteralInteger(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_LiteralInteger implements _LiteralInteger {
  const _$_LiteralInteger({required this.location, required this.value});

  @override
  final LuaLocation location;
  @override
  final String value;

  @override
  String toString() {
    return 'LiteralInteger(location: $location, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LiteralInteger &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LiteralIntegerCopyWith<_$_LiteralInteger> get copyWith =>
      __$$_LiteralIntegerCopyWithImpl<_$_LiteralInteger>(this, _$identity);
}

abstract class _LiteralInteger implements LiteralInteger {
  const factory _LiteralInteger(
      {required final LuaLocation location,
      required final String value}) = _$_LiteralInteger;

  @override
  LuaLocation get location;
  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$_LiteralIntegerCopyWith<_$_LiteralInteger> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LiteralFloat {
  LuaLocation get location => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LiteralFloatCopyWith<LiteralFloat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiteralFloatCopyWith<$Res> {
  factory $LiteralFloatCopyWith(
          LiteralFloat value, $Res Function(LiteralFloat) then) =
      _$LiteralFloatCopyWithImpl<$Res, LiteralFloat>;
  @useResult
  $Res call({LuaLocation location, String value});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$LiteralFloatCopyWithImpl<$Res, $Val extends LiteralFloat>
    implements $LiteralFloatCopyWith<$Res> {
  _$LiteralFloatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LiteralFloatCopyWith<$Res>
    implements $LiteralFloatCopyWith<$Res> {
  factory _$$_LiteralFloatCopyWith(
          _$_LiteralFloat value, $Res Function(_$_LiteralFloat) then) =
      __$$_LiteralFloatCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, String value});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_LiteralFloatCopyWithImpl<$Res>
    extends _$LiteralFloatCopyWithImpl<$Res, _$_LiteralFloat>
    implements _$$_LiteralFloatCopyWith<$Res> {
  __$$_LiteralFloatCopyWithImpl(
      _$_LiteralFloat _value, $Res Function(_$_LiteralFloat) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? value = null,
  }) {
    return _then(_$_LiteralFloat(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_LiteralFloat implements _LiteralFloat {
  const _$_LiteralFloat({required this.location, required this.value});

  @override
  final LuaLocation location;
  @override
  final String value;

  @override
  String toString() {
    return 'LiteralFloat(location: $location, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LiteralFloat &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LiteralFloatCopyWith<_$_LiteralFloat> get copyWith =>
      __$$_LiteralFloatCopyWithImpl<_$_LiteralFloat>(this, _$identity);
}

abstract class _LiteralFloat implements LiteralFloat {
  const factory _LiteralFloat(
      {required final LuaLocation location,
      required final String value}) = _$_LiteralFloat;

  @override
  LuaLocation get location;
  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$_LiteralFloatCopyWith<_$_LiteralFloat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PrimaryExp {
  LuaLocation get location => throw _privateConstructorUsedError;
  Node get primary => throw _privateConstructorUsedError;
  List<Node> get suffixes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PrimaryExpCopyWith<PrimaryExp> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrimaryExpCopyWith<$Res> {
  factory $PrimaryExpCopyWith(
          PrimaryExp value, $Res Function(PrimaryExp) then) =
      _$PrimaryExpCopyWithImpl<$Res, PrimaryExp>;
  @useResult
  $Res call({LuaLocation location, Node primary, List<Node> suffixes});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$PrimaryExpCopyWithImpl<$Res, $Val extends PrimaryExp>
    implements $PrimaryExpCopyWith<$Res> {
  _$PrimaryExpCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? primary = null,
    Object? suffixes = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      primary: null == primary
          ? _value.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as Node,
      suffixes: null == suffixes
          ? _value.suffixes
          : suffixes // ignore: cast_nullable_to_non_nullable
              as List<Node>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_PrimaryExpCopyWith<$Res>
    implements $PrimaryExpCopyWith<$Res> {
  factory _$$_PrimaryExpCopyWith(
          _$_PrimaryExp value, $Res Function(_$_PrimaryExp) then) =
      __$$_PrimaryExpCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Node primary, List<Node> suffixes});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_PrimaryExpCopyWithImpl<$Res>
    extends _$PrimaryExpCopyWithImpl<$Res, _$_PrimaryExp>
    implements _$$_PrimaryExpCopyWith<$Res> {
  __$$_PrimaryExpCopyWithImpl(
      _$_PrimaryExp _value, $Res Function(_$_PrimaryExp) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? primary = null,
    Object? suffixes = null,
  }) {
    return _then(_$_PrimaryExp(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      primary: null == primary
          ? _value.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as Node,
      suffixes: null == suffixes
          ? _value._suffixes
          : suffixes // ignore: cast_nullable_to_non_nullable
              as List<Node>,
    ));
  }
}

/// @nodoc

class _$_PrimaryExp implements _PrimaryExp {
  const _$_PrimaryExp(
      {required this.location,
      required this.primary,
      required final List<Node> suffixes})
      : _suffixes = suffixes;

  @override
  final LuaLocation location;
  @override
  final Node primary;
  final List<Node> _suffixes;
  @override
  List<Node> get suffixes {
    if (_suffixes is EqualUnmodifiableListView) return _suffixes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suffixes);
  }

  @override
  String toString() {
    return 'PrimaryExp(location: $location, primary: $primary, suffixes: $suffixes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PrimaryExp &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.primary, primary) || other.primary == primary) &&
            const DeepCollectionEquality().equals(other._suffixes, _suffixes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, primary,
      const DeepCollectionEquality().hash(_suffixes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PrimaryExpCopyWith<_$_PrimaryExp> get copyWith =>
      __$$_PrimaryExpCopyWithImpl<_$_PrimaryExp>(this, _$identity);
}

abstract class _PrimaryExp implements PrimaryExp {
  const factory _PrimaryExp(
      {required final LuaLocation location,
      required final Node primary,
      required final List<Node> suffixes}) = _$_PrimaryExp;

  @override
  LuaLocation get location;
  @override
  Node get primary;
  @override
  List<Node> get suffixes;
  @override
  @JsonKey(ignore: true)
  _$$_PrimaryExpCopyWith<_$_PrimaryExp> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Subscript {
  LuaLocation get location => throw _privateConstructorUsedError;
  Node get index => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SubscriptCopyWith<Subscript> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptCopyWith<$Res> {
  factory $SubscriptCopyWith(Subscript value, $Res Function(Subscript) then) =
      _$SubscriptCopyWithImpl<$Res, Subscript>;
  @useResult
  $Res call({LuaLocation location, Node index});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$SubscriptCopyWithImpl<$Res, $Val extends Subscript>
    implements $SubscriptCopyWith<$Res> {
  _$SubscriptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? index = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as Node,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_SubscriptCopyWith<$Res> implements $SubscriptCopyWith<$Res> {
  factory _$$_SubscriptCopyWith(
          _$_Subscript value, $Res Function(_$_Subscript) then) =
      __$$_SubscriptCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Node index});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_SubscriptCopyWithImpl<$Res>
    extends _$SubscriptCopyWithImpl<$Res, _$_Subscript>
    implements _$$_SubscriptCopyWith<$Res> {
  __$$_SubscriptCopyWithImpl(
      _$_Subscript _value, $Res Function(_$_Subscript) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? index = null,
  }) {
    return _then(_$_Subscript(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as Node,
    ));
  }
}

/// @nodoc

class _$_Subscript implements _Subscript {
  const _$_Subscript({required this.location, required this.index});

  @override
  final LuaLocation location;
  @override
  final Node index;

  @override
  String toString() {
    return 'Subscript(location: $location, index: $index)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Subscript &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.index, index) || other.index == index));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, index);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SubscriptCopyWith<_$_Subscript> get copyWith =>
      __$$_SubscriptCopyWithImpl<_$_Subscript>(this, _$identity);
}

abstract class _Subscript implements Subscript {
  const factory _Subscript(
      {required final LuaLocation location,
      required final Node index}) = _$_Subscript;

  @override
  LuaLocation get location;
  @override
  Node get index;
  @override
  @JsonKey(ignore: true)
  _$$_SubscriptCopyWith<_$_Subscript> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VarList {
  LuaLocation get location => throw _privateConstructorUsedError;
  List<Var> get vars => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VarListCopyWith<VarList> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VarListCopyWith<$Res> {
  factory $VarListCopyWith(VarList value, $Res Function(VarList) then) =
      _$VarListCopyWithImpl<$Res, VarList>;
  @useResult
  $Res call({LuaLocation location, List<Var> vars});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$VarListCopyWithImpl<$Res, $Val extends VarList>
    implements $VarListCopyWith<$Res> {
  _$VarListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? vars = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      vars: null == vars
          ? _value.vars
          : vars // ignore: cast_nullable_to_non_nullable
              as List<Var>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_VarListCopyWith<$Res> implements $VarListCopyWith<$Res> {
  factory _$$_VarListCopyWith(
          _$_VarList value, $Res Function(_$_VarList) then) =
      __$$_VarListCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, List<Var> vars});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_VarListCopyWithImpl<$Res>
    extends _$VarListCopyWithImpl<$Res, _$_VarList>
    implements _$$_VarListCopyWith<$Res> {
  __$$_VarListCopyWithImpl(_$_VarList _value, $Res Function(_$_VarList) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? vars = null,
  }) {
    return _then(_$_VarList(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      vars: null == vars
          ? _value._vars
          : vars // ignore: cast_nullable_to_non_nullable
              as List<Var>,
    ));
  }
}

/// @nodoc

class _$_VarList implements _VarList {
  const _$_VarList({required this.location, required final List<Var> vars})
      : _vars = vars;

  @override
  final LuaLocation location;
  final List<Var> _vars;
  @override
  List<Var> get vars {
    if (_vars is EqualUnmodifiableListView) return _vars;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vars);
  }

  @override
  String toString() {
    return 'VarList(location: $location, vars: $vars)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_VarList &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other._vars, _vars));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, location, const DeepCollectionEquality().hash(_vars));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_VarListCopyWith<_$_VarList> get copyWith =>
      __$$_VarListCopyWithImpl<_$_VarList>(this, _$identity);
}

abstract class _VarList implements VarList {
  const factory _VarList(
      {required final LuaLocation location,
      required final List<Var> vars}) = _$_VarList;

  @override
  LuaLocation get location;
  @override
  List<Var> get vars;
  @override
  @JsonKey(ignore: true)
  _$$_VarListCopyWith<_$_VarList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Var {
  LuaLocation get location => throw _privateConstructorUsedError;
  Name get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VarCopyWith<Var> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VarCopyWith<$Res> {
  factory $VarCopyWith(Var value, $Res Function(Var) then) =
      _$VarCopyWithImpl<$Res, Var>;
  @useResult
  $Res call({LuaLocation location, Name name});

  $LuaLocationCopyWith<$Res> get location;
  $NameCopyWith<$Res> get name;
}

/// @nodoc
class _$VarCopyWithImpl<$Res, $Val extends Var> implements $VarCopyWith<$Res> {
  _$VarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Name,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NameCopyWith<$Res> get name {
    return $NameCopyWith<$Res>(_value.name, (value) {
      return _then(_value.copyWith(name: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_VarCopyWith<$Res> implements $VarCopyWith<$Res> {
  factory _$$_VarCopyWith(_$_Var value, $Res Function(_$_Var) then) =
      __$$_VarCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Name name});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $NameCopyWith<$Res> get name;
}

/// @nodoc
class __$$_VarCopyWithImpl<$Res> extends _$VarCopyWithImpl<$Res, _$_Var>
    implements _$$_VarCopyWith<$Res> {
  __$$_VarCopyWithImpl(_$_Var _value, $Res Function(_$_Var) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? name = null,
  }) {
    return _then(_$_Var(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Name,
    ));
  }
}

/// @nodoc

class _$_Var implements _Var {
  const _$_Var({required this.location, required this.name});

  @override
  final LuaLocation location;
  @override
  final Name name;

  @override
  String toString() {
    return 'Var(location: $location, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Var &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_VarCopyWith<_$_Var> get copyWith =>
      __$$_VarCopyWithImpl<_$_Var>(this, _$identity);
}

abstract class _Var implements Var {
  const factory _Var(
      {required final LuaLocation location, required final Name name}) = _$_Var;

  @override
  LuaLocation get location;
  @override
  Name get name;
  @override
  @JsonKey(ignore: true)
  _$$_VarCopyWith<_$_Var> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VarPath {
  LuaLocation get location => throw _privateConstructorUsedError;
  Name get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VarPathCopyWith<VarPath> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VarPathCopyWith<$Res> {
  factory $VarPathCopyWith(VarPath value, $Res Function(VarPath) then) =
      _$VarPathCopyWithImpl<$Res, VarPath>;
  @useResult
  $Res call({LuaLocation location, Name name});

  $LuaLocationCopyWith<$Res> get location;
  $NameCopyWith<$Res> get name;
}

/// @nodoc
class _$VarPathCopyWithImpl<$Res, $Val extends VarPath>
    implements $VarPathCopyWith<$Res> {
  _$VarPathCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Name,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NameCopyWith<$Res> get name {
    return $NameCopyWith<$Res>(_value.name, (value) {
      return _then(_value.copyWith(name: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_VarPathCopyWith<$Res> implements $VarPathCopyWith<$Res> {
  factory _$$_VarPathCopyWith(
          _$_VarPath value, $Res Function(_$_VarPath) then) =
      __$$_VarPathCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Name name});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $NameCopyWith<$Res> get name;
}

/// @nodoc
class __$$_VarPathCopyWithImpl<$Res>
    extends _$VarPathCopyWithImpl<$Res, _$_VarPath>
    implements _$$_VarPathCopyWith<$Res> {
  __$$_VarPathCopyWithImpl(_$_VarPath _value, $Res Function(_$_VarPath) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? name = null,
  }) {
    return _then(_$_VarPath(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Name,
    ));
  }
}

/// @nodoc

class _$_VarPath implements _VarPath {
  const _$_VarPath({required this.location, required this.name});

  @override
  final LuaLocation location;
  @override
  final Name name;

  @override
  String toString() {
    return 'VarPath(location: $location, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_VarPath &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_VarPathCopyWith<_$_VarPath> get copyWith =>
      __$$_VarPathCopyWithImpl<_$_VarPath>(this, _$identity);
}

abstract class _VarPath implements VarPath {
  const factory _VarPath(
      {required final LuaLocation location,
      required final Name name}) = _$_VarPath;

  @override
  LuaLocation get location;
  @override
  Name get name;
  @override
  @JsonKey(ignore: true)
  _$$_VarPathCopyWith<_$_VarPath> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MethodCall {
  LuaLocation get location => throw _privateConstructorUsedError;
  Name get name => throw _privateConstructorUsedError;
  Args get args => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MethodCallCopyWith<MethodCall> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MethodCallCopyWith<$Res> {
  factory $MethodCallCopyWith(
          MethodCall value, $Res Function(MethodCall) then) =
      _$MethodCallCopyWithImpl<$Res, MethodCall>;
  @useResult
  $Res call({LuaLocation location, Name name, Args args});

  $LuaLocationCopyWith<$Res> get location;
  $NameCopyWith<$Res> get name;
  $ArgsCopyWith<$Res> get args;
}

/// @nodoc
class _$MethodCallCopyWithImpl<$Res, $Val extends MethodCall>
    implements $MethodCallCopyWith<$Res> {
  _$MethodCallCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? name = null,
    Object? args = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Name,
      args: null == args
          ? _value.args
          : args // ignore: cast_nullable_to_non_nullable
              as Args,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NameCopyWith<$Res> get name {
    return $NameCopyWith<$Res>(_value.name, (value) {
      return _then(_value.copyWith(name: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ArgsCopyWith<$Res> get args {
    return $ArgsCopyWith<$Res>(_value.args, (value) {
      return _then(_value.copyWith(args: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_MethodCallCopyWith<$Res>
    implements $MethodCallCopyWith<$Res> {
  factory _$$_MethodCallCopyWith(
          _$_MethodCall value, $Res Function(_$_MethodCall) then) =
      __$$_MethodCallCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Name name, Args args});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $NameCopyWith<$Res> get name;
  @override
  $ArgsCopyWith<$Res> get args;
}

/// @nodoc
class __$$_MethodCallCopyWithImpl<$Res>
    extends _$MethodCallCopyWithImpl<$Res, _$_MethodCall>
    implements _$$_MethodCallCopyWith<$Res> {
  __$$_MethodCallCopyWithImpl(
      _$_MethodCall _value, $Res Function(_$_MethodCall) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? name = null,
    Object? args = null,
  }) {
    return _then(_$_MethodCall(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Name,
      args: null == args
          ? _value.args
          : args // ignore: cast_nullable_to_non_nullable
              as Args,
    ));
  }
}

/// @nodoc

class _$_MethodCall implements _MethodCall {
  const _$_MethodCall(
      {required this.location, required this.name, required this.args});

  @override
  final LuaLocation location;
  @override
  final Name name;
  @override
  final Args args;

  @override
  String toString() {
    return 'MethodCall(location: $location, name: $name, args: $args)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MethodCall &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.args, args) || other.args == args));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, name, args);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MethodCallCopyWith<_$_MethodCall> get copyWith =>
      __$$_MethodCallCopyWithImpl<_$_MethodCall>(this, _$identity);
}

abstract class _MethodCall implements MethodCall {
  const factory _MethodCall(
      {required final LuaLocation location,
      required final Name name,
      required final Args args}) = _$_MethodCall;

  @override
  LuaLocation get location;
  @override
  Name get name;
  @override
  Args get args;
  @override
  @JsonKey(ignore: true)
  _$$_MethodCallCopyWith<_$_MethodCall> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Name {
  LuaLocation get location => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NameCopyWith<Name> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NameCopyWith<$Res> {
  factory $NameCopyWith(Name value, $Res Function(Name) then) =
      _$NameCopyWithImpl<$Res, Name>;
  @useResult
  $Res call({LuaLocation location, String name});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$NameCopyWithImpl<$Res, $Val extends Name>
    implements $NameCopyWith<$Res> {
  _$NameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_NameCopyWith<$Res> implements $NameCopyWith<$Res> {
  factory _$$_NameCopyWith(_$_Name value, $Res Function(_$_Name) then) =
      __$$_NameCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, String name});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_NameCopyWithImpl<$Res> extends _$NameCopyWithImpl<$Res, _$_Name>
    implements _$$_NameCopyWith<$Res> {
  __$$_NameCopyWithImpl(_$_Name _value, $Res Function(_$_Name) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? name = null,
  }) {
    return _then(_$_Name(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Name implements _Name {
  const _$_Name({required this.location, required this.name});

  @override
  final LuaLocation location;
  @override
  final String name;

  @override
  String toString() {
    return 'Name(location: $location, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Name &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NameCopyWith<_$_Name> get copyWith =>
      __$$_NameCopyWithImpl<_$_Name>(this, _$identity);
}

abstract class _Name implements Name {
  const factory _Name(
      {required final LuaLocation location,
      required final String name}) = _$_Name;

  @override
  LuaLocation get location;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$_NameCopyWith<_$_Name> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Args {
  LuaLocation get location => throw _privateConstructorUsedError;
  List<Node> get args => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ArgsCopyWith<Args> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArgsCopyWith<$Res> {
  factory $ArgsCopyWith(Args value, $Res Function(Args) then) =
      _$ArgsCopyWithImpl<$Res, Args>;
  @useResult
  $Res call({LuaLocation location, List<Node> args});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$ArgsCopyWithImpl<$Res, $Val extends Args>
    implements $ArgsCopyWith<$Res> {
  _$ArgsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? args = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      args: null == args
          ? _value.args
          : args // ignore: cast_nullable_to_non_nullable
              as List<Node>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ArgsCopyWith<$Res> implements $ArgsCopyWith<$Res> {
  factory _$$_ArgsCopyWith(_$_Args value, $Res Function(_$_Args) then) =
      __$$_ArgsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, List<Node> args});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_ArgsCopyWithImpl<$Res> extends _$ArgsCopyWithImpl<$Res, _$_Args>
    implements _$$_ArgsCopyWith<$Res> {
  __$$_ArgsCopyWithImpl(_$_Args _value, $Res Function(_$_Args) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? args = null,
  }) {
    return _then(_$_Args(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      args: null == args
          ? _value._args
          : args // ignore: cast_nullable_to_non_nullable
              as List<Node>,
    ));
  }
}

/// @nodoc

class _$_Args implements _Args {
  const _$_Args({required this.location, required final List<Node> args})
      : _args = args;

  @override
  final LuaLocation location;
  final List<Node> _args;
  @override
  List<Node> get args {
    if (_args is EqualUnmodifiableListView) return _args;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_args);
  }

  @override
  String toString() {
    return 'Args(location: $location, args: $args)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Args &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other._args, _args));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, location, const DeepCollectionEquality().hash(_args));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ArgsCopyWith<_$_Args> get copyWith =>
      __$$_ArgsCopyWithImpl<_$_Args>(this, _$identity);
}

abstract class _Args implements Args {
  const factory _Args(
      {required final LuaLocation location,
      required final List<Node> args}) = _$_Args;

  @override
  LuaLocation get location;
  @override
  List<Node> get args;
  @override
  @JsonKey(ignore: true)
  _$$_ArgsCopyWith<_$_Args> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VarArg {
  LuaLocation get location => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VarArgCopyWith<VarArg> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VarArgCopyWith<$Res> {
  factory $VarArgCopyWith(VarArg value, $Res Function(VarArg) then) =
      _$VarArgCopyWithImpl<$Res, VarArg>;
  @useResult
  $Res call({LuaLocation location});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$VarArgCopyWithImpl<$Res, $Val extends VarArg>
    implements $VarArgCopyWith<$Res> {
  _$VarArgCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_VarArgCopyWith<$Res> implements $VarArgCopyWith<$Res> {
  factory _$$_VarArgCopyWith(_$_VarArg value, $Res Function(_$_VarArg) then) =
      __$$_VarArgCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_VarArgCopyWithImpl<$Res>
    extends _$VarArgCopyWithImpl<$Res, _$_VarArg>
    implements _$$_VarArgCopyWith<$Res> {
  __$$_VarArgCopyWithImpl(_$_VarArg _value, $Res Function(_$_VarArg) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
  }) {
    return _then(_$_VarArg(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
    ));
  }
}

/// @nodoc

class _$_VarArg implements _VarArg {
  const _$_VarArg({required this.location});

  @override
  final LuaLocation location;

  @override
  String toString() {
    return 'VarArg(location: $location)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_VarArg &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_VarArgCopyWith<_$_VarArg> get copyWith =>
      __$$_VarArgCopyWithImpl<_$_VarArg>(this, _$identity);
}

abstract class _VarArg implements VarArg {
  const factory _VarArg({required final LuaLocation location}) = _$_VarArg;

  @override
  LuaLocation get location;
  @override
  @JsonKey(ignore: true)
  _$$_VarArgCopyWith<_$_VarArg> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TableConstructor {
  LuaLocation get location => throw _privateConstructorUsedError;
  List<Field>? get fields => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TableConstructorCopyWith<TableConstructor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TableConstructorCopyWith<$Res> {
  factory $TableConstructorCopyWith(
          TableConstructor value, $Res Function(TableConstructor) then) =
      _$TableConstructorCopyWithImpl<$Res, TableConstructor>;
  @useResult
  $Res call({LuaLocation location, List<Field>? fields});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$TableConstructorCopyWithImpl<$Res, $Val extends TableConstructor>
    implements $TableConstructorCopyWith<$Res> {
  _$TableConstructorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? fields = freezed,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      fields: freezed == fields
          ? _value.fields
          : fields // ignore: cast_nullable_to_non_nullable
              as List<Field>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_TableConstructorCopyWith<$Res>
    implements $TableConstructorCopyWith<$Res> {
  factory _$$_TableConstructorCopyWith(
          _$_TableConstructor value, $Res Function(_$_TableConstructor) then) =
      __$$_TableConstructorCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, List<Field>? fields});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_TableConstructorCopyWithImpl<$Res>
    extends _$TableConstructorCopyWithImpl<$Res, _$_TableConstructor>
    implements _$$_TableConstructorCopyWith<$Res> {
  __$$_TableConstructorCopyWithImpl(
      _$_TableConstructor _value, $Res Function(_$_TableConstructor) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? fields = freezed,
  }) {
    return _then(_$_TableConstructor(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      fields: freezed == fields
          ? _value._fields
          : fields // ignore: cast_nullable_to_non_nullable
              as List<Field>?,
    ));
  }
}

/// @nodoc

class _$_TableConstructor implements _TableConstructor {
  const _$_TableConstructor({required this.location, final List<Field>? fields})
      : _fields = fields;

  @override
  final LuaLocation location;
  final List<Field>? _fields;
  @override
  List<Field>? get fields {
    final value = _fields;
    if (value == null) return null;
    if (_fields is EqualUnmodifiableListView) return _fields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TableConstructor(location: $location, fields: $fields)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TableConstructor &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other._fields, _fields));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, location, const DeepCollectionEquality().hash(_fields));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TableConstructorCopyWith<_$_TableConstructor> get copyWith =>
      __$$_TableConstructorCopyWithImpl<_$_TableConstructor>(this, _$identity);
}

abstract class _TableConstructor implements TableConstructor {
  const factory _TableConstructor(
      {required final LuaLocation location,
      final List<Field>? fields}) = _$_TableConstructor;

  @override
  LuaLocation get location;
  @override
  List<Field>? get fields;
  @override
  @JsonKey(ignore: true)
  _$$_TableConstructorCopyWith<_$_TableConstructor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Field {
  LuaLocation get location => throw _privateConstructorUsedError;
  Node get value => throw _privateConstructorUsedError;
  Node? get key => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FieldCopyWith<Field> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FieldCopyWith<$Res> {
  factory $FieldCopyWith(Field value, $Res Function(Field) then) =
      _$FieldCopyWithImpl<$Res, Field>;
  @useResult
  $Res call({LuaLocation location, Node value, Node? key});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$FieldCopyWithImpl<$Res, $Val extends Field>
    implements $FieldCopyWith<$Res> {
  _$FieldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? value = null,
    Object? key = freezed,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as Node,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as Node?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_FieldCopyWith<$Res> implements $FieldCopyWith<$Res> {
  factory _$$_FieldCopyWith(_$_Field value, $Res Function(_$_Field) then) =
      __$$_FieldCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Node value, Node? key});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_FieldCopyWithImpl<$Res> extends _$FieldCopyWithImpl<$Res, _$_Field>
    implements _$$_FieldCopyWith<$Res> {
  __$$_FieldCopyWithImpl(_$_Field _value, $Res Function(_$_Field) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? value = null,
    Object? key = freezed,
  }) {
    return _then(_$_Field(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as Node,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as Node?,
    ));
  }
}

/// @nodoc

class _$_Field implements _Field {
  const _$_Field({required this.location, required this.value, this.key});

  @override
  final LuaLocation location;
  @override
  final Node value;
  @override
  final Node? key;

  @override
  String toString() {
    return 'Field(location: $location, value: $value, key: $key)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Field &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.key, key) || other.key == key));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, value, key);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FieldCopyWith<_$_Field> get copyWith =>
      __$$_FieldCopyWithImpl<_$_Field>(this, _$identity);
}

abstract class _Field implements Field {
  const factory _Field(
      {required final LuaLocation location,
      required final Node value,
      final Node? key}) = _$_Field;

  @override
  LuaLocation get location;
  @override
  Node get value;
  @override
  Node? get key;
  @override
  @JsonKey(ignore: true)
  _$$_FieldCopyWith<_$_Field> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FunctionDef {
  LuaLocation get location => throw _privateConstructorUsedError;
  FuncBody get body => throw _privateConstructorUsedError;
  FuncName? get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FunctionDefCopyWith<FunctionDef> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FunctionDefCopyWith<$Res> {
  factory $FunctionDefCopyWith(
          FunctionDef value, $Res Function(FunctionDef) then) =
      _$FunctionDefCopyWithImpl<$Res, FunctionDef>;
  @useResult
  $Res call({LuaLocation location, FuncBody body, FuncName? name});

  $LuaLocationCopyWith<$Res> get location;
  $FuncBodyCopyWith<$Res> get body;
  $FuncNameCopyWith<$Res>? get name;
}

/// @nodoc
class _$FunctionDefCopyWithImpl<$Res, $Val extends FunctionDef>
    implements $FunctionDefCopyWith<$Res> {
  _$FunctionDefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? body = null,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as FuncBody,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as FuncName?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FuncBodyCopyWith<$Res> get body {
    return $FuncBodyCopyWith<$Res>(_value.body, (value) {
      return _then(_value.copyWith(body: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FuncNameCopyWith<$Res>? get name {
    if (_value.name == null) {
      return null;
    }

    return $FuncNameCopyWith<$Res>(_value.name!, (value) {
      return _then(_value.copyWith(name: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_FunctionDefCopyWith<$Res>
    implements $FunctionDefCopyWith<$Res> {
  factory _$$_FunctionDefCopyWith(
          _$_FunctionDef value, $Res Function(_$_FunctionDef) then) =
      __$$_FunctionDefCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, FuncBody body, FuncName? name});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $FuncBodyCopyWith<$Res> get body;
  @override
  $FuncNameCopyWith<$Res>? get name;
}

/// @nodoc
class __$$_FunctionDefCopyWithImpl<$Res>
    extends _$FunctionDefCopyWithImpl<$Res, _$_FunctionDef>
    implements _$$_FunctionDefCopyWith<$Res> {
  __$$_FunctionDefCopyWithImpl(
      _$_FunctionDef _value, $Res Function(_$_FunctionDef) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? body = null,
    Object? name = freezed,
  }) {
    return _then(_$_FunctionDef(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as FuncBody,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as FuncName?,
    ));
  }
}

/// @nodoc

class _$_FunctionDef implements _FunctionDef {
  const _$_FunctionDef({required this.location, required this.body, this.name});

  @override
  final LuaLocation location;
  @override
  final FuncBody body;
  @override
  final FuncName? name;

  @override
  String toString() {
    return 'FunctionDef(location: $location, body: $body, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FunctionDef &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, body, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FunctionDefCopyWith<_$_FunctionDef> get copyWith =>
      __$$_FunctionDefCopyWithImpl<_$_FunctionDef>(this, _$identity);
}

abstract class _FunctionDef implements FunctionDef {
  const factory _FunctionDef(
      {required final LuaLocation location,
      required final FuncBody body,
      final FuncName? name}) = _$_FunctionDef;

  @override
  LuaLocation get location;
  @override
  FuncBody get body;
  @override
  FuncName? get name;
  @override
  @JsonKey(ignore: true)
  _$$_FunctionDefCopyWith<_$_FunctionDef> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FuncName {
  LuaLocation get location => throw _privateConstructorUsedError;
  List<Name> get path => throw _privateConstructorUsedError;
  Name? get method => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FuncNameCopyWith<FuncName> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FuncNameCopyWith<$Res> {
  factory $FuncNameCopyWith(FuncName value, $Res Function(FuncName) then) =
      _$FuncNameCopyWithImpl<$Res, FuncName>;
  @useResult
  $Res call({LuaLocation location, List<Name> path, Name? method});

  $LuaLocationCopyWith<$Res> get location;
  $NameCopyWith<$Res>? get method;
}

/// @nodoc
class _$FuncNameCopyWithImpl<$Res, $Val extends FuncName>
    implements $FuncNameCopyWith<$Res> {
  _$FuncNameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? path = null,
    Object? method = freezed,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as List<Name>,
      method: freezed == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as Name?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NameCopyWith<$Res>? get method {
    if (_value.method == null) {
      return null;
    }

    return $NameCopyWith<$Res>(_value.method!, (value) {
      return _then(_value.copyWith(method: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_FuncNameCopyWith<$Res> implements $FuncNameCopyWith<$Res> {
  factory _$$_FuncNameCopyWith(
          _$_FuncName value, $Res Function(_$_FuncName) then) =
      __$$_FuncNameCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, List<Name> path, Name? method});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $NameCopyWith<$Res>? get method;
}

/// @nodoc
class __$$_FuncNameCopyWithImpl<$Res>
    extends _$FuncNameCopyWithImpl<$Res, _$_FuncName>
    implements _$$_FuncNameCopyWith<$Res> {
  __$$_FuncNameCopyWithImpl(
      _$_FuncName _value, $Res Function(_$_FuncName) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? path = null,
    Object? method = freezed,
  }) {
    return _then(_$_FuncName(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      path: null == path
          ? _value._path
          : path // ignore: cast_nullable_to_non_nullable
              as List<Name>,
      method: freezed == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as Name?,
    ));
  }
}

/// @nodoc

class _$_FuncName implements _FuncName {
  const _$_FuncName(
      {required this.location,
      required final List<Name> path,
      required this.method})
      : _path = path;

  @override
  final LuaLocation location;
  final List<Name> _path;
  @override
  List<Name> get path {
    if (_path is EqualUnmodifiableListView) return _path;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_path);
  }

  @override
  final Name? method;

  @override
  String toString() {
    return 'FuncName(location: $location, path: $path, method: $method)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FuncName &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other._path, _path) &&
            (identical(other.method, method) || other.method == method));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location,
      const DeepCollectionEquality().hash(_path), method);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FuncNameCopyWith<_$_FuncName> get copyWith =>
      __$$_FuncNameCopyWithImpl<_$_FuncName>(this, _$identity);
}

abstract class _FuncName implements FuncName {
  const factory _FuncName(
      {required final LuaLocation location,
      required final List<Name> path,
      required final Name? method}) = _$_FuncName;

  @override
  LuaLocation get location;
  @override
  List<Name> get path;
  @override
  Name? get method;
  @override
  @JsonKey(ignore: true)
  _$$_FuncNameCopyWith<_$_FuncName> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LocalFunctionDef {
  LuaLocation get location => throw _privateConstructorUsedError;
  Name get name => throw _privateConstructorUsedError;
  FuncBody get body => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LocalFunctionDefCopyWith<LocalFunctionDef> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalFunctionDefCopyWith<$Res> {
  factory $LocalFunctionDefCopyWith(
          LocalFunctionDef value, $Res Function(LocalFunctionDef) then) =
      _$LocalFunctionDefCopyWithImpl<$Res, LocalFunctionDef>;
  @useResult
  $Res call({LuaLocation location, Name name, FuncBody body});

  $LuaLocationCopyWith<$Res> get location;
  $NameCopyWith<$Res> get name;
  $FuncBodyCopyWith<$Res> get body;
}

/// @nodoc
class _$LocalFunctionDefCopyWithImpl<$Res, $Val extends LocalFunctionDef>
    implements $LocalFunctionDefCopyWith<$Res> {
  _$LocalFunctionDefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? name = null,
    Object? body = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Name,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as FuncBody,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NameCopyWith<$Res> get name {
    return $NameCopyWith<$Res>(_value.name, (value) {
      return _then(_value.copyWith(name: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FuncBodyCopyWith<$Res> get body {
    return $FuncBodyCopyWith<$Res>(_value.body, (value) {
      return _then(_value.copyWith(body: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LocalFunctionDefCopyWith<$Res>
    implements $LocalFunctionDefCopyWith<$Res> {
  factory _$$_LocalFunctionDefCopyWith(
          _$_LocalFunctionDef value, $Res Function(_$_LocalFunctionDef) then) =
      __$$_LocalFunctionDefCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, Name name, FuncBody body});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $NameCopyWith<$Res> get name;
  @override
  $FuncBodyCopyWith<$Res> get body;
}

/// @nodoc
class __$$_LocalFunctionDefCopyWithImpl<$Res>
    extends _$LocalFunctionDefCopyWithImpl<$Res, _$_LocalFunctionDef>
    implements _$$_LocalFunctionDefCopyWith<$Res> {
  __$$_LocalFunctionDefCopyWithImpl(
      _$_LocalFunctionDef _value, $Res Function(_$_LocalFunctionDef) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? name = null,
    Object? body = null,
  }) {
    return _then(_$_LocalFunctionDef(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Name,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as FuncBody,
    ));
  }
}

/// @nodoc

class _$_LocalFunctionDef implements _LocalFunctionDef {
  const _$_LocalFunctionDef(
      {required this.location, required this.name, required this.body});

  @override
  final LuaLocation location;
  @override
  final Name name;
  @override
  final FuncBody body;

  @override
  String toString() {
    return 'LocalFunctionDef(location: $location, name: $name, body: $body)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LocalFunctionDef &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.body, body) || other.body == body));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, name, body);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LocalFunctionDefCopyWith<_$_LocalFunctionDef> get copyWith =>
      __$$_LocalFunctionDefCopyWithImpl<_$_LocalFunctionDef>(this, _$identity);
}

abstract class _LocalFunctionDef implements LocalFunctionDef {
  const factory _LocalFunctionDef(
      {required final LuaLocation location,
      required final Name name,
      required final FuncBody body}) = _$_LocalFunctionDef;

  @override
  LuaLocation get location;
  @override
  Name get name;
  @override
  FuncBody get body;
  @override
  @JsonKey(ignore: true)
  _$$_LocalFunctionDefCopyWith<_$_LocalFunctionDef> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FuncBody {
  LuaLocation get location => throw _privateConstructorUsedError;
  ParamList? get paramList => throw _privateConstructorUsedError;
  Block get block => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FuncBodyCopyWith<FuncBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FuncBodyCopyWith<$Res> {
  factory $FuncBodyCopyWith(FuncBody value, $Res Function(FuncBody) then) =
      _$FuncBodyCopyWithImpl<$Res, FuncBody>;
  @useResult
  $Res call({LuaLocation location, ParamList? paramList, Block block});

  $LuaLocationCopyWith<$Res> get location;
  $ParamListCopyWith<$Res>? get paramList;
  $BlockCopyWith<$Res> get block;
}

/// @nodoc
class _$FuncBodyCopyWithImpl<$Res, $Val extends FuncBody>
    implements $FuncBodyCopyWith<$Res> {
  _$FuncBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? paramList = freezed,
    Object? block = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      paramList: freezed == paramList
          ? _value.paramList
          : paramList // ignore: cast_nullable_to_non_nullable
              as ParamList?,
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ParamListCopyWith<$Res>? get paramList {
    if (_value.paramList == null) {
      return null;
    }

    return $ParamListCopyWith<$Res>(_value.paramList!, (value) {
      return _then(_value.copyWith(paramList: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BlockCopyWith<$Res> get block {
    return $BlockCopyWith<$Res>(_value.block, (value) {
      return _then(_value.copyWith(block: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_FuncBodyCopyWith<$Res> implements $FuncBodyCopyWith<$Res> {
  factory _$$_FuncBodyCopyWith(
          _$_FuncBody value, $Res Function(_$_FuncBody) then) =
      __$$_FuncBodyCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, ParamList? paramList, Block block});

  @override
  $LuaLocationCopyWith<$Res> get location;
  @override
  $ParamListCopyWith<$Res>? get paramList;
  @override
  $BlockCopyWith<$Res> get block;
}

/// @nodoc
class __$$_FuncBodyCopyWithImpl<$Res>
    extends _$FuncBodyCopyWithImpl<$Res, _$_FuncBody>
    implements _$$_FuncBodyCopyWith<$Res> {
  __$$_FuncBodyCopyWithImpl(
      _$_FuncBody _value, $Res Function(_$_FuncBody) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? paramList = freezed,
    Object? block = null,
  }) {
    return _then(_$_FuncBody(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      paramList: freezed == paramList
          ? _value.paramList
          : paramList // ignore: cast_nullable_to_non_nullable
              as ParamList?,
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
    ));
  }
}

/// @nodoc

class _$_FuncBody implements _FuncBody {
  const _$_FuncBody(
      {required this.location, required this.paramList, required this.block});

  @override
  final LuaLocation location;
  @override
  final ParamList? paramList;
  @override
  final Block block;

  @override
  String toString() {
    return 'FuncBody(location: $location, paramList: $paramList, block: $block)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FuncBody &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.paramList, paramList) ||
                other.paramList == paramList) &&
            (identical(other.block, block) || other.block == block));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, paramList, block);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FuncBodyCopyWith<_$_FuncBody> get copyWith =>
      __$$_FuncBodyCopyWithImpl<_$_FuncBody>(this, _$identity);
}

abstract class _FuncBody implements FuncBody {
  const factory _FuncBody(
      {required final LuaLocation location,
      required final ParamList? paramList,
      required final Block block}) = _$_FuncBody;

  @override
  LuaLocation get location;
  @override
  ParamList? get paramList;
  @override
  Block get block;
  @override
  @JsonKey(ignore: true)
  _$$_FuncBodyCopyWith<_$_FuncBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ParamList {
  LuaLocation get location => throw _privateConstructorUsedError;
  List<Name> get names => throw _privateConstructorUsedError;
  bool get variadic => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ParamListCopyWith<ParamList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParamListCopyWith<$Res> {
  factory $ParamListCopyWith(ParamList value, $Res Function(ParamList) then) =
      _$ParamListCopyWithImpl<$Res, ParamList>;
  @useResult
  $Res call({LuaLocation location, List<Name> names, bool variadic});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$ParamListCopyWithImpl<$Res, $Val extends ParamList>
    implements $ParamListCopyWith<$Res> {
  _$ParamListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? names = null,
    Object? variadic = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      names: null == names
          ? _value.names
          : names // ignore: cast_nullable_to_non_nullable
              as List<Name>,
      variadic: null == variadic
          ? _value.variadic
          : variadic // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ParamListCopyWith<$Res> implements $ParamListCopyWith<$Res> {
  factory _$$_ParamListCopyWith(
          _$_ParamList value, $Res Function(_$_ParamList) then) =
      __$$_ParamListCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, List<Name> names, bool variadic});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_ParamListCopyWithImpl<$Res>
    extends _$ParamListCopyWithImpl<$Res, _$_ParamList>
    implements _$$_ParamListCopyWith<$Res> {
  __$$_ParamListCopyWithImpl(
      _$_ParamList _value, $Res Function(_$_ParamList) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? names = null,
    Object? variadic = null,
  }) {
    return _then(_$_ParamList(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      names: null == names
          ? _value._names
          : names // ignore: cast_nullable_to_non_nullable
              as List<Name>,
      variadic: null == variadic
          ? _value.variadic
          : variadic // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_ParamList implements _ParamList {
  const _$_ParamList(
      {required this.location,
      required final List<Name> names,
      required this.variadic})
      : _names = names;

  @override
  final LuaLocation location;
  final List<Name> _names;
  @override
  List<Name> get names {
    if (_names is EqualUnmodifiableListView) return _names;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_names);
  }

  @override
  final bool variadic;

  @override
  String toString() {
    return 'ParamList(location: $location, names: $names, variadic: $variadic)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ParamList &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other._names, _names) &&
            (identical(other.variadic, variadic) ||
                other.variadic == variadic));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location,
      const DeepCollectionEquality().hash(_names), variadic);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ParamListCopyWith<_$_ParamList> get copyWith =>
      __$$_ParamListCopyWithImpl<_$_ParamList>(this, _$identity);
}

abstract class _ParamList implements ParamList {
  const factory _ParamList(
      {required final LuaLocation location,
      required final List<Name> names,
      required final bool variadic}) = _$_ParamList;

  @override
  LuaLocation get location;
  @override
  List<Name> get names;
  @override
  bool get variadic;
  @override
  @JsonKey(ignore: true)
  _$$_ParamListCopyWith<_$_ParamList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Return {
  LuaLocation get location => throw _privateConstructorUsedError;
  List<Node>? get expList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ReturnCopyWith<Return> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReturnCopyWith<$Res> {
  factory $ReturnCopyWith(Return value, $Res Function(Return) then) =
      _$ReturnCopyWithImpl<$Res, Return>;
  @useResult
  $Res call({LuaLocation location, List<Node>? expList});

  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$ReturnCopyWithImpl<$Res, $Val extends Return>
    implements $ReturnCopyWith<$Res> {
  _$ReturnCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? expList = freezed,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      expList: freezed == expList
          ? _value.expList
          : expList // ignore: cast_nullable_to_non_nullable
              as List<Node>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLocationCopyWith<$Res> get location {
    return $LuaLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ReturnCopyWith<$Res> implements $ReturnCopyWith<$Res> {
  factory _$$_ReturnCopyWith(_$_Return value, $Res Function(_$_Return) then) =
      __$$_ReturnCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LuaLocation location, List<Node>? expList});

  @override
  $LuaLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_ReturnCopyWithImpl<$Res>
    extends _$ReturnCopyWithImpl<$Res, _$_Return>
    implements _$$_ReturnCopyWith<$Res> {
  __$$_ReturnCopyWithImpl(_$_Return _value, $Res Function(_$_Return) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? expList = freezed,
  }) {
    return _then(_$_Return(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LuaLocation,
      expList: freezed == expList
          ? _value._expList
          : expList // ignore: cast_nullable_to_non_nullable
              as List<Node>?,
    ));
  }
}

/// @nodoc

class _$_Return implements _Return {
  const _$_Return({required this.location, final List<Node>? expList})
      : _expList = expList;

  @override
  final LuaLocation location;
  final List<Node>? _expList;
  @override
  List<Node>? get expList {
    final value = _expList;
    if (value == null) return null;
    if (_expList is EqualUnmodifiableListView) return _expList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Return(location: $location, expList: $expList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Return &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other._expList, _expList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, location, const DeepCollectionEquality().hash(_expList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ReturnCopyWith<_$_Return> get copyWith =>
      __$$_ReturnCopyWithImpl<_$_Return>(this, _$identity);
}

abstract class _Return implements Return {
  const factory _Return(
      {required final LuaLocation location,
      final List<Node>? expList}) = _$_Return;

  @override
  LuaLocation get location;
  @override
  List<Node>? get expList;
  @override
  @JsonKey(ignore: true)
  _$$_ReturnCopyWith<_$_Return> get copyWith =>
      throw _privateConstructorUsedError;
}
