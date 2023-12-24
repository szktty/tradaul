import 'dart:math';

import 'package:fixnum/fixnum.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

abstract class NumberParser {
  static Int64? parseInt64(String s) {
    if (s.toLowerCase().startsWith('0x')) {
      return Int64.tryParseHex(s.substring(2));
    } else {
      return Int64.tryParseInt(s);
    }
  }

  static double? parseDouble(String s) {
    if (s.toLowerCase().startsWith('0x')) {
      return _parseHexFloat(s.substring(2));
    } else {
      return double.tryParse(s);
    }
  }

  static double? _parseHexFloat(String input) {
    final parts = input.toLowerCase().split('p');

    String basePart;
    String? exponentPart;

    if (parts.length == 2) {
      basePart = parts[0];
      exponentPart = parts[1];
    } else if (parts.length == 1) {
      basePart = parts[0];
      exponentPart = null;
    } else {
      return null;
    }

    basePart = basePart.startsWith('0x') ? basePart.substring(2) : basePart;

    final hexParts = basePart.split('.');
    if (hexParts.length > 2) return null;

    final hexIntPart = hexParts[0];
    final intBase = hexIntPart.isNotEmpty ? int.tryParse('0x$hexIntPart') : 0;
    if (intBase == null) return null;

    var result = intBase.toDouble();

    if (hexParts.length == 2) {
      for (var i = 0; i < hexParts[1].length; i++) {
        final value = int.tryParse(hexParts[1][i], radix: 16);
        if (value == null) return null;
        result += value / pow(16, i + 1);
      }
    }

    final intExponent = (exponentPart == null) ? 0 : int.tryParse(exponentPart);
    if (intExponent == null) return null;

    return result * pow(2, intExponent.toDouble());
  }

  static LuaValue? parseLuaValue(String s) {
    final int64 = parseInt64(s);
    if (int64 != null) {
      return LuaInteger(int64);
    }

    final double = parseDouble(s);
    if (double != null) {
      return LuaFloat(double);
    }

    return null;
  }
}
