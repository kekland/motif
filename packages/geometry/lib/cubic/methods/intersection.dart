part of '../cubic.dart';

List<Intersection> _cubicIntersect(Cubic2 a, Cubic2 b) {
  return _ffiCubicIntersect(a, b);
}

Intersection? _cubicSelfIntersect(Cubic2 c) {
  return _ffiCubicSelfIntersect(c);
}

List<Intersection> _cubicCircleIntersect(Cubic2 c, Circle2 circle) {
  return _ffiCubicCircleIntersect(c, circle);
}

List<Intersection> _splineIntersect(CubicSpline2 a, CubicSpline2 b) {
  return _cubicListIntersect(
    a.segments.toList(),
    b.segments.toList(),
  );
}

List<Intersection> _splineCubicIntersect(CubicSpline2 a, Cubic2 b) {
  return _cubicListIntersect(a.segments.toList(), [b]);
}

List<Intersection> _splineCircleIntersect(CubicSpline2 a, Circle2 circle) {
  final segments = a.segments.toList();
  final n = a.segmentCount;
  final out = <Intersection>[];

  for (var i = 0; i < n; i++) {
    final inters = _cubicCircleIntersect(segments[i], circle);
    for (final inter in inters) {
      final ta = (i + inter.tA) / n;
      out.add(Intersection(inter.point, ta, 0.0));
    }
  }

  return _splineIntersectDedupe(out);
}

List<Intersection> _splineSelfIntersect(CubicSpline2 a) {
  final segments = a.segments.toList();
  final n = a.segmentCount;
  final out = <Intersection>[];

  for (var i = 0; i < n; i++) {
    final self = _cubicSelfIntersect(segments[i]);
    if (self != null) out.add(_splineIntersectNormalize(self, i, i, n, n));

    for (var j = i + 1; j < n; j++) {
      final inters = _cubicIntersect(segments[i], segments[j]);
      for (final inter in inters) out.add(_splineIntersectNormalize(inter, i, j, n, n));
    }
  }

  final knotEps = 0.5 / n;
  out.removeWhere((h) {
    final nearestKnot = (h.tA * n).round() / n;
    final tANearKnot = (h.tA - nearestKnot).abs() < knotEps * 0.1;
    final tBNearKnot = (h.tB - nearestKnot).abs() < knotEps * 0.1;
    return tANearKnot && tBNearKnot;
  });

  return _splineIntersectDedupe(
    out.map((h) {
      return h.tA <= h.tB ? h : Intersection(h.point, h.tB, h.tA);
    }).toList(),
  );
}

List<Intersection> _splineIntersectDedupe(List<Intersection> raw, {double epsilon = 1e-9}) {
  if (raw.length < 2) return raw;
  raw.sort((x, y) {
    final c = x.tA.compareTo(y.tA);
    return c != 0 ? c : x.tB.compareTo(y.tB);
  });

  final out = <Intersection>[raw.first];
  for (var i = 1; i < raw.length; i++) {
    final prev = out.last;
    final curr = raw[i];
    if ((curr.tA - prev.tA).abs() < epsilon && (curr.tB - prev.tB).abs() < epsilon) continue;
    out.add(curr);
  }

  return out;
}

List<Intersection> _cubicListIntersect(List<Cubic2> a, List<Cubic2> b) {
  final out = <Intersection>[];
  for (var i = 0; i < a.length; i++) {
    for (var j = 0; j < b.length; j++) {
      final inters = _cubicIntersect(a[i], b[j]);
      for (final inter in inters) {
        out.add(_splineIntersectNormalize(inter, i, j, a.length, b.length));
      }
    }
  }

  return _splineIntersectDedupe(out);
}

Intersection _splineIntersectNormalize(Intersection i, int ai, int bi, int na, int nb) {
  final ta = (ai + i.tA) / na;
  final tb = (bi + i.tB) / nb;
  return Intersection(i.point, ta, tb);
}
