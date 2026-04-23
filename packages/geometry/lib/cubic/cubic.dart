import 'package:vector_math/vector_math_64.dart';

part 'methods.dart';

final class CubicKnot2 {
  CubicKnot2(this.p, {this.c1, this.c2});

  Vector2 p;
  Vector2? c1;
  Vector2? c2;

  CubicKnot2 copy() => .new(p.clone(), c1: c1?.clone(), c2: c2?.clone());
}

final class Cubic2 {
  Cubic2(this.a, this.b, {this.c1, this.c2});

  static void flattenCubic(
    Vector2 a,
    Vector2 c1,
    Vector2 c2,
    Vector2 b,
    double tolerance,
    void Function(Vector2, double) callback,
  ) => _flattenCubic(a, c1, c2, b, tolerance, callback);

  final Vector2 a;
  final Vector2? c1;
  final Vector2? c2;
  final Vector2 b;

  /// Evaluate the cubic at a given parameter t in [0, 1].
  Vector2 sample(double t) {
    final q1 = c1 ?? a;
    final q2 = c2 ?? b;
    final u = 1 - t, uu = u * u, tt = t * t;
    return a * (uu * u) + q1 * (3 * uu * t) + q2 * (3 * u * tt) + b * (tt * t);
  }

  /// Returns a polyline approximation of this cubic within a given [tolerance] distance.
  List<Vector2> flatten({double tolerance = 0.5}) {
    final (result, _) = _flattenCubicWithResult(a, c1 ?? a, c2 ?? b, b, tolerance);
    return result;
  }

  /// Returns the arc length of this cubic.
  double arcLength({double tolerance = 0.5}) {
    final points = flatten(tolerance: tolerance);
    var length = 0.0;
    for (var i = 1; i < points.length; i++) length += points[i].distanceTo(points[i - 1]);
    return length;
  }

  /// Splits this cubic at parameter t in [0, 1] into two cubics.
  (Cubic2, Cubic2) split(double t) {
    if (!(t > 0 && t < 1)) throw ArgumentError.value(t, 't', 'must be in range (0, 1)');
    if (c1 == null && c2 == null) {
      final mid = _lerpVector2(a, b, t);
      return (.new(a, mid), .new(mid.clone(), b));
    }

    final q1 = c1 ?? a;
    final q2 = c2 ?? b;
    final m01 = _lerpVector2(a, q1, t);
    final m12 = _lerpVector2(q1, q2, t);
    final m23 = _lerpVector2(q2, b, t);
    final m012 = _lerpVector2(m01, m12, t);
    final m123 = _lerpVector2(m12, m23, t);
    final m0123 = _lerpVector2(m012, m123, t);

    final q1IsNull = c1 == null;
    final q2IsNull = c2 == null;

    return (
      .new(a, m0123, c1: q1IsNull ? null : m01, c2: q1IsNull && q2IsNull ? null : m012),
      .new(m0123.clone(), b, c1: q1IsNull && q2IsNull ? null : m123, c2: q2IsNull ? null : m23),
    );
  }
}

final class CubicSpline2 {
  CubicSpline2(this.knots);
  CubicSpline2.single(Vector2 p) : knots = [.new(p)];
  CubicSpline2.empty() : knots = [];

  factory CubicSpline2.cubics(List<Cubic2> cubics) {
    final knots = <CubicKnot2>[];
    if (cubics.isEmpty) return .empty();

    knots.add(.new(cubics.first.a, c1: null, c2: cubics.first.c1));

    for (var i = 0; i < cubics.length - 1; i++) {
      knots.add(.new(cubics[i].b, c1: cubics[i].c2, c2: cubics[i + 1].c1));
    }

    knots.add(.new(cubics.last.b, c1: cubics.last.c2, c2: null));

    return CubicSpline2(knots);
  }

  List<CubicKnot2> knots;

  /// Number of knots/anchors in the spline.
  int get length => knots.length;

  /// Whether the spline has no knots.
  bool get isEmpty => knots.isEmpty;

  /// Number of segments in the spline.
  int get segmentCount => length <= 1 ? 0 : length - 1;

  /// Return the i-th cubic segment of the spline as a [Cubic2].
  Cubic2 segment(int i) {
    if (i < 0 || i >= segmentCount) throw RangeError.index(i, knots, 'segment', null, segmentCount);
    final k0 = knots[i];
    final k1 = knots[i + 1];
    return .new(k0.p, k1.p, c1: k0.c2, c2: k1.c1);
  }

  /// Return an iterable of all cubic segments in the spline.
  Iterable<Cubic2> get segments sync* {
    for (var i = 0; i < segmentCount; i++) yield segment(i);
  }

  /// Evaluate at a given parameter [t] in range (0, 1).
  Vector2 sample(double t) {
    if (isEmpty) throw StateError('Cannot sample an empty spline');
    if (length == 1) return knots.first.p;

    final n = segmentCount;
    final clamped = t.clamp(0.0, 1.0) * n;
    if (clamped >= n) return segment(n - 1).sample(1.0);

    final i = clamped.floor();
    return segment(i).sample(clamped - i);
  }

  /// Return a polyline approximation of this cubic spline within a given [tolerance] distance.
  List<Vector2> flatten({double tolerance = 0.5}) {
    if (isEmpty) return [];
    final result = <Vector2>[knots.first.p];

    for (var i = 0; i < segmentCount; i++) {
      final k0 = knots[i];
      final k1 = knots[i + 1];
      final (cubicResult, _) = _flattenCubicWithResult(k0.p, k0.c2 ?? k0.p, k1.c1 ?? k1.p, k1.p, tolerance);
      result.addAll(cubicResult.skip(1));
    }

    return result;
  }

  /// Arc length of segment at index [i].
  double segmentArcLength(int i, {double tolerance = 0.5}) => segment(i).arcLength(tolerance: tolerance);

  /// Arc length of the whole spline.
  double arcLength({double tolerance = 0.5}) {
    var length = 0.0;
    for (var i = 0; i < segmentCount; i++) length += segmentArcLength(i, tolerance: tolerance);
    return length;
  }

  /// Splits this spline at parameter [t] in range (0, 1) into two splines.
  (CubicSpline2, CubicSpline2) split(double t) {
    final n = segmentCount;
    if (n == 0) throw StateError('Cannot split an empty spline');
    if (!(t > 0 && t < 1)) throw ArgumentError.value(t, 't', 'must be in range (0, 1)');

    final local = t * n;
    final rounded = local.round();

    // Split point is exactly on a knot.
    if (rounded >= 1 && rounded <= n - 1 && (local - rounded).abs() < 1e-9) {
      final left = knots.take(rounded + 1).map((k) => k.copy()).toList();
      final right = knots.skip(rounded).map((k) => k.copy()).toList();
      left.last.c2 = null;
      right.first.c1 = null;
      return (.new(left), .new(right));
    }

    final i = local.floor();
    final u = local - i;
    final (left, right) = segment(i).split(u);

    final leftKnots = knots.take(i).map((k) => k.copy()).toList();
    final leftBoundary = knots[i].copy();
    leftBoundary.c2 = left.c1?.clone();
    leftKnots.add(leftBoundary);
    leftKnots.add(.new(left.b.clone(), c1: left.c2?.clone()));

    final rightKnots = <CubicKnot2>[];
    rightKnots.add(.new(right.a.clone(), c2: right.c1?.clone()));
    final rightBoundary = knots[i + 1].copy();
    rightBoundary.c1 = right.c2?.clone();
    rightKnots.add(rightBoundary);
    rightKnots.addAll(knots.skip(i + 2).map((k) => k.copy()));

    return (.new(leftKnots), .new(rightKnots));
  }
}
