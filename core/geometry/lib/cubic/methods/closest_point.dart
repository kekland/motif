part of '../cubic.dart';

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
