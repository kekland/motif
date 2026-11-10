import 'dart:math' as math;
import 'dart:typed_data';

import 'package:shared/shared.dart';
import 'package:geometry/geometry_32.dart';

extension type Size2._(Vec2 vec) {
  Size2.from(Vec2 vec) : this._(vec);
  Size2(double width, double height) : this._(Vec2(width, height));
  Size2.zero() : this._(Vec2.zero());

  double get width => vec.x;
  double get height => vec.y;

  double get longest => width > height ? width : height;
  double get shortest => width > height ? height : width;

  Size2 operator +(Size2 other) => ._(vec + other.vec);
  Size2 operator -(Size2 other) => ._(vec - other.vec);
  Size2 operator *(double scalar) => ._(vec * scalar);
  Size2 operator /(double scalar) => ._(vec / scalar);

  Size2 transformed(Mat4 transform) {
    final aabb = toAabb();
    final transformed = aabb.transformed(transform);
    return transformed.size;
  }

  Size2 hull(Size2 other) => .new(
    width > other.width ? width : other.width,
    height > other.height ? height : other.height,
  );

  Size2 inflate(double horizontal, double vertical) => .new(width + horizontal, height + vertical);
  Size2 deflate(double horizontal, double vertical) => .new(width - horizontal, height - vertical);

  Aabb2 toAabb({Vec2? origin}) {
    if (origin == null) return .ltwh(0, 0, width, height);
    return .ltwh(origin.x, origin.y, width, height);
  }

  Size2 withWidth(double newWidth) => .new(newWidth, height);
  Size2 withHeight(double newHeight) => .new(width, newHeight);

  Size2 scale(double sx, double sy) => .new(width * sx, height * sy);
  Size2 round() => .new(width.roundToDouble(), height.roundToDouble());

  bool equals(Size2 other, [double epsilon = 1e-12]) => vec.equals(other.vec, epsilon);
  bool exactEquals(Size2 other) => vec.exactEquals(other.vec);
}

final class Intersection {
  Intersection(this.ta, this.tb, this.point);

  static const epsD = 1e-6;
  static const epsD2 = epsD * epsD;
  static const epsT = 1e-9;

  final double ta, tb;
  final Vec2 point;

  @pragma('vm:prefer-inline')
  T? _resolveEndpoints<T>(double t, T Function() start, T Function() end) {
    if (t <= epsT) return start();
    if (t >= 1 - epsT) return end();
    return null;
  }

  @pragma('vm:prefer-inline')
  T? resolveEndpointsA<T>(T Function() start, T Function() end) => _resolveEndpoints(ta, start, end);

  @pragma('vm:prefer-inline')
  T? resolveEndpointsB<T>(T Function() start, T Function() end) => _resolveEndpoints(tb, start, end);
}

final class Overlap {
  Overlap(this.ta0, this.ta1, this.tb0, this.tb1);

  final double ta0, ta1;
  final double tb0, tb1;

  bool _contains(double a, double b, double t) => t >= a - 1e-6 && t <= b + 1e-6;

  bool containsA(double t) => _contains(ta0, ta1, t);
  bool containsB(double t) => _contains(tb0, tb1, t);
}

final class Intersections {
  const Intersections(this.intersections, this.overlaps);
  static const Intersections empty = .new([], []);

  final List<Intersection> intersections;
  final List<Overlap> overlaps;

  bool get isEmpty => intersections.isEmpty && overlaps.isEmpty;
  bool get isNotEmpty => intersections.isNotEmpty || overlaps.isNotEmpty;
}


extension type const Aabb2._(Vec2List storage) {
  Aabb2.minMax(Vec2 min, Vec2 max) : storage = .new(2) {
    storage[0] = min;
    storage[1] = max;
  }

  Aabb2.view(Vec2List storage) : storage = storage;

  Aabb2.invertedInfinity() : this.minMax(.new(.infinity, .infinity), .new(.negativeInfinity, .negativeInfinity));
  Aabb2.point(Vec2 p) : this.minMax(p, p);
  Aabb2.empty() : this.minMax(.zero(), .zero());

  Aabb2(double left, double top, double right, double bottom) : this.minMax(.new(left, top), .new(right, bottom));
  Aabb2.ltwh(double left, double top, double width, double height) : this(left, top, left + width, top + height);
  Aabb2.center(Vec2 center, double width, double height)
    : this.minMax(
        .new(center.x - width * 0.5, center.y - height * 0.5),
        .new(center.x + width * 0.5, center.y + height * 0.5),
      );

  factory Aabb2.bbox(Iterable<Vec2> points) {
    if (points.isEmpty) return Aabb2.minMax(.zero(), .zero());
    var min = points.first, max = points.first;
    for (final p in points) {
      min = min.min(p);
      max = max.max(p);
    }
    return Aabb2.minMax(min, max);
  }

  factory Aabb2.bbox2(Vec2 a, Vec2 b) => .minMax(
    .min(a, b),
    .max(a, b),
  );

  Vec2 get min => storage[0];
  Vec2 get max => storage[1];

  set _min(Vec2 value) => storage[0] = value;
  set _max(Vec2 value) => storage[1] = value;

  void hull(Aabb2 other) {
    _min = min.min(other.min);
    _max = max.max(other.max);
  }

  void hullPoint(Vec2 p) {
    _min = min.min(p);
    _max = max.max(p);
  }

  Aabb2 inflated(double amount) => Aabb2.minMax(
    .new(min.x - amount, min.y - amount),
    .new(max.x + amount, max.y + amount),
  );

  bool contains(Vec2 p, {double inflate = 0}) =>
      p.x >= min.x - inflate && p.x <= max.x + inflate && p.y >= min.y - inflate && p.y <= max.y + inflate;

  bool containsAabb(Aabb2 other) =>
      other.min.x >= min.x && other.max.x <= max.x && other.min.y >= min.y && other.max.y <= max.y;

  bool intersectsAabb(Aabb2 other) =>
      min.x <= other.max.x && max.x >= other.min.x && min.y <= other.max.y && max.y >= other.min.y;

  double distance2To(Vec2 p) {
    final dx = math.max(math.max(min.x - p.x, 0.0), p.x - max.x);
    final dy = math.max(math.max(min.y - p.y, 0.0), p.y - max.y);
    return dx * dx + dy * dy;
  }

  double distanceTo(Vec2 p) => math.sqrt(distance2To(p));

  void transform(Mat4 m) {
    final a = m.transform2(Vec2(min.x, min.y));
    final b = m.transform2(Vec2(max.x, min.y));
    final c = m.transform2(Vec2(max.x, max.y));
    final d = m.transform2(Vec2(min.x, max.y));
    _min = .min(a, .min(b, .min(c, d)));
    _max = .max(a, .max(b, .max(c, d)));
  }

  void transformDelta(Mat4 m) {
    final a = m.transformDelta2(Vec2(min.x, min.y));
    final b = m.transformDelta2(Vec2(max.x, min.y));
    final c = m.transformDelta2(Vec2(max.x, max.y));
    final d = m.transformDelta2(Vec2(min.x, max.y));
    _min = .min(a, .min(b, .min(c, d)));
    _max = .max(a, .max(b, .max(c, d)));
  }

  Aabb2 transformed(Mat4 m) => copyWith()..transform(m);
  Aabb2 transformedDelta(Mat4 m) => copyWith()..transformDelta(m);

  Size2 get size => .new(max.x - min.x, max.y - min.y);
  double get width => max.x - min.x;
  double get height => max.y - min.y;
  double get aspectRatio => width / height;

  double get left => min.x;
  double get top => min.y;
  double get right => max.x;
  double get bottom => max.y;

  Vec2 get topLeft => min;
  Vec2 get topRight => .new(max.x, min.y);
  Vec2 get bottomRight => max;
  Vec2 get bottomLeft => .new(min.x, max.y);
  Vec2List get corners => .fromElementList([topLeft, topRight, bottomRight, bottomLeft]);

  Vec2 get center => .new((min.x + max.x) * 0.5, (min.y + max.y) * 0.5);

  Aabb2 copyWith({Vec2? min, Vec2? max}) => .minMax(min ?? this.min, max ?? this.max);
  Aabb2 copy() => .minMax(min, max);
}

extension type const CornerRadius._(Vec2 _v) implements Vec2 {
  CornerRadius(double x, double y) : _v = .new(x, y);
  CornerRadius.vec(Vec2 v) : _v = v;

  static final zero = CornerRadius._(.zero());

  double get x => _v.x;
  double get y => _v.y;
}

extension type const Quadratic2._(Vec2List storage) implements Object {
  Quadratic2.zero() : storage = .new(3);
  Quadratic2.line(Vec2 p0, Vec2 p2) : this(p0, p2, p1: p0 + (p2 - p0).scale(0.5));
  Quadratic2.view(Vec2List storage) : storage = storage;

  Quadratic2(Vec2 p0, Vec2 p2, {Vec2? p1}) : storage = .new(3) {
    storage[0] = p0;
    storage[1] = p1 ?? (p0 + p2).scale(0.5);
    storage[2] = p2;
  }

  Vec2 get p0 => storage[0];
  Vec2 get p1 => storage[1];
  Vec2 get p2 => storage[2];

  set p0(Vec2 v) => storage[0] = v;
  set p1(Vec2 v) => storage[1] = v;
  set p2(Vec2 v) => storage[2] = v;
}



final class StrokeData {
  StrokeData();

  static const int _baseSize = storageBaseSize;

  var _length = 0;
  int get length => _length;

  bool get isEmpty => _length == 0;
  bool get isNotEmpty => _length > 0;

  double get totalLength => _length > 0 ? _arcLength[_length - 1] : 0;

  Vec2List _point = .new(_baseSize);
  Float64List _timestamp = .new(_baseSize);
  Float64List _arcLength = .new(_baseSize);
  Float64List _pressure = .new(_baseSize);
  Float64List _tilt = .new(_baseSize);
  Float64List _orientation = .new(_baseSize);

  Vec2 point(int i) => _point[i];
  double arcLength(int i) => _arcLength[i];
  double timestamp(int i) => _timestamp[i];
  double pressure(int i) => _pressure[i];
  double tilt(int i) => _tilt[i];
  double orientation(int i) => _orientation[i];

  void add({
    required Vec2 point,
    required double timestamp,
    double? pressure,
    double? tilt,
    double? orientation,
  }) {
    _grow(_length + 1);
    _point[_length] = point;
    _arcLength[_length] = _length == 0 ? 0 : _arcLength[_length - 1] + point.distanceTo(_point[_length - 1]);
    _timestamp[_length] = timestamp;
    _pressure[_length] = pressure ?? -1;
    _tilt[_length] = tilt ?? -1;
    _orientation[_length] = orientation ?? -1;
    _length++;
  }

  void clear() {
    _length = 0;
  }

  void _grow(int atLeast) {
    if (_point.length >= atLeast) return;
    _point = _point.grow(atLeast);
    _arcLength = _arcLength.grow(atLeast);
    _timestamp = _timestamp.grow(atLeast);
    _pressure = _pressure.grow(atLeast);
    _tilt = _tilt.grow(atLeast);
    _orientation = _orientation.grow(atLeast);
  }

  StrokeData copy() {
    final copy = StrokeData();
    copy._length = _length;
    copy._point = .fromBuffer(_point.buffer);
    copy._timestamp = .fromList(_timestamp);
    copy._arcLength = .fromList(_arcLength);
    copy._pressure = .fromList(_pressure);
    copy._tilt = .fromList(_tilt);
    copy._orientation = .fromList(_orientation);
    return copy;
  }

  Float64List curvature({int window = 2}) {
    final k = Float64List(_length);
    if (_length <= 2 * window) return k;
    for (var i = window; i < _length - window; i++) {
      final a = _point[i] - _point[i - window], b = _point[i + window] - _point[i];
      final len = (a.length + b.length) / 2;
      k[i] = len == 0 ? 0 : math.atan2(a.cross(b), a.dot(b)) / len;
    }
    for (var i = 0; i < window; i++) k[i] = k[window];
    for (var i = _length - window; i < _length; i++) k[i] = k[_length - window - 1];
    return k;
  }

  StrokeData resampled(double spacing) {
    if (length < 2 || totalLength == 0) return copy();

    final total = totalLength;
    final n = math.max(1, (total / spacing).round());
    final step = total / n;
    final out = StrokeData();

    var k = 0;
    for (var m = 0; m <= n; m++) {
      final target = m == n ? total : m * step;
      while (k < length - 2 && arcLength(k + 1) < target) k++;
      final span = arcLength(k + 1) - arcLength(k);
      final t = span == 0.0 ? 0.0 : (target - arcLength(k)) / span;
      out.add(
        point: Vec2.lerp(point(k), point(k + 1), t),
        timestamp: lerp(timestamp(k), timestamp(k + 1), t),
        pressure: _lerpSafe(pressure(k), pressure(k + 1), t),
        tilt: _lerpSafe(tilt(k), tilt(k + 1), t),
        orientation: _lerpSafe(orientation(k), orientation(k + 1), t),
      );
    }

    return out;
  }

  double _lerpSafe(double a, double b, double t) {
    if (a == -1 || b == -1) return -1;
    return lerp(a, b, t);
  }
}

final class StrokeSegment {
  const StrokeSegment(this.start, this.end, this.cubic);
  final int start, end;
  final Cubic2 cubic;
}
 
/// Turns an arc-length-resampled stroke into cubics.
///
/// Corners — where the pen slowed and turned sharply — are fixed breaks. Everything else is
/// decided by bottom-up merging: every sample starts as a break, and the adjacent pair of pieces
/// whose merge fits worst-but-still-best is merged, until the cheapest merge exceeds the tolerance
/// that [smoothness] sets. The merge order does not depend on the tolerance, so the breaks at a
/// higher smoothness are a subset of the breaks at a lower one.
abstract final class StrokeFitter {
  static List<StrokeSegment> fit(StrokeData data, {required double smoothness}) {
    final n = data.length;
    if (n < 2) return const [];
    final spacing = data.totalLength / (n - 1);
    final tolerance = _tolerance(smoothness) * spacing;
 
    final corners = {...detectCorners(data)};
 
    // One tangent estimate per index, so the two pieces meeting there use the same line. At a
    // corner and at the stroke's ends each piece looks only into its own side.
    Vec2 tangentOut(int k) => k == 0 || corners.contains(k) ? _tangent(data, k, 1, spacing) : _tangent(data, k, 0, spacing);
    Vec2 tangentIn(int k) => k == n - 1 || corners.contains(k) ? _tangent(data, k, -1, spacing) : -_tangent(data, k, 0, spacing);
    Cubic2 fitPiece(int i, int j) => _fit(data, i, j, tangentOut(i), tangentIn(j));
 
    // Breaks as a doubly linked list over sample indices; every sample starts as one.
    final prev = List<int>.generate(n, (i) => i - 1);
    final next = List<int>.generate(n, (i) => i + 1);
    final alive = List<bool>.filled(n, true);
    final version = List<int>.filled(n, 0);   // bumped when a break's neighbourhood changes
    final cubic = <int, Cubic2>{};             // by piece start
    for (var i = 0; i + 1 < n; i++) cubic[i] = fitPiece(i, i + 1);
 
    // A candidate merge removes break b, joining (prev[b], b) and (b, next[b]) into one piece.
    _Merge? candidate(int b) {
      if (b <= 0 || b >= n - 1 || corners.contains(b)) return null;
      final i = prev[b], j = next[b];
      final c = fitPiece(i, j);
      return _Merge(b, c, _maxError(data, i, j, c), version[b]);
    }
 
    final queue = PriorityQueue<_Merge>((a, b) => a.error.compareTo(b.error));
    for (var b = 1; b < n - 1; b++) {
      if (candidate(b) case final m?) queue.add(m);
    }
 
    while (queue.isNotEmpty) {
      final m = queue.removeFirst();
      final b = m.at;
      if (!alive[b] || m.version != version[b]) continue;   // stale: a neighbour changed since
      if (m.error > tolerance) break;                        // nothing cheaper is left
 
      alive[b] = false;
      final a = prev[b], c = next[b];
      next[a] = c;
      prev[c] = a;
      cubic.remove(b);
      cubic[a] = m.cubic;
 
      // The breaks on either side now sit between different pieces: re-evaluate them.
      for (final k in [a, c]) {
        version[k]++;
        if (candidate(k) case final nm?) queue.add(nm);
      }
    }
 
    return [for (var i = 0; i < n - 1; i = next[i]) StrokeSegment(i, next[i], cubic[i]!)];
  }
 
  /// Distance the curve may stray from the ink, in samples. 0.5–4 samples is 1–8 logical px at
  /// 2 px spacing.
  static double _tolerance(double smoothness) => lerp(0.5, 4.0, smoothness);
 
  // -----------------------------------------------------------------------------------------------
  // Corners: where the pen slowed down and turned sharply
  // -----------------------------------------------------------------------------------------------
 
  /// A corner is a local minimum of speed with a turn of at least [minAngle] across it, most of
  /// which happens within a sample or two of the point. Speed alone fires on hesitation, angle
  /// alone on fast sweeps, and a spread-out turn is a bend, not a corner.
  static List<int> detectCorners(
    StrokeData data, {
    double minAngle = math.pi / 6,
    double minSharpness = 0.6,
    int window = 3,
  }) {
    final n = data.length;
    if (n < 2 * window + 1) return const [];
 
    final speed = Float64List(n);
    for (var i = 1; i < n - 1; i++) {
      final dt = data.timestamp(i + 1) - data.timestamp(i - 1);
      speed[i] = dt > 0 ? (data.arcLength(i + 1) - data.arcLength(i - 1)) / dt : 0;
    }
    speed[0] = speed[1];
    speed[n - 1] = speed[n - 2];
 
    final out = <int>[];
    for (var i = window; i < n - window; i++) {
      var isMin = true;
      for (var j = i - window; j <= i + window && isMin; j++) {
        if (j != i && speed[j] <= speed[i]) isMin = false;
      }
      if (!isMin) continue;
 
      final wide = _turn(data, i, window).abs();
      if (wide < minAngle) continue;
      final narrow = _turn(data, i, 1).abs();
      if (narrow / wide < minSharpness) continue;
 
      out.add(i);
      i += window;   // one corner per window
    }
    return out;
  }
 
  /// Signed turning angle at [i] between the chords [w] samples before and after it.
  static double _turn(StrokeData data, int i, int w) {
    final a = data.point(i) - data.point(i - w), b = data.point(i + w) - data.point(i);
    return math.atan2(a.cross(b), a.dot(b));
  }
 
  // -----------------------------------------------------------------------------------------------
  // Tangents
  // -----------------------------------------------------------------------------------------------
 
  /// Unit tangent at [i]. [side] 1 looks forward only, -1 backward only, 0 both ways. Looks out to
  /// the first sample at least [reach] away rather than a fixed number of samples, so a tight turn
  /// doesn't collapse the estimate.
  static Vec2 _tangent(StrokeData data, int i, int side, double reach) {
    final n = data.length;
    int walk(int dir) {
      var j = i;
      while (j + dir >= 0 && j + dir < n) {
        j += dir;
        if ((data.arcLength(j) - data.arcLength(i)).abs() >= reach) break;
      }
      return j;
    }
 
    final a = side == 1 ? i : walk(-1);
    final b = side == -1 ? i : walk(1);
    final t = data.point(b) - data.point(a);
    if (t.length2 > 0) return t.normalized();
 
    // A stroke shorter than the reach: fall back to the immediate neighbours.
    final fa = math.max(0, i - 1), fb = math.min(n - 1, i + 1);
    final f = data.point(fb) - data.point(fa);
    return f.length2 > 0 ? f.normalized() : Vec2(1, 0);
  }
 
  // -----------------------------------------------------------------------------------------------
  // Fitting one piece: Schneider's constrained least squares with reparametrisation
  // -----------------------------------------------------------------------------------------------
 
  static Cubic2 _fit(StrokeData data, int i, int j, Vec2 t0, Vec2 t1) {
    final count = j - i + 1;
    if (count == 2) return Cubic2.line(data.point(i), data.point(j));
 
    // Chord-length parametrisation straight from the stroke's arc length.
    final u = Float64List(count);
    final s0 = data.arcLength(i), span = data.arcLength(j) - s0;
    for (var m = 0; m < count; m++) u[m] = span == 0 ? m / (count - 1) : (data.arcLength(i + m) - s0) / span;
 
    var c = _leastSquares(data, i, j, u, t0, t1);
    for (var round = 0; round < 2; round++) {
      _reparametrise(data, i, j, c, u);
      c = _leastSquares(data, i, j, u, t0, t1);
    }
    return c;
  }
 
  /// Handle lengths α0, α1 along t0, t1 that minimise squared distance to the samples — the 2×2
  /// normal equations from the paper. Degenerate → a third of the chord; wild → clamped to twice it.
  static Cubic2 _leastSquares(StrokeData data, int i, int j, Float64List u, Vec2 t0, Vec2 t1) {
    final p0 = data.point(i), p3 = data.point(j);
    var c00 = 0.0, c01 = 0.0, c11 = 0.0, x0 = 0.0, x1 = 0.0;
    for (var m = 0; m < u.length; m++) {
      final t = u[m], mt = 1 - t;
      final b0 = mt * mt * mt, b1 = 3 * mt * mt * t, b2 = 3 * mt * t * t, b3 = t * t * t;
      final a0 = t0 * b1, a1 = t1 * b2;
      final d = data.point(i + m) - (p0 * (b0 + b1) + p3 * (b2 + b3));
      c00 += a0.dot(a0);
      c01 += a0.dot(a1);
      c11 += a1.dot(a1);
      x0 += a0.dot(d);
      x1 += a1.dot(d);
    }
 
    final chord = p0.distanceTo(p3);
    final det = c00 * c11 - c01 * c01;
    var alpha0 = det == 0 ? 0.0 : (x0 * c11 - x1 * c01) / det;
    var alpha1 = det == 0 ? 0.0 : (c00 * x1 - c01 * x0) / det;
 
    if (alpha0 < 1e-6 * chord || alpha1 < 1e-6 * chord) {
      alpha0 = alpha1 = chord / 3;   // Schneider's fallback for a singular or backwards solution
    }
    alpha0 = math.min(alpha0, 2 * chord);   // a bad tangent can still make the solution huge
    alpha1 = math.min(alpha1, 2 * chord);
 
    return Cubic2(p0, p3, p1: p0 + t0 * alpha0, p2: p3 + t1 * alpha1);
  }
 
  /// Largest distance from a sample to the curve at its current parameter. Uses the chord
  /// parametrisation for the candidate, which slightly overestimates — a merge that passes is a
  /// merge that fits.
  static double _maxError(StrokeData data, int i, int j, Cubic2 c) {
    final count = j - i + 1;
    if (count == 2) return 0;
    final s0 = data.arcLength(i), span = data.arcLength(j) - s0;
    var worst = 0.0;
    for (var m = 0; m < count; m++) {
      final t = span == 0 ? m / (count - 1) : (data.arcLength(i + m) - s0) / span;
      final d = c.point(t).distance2To(data.point(i + m));
      if (d > worst) worst = d;
    }
    return math.sqrt(worst);
  }
 
  /// One Newton–Raphson step per sample toward its closest point on [c].
  static void _reparametrise(StrokeData data, int i, int j, Cubic2 c, Float64List u) {
    for (var m = 0; m < u.length; m++) {
      final t = u[m];
      final d = c.point(t) - data.point(i + m);
      final d1 = c.velocity(t), d2 = c.acceleration(t);
      final denominator = d1.dot(d1) + d.dot(d2);
      if (denominator.abs() > 1e-12) u[m] = (t - d.dot(d1) / denominator).clamp(0.0, 1.0);
    }
  }
}
 
/// A candidate merge: removing break [at] and fitting one cubic across the two pieces it separated.
/// [version] is the break's version when the candidate was computed; a stale one is skipped.
final class _Merge {
  const _Merge(this.at, this.cubic, this.error, this.version);
  final int at;
  final Cubic2 cubic;
  final double error;
  final int version;
}
 




extension type const Cubic2._(Vec2List storage) implements Object {
  Cubic2.zero() : storage = .new(4);
  Cubic2.line(Vec2 p0, Vec2 p3) : this(p0, p3, p1: p0 + (p3 - p0).scale(1 / 3), p2: p0 + (p3 - p0).scale(2 / 3));
  Cubic2.view(Vec2List storage) : storage = storage;

  Cubic2(Vec2 p0, Vec2 p3, {Vec2? p1, Vec2? p2}) : storage = .new(4) {
    storage[0] = p0;
    storage[1] = p1 ?? p0;
    storage[2] = p2 ?? p3;
    storage[3] = p3;
  }

  Vec2 get p0 => storage[0];
  Vec2 get p1 => storage[1];
  Vec2 get p2 => storage[2];
  Vec2 get p3 => storage[3];

  set p0(Vec2 v) => storage[0] = v;
  set p1(Vec2 v) => storage[1] = v;
  set p2(Vec2 v) => storage[2] = v;
  set p3(Vec2 v) => storage[3] = v;

  Vec2 point(double t) => _cubicEvaluate(this, t);
  Vec2 velocity(double t) => _cubicVelocity(this, t);
  Vec2 tangent(double t) => _cubicTangent(this, t);
  Vec2 acceleration(double t) => _cubicAcceleration(this, t);

  (Cubic2, Cubic2) split(double t) => _cubicSplit(this, t);
  List<Cubic2> splitMultiple(List<double> ts) => _cubicSplitMultiple(this, ts);
  Cubic2 piece(double t0, double t1) => _cubicPiece(this, t0, t1);

  List<double> get extrema => _cubicExtrema(this);
  List<Cubic2> get monotonePieces => _cubicMonotonePieces(this);
  bool get isMonotonicInX => _cubicMonotonicInX(this);
  bool get isMonotonicInY => _cubicMonotonicInY(this);
  bool get isMonotone => _cubicIsMonotone(this);

  double get flatness => _cubicFlatness(this);
  bool isFlat({double? tolerance}) => _cubicIsFlat(this, tolerance: tolerance);

  CubicClassification get classification => _cubicClassify(this);
  Intersections intersect(Cubic2 other) => _cubicIntersect(this, other);
  Intersection? selfIntersect() => _cubicSelfIntersection(this);

  Aabb2 get bbox => _cubicBbox(this);
  Aabb2 get bboxTight => _cubicBboxTight(this);
  double get signedAreaIntegral => _cubicSignedArea(this);
  ClosestPointResult closestPoint(Vec2 q) => _cubicClosestPoint(this, q);

  CubicArcIndex get arcIndex => .of(this);
  double get arcLength => arcIndex.length;
  double arcLengthBetween(double t0, double t1) => arcIndex.distanceBetween(t0, t1);
  double distanceAtT(double t) => arcIndex.distanceAt(t);
  double tAtDistance(double distance) => arcIndex.tAt(distance);

  int winding(Vec2 p) => _cubicWinding(this, p);

  bool containedInAabb(Aabb2 bbox) => _cubicContainedInAabb(this, bbox);
  bool intersectsAabb(Aabb2 bbox) => _cubicIntersectsAabb(this, bbox);

  void reverse() => _cubicReverse(this);
  void transform(Mat4 m) => _cubicTransform(this, m);
  Cubic2 reversed() => copy()..reverse();
  Cubic2 transformed(Mat4 m) => copy()..transform(m);
  Cubic2 bend(double t, Vec2 q) => _cubicBend(this, t, q);

  int toQuadraticCount(double tolerance) => _cubicToQuadraticCount(this, tolerance);
  List<Quadratic2> toQuadratics({double tolerance = 1.0}) => _cubicToQuadratics(this, tolerance);
  void toQuadraticsRaw(int n, void Function(Vec2, Vec2) cb) => _cubicToQuadraticsRaw(this, n, cb);

  Cubic2 copy() => .new(p0, p3, p1: p1, p2: p2);
}

@pragma('vm:prefer-inline')
double _bernsteinEvaluate1d(double p0, double p1, double p2, double p3, double t) {
  final u = 1 - t, uu = u * u, tt = t * t;
  return p0 * (uu * u) + p1 * (3 * uu * t) + p2 * (3 * u * tt) + p3 * (tt * t);
}

@pragma('vm:prefer-inline')
Vec2 _bernsteinEvaluate(Vec2 p0, Vec2 p1, Vec2 p2, Vec2 p3, double t) {
  final u = 1 - t, uu = u * u, tt = t * t;
  return p0 * (uu * u) + p1 * (3 * uu * t) + p2 * (3 * u * tt) + p3 * (tt * t);
}

@pragma('vm:prefer-inline')
double _bernsteinVelocityEvaluate1d(double p0, double p1, double p2, double p3, double t) {
  final u = 1 - t;
  return (p1 - p0) * (3 * u * u) + (p2 - p1) * (6 * u * t) + (p3 - p2) * (3 * t * t);
}

@pragma('vm:prefer-inline')
Vec2 _bernsteinVelocityEvaluate(Vec2 p0, Vec2 p1, Vec2 p2, Vec2 p3, double t) {
  final u = 1 - t;
  return (p1 - p0) * (3 * u * u) + (p2 - p1) * (6 * u * t) + (p3 - p2) * (3 * t * t);
}

@pragma('vm:prefer-inline')
Vec2 _bernsteinTangentEvaluate(Vec2 p0, Vec2 p1, Vec2 p2, Vec2 p3, double t) {
  final v = _bernsteinVelocityEvaluate(p0, p1, p2, p3, t);
  if (v.length2 > 1e-18) return v.normalized();

  final chord = p3 - p0;
  if (chord.length2 > 1e-18) return chord.normalized();
  return .zero();
}

@pragma('vm:prefer-inline')
Vec2 _bernsteinAccelerationEvaluate(Vec2 p0, Vec2 p1, Vec2 p2, Vec2 p3, double t) {
  return (p2 - p1 * 2 + p0) * (6 * (1 - t)) + (p3 - p2 * 2 + p1) * (6 * t);
}

List<double> _bernsteinCubicRoots(double c0, double c1, double c2, double c3) {
  final out = <double>[];
  _findRoots([Vec2(0, c0), Vec2(1 / 3, c1), Vec2(2 / 3, c2), Vec2(1, c3)], 3, out, 0);
  out.sort();

  final dedup = <double>[];
  for (final t in out) {
    if (dedup.isEmpty || (t - dedup.last).abs() > 1e-9) dedup.add(t);
  }

  return dedup;
}

@pragma('vm:prefer-inline')
void _deCasteljauSplit(Vec2 p0, Vec2 p1, Vec2 p2, Vec2 p3, double t, Cubic2 a, Cubic2 b) {
  if (!(t > 0 && t < 1)) throw ArgumentError.value(t, 't', 'must be in range (0, 1)');

  final u = 1 - t;
  final m01 = p0 * u + p1 * t;
  final m12 = p1 * u + p2 * t;
  final m23 = p2 * u + p3 * t;
  final m012 = m01 * u + m12 * t;
  final m123 = m12 * u + m23 * t;
  final m0123 = m012 * u + m123 * t;

  a.p0 = p0;
  a.p1 = m01;
  a.p2 = m012;
  a.p3 = m0123;

  b.p0 = m0123;
  b.p1 = m123;
  b.p2 = m23;
  b.p3 = p3;
}

extension type const CubicArcIndex._(Float64List _cumulative) implements Object {
  static CubicArcIndex of(Cubic2 cubic, {int segments = 32}) {
    final cumulative = Float64List(segments + 1);
    for (var i = 0; i < segments; i++) {
      cumulative[i + 1] = cumulative[i] + _segmentLength(cubic, i / segments, (i + 1) / segments);
    }
    return CubicArcIndex._(cumulative);
  }

  int get segmentCount => _cumulative.length - 1;
  double get length => _cumulative.last;

  double distanceBetween(double t0, double t1) {
    if (t0 > t1) throw ArgumentError.value(t0, 't0', 'must be <= t1');
    return distanceAt(t1) - distanceAt(t0);
  }

  double distanceAt(double t) {
    if (t <= 0) return 0;
    if (t >= 1) return length;
    final s = t * segmentCount, i = s.floor();
    return _cumulative[i] + (_cumulative[i + 1] - _cumulative[i]) * (s - i);
  }

  double tAt(double distance) {
    if (distance <= 0) return 0;
    if (distance >= length) return 1;
    var lo = 0, hi = segmentCount;
    while (hi - lo > 1) {
      final mid = (lo + hi) >> 1;
      if (_cumulative[mid] <= distance) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    final a = _cumulative[lo], b = _cumulative[hi];
    return (lo + (distance - a) / (b - a)) / segmentCount;
  }

  static double _segmentLength(Cubic2 c, double t0, double t1) {
    final half = (t1 - t0) / 2, mid = (t0 + t1) / 2;
    var sum = 0.0;
    for (var k = 0; k < 5; k++) sum += _gw[k] * c.velocity(mid + half * _gn[k]).length;
    return sum * half;
  }

  static const _gn = [
    -0.9061798459386640,
    -0.5384693101056831,
    0.0,
    0.5384693101056831,
    0.9061798459386640,
  ];

  static const _gw = [
    0.2369268850561891,
    0.4786286704993665,
    0.5688888888888889,
    0.4786286704993665,
    0.2369268850561891,
  ];
}

double _cubicSignedAreaRaw(Vec2 p0, Vec2 p1, Vec2 p2, Vec2 p3) {
  var result =
      6.0 * p0.cross(p1) +
      3.0 * p0.cross(p2) +
      p0.cross(p3) +
      3.0 * p1.cross(p2) +
      3.0 * p1.cross(p3) +
      6.0 * p2.cross(p3);

  return result / 20.0;
}

double _cubicSignedArea(Cubic2 c) => _cubicSignedAreaRaw(c.p0, c.p1, c.p2, c.p3);

Aabb2 _cubicBbox(Cubic2 cubic) {
  final bbox = Aabb2.point(cubic.p0);
  bbox.hullPoint(cubic.p1);
  bbox.hullPoint(cubic.p2);
  bbox.hullPoint(cubic.p3);
  return bbox;
}

Cubic2 _cubicBend(Cubic2 c, double t, Vec2 q) {
  final u = 1 - t;
  final w1 = 3 * u * u * t;
  final w2 = 3 * u * t * t;
  final norm = w1 * w1 + w2 * w2;
  if (norm < 1e-12) return c.copy();

  final d = (q - c.point(t)) / norm;
  return .new(c.p0, c.p3, p1: c.p1 + d * w1, p2: c.p2 + d * w2);
}

enum CubicType {
  point,
  line,
  quadratic,
  serpentine,
  cusp,
  loop,
}

final class CubicClassification {
  new(this.type, this.d1, this.d2, this.d3, {this.loopPoint});

  final CubicType type;
  final double d1, d2, d3;

  final (double, double)? loopPoint;
}

@pragma('vm:prefer-inline')
double _det(Vec2 p, Vec2 q, Vec2 r) => (q - p).cross(r - p);

CubicClassification _cubicClassify(Cubic2 c) {
  final a1 = _det(c.p0, c.p3, c.p2);
  final a2 = _det(c.p1, c.p0, c.p3);
  final a3 = _det(c.p2, c.p1, c.p0);

  final d1 = a1 - 2 * a2 + 3 * a3;
  final d2 = -a2 + 3 * a3;
  final d3 = 3 * a3;

  final scale = math.max(math.max(d1.abs(), d2.abs()), d3.abs());
  final eps = 1e-9 * scale;
  bool isZero(double v) => v.abs() <= eps;

  if (scale == 0.0) {
    const eps = 1e-12;
    final isPoint = c.p0.equals(c.p3, eps) && c.p1.equals(c.p0, eps) && c.p2.equals(c.p0, eps);
    return .new(isPoint ? .point : .line, d1, d2, d3);
  }

  if (isZero(d1)) {
    final isQuadratic = isZero(d2);
    return .new(isQuadratic ? .quadratic : .cusp, d1, d2, d3);
  }

  final disc = 3 * d2 * d2 - 4 * d1 * d3;
  if (isZero(disc / scale)) return .new(.cusp, d1, d2, d3);
  if (disc > 0) return .new(.serpentine, d1, d2, d3);

  final root = math.sqrt(-disc);
  final t1 = (d2 - root) / (2 * d1);
  final t2 = (d2 + root) / (2 * d1);
  final tmin = math.min(t1, t2);
  final tmax = math.max(t1, t2);

  return .new(.loop, d1, d2, d3, loopPoint: (tmin, tmax));
}

typedef ClosestPointResult = ({double t, Vec2 point, double distance});

ClosestPointResult _cubicClosestPoint(Cubic2 c, Vec2 q) {
  return _cubicClosestPointRaw(c.p0, c.p1, c.p2, c.p3, q);
}

ClosestPointResult _cubicClosestPointRaw(Vec2 p0, Vec2 p1, Vec2 p2, Vec2 p3, Vec2 q) {
  final w = _closestPointQuintic(p0, p1, p2, p3, q);
  final candidates = <double>[];
  _findRoots(w, _wDegree, candidates, 0);

  var bestT = 0.0;
  var bestPoint = _bernsteinEvaluate(p0, p1, p2, p3, 0.0);
  var bestDist2 = bestPoint.distance2To(q);

  final endPoint = _bernsteinEvaluate(p0, p1, p2, p3, 1.0);
  final dist2End = endPoint.distance2To(q);
  if (dist2End < bestDist2) {
    bestT = 1.0;
    bestPoint = endPoint;
    bestDist2 = dist2End;
  }

  for (final t in candidates) {
    final pt = _bernsteinEvaluate(p0, p1, p2, p3, t);
    final d2 = pt.distance2To(q);
    if (d2 < bestDist2) {
      bestT = t;
      bestPoint = pt;
      bestDist2 = d2;
    }
  }

  return (t: bestT, point: bestPoint, distance: math.sqrt(bestDist2));
}

const int _wDegree = 5;
const int _maxDepth = 64;
final double _epsilon = math.pow(2.0, -_maxDepth - 1).toDouble();

List<Vec2> _closestPointQuintic(Vec2 p0, Vec2 p1, Vec2 p2, Vec2 p3, Vec2 q) {
  final c0 = p0 - q;
  final c1 = p1 - q;
  final c2 = p2 - q;
  final c3 = p3 - q;

  final d0 = (p1 - p0) * 3.0;
  final d1 = (p2 - p1) * 3.0;
  final d2 = (p3 - p2) * 3.0;

  final cd = <List<double>>[
    [d0.dot(c0), d0.dot(c1), d0.dot(c2), d0.dot(c3)],
    [d1.dot(c0), d1.dot(c1), d1.dot(c2), d1.dot(c3)],
    [d2.dot(c0), d2.dot(c1), d2.dot(c2), d2.dot(c3)],
  ];

  final z = <List<double>>[
    [1.0, 0.6, 0.3, 0.1],
    [0.4, 0.6, 0.6, 0.4],
    [0.1, 0.3, 0.6, 1.0],
  ];

  final ys = List<double>.filled(_wDegree + 1, 0.0);
  const n = 3;
  const m = 2;

  for (var k = 0; k <= n + m; k++) {
    final lb = k > m ? k - m : 0;
    final ub = k < n ? k : n;

    for (var i = lb; i <= ub; i++) {
      final j = k - i;
      ys[i + j] += cd[j][i] * z[j][i];
    }
  }

  return [for (var i = 0; i <= _wDegree; i++) .new(i / _wDegree, ys[i])];
}

void _findRoots(List<Vec2> w, int degree, List<double> out, int depth) {
  final crossings = _crossingCount(w, degree);
  if (crossings == 0) return;
  if (crossings == 1) {
    if (depth >= _maxDepth) {
      out.add((w[0].x + w[degree].x) * 0.5);
      return;
    }
    if (_controlPolygonFlatEnough(w, degree)) {
      out.add(_computeXIntercept(w, degree));
      return;
    }
  }

  final left = List<Vec2>.generate(degree + 1, (_) => .zero());
  final right = List<Vec2>.generate(degree + 1, (_) => .zero());
  _bezierSubdivide(w, degree, 0.5, left, right);
  _findRoots(left, degree, out, depth + 1);
  _findRoots(right, degree, out, depth + 1);
}

int _crossingCount(List<Vec2> w, int degree) {
  var crossings = 0;
  var prev = w[0].y.sign;

  for (var i = 1; i <= degree; i++) {
    final s = w[i].y.sign;
    if (s != prev) crossings++;
    prev = s;
  }

  return crossings;
}

bool _controlPolygonFlatEnough(List<Vec2> w, int degree) {
  final a = w[0].y - w[degree].y;
  final b = w[degree].x - w[0].x;
  final cChord = w[0].x * w[degree].y - w[degree].x * w[0].y;
  final abSquared = a * a + b * b;
  if (abSquared == 0.0) return true;

  var maxAbove = 0.0;
  var maxBelow = 0.0;
  for (var i = 1; i < degree; i++) {
    final raw = a * w[i].x + b * w[i].y + cChord;
    final d = raw.sign * (raw * raw) / abSquared;
    if (d > maxAbove) maxAbove = d;
    if (d < maxBelow) maxBelow = d;
  }

  if (a == 0.0) return true;

  final dInv = -1.0 / a;
  final intercept1 = (cChord + maxAbove) * dInv;
  final intercept2 = (cChord + maxBelow) * dInv;

  final lo = math.min(intercept1, intercept2);
  final hi = math.max(intercept1, intercept2);
  final error = 0.5 * (hi - lo);
  return error < _epsilon;
}

double _computeXIntercept(List<Vec2> w, int degree) {
  final dy = w[degree].y - w[0].y;
  if (dy == 0.0) return w[0].x;
  final dx = w[degree].x - w[0].x;
  return w[0].x - w[0].y * dx / dy;
}

void _bezierSubdivide(List<Vec2> v, int degree, double t, List<Vec2> left, List<Vec2> right) {
  final tmp = List<List<Vec2>>.generate(
    degree + 1,
    (_) => List<Vec2>.generate(degree + 1, (_) => .zero()),
  );

  for (var j = 0; j <= degree; j++) tmp[0][j] = v[j];
  final mt = 1.0 - t;
  for (var i = 1; i <= degree; i++) {
    for (var j = 0; j <= degree - i; j++) {
      final a = tmp[i - 1][j];
      final b = tmp[i - 1][j + 1];
      tmp[i][j] = .new(mt * a.x + t * b.x, mt * a.y + t * b.y);
    }
  }

  for (var j = 0; j <= degree; j++) {
    left[j] = tmp[j][0];
    right[j] = tmp[degree - j][j];
  }
}

extension Cubic2IterableCopy on Iterable<Cubic2> {
  List<Cubic2> copy() => map((c) => c.copy()).toList(growable: false);
}

@pragma('vm:prefer-inline')
Vec2 _cubicEvaluate(Cubic2 c, double t) => _bernsteinEvaluate(c.p0, c.p1, c.p2, c.p3, t);

@pragma('vm:prefer-inline')
Vec2 _cubicVelocity(Cubic2 c, double t) => _bernsteinVelocityEvaluate(c.p0, c.p1, c.p2, c.p3, t);

@pragma('vm:prefer-inline')
Vec2 _cubicTangent(Cubic2 c, double t) => _bernsteinTangentEvaluate(c.p0, c.p1, c.p2, c.p3, t);

@pragma('vm:prefer-inline')
Vec2 _cubicAcceleration(Cubic2 c, double t) => _bernsteinAccelerationEvaluate(c.p0, c.p1, c.p2, c.p3, t);

List<double> _cubicExtrema(Cubic2 cubic) {
  const tEpsilon = 1e-6;
  final out = <double>[];
  void emit(double t) {
    if (t > tEpsilon && t < 1 - tEpsilon) out.add(t);
  }

  void axisExtrema(double d0, double d1, double d2) {
    final a = d0 - 2 * d1 + d2;
    final b = 2 * (d1 - d0);
    final c = d0;

    final scale = math.max(math.max(b.abs(), c.abs()), 1.0);
    if (a.abs() < 1e-12 * scale) {
      if (b.abs() > 1e-12 * scale) emit(-c / b);
    }

    final disc = b * b - 4 * a * c;
    if (disc < 0) return;

    final sq = math.sqrt(disc);
    final q = -0.5 * (b + b.sign * sq);
    emit(q / a);
    if (q.abs() > 1e-12 * scale) emit(c / q);
  }

  final p0 = cubic.p0, p1 = cubic.p1, p2 = cubic.p2, p3 = cubic.p3;
  axisExtrema(p1.x - p0.x, p2.x - p1.x, p3.x - p2.x);
  axisExtrema(p1.y - p0.y, p2.y - p1.y, p3.y - p2.y);
  if (out.length > 1) out.sort();

  var w = 0;
  for (var i = 0; i < out.length; i++) {
    if (w == 0 || out[i] - out[w - 1] > tEpsilon) out[w++] = out[i];
  }

  return out.sublist(0, w);
}

List<Cubic2> _cubicMonotonePieces(Cubic2 c) {
  final ts = _cubicExtrema(c);
  if (ts.isEmpty) return [c];
  return _cubicSplitMultiple(c, ts);
}

Aabb2 _cubicBboxTight(Cubic2 c) {
  final bbox = Aabb2.minMax(
    Vec2.min(c.p0, c.p3),
    Vec2.max(c.p0, c.p3),
  );

  for (final t in _cubicExtrema(c)) {
    bbox.hullPoint(c.point(t));
  }

  return bbox;
}

bool _cubicContainedInAabb(Cubic2 c, Aabb2 bbox) {
  return bbox.containsAabb(c.bboxTight);
}

bool _cubicIntersectsAabb(Cubic2 c, Aabb2 bbox) {
  if (!bbox.intersectsAabb(c.bbox)) return false;
  if (bbox.containsAabb(c.bbox)) return true;

  bool monotoneIntersects(Cubic2 c, Aabb2 bbox, [int depth = 20]) {
    final b = c.bbox;
    if (!bbox.intersectsAabb(b)) return false;
    if (bbox.contains(c.p0) || bbox.contains(c.p3)) return true;
    if (bbox.containsAabb(b)) return true;
    if (depth == 0) return true;

    final (l, r) = c.split(0.5);
    return monotoneIntersects(l, bbox, depth - 1) || monotoneIntersects(r, bbox, depth - 1);
  }

  for (final piece in _cubicMonotonePieces(c)) {
    if (monotoneIntersects(piece, bbox)) return true;
  }

  return false;
}

double _cubicFlatness(Cubic2 c) {
  final chord = c.p3 - c.p0;
  final len2 = chord.length2;
  if (len2 < 1e-18) return math.max((c.p1 - c.p0).length, (c.p2 - c.p0).length);

  final invLen = 1 / math.sqrt(len2);
  final d1 = chord.cross(c.p1 - c.p0).abs();
  final d2 = chord.cross(c.p2 - c.p0).abs();
  return math.max(d1, d2) * invLen;
}

bool _cubicIsFlat(Cubic2 c, {double? tolerance}) {
  tolerance ??= 1e-9;
  if (c.p0.equals(c.p1, tolerance) && c.p2.equals(c.p3, tolerance)) return true;
  return _cubicFlatness(c) <= tolerance;
}

const _iEpsD = Intersection.epsD;
const _iEpsD2 = Intersection.epsD2;
const _iEpsT = Intersection.epsT;
const _iMaxDepth = 60;

Intersections _cubicIntersect(Cubic2 a, Cubic2 b) {
  if (!_bboxIntersects(a, b)) return .empty;
  final candidates = <(double, double)>[];

  final overlap = _cubicOverlap(a, b);
  if (overlap == null) {
    _intersectSearch(a, 0, 1, b, 0, 1, 0, candidates);
  } else {
    if (overlap.ta0 > _iEpsT) {
      _intersectSearch(_cubicPiece(a, 0, overlap.ta0), 0, overlap.ta0, b, 0, 1, 0, candidates);
    }
    if (overlap.ta1 < 1 - _iEpsT) {
      _intersectSearch(_cubicPiece(a, overlap.ta1, 1), overlap.ta1, 1, b, 0, 1, 0, candidates);
    }
  }

  final hits = <Intersection>[];
  for (final (taRaw, tbRaw) in candidates) {
    final refined = _intersectPolish(a, b, taRaw, tbRaw);
    if (refined == null) continue;

    final (ta, tb) = refined;
    if (overlap != null && overlap.containsA(ta)) continue;

    final p = a.point(ta);
    if (hits.any((h) => h.point.distance2To(p) <= _iEpsD2 && (h.ta - ta).abs() < 1e-6)) continue;
    hits.add(.new(ta, tb, p));
  }

  hits.sort((x, y) => x.ta.compareTo(y.ta));
  return .new(hits, overlap != null ? [overlap] : []);
}

bool _bboxIntersects(Cubic2 a, Cubic2 b) => a.bbox.inflated(_iEpsD).intersectsAabb(b.bbox);

void _intersectSearch(
  Cubic2 a,
  double a0,
  double a1,
  Cubic2 b,
  double b0,
  double b1,
  int depth,
  List<(double, double)> out,
) {
  if (!_bboxIntersects(a, b)) return;

  final aIsFlat = _cubicIsFlat(a, tolerance: _iEpsD);
  final bIsFlat = _cubicIsFlat(b, tolerance: _iEpsD);

  if (aIsFlat && bIsFlat) {
    final intersection = lineSegmentIntersect(a.p0, a.p3, b.p0, b.p3, tolerance: _iEpsD);
    if (intersection != null) {
      final u = a0 + (a1 - a0) * _cubicClosestPoint(a, intersection.point).t;
      final v = b0 + (b1 - b0) * _cubicClosestPoint(b, intersection.point).t;
      out.add((u, v));
    }
    return;
  } else if (depth >= _iMaxDepth) {
    final aMid = (a0 + a1) / 2;
    final bMid = (b0 + b1) / 2;
    out.add((aMid, bMid));
    return;
  }

  if (aIsFlat || (!bIsFlat && (a1 - a0) < (b1 - b0))) {
    final (l, r) = _cubicSplit(b, 0.5);
    final m = (b0 + b1) / 2;
    _intersectSearch(a, a0, a1, l, b0, m, depth + 1, out);
    _intersectSearch(a, a0, a1, r, m, b1, depth + 1, out);
  } else {
    final (l, r) = _cubicSplit(a, 0.5);
    final m = (a0 + a1) / 2;
    _intersectSearch(l, a0, m, b, b0, b1, depth + 1, out);
    _intersectSearch(r, m, a1, b, b0, b1, depth + 1, out);
  }
}

@pragma('vm:prefer-inline')
bool _intersectionHitsBoth(Cubic2 a, Cubic2 b, double ta, double tb) {
  final pa = a.point(ta);
  final pb = b.point(tb);
  return pa.distance2To(pb) <= _iEpsD2;
}

(double, double)? _intersectPolish(Cubic2 a, Cubic2 b, double ta, double tb) {
  const eps = 1e-6;

  for (var i = 0; i < 8; i++) {
    final f = a.point(ta) - b.point(tb);
    if (f.length2 <= _iEpsD2 * 1e-4) break;

    final da = a.velocity(ta), db = b.velocity(tb);
    final det = db.cross(da);
    if (det.abs() < 1e-18) break;

    final dta = db.cross(f) / det;
    final dtb = da.cross(f) / det;
    ta -= dta;
    tb -= dtb;

    if (ta < -eps || ta > 1 + eps || tb < -eps || tb > 1 + eps) return null;
  }

  return _intersectionHitsBoth(a, b, ta, tb) ? (ta.clamp(0.0, 1.0), tb.clamp(0.0, 1.0)) : null;
}

Overlap? _cubicOverlap(Cubic2 a, Cubic2 b) {
  final b0 = _cubicClosestPoint(a, b.p0);
  final b3 = _cubicClosestPoint(a, b.p3);
  final a0 = _cubicClosestPoint(b, a.p0);
  final a3 = _cubicClosestPoint(b, a.p3);

  final ends = <double>[
    if (b0.distance <= _iEpsD) b0.t,
    if (b3.distance <= _iEpsD) b3.t,
    if (a0.distance <= _iEpsD) 0.0,
    if (a3.distance <= _iEpsD) 1.0,
  ];
  if (ends.length < 2) return null;
  ends.sort();

  final ta0 = ends.first, ta1 = ends.last;
  if (ta1 - ta0 < _iEpsT) return null;

  for (var k = 1; k <= 3; k++) {
    final t = ta0 + (ta1 - ta0) * k / 4;
    if (_cubicClosestPoint(b, a.point(t)).distance > _iEpsD) return null;
  }

  return .new(
    ta0,
    ta1,
    _cubicClosestPoint(b, a.point(ta0)).t,
    _cubicClosestPoint(b, a.point(ta1)).t,
  );
}

Intersection? _cubicSelfIntersection(Cubic2 c) {
  if (_cubicMonotonicInX(c) && _cubicMonotonicInY(c)) return null;
  final cls = _cubicClassify(c);
  if (cls.type != .loop) return null;

  final (lo, hi) = cls.loopPoint!;
  if (lo <= 0 || hi >= 1) return null;

  final (t0, t1) = _intersectPolish(c, c, lo, hi) ?? (lo, hi);
  return .new(t0, t1, c.point(t0));
}

bool _cubicMonotonicInX(Cubic2 c) => _monotone(c.p0.x, c.p1.x, c.p2.x, c.p3.x);
bool _cubicMonotonicInY(Cubic2 c) => _monotone(c.p0.y, c.p1.y, c.p2.y, c.p3.y);

bool _monotone(double a, double b, double c, double d) => (a <= b && b <= c && c <= d) || (a >= b && b >= c && c >= d);

bool _cubicIsMonotone(Cubic2 c) => _cubicExtrema(c).isEmpty;

int _cubicToQuadraticCount(Cubic2 c, double tolerance) {
  final d3 = c.p3 - (c.p2 * 3) + (c.p1 * 3) - c.p0;
  final err = d3.length * (math.sqrt(3) / 36);
  if (err <= tolerance) return 1;
  return math.pow(err / tolerance, 1 / 3).ceil();
}

List<Quadratic2> _cubicToQuadratics(Cubic2 c, double tolerance) {
  final out = <Quadratic2>[];
  var current = c.p0;
  _cubicToQuadraticsRaw(c, _cubicToQuadraticCount(c, tolerance), (control, end) {
    out.add(Quadratic2(current, end, p1: control));
    current = end;
  });
  return out;
}

void _cubicToQuadraticsRaw(Cubic2 c, int n, void Function(Vec2, Vec2) callback) {
  var current = c.p0;
  var currentVel = c.velocity(0);

  final dt = 1 / n;
  for (var i = 1; i <= n; i++) {
    final t = i == n ? 1.0 : i * dt;
    final end = i == n ? c.p3 : c.point(t);
    final endVel = c.velocity(t);

    final control = (current + end) * 0.5 + (currentVel - endVel) * (dt * 0.25);
    callback(control, end);
    current = end;
    currentVel = endVel;
  }
}

(Cubic2, Cubic2) _cubicSplit(Cubic2 c, double t) {
  if (_cubicIsFlat(c)) {
    final p = c.point(t);
    return (.new(c.p0, p), .new(p, c.p3));
  }

  final left = Cubic2.zero(), right = Cubic2.zero();
  _deCasteljauSplit(c.p0, c.p1, c.p2, c.p3, t, left, right);
  return (left, right);
}

Cubic2 _cubicPiece(Cubic2 c, double t0, double t1) {
  assert(t0 >= 0 && t1 <= 1 && t0 < t1);
  if (t0 == 0 && t1 == 1) return c.copy();
  var out = c;
  if (t1 < 1) out = _cubicSplit(out, t1).$1;
  if (t0 > 0) out = _cubicSplit(out, (t0 / t1)).$2;
  return out;
}

List<double> _sortAndValidateSplitsList(List<double> v, double min, double max, double tolerance) {
  final sorted = v.toList(growable: false)..sort();
  for (final t in sorted) {
    if (!(t > min && t < max)) throw ArgumentError.value(t, 't', 'must be in range ($min, $max)');
  }

  for (var i = 1; i < sorted.length; i++) {
    if ((sorted[i] - sorted[i - 1]).abs() < tolerance) {
      throw ArgumentError.value(sorted.join(', '), 'v', 'values must be unique (also not near-coincident)');
    }
  }

  return sorted;
}

List<double> _sortAndValidateTsList(List<double> ts) {
  return _sortAndValidateSplitsList(ts, 0.0, 1.0, 1e-9);
}

List<Cubic2> _cubicSplitMultiple(Cubic2 c, List<double> ts_) {
  if (ts_.isEmpty) return [c.copy()];
  final ts = _sortAndValidateTsList(ts_);

  if (_cubicIsFlat(c)) {
    final pts = [c.p0, for (final t in ts) c.point(t), c.p3];
    return [for (var i = 0; i < pts.length - 1; i++) .new(pts[i], pts[i + 1])];
  }

  final pieces = <Cubic2>[];
  var current = c;
  var remaining = ts;

  while (remaining.isNotEmpty) {
    final u = remaining.first;
    final (left, right) = _cubicSplit(current, u);
    pieces.add(left);
    current = right;
    final scale = 1.0 - u;
    remaining = [for (final t in remaining.skip(1)) (t - u) / scale];
  }

  pieces.add(current);
  return pieces;
}

void _cubicTransform(Cubic2 c, Mat4 m) {
  c.p0 = m.transform2(c.p0);
  c.p1 = m.transform2(c.p1);
  c.p2 = m.transform2(c.p2);
  c.p3 = m.transform2(c.p3);
}

void _cubicReverse(Cubic2 c) {
  final p0 = c.p0, p1 = c.p1, p2 = c.p2, p3 = c.p3;
  c.p0 = p3;
  c.p1 = p2;
  c.p2 = p1;
  c.p3 = p0;
}

int _cubicWinding(Cubic2 c, Vec2 p) {
  final y0 = c.p0.y;
  final y1 = c.p1.y;
  final y2 = c.p2.y;
  final y3 = c.p3.y;

  final roots = _bernsteinCubicRoots(y0 - p.y, y1 - p.y, y2 - p.y, y3 - p.y);

  var winding = 0;
  for (final t in roots) {
    if (t >= 1.0) continue;
    final x = _bernsteinEvaluate1d(c.p0.x, c.p1.x, c.p2.x, c.p3.x, t);
    if (x <= p.x) continue;

    final dy = _bernsteinVelocityEvaluate1d(y0, y1, y2, y3, t);
    winding += dy.sign.toInt();
  }

  return winding;
}

extension type const LineSegment2._(Vec2List storage) implements Object {
  LineSegment2.zero() : storage = .new(2);

  LineSegment2(Vec2 a, Vec2 b) : storage = .new(2) {
    storage[0] = a;
    storage[1] = b;
  }

  LineSegment2.view(Vec2List storage) : storage = storage;

  Vec2 get a => storage[0];
  Vec2 get b => storage[1];

  set a(Vec2 value) => storage[0] = value;
  set b(Vec2 value) => storage[1] = value;

  Intersection? intersect(LineSegment2 other, {double tolerance = 1e-9}) {
    return lineSegmentIntersect(a, b, other.a, other.b, tolerance: tolerance);
  }
}

Intersection? lineSegmentIntersect(Vec2 a, Vec2 b, Vec2 c, Vec2 d, {double tolerance = 1e-9}) {
  final r = b - a;
  final s = d - c;
  final denom = r.cross(s);
  if (denom.abs() < 1e-18) return null;

  final qp = c - a;
  final u = qp.cross(s) / denom;
  final v = qp.cross(r) / denom;

  if (u < -tolerance || u > 1 + tolerance || v < -tolerance || v > 1 + tolerance) return null;
  return .new(u.clamp(0.0, 1.0), v.clamp(0.0, 1.0), a + r * u);
}


extension Vec2ListImpl on Vec2List {
  void transform(Mat4 m) {
    for (var i = 0; i < length; i++) this[i] = m.transform2(this[i]);
  }
}

extension Vec2Impl on Vec2 {
  double dot(Vec2 other) => x * other.x + y * other.y;
  double cross(Vec2 other) => x * other.y - y * other.x;

  double get length2 => x * x + y * y;
  double get length => math.sqrt(length2);
  Vec2 normalized() => this / length;

  double distance2To(Vec2 other) => (x - other.x) * (x - other.x) + (y - other.y) * (y - other.y);
  double distanceTo(Vec2 other) => math.sqrt(distance2To(other));

  Vec2 multiply(Vec2 other) => .new(x * other.x, y * other.y);

  bool equals(Vec2 other, [double epsilon = 1e-12]) {
    return (x - other.x).abs() < epsilon && (y - other.y).abs() < epsilon;
  }

  bool isZero([double epsilon = 1e-12]) => x.abs() < epsilon && y.abs() < epsilon;
  bool get isFinite => x.isFinite && y.isFinite;

  Vec2 pointReflect(Vec2 p) {
    return p * 2 - this;
  }

  bool exactEquals(Vec2 other) => x == other.x && y == other.y;

  Aabb2 aabb(Vec2 other) => Aabb2.bbox2(this, other);
  Aabb2 operator &(Size2 size) => Aabb2.ltwh(x, y, size.width, size.height);

  Vec2 round() => .new(x.roundToDouble(), y.roundToDouble());
  Vec2 floor() => .new(x.floorToDouble(), y.floorToDouble());
  Vec2 ceil() => .new(x.ceilToDouble(), y.ceilToDouble());

  Vec2 snappedToAxis() {
    if (x.abs() > y.abs()) {
      return Vec2(x, 0);
    } else {
      return Vec2(0, y);
    }
  }

  Vec2 snappedToAngle(double angleRad) {
    if (angleRad == 0.0) return this;
    final length = this.length;
    if (length == 0) return this;

    final currentAngle = math.atan2(y, x);
    final snappedAngle = (currentAngle / angleRad).round() * angleRad;
    final delta = snappedAngle - currentAngle;
    if (delta == 0.0) return this;

    final cosD = math.cos(delta);
    final sinD = math.sin(delta);

    return .new(x * cosD - y * sinD, x * sinD + y * cosD);
  }
}


extension MatrixImpl on Mat4 {
  double get determinant2 => this[0] * this[5] - this[1] * this[4];
  Mat4 inverted() => .copy(this)..invert();

  double get scaleX => math.sqrt(this[0] * this[0] + this[1] * this[1] + this[2] * this[2]);
  double get scaleY => math.sqrt(this[4] * this[4] + this[5] * this[5] + this[6] * this[6]);
  double get scaleZ => math.sqrt(this[8] * this[8] + this[9] * this[9] + this[10] * this[10]);

  Mat4 withNormalizedScale() {
    final sx = scaleX, sy = scaleY, sz = scaleZ;
    final m = Mat4.copy(this);
    // dart format off
    if (sx > 0) { m[0] /= sx; m[1] /= sx; m[2] /= sx; }
    if (sy > 0) { m[4] /= sy; m[5] /= sy; m[6] /= sy; }
    if (sz > 0) { m[8] /= sz; m[9] /= sz; m[10] /= sz; }
    // dart format on
    return m;
  }

  Mat4 unmirrored(Size2 box) {
    if (determinant2 > 0) return this;

    final Mat4 flip;
    if (this[0] < 0) {
      flip = Mat4.identity()
        ..translate(box.width, 0.0)
        ..scale(-1, 1);
    } else {
      flip = Mat4.identity()
        ..translate(0.0, box.height)
        ..scale(1, -1);
    }

    return this * flip;
  }

  double get maxScaleOnAxis => math.max(math.max(scaleX, scaleY), scaleZ);
  double get maxScaleOnAxis2D => math.max(scaleX, scaleY);

  bool equals(Mat4 other, [double epsilon = 1e-6]) {
    for (var i = 0; i < 16; i++) {
      if ((this[i] - other[i]).abs() > epsilon) return false;
    }
    return true;
  }

  bool exactEquals(Mat4 other) {
    for (var i = 0; i < 16; i++) {
      if (this[i] != other[i]) return false;
    }
    return true;
  }
}