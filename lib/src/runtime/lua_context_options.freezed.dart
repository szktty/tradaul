// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lua_context_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LuaContextOptions {
  bool get debug => throw _privateConstructorUsedError;
  LuaLogLevel get logLevel => throw _privateConstructorUsedError;
  bool get checkSyntaxOnly => throw _privateConstructorUsedError;
  LuaPermissions get permissions => throw _privateConstructorUsedError;
  LuaPermissionWarning get permissionWarning =>
      throw _privateConstructorUsedError;
  LuaEnvironment? get environment => throw _privateConstructorUsedError;
  List<String> get systemModuleSearchPath => throw _privateConstructorUsedError;
  LuaTable? get preloadModuleLoaders => throw _privateConstructorUsedError;
  List<String> get userModuleSearchPath => throw _privateConstructorUsedError;
  List<LuaModuleLoader> get moduleLoaders => throw _privateConstructorUsedError;
  LuaSystem? get system => throw _privateConstructorUsedError;
  FileSystem? get fileSystem => throw _privateConstructorUsedError;
  LuaOsModuleOptions? get osCallbacks => throw _privateConstructorUsedError;
  LuaIoModuleOptions? get ioOptions => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LuaContextOptionsCopyWith<LuaContextOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LuaContextOptionsCopyWith<$Res> {
  factory $LuaContextOptionsCopyWith(
          LuaContextOptions value, $Res Function(LuaContextOptions) then) =
      _$LuaContextOptionsCopyWithImpl<$Res, LuaContextOptions>;
  @useResult
  $Res call(
      {bool debug,
      LuaLogLevel logLevel,
      bool checkSyntaxOnly,
      LuaPermissions permissions,
      LuaPermissionWarning permissionWarning,
      LuaEnvironment? environment,
      List<String> systemModuleSearchPath,
      LuaTable? preloadModuleLoaders,
      List<String> userModuleSearchPath,
      List<LuaModuleLoader> moduleLoaders,
      LuaSystem? system,
      FileSystem? fileSystem,
      LuaOsModuleOptions? osCallbacks,
      LuaIoModuleOptions? ioOptions});

  $LuaPermissionsCopyWith<$Res> get permissions;
}

/// @nodoc
class _$LuaContextOptionsCopyWithImpl<$Res, $Val extends LuaContextOptions>
    implements $LuaContextOptionsCopyWith<$Res> {
  _$LuaContextOptionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? debug = null,
    Object? logLevel = null,
    Object? checkSyntaxOnly = null,
    Object? permissions = null,
    Object? permissionWarning = null,
    Object? environment = freezed,
    Object? systemModuleSearchPath = null,
    Object? preloadModuleLoaders = freezed,
    Object? userModuleSearchPath = null,
    Object? moduleLoaders = null,
    Object? system = freezed,
    Object? fileSystem = freezed,
    Object? osCallbacks = freezed,
    Object? ioOptions = freezed,
  }) {
    return _then(_value.copyWith(
      debug: null == debug
          ? _value.debug
          : debug // ignore: cast_nullable_to_non_nullable
              as bool,
      logLevel: null == logLevel
          ? _value.logLevel
          : logLevel // ignore: cast_nullable_to_non_nullable
              as LuaLogLevel,
      checkSyntaxOnly: null == checkSyntaxOnly
          ? _value.checkSyntaxOnly
          : checkSyntaxOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as LuaPermissions,
      permissionWarning: null == permissionWarning
          ? _value.permissionWarning
          : permissionWarning // ignore: cast_nullable_to_non_nullable
              as LuaPermissionWarning,
      environment: freezed == environment
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as LuaEnvironment?,
      systemModuleSearchPath: null == systemModuleSearchPath
          ? _value.systemModuleSearchPath
          : systemModuleSearchPath // ignore: cast_nullable_to_non_nullable
              as List<String>,
      preloadModuleLoaders: freezed == preloadModuleLoaders
          ? _value.preloadModuleLoaders
          : preloadModuleLoaders // ignore: cast_nullable_to_non_nullable
              as LuaTable?,
      userModuleSearchPath: null == userModuleSearchPath
          ? _value.userModuleSearchPath
          : userModuleSearchPath // ignore: cast_nullable_to_non_nullable
              as List<String>,
      moduleLoaders: null == moduleLoaders
          ? _value.moduleLoaders
          : moduleLoaders // ignore: cast_nullable_to_non_nullable
              as List<LuaModuleLoader>,
      system: freezed == system
          ? _value.system
          : system // ignore: cast_nullable_to_non_nullable
              as LuaSystem?,
      fileSystem: freezed == fileSystem
          ? _value.fileSystem
          : fileSystem // ignore: cast_nullable_to_non_nullable
              as FileSystem?,
      osCallbacks: freezed == osCallbacks
          ? _value.osCallbacks
          : osCallbacks // ignore: cast_nullable_to_non_nullable
              as LuaOsModuleOptions?,
      ioOptions: freezed == ioOptions
          ? _value.ioOptions
          : ioOptions // ignore: cast_nullable_to_non_nullable
              as LuaIoModuleOptions?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaPermissionsCopyWith<$Res> get permissions {
    return $LuaPermissionsCopyWith<$Res>(_value.permissions, (value) {
      return _then(_value.copyWith(permissions: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LuaContextOptionsCopyWith<$Res>
    implements $LuaContextOptionsCopyWith<$Res> {
  factory _$$_LuaContextOptionsCopyWith(_$_LuaContextOptions value,
          $Res Function(_$_LuaContextOptions) then) =
      __$$_LuaContextOptionsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool debug,
      LuaLogLevel logLevel,
      bool checkSyntaxOnly,
      LuaPermissions permissions,
      LuaPermissionWarning permissionWarning,
      LuaEnvironment? environment,
      List<String> systemModuleSearchPath,
      LuaTable? preloadModuleLoaders,
      List<String> userModuleSearchPath,
      List<LuaModuleLoader> moduleLoaders,
      LuaSystem? system,
      FileSystem? fileSystem,
      LuaOsModuleOptions? osCallbacks,
      LuaIoModuleOptions? ioOptions});

  @override
  $LuaPermissionsCopyWith<$Res> get permissions;
}

/// @nodoc
class __$$_LuaContextOptionsCopyWithImpl<$Res>
    extends _$LuaContextOptionsCopyWithImpl<$Res, _$_LuaContextOptions>
    implements _$$_LuaContextOptionsCopyWith<$Res> {
  __$$_LuaContextOptionsCopyWithImpl(
      _$_LuaContextOptions _value, $Res Function(_$_LuaContextOptions) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? debug = null,
    Object? logLevel = null,
    Object? checkSyntaxOnly = null,
    Object? permissions = null,
    Object? permissionWarning = null,
    Object? environment = freezed,
    Object? systemModuleSearchPath = null,
    Object? preloadModuleLoaders = freezed,
    Object? userModuleSearchPath = null,
    Object? moduleLoaders = null,
    Object? system = freezed,
    Object? fileSystem = freezed,
    Object? osCallbacks = freezed,
    Object? ioOptions = freezed,
  }) {
    return _then(_$_LuaContextOptions(
      debug: null == debug
          ? _value.debug
          : debug // ignore: cast_nullable_to_non_nullable
              as bool,
      logLevel: null == logLevel
          ? _value.logLevel
          : logLevel // ignore: cast_nullable_to_non_nullable
              as LuaLogLevel,
      checkSyntaxOnly: null == checkSyntaxOnly
          ? _value.checkSyntaxOnly
          : checkSyntaxOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as LuaPermissions,
      permissionWarning: null == permissionWarning
          ? _value.permissionWarning
          : permissionWarning // ignore: cast_nullable_to_non_nullable
              as LuaPermissionWarning,
      environment: freezed == environment
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as LuaEnvironment?,
      systemModuleSearchPath: null == systemModuleSearchPath
          ? _value._systemModuleSearchPath
          : systemModuleSearchPath // ignore: cast_nullable_to_non_nullable
              as List<String>,
      preloadModuleLoaders: freezed == preloadModuleLoaders
          ? _value.preloadModuleLoaders
          : preloadModuleLoaders // ignore: cast_nullable_to_non_nullable
              as LuaTable?,
      userModuleSearchPath: null == userModuleSearchPath
          ? _value._userModuleSearchPath
          : userModuleSearchPath // ignore: cast_nullable_to_non_nullable
              as List<String>,
      moduleLoaders: null == moduleLoaders
          ? _value._moduleLoaders
          : moduleLoaders // ignore: cast_nullable_to_non_nullable
              as List<LuaModuleLoader>,
      system: freezed == system
          ? _value.system
          : system // ignore: cast_nullable_to_non_nullable
              as LuaSystem?,
      fileSystem: freezed == fileSystem
          ? _value.fileSystem
          : fileSystem // ignore: cast_nullable_to_non_nullable
              as FileSystem?,
      osCallbacks: freezed == osCallbacks
          ? _value.osCallbacks
          : osCallbacks // ignore: cast_nullable_to_non_nullable
              as LuaOsModuleOptions?,
      ioOptions: freezed == ioOptions
          ? _value.ioOptions
          : ioOptions // ignore: cast_nullable_to_non_nullable
              as LuaIoModuleOptions?,
    ));
  }
}

/// @nodoc

class _$_LuaContextOptions extends _LuaContextOptions {
  const _$_LuaContextOptions(
      {this.debug = false,
      this.logLevel = LuaLogLevel.error,
      this.checkSyntaxOnly = false,
      this.permissions = const LuaPermissions(),
      this.permissionWarning = LuaPermissionWarning.warn,
      this.environment,
      final List<String> systemModuleSearchPath = const [],
      this.preloadModuleLoaders,
      final List<String> userModuleSearchPath = const [],
      final List<LuaModuleLoader> moduleLoaders = const [],
      this.system,
      this.fileSystem,
      this.osCallbacks,
      this.ioOptions})
      : _systemModuleSearchPath = systemModuleSearchPath,
        _userModuleSearchPath = userModuleSearchPath,
        _moduleLoaders = moduleLoaders,
        super._();

  @override
  @JsonKey()
  final bool debug;
  @override
  @JsonKey()
  final LuaLogLevel logLevel;
  @override
  @JsonKey()
  final bool checkSyntaxOnly;
  @override
  @JsonKey()
  final LuaPermissions permissions;
  @override
  @JsonKey()
  final LuaPermissionWarning permissionWarning;
  @override
  final LuaEnvironment? environment;
  final List<String> _systemModuleSearchPath;
  @override
  @JsonKey()
  List<String> get systemModuleSearchPath {
    if (_systemModuleSearchPath is EqualUnmodifiableListView)
      return _systemModuleSearchPath;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_systemModuleSearchPath);
  }

  @override
  final LuaTable? preloadModuleLoaders;
  final List<String> _userModuleSearchPath;
  @override
  @JsonKey()
  List<String> get userModuleSearchPath {
    if (_userModuleSearchPath is EqualUnmodifiableListView)
      return _userModuleSearchPath;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userModuleSearchPath);
  }

  final List<LuaModuleLoader> _moduleLoaders;
  @override
  @JsonKey()
  List<LuaModuleLoader> get moduleLoaders {
    if (_moduleLoaders is EqualUnmodifiableListView) return _moduleLoaders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moduleLoaders);
  }

  @override
  final LuaSystem? system;
  @override
  final FileSystem? fileSystem;
  @override
  final LuaOsModuleOptions? osCallbacks;
  @override
  final LuaIoModuleOptions? ioOptions;

  @override
  String toString() {
    return 'LuaContextOptions(debug: $debug, logLevel: $logLevel, checkSyntaxOnly: $checkSyntaxOnly, permissions: $permissions, permissionWarning: $permissionWarning, environment: $environment, systemModuleSearchPath: $systemModuleSearchPath, preloadModuleLoaders: $preloadModuleLoaders, userModuleSearchPath: $userModuleSearchPath, moduleLoaders: $moduleLoaders, system: $system, fileSystem: $fileSystem, osCallbacks: $osCallbacks, ioOptions: $ioOptions)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LuaContextOptions &&
            (identical(other.debug, debug) || other.debug == debug) &&
            (identical(other.logLevel, logLevel) ||
                other.logLevel == logLevel) &&
            (identical(other.checkSyntaxOnly, checkSyntaxOnly) ||
                other.checkSyntaxOnly == checkSyntaxOnly) &&
            (identical(other.permissions, permissions) ||
                other.permissions == permissions) &&
            (identical(other.permissionWarning, permissionWarning) ||
                other.permissionWarning == permissionWarning) &&
            (identical(other.environment, environment) ||
                other.environment == environment) &&
            const DeepCollectionEquality().equals(
                other._systemModuleSearchPath, _systemModuleSearchPath) &&
            (identical(other.preloadModuleLoaders, preloadModuleLoaders) ||
                other.preloadModuleLoaders == preloadModuleLoaders) &&
            const DeepCollectionEquality()
                .equals(other._userModuleSearchPath, _userModuleSearchPath) &&
            const DeepCollectionEquality()
                .equals(other._moduleLoaders, _moduleLoaders) &&
            const DeepCollectionEquality().equals(other.system, system) &&
            (identical(other.fileSystem, fileSystem) ||
                other.fileSystem == fileSystem) &&
            (identical(other.osCallbacks, osCallbacks) ||
                other.osCallbacks == osCallbacks) &&
            (identical(other.ioOptions, ioOptions) ||
                other.ioOptions == ioOptions));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      debug,
      logLevel,
      checkSyntaxOnly,
      permissions,
      permissionWarning,
      environment,
      const DeepCollectionEquality().hash(_systemModuleSearchPath),
      preloadModuleLoaders,
      const DeepCollectionEquality().hash(_userModuleSearchPath),
      const DeepCollectionEquality().hash(_moduleLoaders),
      const DeepCollectionEquality().hash(system),
      fileSystem,
      osCallbacks,
      ioOptions);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LuaContextOptionsCopyWith<_$_LuaContextOptions> get copyWith =>
      __$$_LuaContextOptionsCopyWithImpl<_$_LuaContextOptions>(
          this, _$identity);
}

abstract class _LuaContextOptions extends LuaContextOptions {
  const factory _LuaContextOptions(
      {final bool debug,
      final LuaLogLevel logLevel,
      final bool checkSyntaxOnly,
      final LuaPermissions permissions,
      final LuaPermissionWarning permissionWarning,
      final LuaEnvironment? environment,
      final List<String> systemModuleSearchPath,
      final LuaTable? preloadModuleLoaders,
      final List<String> userModuleSearchPath,
      final List<LuaModuleLoader> moduleLoaders,
      final LuaSystem? system,
      final FileSystem? fileSystem,
      final LuaOsModuleOptions? osCallbacks,
      final LuaIoModuleOptions? ioOptions}) = _$_LuaContextOptions;
  const _LuaContextOptions._() : super._();

  @override
  bool get debug;
  @override
  LuaLogLevel get logLevel;
  @override
  bool get checkSyntaxOnly;
  @override
  LuaPermissions get permissions;
  @override
  LuaPermissionWarning get permissionWarning;
  @override
  LuaEnvironment? get environment;
  @override
  List<String> get systemModuleSearchPath;
  @override
  LuaTable? get preloadModuleLoaders;
  @override
  List<String> get userModuleSearchPath;
  @override
  List<LuaModuleLoader> get moduleLoaders;
  @override
  LuaSystem? get system;
  @override
  FileSystem? get fileSystem;
  @override
  LuaOsModuleOptions? get osCallbacks;
  @override
  LuaIoModuleOptions? get ioOptions;
  @override
  @JsonKey(ignore: true)
  _$$_LuaContextOptionsCopyWith<_$_LuaContextOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LuaPermissions {
  bool get module => throw _privateConstructorUsedError;
  bool get environment => throw _privateConstructorUsedError;
  bool get assertion => throw _privateConstructorUsedError;
  bool get error => throw _privateConstructorUsedError;
  bool get metatable => throw _privateConstructorUsedError;
  bool get raw => throw _privateConstructorUsedError;
  bool get process => throw _privateConstructorUsedError;
  bool get platform => throw _privateConstructorUsedError;
  bool get debug => throw _privateConstructorUsedError;
  bool get print => throw _privateConstructorUsedError;
  bool get io => throw _privateConstructorUsedError;
  bool get os => throw _privateConstructorUsedError;
  bool get stdio => throw _privateConstructorUsedError;
  bool get overwrite => throw _privateConstructorUsedError;
  bool get global => throw _privateConstructorUsedError;
  LuaLibraryPermissions get library => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LuaPermissionsCopyWith<LuaPermissions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LuaPermissionsCopyWith<$Res> {
  factory $LuaPermissionsCopyWith(
          LuaPermissions value, $Res Function(LuaPermissions) then) =
      _$LuaPermissionsCopyWithImpl<$Res, LuaPermissions>;
  @useResult
  $Res call(
      {bool module,
      bool environment,
      bool assertion,
      bool error,
      bool metatable,
      bool raw,
      bool process,
      bool platform,
      bool debug,
      bool print,
      bool io,
      bool os,
      bool stdio,
      bool overwrite,
      bool global,
      LuaLibraryPermissions library});

  $LuaLibraryPermissionsCopyWith<$Res> get library;
}

/// @nodoc
class _$LuaPermissionsCopyWithImpl<$Res, $Val extends LuaPermissions>
    implements $LuaPermissionsCopyWith<$Res> {
  _$LuaPermissionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? module = null,
    Object? environment = null,
    Object? assertion = null,
    Object? error = null,
    Object? metatable = null,
    Object? raw = null,
    Object? process = null,
    Object? platform = null,
    Object? debug = null,
    Object? print = null,
    Object? io = null,
    Object? os = null,
    Object? stdio = null,
    Object? overwrite = null,
    Object? global = null,
    Object? library = null,
  }) {
    return _then(_value.copyWith(
      module: null == module
          ? _value.module
          : module // ignore: cast_nullable_to_non_nullable
              as bool,
      environment: null == environment
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as bool,
      assertion: null == assertion
          ? _value.assertion
          : assertion // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      metatable: null == metatable
          ? _value.metatable
          : metatable // ignore: cast_nullable_to_non_nullable
              as bool,
      raw: null == raw
          ? _value.raw
          : raw // ignore: cast_nullable_to_non_nullable
              as bool,
      process: null == process
          ? _value.process
          : process // ignore: cast_nullable_to_non_nullable
              as bool,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as bool,
      debug: null == debug
          ? _value.debug
          : debug // ignore: cast_nullable_to_non_nullable
              as bool,
      print: null == print
          ? _value.print
          : print // ignore: cast_nullable_to_non_nullable
              as bool,
      io: null == io
          ? _value.io
          : io // ignore: cast_nullable_to_non_nullable
              as bool,
      os: null == os
          ? _value.os
          : os // ignore: cast_nullable_to_non_nullable
              as bool,
      stdio: null == stdio
          ? _value.stdio
          : stdio // ignore: cast_nullable_to_non_nullable
              as bool,
      overwrite: null == overwrite
          ? _value.overwrite
          : overwrite // ignore: cast_nullable_to_non_nullable
              as bool,
      global: null == global
          ? _value.global
          : global // ignore: cast_nullable_to_non_nullable
              as bool,
      library: null == library
          ? _value.library
          : library // ignore: cast_nullable_to_non_nullable
              as LuaLibraryPermissions,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LuaLibraryPermissionsCopyWith<$Res> get library {
    return $LuaLibraryPermissionsCopyWith<$Res>(_value.library, (value) {
      return _then(_value.copyWith(library: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LuaPermissionsCopyWith<$Res>
    implements $LuaPermissionsCopyWith<$Res> {
  factory _$$_LuaPermissionsCopyWith(
          _$_LuaPermissions value, $Res Function(_$_LuaPermissions) then) =
      __$$_LuaPermissionsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool module,
      bool environment,
      bool assertion,
      bool error,
      bool metatable,
      bool raw,
      bool process,
      bool platform,
      bool debug,
      bool print,
      bool io,
      bool os,
      bool stdio,
      bool overwrite,
      bool global,
      LuaLibraryPermissions library});

  @override
  $LuaLibraryPermissionsCopyWith<$Res> get library;
}

/// @nodoc
class __$$_LuaPermissionsCopyWithImpl<$Res>
    extends _$LuaPermissionsCopyWithImpl<$Res, _$_LuaPermissions>
    implements _$$_LuaPermissionsCopyWith<$Res> {
  __$$_LuaPermissionsCopyWithImpl(
      _$_LuaPermissions _value, $Res Function(_$_LuaPermissions) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? module = null,
    Object? environment = null,
    Object? assertion = null,
    Object? error = null,
    Object? metatable = null,
    Object? raw = null,
    Object? process = null,
    Object? platform = null,
    Object? debug = null,
    Object? print = null,
    Object? io = null,
    Object? os = null,
    Object? stdio = null,
    Object? overwrite = null,
    Object? global = null,
    Object? library = null,
  }) {
    return _then(_$_LuaPermissions(
      module: null == module
          ? _value.module
          : module // ignore: cast_nullable_to_non_nullable
              as bool,
      environment: null == environment
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as bool,
      assertion: null == assertion
          ? _value.assertion
          : assertion // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      metatable: null == metatable
          ? _value.metatable
          : metatable // ignore: cast_nullable_to_non_nullable
              as bool,
      raw: null == raw
          ? _value.raw
          : raw // ignore: cast_nullable_to_non_nullable
              as bool,
      process: null == process
          ? _value.process
          : process // ignore: cast_nullable_to_non_nullable
              as bool,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as bool,
      debug: null == debug
          ? _value.debug
          : debug // ignore: cast_nullable_to_non_nullable
              as bool,
      print: null == print
          ? _value.print
          : print // ignore: cast_nullable_to_non_nullable
              as bool,
      io: null == io
          ? _value.io
          : io // ignore: cast_nullable_to_non_nullable
              as bool,
      os: null == os
          ? _value.os
          : os // ignore: cast_nullable_to_non_nullable
              as bool,
      stdio: null == stdio
          ? _value.stdio
          : stdio // ignore: cast_nullable_to_non_nullable
              as bool,
      overwrite: null == overwrite
          ? _value.overwrite
          : overwrite // ignore: cast_nullable_to_non_nullable
              as bool,
      global: null == global
          ? _value.global
          : global // ignore: cast_nullable_to_non_nullable
              as bool,
      library: null == library
          ? _value.library
          : library // ignore: cast_nullable_to_non_nullable
              as LuaLibraryPermissions,
    ));
  }
}

/// @nodoc

class _$_LuaPermissions implements _LuaPermissions {
  const _$_LuaPermissions(
      {this.module = true,
      this.environment = true,
      this.assertion = true,
      this.error = true,
      this.metatable = true,
      this.raw = true,
      this.process = true,
      this.platform = true,
      this.debug = true,
      this.print = true,
      this.io = true,
      this.os = true,
      this.stdio = true,
      this.overwrite = true,
      this.global = true,
      this.library = const LuaLibraryPermissions()});

  @override
  @JsonKey()
  final bool module;
  @override
  @JsonKey()
  final bool environment;
  @override
  @JsonKey()
  final bool assertion;
  @override
  @JsonKey()
  final bool error;
  @override
  @JsonKey()
  final bool metatable;
  @override
  @JsonKey()
  final bool raw;
  @override
  @JsonKey()
  final bool process;
  @override
  @JsonKey()
  final bool platform;
  @override
  @JsonKey()
  final bool debug;
  @override
  @JsonKey()
  final bool print;
  @override
  @JsonKey()
  final bool io;
  @override
  @JsonKey()
  final bool os;
  @override
  @JsonKey()
  final bool stdio;
  @override
  @JsonKey()
  final bool overwrite;
  @override
  @JsonKey()
  final bool global;
  @override
  @JsonKey()
  final LuaLibraryPermissions library;

  @override
  String toString() {
    return 'LuaPermissions(module: $module, environment: $environment, assertion: $assertion, error: $error, metatable: $metatable, raw: $raw, process: $process, platform: $platform, debug: $debug, print: $print, io: $io, os: $os, stdio: $stdio, overwrite: $overwrite, global: $global, library: $library)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LuaPermissions &&
            (identical(other.module, module) || other.module == module) &&
            (identical(other.environment, environment) ||
                other.environment == environment) &&
            (identical(other.assertion, assertion) ||
                other.assertion == assertion) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.metatable, metatable) ||
                other.metatable == metatable) &&
            (identical(other.raw, raw) || other.raw == raw) &&
            (identical(other.process, process) || other.process == process) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.debug, debug) || other.debug == debug) &&
            (identical(other.print, print) || other.print == print) &&
            (identical(other.io, io) || other.io == io) &&
            (identical(other.os, os) || other.os == os) &&
            (identical(other.stdio, stdio) || other.stdio == stdio) &&
            (identical(other.overwrite, overwrite) ||
                other.overwrite == overwrite) &&
            (identical(other.global, global) || other.global == global) &&
            (identical(other.library, library) || other.library == library));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      module,
      environment,
      assertion,
      error,
      metatable,
      raw,
      process,
      platform,
      debug,
      print,
      io,
      os,
      stdio,
      overwrite,
      global,
      library);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LuaPermissionsCopyWith<_$_LuaPermissions> get copyWith =>
      __$$_LuaPermissionsCopyWithImpl<_$_LuaPermissions>(this, _$identity);
}

abstract class _LuaPermissions implements LuaPermissions {
  const factory _LuaPermissions(
      {final bool module,
      final bool environment,
      final bool assertion,
      final bool error,
      final bool metatable,
      final bool raw,
      final bool process,
      final bool platform,
      final bool debug,
      final bool print,
      final bool io,
      final bool os,
      final bool stdio,
      final bool overwrite,
      final bool global,
      final LuaLibraryPermissions library}) = _$_LuaPermissions;

  @override
  bool get module;
  @override
  bool get environment;
  @override
  bool get assertion;
  @override
  bool get error;
  @override
  bool get metatable;
  @override
  bool get raw;
  @override
  bool get process;
  @override
  bool get platform;
  @override
  bool get debug;
  @override
  bool get print;
  @override
  bool get io;
  @override
  bool get os;
  @override
  bool get stdio;
  @override
  bool get overwrite;
  @override
  bool get global;
  @override
  LuaLibraryPermissions get library;
  @override
  @JsonKey(ignore: true)
  _$$_LuaPermissionsCopyWith<_$_LuaPermissions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LuaLibraryPermissions {
  bool get file => throw _privateConstructorUsedError;
  bool get io => throw _privateConstructorUsedError;
  bool get coroutine => throw _privateConstructorUsedError;
  bool get os => throw _privateConstructorUsedError;
  bool get package => throw _privateConstructorUsedError;
  bool get math => throw _privateConstructorUsedError;
  bool get table => throw _privateConstructorUsedError;
  bool get string => throw _privateConstructorUsedError;
  bool get utf8 => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LuaLibraryPermissionsCopyWith<LuaLibraryPermissions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LuaLibraryPermissionsCopyWith<$Res> {
  factory $LuaLibraryPermissionsCopyWith(LuaLibraryPermissions value,
          $Res Function(LuaLibraryPermissions) then) =
      _$LuaLibraryPermissionsCopyWithImpl<$Res, LuaLibraryPermissions>;
  @useResult
  $Res call(
      {bool file,
      bool io,
      bool coroutine,
      bool os,
      bool package,
      bool math,
      bool table,
      bool string,
      bool utf8});
}

/// @nodoc
class _$LuaLibraryPermissionsCopyWithImpl<$Res,
        $Val extends LuaLibraryPermissions>
    implements $LuaLibraryPermissionsCopyWith<$Res> {
  _$LuaLibraryPermissionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? file = null,
    Object? io = null,
    Object? coroutine = null,
    Object? os = null,
    Object? package = null,
    Object? math = null,
    Object? table = null,
    Object? string = null,
    Object? utf8 = null,
  }) {
    return _then(_value.copyWith(
      file: null == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as bool,
      io: null == io
          ? _value.io
          : io // ignore: cast_nullable_to_non_nullable
              as bool,
      coroutine: null == coroutine
          ? _value.coroutine
          : coroutine // ignore: cast_nullable_to_non_nullable
              as bool,
      os: null == os
          ? _value.os
          : os // ignore: cast_nullable_to_non_nullable
              as bool,
      package: null == package
          ? _value.package
          : package // ignore: cast_nullable_to_non_nullable
              as bool,
      math: null == math
          ? _value.math
          : math // ignore: cast_nullable_to_non_nullable
              as bool,
      table: null == table
          ? _value.table
          : table // ignore: cast_nullable_to_non_nullable
              as bool,
      string: null == string
          ? _value.string
          : string // ignore: cast_nullable_to_non_nullable
              as bool,
      utf8: null == utf8
          ? _value.utf8
          : utf8 // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LuaLibraryPermissionsCopyWith<$Res>
    implements $LuaLibraryPermissionsCopyWith<$Res> {
  factory _$$_LuaLibraryPermissionsCopyWith(_$_LuaLibraryPermissions value,
          $Res Function(_$_LuaLibraryPermissions) then) =
      __$$_LuaLibraryPermissionsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool file,
      bool io,
      bool coroutine,
      bool os,
      bool package,
      bool math,
      bool table,
      bool string,
      bool utf8});
}

/// @nodoc
class __$$_LuaLibraryPermissionsCopyWithImpl<$Res>
    extends _$LuaLibraryPermissionsCopyWithImpl<$Res, _$_LuaLibraryPermissions>
    implements _$$_LuaLibraryPermissionsCopyWith<$Res> {
  __$$_LuaLibraryPermissionsCopyWithImpl(_$_LuaLibraryPermissions _value,
      $Res Function(_$_LuaLibraryPermissions) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? file = null,
    Object? io = null,
    Object? coroutine = null,
    Object? os = null,
    Object? package = null,
    Object? math = null,
    Object? table = null,
    Object? string = null,
    Object? utf8 = null,
  }) {
    return _then(_$_LuaLibraryPermissions(
      file: null == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as bool,
      io: null == io
          ? _value.io
          : io // ignore: cast_nullable_to_non_nullable
              as bool,
      coroutine: null == coroutine
          ? _value.coroutine
          : coroutine // ignore: cast_nullable_to_non_nullable
              as bool,
      os: null == os
          ? _value.os
          : os // ignore: cast_nullable_to_non_nullable
              as bool,
      package: null == package
          ? _value.package
          : package // ignore: cast_nullable_to_non_nullable
              as bool,
      math: null == math
          ? _value.math
          : math // ignore: cast_nullable_to_non_nullable
              as bool,
      table: null == table
          ? _value.table
          : table // ignore: cast_nullable_to_non_nullable
              as bool,
      string: null == string
          ? _value.string
          : string // ignore: cast_nullable_to_non_nullable
              as bool,
      utf8: null == utf8
          ? _value.utf8
          : utf8 // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_LuaLibraryPermissions implements _LuaLibraryPermissions {
  const _$_LuaLibraryPermissions(
      {this.file = true,
      this.io = true,
      this.coroutine = true,
      this.os = true,
      this.package = true,
      this.math = true,
      this.table = true,
      this.string = true,
      this.utf8 = true});

  @override
  @JsonKey()
  final bool file;
  @override
  @JsonKey()
  final bool io;
  @override
  @JsonKey()
  final bool coroutine;
  @override
  @JsonKey()
  final bool os;
  @override
  @JsonKey()
  final bool package;
  @override
  @JsonKey()
  final bool math;
  @override
  @JsonKey()
  final bool table;
  @override
  @JsonKey()
  final bool string;
  @override
  @JsonKey()
  final bool utf8;

  @override
  String toString() {
    return 'LuaLibraryPermissions(file: $file, io: $io, coroutine: $coroutine, os: $os, package: $package, math: $math, table: $table, string: $string, utf8: $utf8)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LuaLibraryPermissions &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.io, io) || other.io == io) &&
            (identical(other.coroutine, coroutine) ||
                other.coroutine == coroutine) &&
            (identical(other.os, os) || other.os == os) &&
            (identical(other.package, package) || other.package == package) &&
            (identical(other.math, math) || other.math == math) &&
            (identical(other.table, table) || other.table == table) &&
            (identical(other.string, string) || other.string == string) &&
            (identical(other.utf8, utf8) || other.utf8 == utf8));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, file, io, coroutine, os, package, math, table, string, utf8);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LuaLibraryPermissionsCopyWith<_$_LuaLibraryPermissions> get copyWith =>
      __$$_LuaLibraryPermissionsCopyWithImpl<_$_LuaLibraryPermissions>(
          this, _$identity);
}

abstract class _LuaLibraryPermissions implements LuaLibraryPermissions {
  const factory _LuaLibraryPermissions(
      {final bool file,
      final bool io,
      final bool coroutine,
      final bool os,
      final bool package,
      final bool math,
      final bool table,
      final bool string,
      final bool utf8}) = _$_LuaLibraryPermissions;

  @override
  bool get file;
  @override
  bool get io;
  @override
  bool get coroutine;
  @override
  bool get os;
  @override
  bool get package;
  @override
  bool get math;
  @override
  bool get table;
  @override
  bool get string;
  @override
  bool get utf8;
  @override
  @JsonKey(ignore: true)
  _$$_LuaLibraryPermissionsCopyWith<_$_LuaLibraryPermissions> get copyWith =>
      throw _privateConstructorUsedError;
}
