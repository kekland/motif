part of '../cubic.dart';

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
