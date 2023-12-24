import 'package:fixnum/fixnum.dart';

abstract class NumberUtils {
  static Int64? toIntRepresentation(dynamic v) {
    if (v is Int64) {
      return v;
    } else if (v is double) {
      return doubleToIntRepresentation(v);
    } else {
      return null;
    }
  }

  static Int64? doubleToIntRepresentation(double value) {
    final intVal = value.toInt();
    if (doubleNearlyEqual(intVal.toDouble(), value)) {
      return Int64(intVal);
    } else {
      return null;
    }
  }

  static bool doubleNearlyEqual(double a, double b, {double epsilon = 1e-10}) {
    final absA = a.abs();
    final absB = b.abs();
    final diff = (a - b).abs();

    if (a == b) {
      return true;
    } else if (a == 0 || b == 0 || diff < double.minPositive) {
      return diff < epsilon * double.minPositive;
    } else {
      return diff / (absA + absB) < epsilon;
    }
  }

  static bool isDivisionInfinity(num a, num b) {
    if (b == 0.0) {
      return a > 0 || a < 0;
    } else {
      return false;
    }
  }
}
