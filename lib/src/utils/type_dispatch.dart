abstract class TypeDispatch<R> {
  Type? validate(dynamic v1, dynamic v2);

  R dispatch(dynamic v1, dynamic v2);
}

final class TypeDispatch2<T1, T2, R> implements TypeDispatch<R> {
  TypeDispatch2({
    required this.t1T1,
    required this.t1T2,
    required this.t2T1,
    required this.t2T2,
  });

  final R Function(T1, T1) t1T1;
  final R Function(T1, T2) t1T2;
  final R Function(T2, T1) t2T1;
  final R Function(T2, T2) t2T2;

  @override
  Type? validate(dynamic v1, dynamic v2) {
    if (v1 is! T1 && v1 is! T2) {
      return v1.runtimeType;
    } else if (v2 is! T1 && v2 is! T2) {
      return v2.runtimeType;
    } else {
      return null;
    }
  }

  @override
  R dispatch(dynamic v1, dynamic v2) {
    if (v1 is T1) {
      if (v2 is T1) {
        return t1T1(v1, v2);
      } else if (v2 is T2) {
        return t1T2(v1, v2);
      }
    } else if (v1 is T2) {
      if (v2 is T1) {
        return t2T1(v1, v2);
      } else if (v2 is T2) {
        return t2T2(v1, v2);
      }
    }
    throw ArgumentError('type dispatch: invalid type combination: $v1 and $v2');
  }
}

final class TypeDispatch3<T1, T2, T3, R> implements TypeDispatch<R> {
  TypeDispatch3({
    required this.t1T1,
    required this.t1T2,
    required this.t1T3,
    required this.t2T1,
    required this.t2T2,
    required this.t2T3,
    required this.t3T1,
    required this.t3T2,
    required this.t3T3,
  });

  final R Function(T1, T1) t1T1;
  final R Function(T1, T2) t1T2;
  final R Function(T1, T3) t1T3;
  final R Function(T2, T1) t2T1;
  final R Function(T2, T2) t2T2;
  final R Function(T2, T3) t2T3;
  final R Function(T3, T1) t3T1;
  final R Function(T3, T2) t3T2;
  final R Function(T3, T3) t3T3;

  @override
  Type? validate(dynamic v1, dynamic v2) {
    if (v1 is! T1 && v1 is! T2 && v1 is! T3) return v1.runtimeType;
    if (v2 is! T1 && v2 is! T2 && v2 is! T3) return v2.runtimeType;
    return null;
  }

  @override
  R dispatch(dynamic v1, dynamic v2) {
    if (v1 is T1) {
      if (v2 is T1) return t1T1(v1, v2);
      if (v2 is T2) return t1T2(v1, v2);
      if (v2 is T3) return t1T3(v1, v2);
    }
    if (v1 is T2) {
      if (v2 is T1) return t2T1(v1, v2);
      if (v2 is T2) return t2T2(v1, v2);
      if (v2 is T3) return t2T3(v1, v2);
    }
    if (v1 is T3) {
      if (v2 is T1) return t3T1(v1, v2);
      if (v2 is T2) return t3T2(v1, v2);
      if (v2 is T3) return t3T3(v1, v2);
    }
    throw ArgumentError('type dispatch: invalid type combination: $v1 and $v2');
  }
}
