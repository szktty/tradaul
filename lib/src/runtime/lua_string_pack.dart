import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:result_dart/result_dart.dart';

enum EndianType { little, big, native }

// TODO: 32 bit in JavaScript
int _nativeIntSize = 8;
int _nativeFloatSize = 8;
int _luaIntSize = 8;
int _luaFloatSize = _nativeFloatSize;
int _nativeAlignment = 8;

sealed class _FormatOption {
  const _FormatOption();
}

final class _EndiannessOption extends _FormatOption {
  const _EndiannessOption(this.type);

  final EndianType type;
}

final class _AlignmentOption extends _FormatOption {
  const _AlignmentOption(this.size);

  final int size;
}

final class _SignedByteOption extends _FormatOption {
  const _SignedByteOption();
}

final class _UnsignedByteOption extends _FormatOption {
  const _UnsignedByteOption();
}

final class _SignedShortOption extends _FormatOption {
  const _SignedShortOption();
}

final class _UnsignedShortOption extends _FormatOption {
  const _UnsignedShortOption();
}

final class _SignedLongOption extends _FormatOption {
  const _SignedLongOption();
}

final class _UnsignedLongOption extends _FormatOption {
  const _UnsignedLongOption();
}

final class _LuaIntegerOption extends _FormatOption {
  const _LuaIntegerOption();
}

final class _LuaUnsignedOption extends _FormatOption {
  const _LuaUnsignedOption();
}

final class _LuaNumberOption extends _FormatOption {
  const _LuaNumberOption();
}

final class _NativeSizeOption extends _FormatOption {
  const _NativeSizeOption();
}

final class _FloatOption extends _FormatOption {
  const _FloatOption();
}

final class _DoubleOption extends _FormatOption {
  const _DoubleOption();
}

final class _FixedStringOption extends _FormatOption {
  const _FixedStringOption(this.size);

  final int size;
}

final class _ZeroTerminatedStringOption extends _FormatOption {
  const _ZeroTerminatedStringOption();
}

final class _StringWithLengthOption extends _FormatOption {
  const _StringWithLengthOption(this.size);

  final int size;
}

final class _PaddingOption extends _FormatOption {
  const _PaddingOption();
}

final class _EmptyItemOption extends _FormatOption {
  const _EmptyItemOption(this.option);

  final List<_FormatOption> option;
}

final class _FormatScanner {
  _FormatScanner(this.format);

  final String format;
  int index = 0;

  bool get hasNext => index < format.length;

  String next() {
    return format[index++];
  }

  String peek() {
    return format[index];
  }

  int? scanNumber([int? defaultValue]) {
    final startIndex = index;
    while (hasNext && _isDigit(peek())) {
      index++;
    }
    if (startIndex == index) {
      return defaultValue;
    } else {
      return int.parse(format.substring(startIndex, index));
    }
  }

  bool _isDigit(String char) {
    return char.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
        char.codeUnitAt(0) <= '9'.codeUnitAt(0);
  }
}

final class _FormatParser {
  _FormatParser(this.format) : scanner = _FormatScanner(format);

  final String format;
  final _FormatScanner scanner;

  Result<List<_FormatOption>, String> parse() {
    final options = <_FormatOption>[];

    while (scanner.hasNext) {
      final char = scanner.next();

      switch (char) {
        case '<':
          options.add(const _EndiannessOption(EndianType.little));
        case '>':
          options.add(const _EndiannessOption(EndianType.big));
        case '=':
          options.add(const _EndiannessOption(EndianType.native));
        case '!':
          options.add(_AlignmentOption(scanner.scanNumber(_nativeAlignment)!));
        case 'b':
          options.add(const _SignedByteOption());
        case 'B':
          options.add(const _UnsignedByteOption());
        case 'h':
          options.add(const _SignedShortOption());
        case 'H':
          options.add(const _UnsignedShortOption());
        case 'l':
          options.add(const _SignedLongOption());
        case 'L':
          options.add(const _UnsignedLongOption());
        case 'j':
          options.add(const _LuaIntegerOption());
        case 'J':
          options.add(const _LuaUnsignedOption());
        case 'T':
          options.add(const _NativeSizeOption());
        case 'f':
          options.add(const _FloatOption());
        case 'd':
          options.add(const _DoubleOption());
        case 'n':
          options.add(const _LuaNumberOption());
        case 'c':
          final n = scanner.scanNumber(_nativeAlignment);
          if (n != null) {
            options.add(_FixedStringOption(n));
          } else {
            return const Failure("missing size for format option 'c'");
          }
        case 's':
          options.add(
            _StringWithLengthOption(scanner.scanNumber(_nativeIntSize)!),
          );
        case 'x':
          options.add(const _PaddingOption());
        case 'X':
          final result = parse();
          if (result.isError()) {
            return result;
          }
          options.add(_EmptyItemOption(result.getOrThrow()));
        case 'z':
          options.add(const _ZeroTerminatedStringOption());
        case ' ':
          continue;
        default:
          return Failure("invalid format option '$char'");
      }
    }

    return Success(options);
  }
}

final class _Context {
  _Context();

  EndianType endian = EndianType.native;
  int alignment = _nativeAlignment;
  final data = ByteData(8);
  final builder = BytesBuilder();
}

abstract class StructPacker {
  static Result<List<int>, String> pack(String format, List<Int64> values) {
    final result = _FormatParser(format).parse();
    if (result.isError()) {
      return Failure(result.exceptionOrNull()!);
    }
    final options = result.getOrThrow();

    final context = _Context();
    for (final option in options) {
      final result = _packOption(option, context);
      if (result.isError()) {
        return Failure(result.exceptionOrNull()!);
      }
    }

    return Success(context.builder.toBytes().toList());
  }

  static Result<void, String> _packOption(
    _FormatOption option,
    _Context context,
  ) {
    // TODO: implement
    return const Success(());
  }
}
