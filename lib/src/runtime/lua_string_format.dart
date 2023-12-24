import 'package:result_dart/result_dart.dart';
import 'package:sprintf/sprintf.dart';
import 'package:tradaul/src/compiler/number_parser.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

// ignore_for_file: non_constant_identifier_names

final class LuaStringFormatter {
  static PrintFormat? _luaSprintf;

  static PrintFormat get luaSprintf => _luaSprintf ?? _createLuaSprintf();

  static PrintFormat _createLuaSprintf() {
    return PrintFormat()
      ..unregistier_specifier('i')
      ..unregistier_specifier('d')
      ..unregistier_specifier('x')
      ..unregistier_specifier('x')
      ..unregistier_specifier('o')
      ..unregistier_specifier('O')
      ..register_specifier(
        'i',
        (arg, options) => _LuaIntegerFormatter(arg, 'i', options),
      )
      ..register_specifier(
        'd',
        (arg, options) => _LuaIntegerFormatter(arg, 'd', options),
      )
      ..register_specifier(
        'x',
        (arg, options) => _LuaIntegerFormatter(arg, 'x', options),
      )
      ..register_specifier(
        'X',
        (arg, options) => _LuaIntegerFormatter(arg, 'x', options),
      )
      ..register_specifier(
        'o',
        (arg, options) => _LuaIntegerFormatter(arg, 'o', options),
      )
      ..register_specifier(
        'O',
        (arg, options) => _LuaIntegerFormatter(arg, 'o', options),
      )
      ..register_specifier(
        'u',
        (arg, options) => _UnsignedFormatter(arg, 'u', options),
      )
      ..register_specifier(
        'c',
        (arg, options) => _CharacterFormatter(arg, 'c', options),
      )
      ..register_specifier(
        'q',
        (arg, options) => _QuotedStringFormatter(arg, 'q', options),
      )
      ..register_specifier(
        'p',
        (arg, options) => _PointerFormatter(arg, 'p', options),
      )
      ..register_specifier(
        'u',
        (arg, options) => _UnsignedFormatter(arg, 'u', options),
      )
      ..register_specifier(
        's',
        (arg, options) => _LuaStringFormatter(arg, 's', options),
      );
  }

  static Result<String, Exception> format(
    String format,
    List<LuaValue> arguments,
  ) {
    try {
      final rawArguments = arguments.map((e) {
        switch (e.runtimeType) {
          case LuaInteger:
            return e;
          default:
            return e.rawValue;
        }
      }).toList();
      return Success(luaSprintf(format, rawArguments));
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}

final class _QuotedStringFormatter extends StringFormatter {
  _QuotedStringFormatter(this.arg, dynamic fmt_type, dynamic options)
      : super(arg, fmt_type, options);

  final dynamic arg;

  @override
  String asString() {
    if (arg == null) {
      return 'nil';
    } else if (arg is String) {
      final base = super.asString();
      return LuaString(base).luaRepresentation;
    } else if (arg is LuaValue) {
      return (arg as LuaValue).rawValue.toString();
    } else {
      return arg.toString();
    }
  }
}

final class _PointerFormatter extends Formatter {
  _PointerFormatter(this.arg, super.fmt_type, super.options);

  final dynamic arg;

  @override
  String asString() {
    return '(null)';
  }
}

final class _UnsignedFormatter extends Formatter {
  _UnsignedFormatter(this.arg, super.fmt_type, super.options);

  final dynamic arg;

  @override
  String asString() {
    if (arg is LuaInteger) {
      return (arg as LuaInteger).value.toStringUnsigned();
    } else {
      throw ArgumentError('%u integer expected, got ${arg.runtimeType})');
    }
  }
}

final class _LuaIntegerFormatter extends IntFormatter {
  _LuaIntegerFormatter(dynamic arg, dynamic fmt_type, dynamic options)
      : super(_toInt(arg, fmt_type), fmt_type, options);

  static int _toInt(dynamic arg, dynamic fmt_type) {
    if (arg is LuaInteger) {
      return arg.value.toInt();
    } else if (arg is String) {
      final n = NumberParser.parseInt64(arg);
      if (n != null) {
        return n.toInt();
      }
    }
    throw ArgumentError('%$fmt_type integer expected, got ${arg.runtimeType}');
  }
}

final class _CharacterFormatter extends Formatter {
  _CharacterFormatter(this.arg, super.fmt_type, super.options);

  final dynamic arg;

  @override
  String asString() {
    if (arg is LuaInteger) {
      final n = (arg as LuaInteger).value;
      return String.fromCharCode(n.toInt());
    } else {
      throw ArgumentError('%c integer expected, got ${arg.runtimeType}');
    }
  }
}

final class _LuaStringFormatter extends StringFormatter {
  _LuaStringFormatter(this.arg, dynamic fmt_type, dynamic options)
      : super(arg, fmt_type, options);

  final dynamic arg;

  @override
  String asString() {
    if (arg == null) {
      return 'nil';
    } else if (arg is LuaValue) {
      return (arg as LuaValue).luaToString();
    } else {
      return super.asString();
    }
  }
}
