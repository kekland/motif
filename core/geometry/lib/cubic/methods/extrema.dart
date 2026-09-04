part of '../cubic.dart';

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
