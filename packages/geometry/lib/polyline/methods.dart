part of 'polyline.dart';

Iterable<LineSegment2> _polylineSegments(Polyline2 p) sync* {
  for (var i = 0; i < p.length - 1; i++) yield .new(p[i], p[i + 1]);
}

Iterable<LineSegment2> _polylineClosedSegments(Polyline2 p) sync* {
  if (p.length < 2) return;
  for (var i = 0; i < p.length - 1; i++) yield .new(p[i], p[i + 1]);
  if (p.first != p.last) yield .new(p.last, p.first);
}

Aabb2 _polylineBbox(Polyline2 p) {
  if (p.isEmpty) return Aabb2();

  final min = p.first.clone(), max = p.first.clone();

  for (final pt in p.points) {
    Vector2.min(min, pt, min);
    Vector2.max(max, pt, max);
  }

  return Aabb2.minMax(min, max);
}

double _polylineSignedArea(Polyline2 p) {
  if (p.length < 3) return 0.0;
  var area = 0.0;

  for (final segment in _polylineClosedSegments(p)) {
    final (a, b) = segment.points;
    area += (a.x * b.y) - (b.x * a.y);
  }

  return 0.5 * area;
}

bool _polylineContains(Polyline2 p, Vector2 target) {
  var inside = false;

  for (var i = 0, j = p.length - 1; i < p.length; j = i++) {
    final yi = p[i].y, yj = p[j].y;
    if ((yi > target.y) != (yj > target.y)) {
      final xi = p[i].x, xj = p[j].x;
      final x = xj + (target.y - yj) * (xi - xj) / (yi - yj);
      if (target.x < x) inside = !inside;
    }
  }

  return inside;
}

double _polylineLength(Polyline2 p) {
  var length = 0.0;
  for (final segment in _polylineSegments(p)) length += segment.length;
  return length;
}

typedef SegmentClosestPointResult = ({Vector2 point, double distance, double t});
SegmentClosestPointResult _segmentClosestTo(Vector2 a, Vector2 b, Vector2 target) {
  final ab = b - a;
  final at = target - a;
  final lenSq = ab.length2;
  final t = lenSq < 1e-18 ? 0.0 : (at.dot(ab) / lenSq).clamp(0.0, 1.0);
  final proj = a + (ab * t);
  final dist = target.distanceTo(proj);
  return (point: proj, distance: dist, t: t);
}

typedef ClosestPointResult = ({Vector2 point, double distance, int segmentIndex, double t});

ClosestPointResult _polylineClosestTo(Polyline2 p, Vector2 target) {
  if (p.isEmpty) throw StateError('cannot find closest point on an empty polyline');
  if (p.length == 1) return (point: p.first.clone(), distance: target.distanceTo(p.first), segmentIndex: 0, t: 0.0);

  var bestIndex = 0;
  var best = _segmentClosestTo(p[0], p[1], target);

  for (var i = 1; i < p.length - 1; i++) {
    final r = _segmentClosestTo(p[i], p[i + 1], target);
    if (r.distance < best.distance) {
      bestIndex = i;
      best = r;
    }
  }

  return (point: best.point, distance: best.distance, segmentIndex: bestIndex, t: best.t);
}

Vector2 _polylineLeftmost(Polyline2 p) {
  if (p.isEmpty) throw StateError('cannot find leftmost point of an empty polyline');

  var leftmost = p.first;
  for (final pt in p.points) {
    if (pt.x < leftmost.x || (pt.x == leftmost.x && pt.y < leftmost.y)) {
      leftmost = pt;
    }
  }

  return leftmost.clone();
}
