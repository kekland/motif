part of '../vector_complex.dart';

sealed class HitTestEntry {
  const HitTestEntry({required this.distance});

  /// Distance in canvas-space units, from the point to the closest point in the cell's geometry.
  final double distance;

  /// The cell that was hit.
  Cell get cell;
}

final class VertexHitTestEntry extends HitTestEntry {
  const VertexHitTestEntry({required this.vertex, required super.distance});

  final Vertex vertex;

  @override
  Cell get cell => vertex;
}

final class EdgeHitTestEntry extends HitTestEntry {
  const EdgeHitTestEntry({required this.edge, required this.t, required super.distance});

  final Edge edge;

  /// Parameter in range (0, 1) for the spline.
  final double t;

  @override
  Cell get cell => edge;
}

final class FaceHitTestEntry extends HitTestEntry {
  const FaceHitTestEntry({required this.face, required super.distance});

  final Face face;

  @override
  Cell get cell => face;
}

final class HitTestTolerance {
  const HitTestTolerance({required this.vertex, required this.edge});
  static const defaultTolerance = HitTestTolerance(vertex: 8.0, edge: 5.0);

  /// Tolerance for hitting vertices, in canvas-space units.
  final double vertex;

  /// Tolerance for hitting edges, in canvas-space units.
  final double edge;

  HitTestTolerance scaled(double f) => HitTestTolerance(vertex: vertex * f, edge: edge * f);
}

List<HitTestEntry> _hitTestComplex(
  VectorComplex complex,
  Vector2 point, {
  HitTestTolerance tolerance = .defaultTolerance,
}) {
  final indexed = <(HitTestEntry, int)>[];
  var depth = 0;

  for (var c = complex.top; c != null; c = c.prev) {
    final result = switch (c) {
      Vertex v => _hitTestVertex(v, point, tolerance.vertex),
      Edge e => _hitTestEdge(e, point, tolerance.edge),
      Face _ => null,
    };

    if (result != null) indexed.add((result, depth));
    depth++;
  }

  int _priority(HitTestEntry r) => switch (r) {
    VertexHitTestEntry _ => 0,
    EdgeHitTestEntry _ => 1,
    FaceHitTestEntry _ => 2,
  };

  indexed.sort((a, b) {
    final typeComparison = _priority(a.$1).compareTo(_priority(b.$1));
    if (typeComparison != 0) return typeComparison;

    final distanceComparison = a.$1.distance.compareTo(b.$1.distance);
    if (distanceComparison != 0) return distanceComparison;

    return a.$2.compareTo(b.$2);
  });

  return indexed.map((e) => e.$1).toList();
}

// --
// Vertex
// --

VertexHitTestEntry? _hitTestVertex(Vertex v, Vector2 point, double tolerance) {
  final d = v.position.distanceTo(point);
  if (d > tolerance) return null;
  return .new(vertex: v, distance: d);
}

// --
// Edge
// --

EdgeHitTestEntry? _hitTestEdge(Edge e, Vector2 point, double tolerance) {
  const double flatnessTolerance = 0.5;

  final spline = e.spline;
  final n = spline.segmentCount;
  if (n == 0) return null;

  var bestDistance = double.infinity;
  var bestLocal = 0.0;

  for (var i = 0; i < n; i++) {
    final cubic = spline.segment(i);
    final a = cubic.a;
    final b = cubic.b;
    final c1 = cubic.c1 ?? a;
    final c2 = cubic.c2 ?? b;

    final minX = math.min(math.min(a.x, b.x), math.min(c1.x, c2.x));
    final maxX = math.max(math.max(a.x, b.x), math.max(c1.x, c2.x));
    final minY = math.min(math.min(a.y, b.y), math.min(c1.y, c2.y));
    final maxY = math.max(math.max(a.y, b.y), math.max(c1.y, c2.y));

    final dx = math.max(0.0, math.max(minX - point.x, point.x - maxX));
    final dy = math.max(0.0, math.max(minY - point.y, point.y - maxY));
    final bboxDistance = math.sqrt(dx * dx + dy * dy);
    if (bboxDistance > tolerance || bboxDistance >= bestDistance) continue;

    Vector2? previousPoint;
    double previousT = 0.0;

    Cubic2.flattenCubic(a, c1, c2, b, flatnessTolerance, (s, t) {
      if (previousPoint != null) {
        final (segmentDistance, segmentT) = _closestOnSegment(previousPoint!, s, point);
        if (segmentDistance < bestDistance) {
          bestDistance = segmentDistance;
          bestLocal = i + (previousT + segmentT * (t - previousT));
        }
      }

      previousPoint = s;
      previousT = t;
    });
  }

  if (bestDistance > tolerance) return null;
  return .new(edge: e, t: bestLocal / n, distance: bestDistance);
}

(double, double) _closestOnSegment(Vector2 a, Vector2 b, Vector2 point) {
  final ab = b - a;
  final lengthSquared = ab.length2;
  if (lengthSquared < 1e-18) return (point.distanceTo(a), 0.0);

  var t = (point - a).dot(ab) / lengthSquared;
  t = t.clamp(0.0, 1.0);

  final closest = a + (ab * t);
  return (closest.distanceTo(point), t);
}
