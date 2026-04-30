part of 'render.dart';

final class VectorComplexHitTestResult extends BoxHitTestResult {}

sealed class CellHitTestEntry extends HitTestEntry<RenderCell> {
  CellHitTestEntry(super.target, {required this.distance});

  Cell get cell => target.cell;
  final double distance;
}

final class VertexHitTestEntry extends CellHitTestEntry {
  VertexHitTestEntry(RenderVertex super.target, {required super.distance});

  Vertex get vertex => cell as Vertex;
}

final class EdgeHitTestEntry extends CellHitTestEntry {
  EdgeHitTestEntry(RenderEdge super.target, {required this.t, required super.distance});

  Edge get edge => cell as Edge;
  final double t;
}

final class FaceHitTestEntry extends CellHitTestEntry {
  FaceHitTestEntry(RenderFace super.target, {required super.distance});

  Face get face => cell as Face;
}

final class CellHitTestTolerance {
  const CellHitTestTolerance({required this.vertex, required this.edge});
  static const defaultTolerance = CellHitTestTolerance(vertex: 8.0, edge: 5.0);

  /// Tolerance for hitting vertices, in canvas-space units.
  final double vertex;

  /// Tolerance for hitting edges, in canvas-space units.
  final double edge;

  CellHitTestTolerance scaled(double f) => CellHitTestTolerance(vertex: vertex * f, edge: edge * f);
}

List<CellHitTestEntry> _hitTestRenderComplex(
  RenderVectorComplex renderComplex,
  Offset position,
  CellHitTestTolerance tolerance,
) {
  final complex = renderComplex.complex;
  final indexed = <(CellHitTestEntry, int)>[];
  var depth = 0;

  for (var c = complex.top; c != null; c = c.prev) {
    final child = renderComplex._children[c];
    if (child == null) continue;

    final result = switch (c) {
      Vertex _ => _hitTestRenderVertex(child as RenderVertex, position, tolerance.vertex),
      Edge _ => _hitTestRenderEdge(child as RenderEdge, position, tolerance.edge),
      Face _ => null,
    };

    if (result != null) indexed.add((result, depth));
    depth++;
  }

  int _priority(CellHitTestEntry r) => switch (r) {
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

VertexHitTestEntry? _hitTestRenderVertex(RenderVertex render, Offset position, double tolerance) {
  final result = _hitTestVertexRaw(render.vertex, Vector2(position.dx, position.dy), tolerance);
  return result != null ? VertexHitTestEntry(render, distance: result) : null;
}

double? _hitTestVertexRaw(Vertex v, Vector2 point, double tolerance) {
  final diff = (v.position - point)..absolute();
  final max = math.max(diff.x, diff.y);
  if (max > tolerance) return null;
  return max;
}

// --
// Edge
// --

EdgeHitTestEntry? _hitTestRenderEdge(RenderEdge render, Offset position, double tolerance) {
  final result = _hitTestEdgeRaw(render.edge, Vector2(position.dx, position.dy), tolerance);
  return result != null ? EdgeHitTestEntry(render, distance: result.$1, t: result.$2) : null;
}

(double distance, double t)? _hitTestEdgeRaw(Edge e, Vector2 point, double tolerance) {
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
  return (bestDistance, bestLocal / n);
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
