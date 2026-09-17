part of 'stroke.dart';

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
 
