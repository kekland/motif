part of 'render.dart';

final class VectorComplexHitTestResult extends BoxHitTestResult {}

sealed class CellHitTestEntry extends HitTestEntry<RenderCell> {
  CellHitTestEntry(super.target, {required this.distance, required this.localPosition});

  Cell get cell => target.cell;
  final double distance;
  final Vector2 localPosition;
}

final class VertexHitTestEntry extends CellHitTestEntry {
  VertexHitTestEntry(RenderVertex super.target, {required super.distance, required super.localPosition});

  Vertex get vertex => cell as Vertex;
}

final class EdgeHitTestEntry extends CellHitTestEntry {
  EdgeHitTestEntry(
    RenderEdge super.target, {
    required this.t,
    required super.distance,
    required super.localPosition,
  });

  Edge get edge => cell as Edge;

  final double t;
}

final class FaceHitTestEntry extends CellHitTestEntry {
  FaceHitTestEntry(RenderFace super.target, {required super.distance, required super.localPosition});

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
  return result != null ? VertexHitTestEntry(render, distance: result, localPosition: render.vertex.position) : null;
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

  return result != null ? EdgeHitTestEntry(render, distance: result.$1, localPosition: result.$2, t: result.$3) : null;
}

(double distance, Vector2, double t)? _hitTestEdgeRaw(Edge e, Vector2 point, double tolerance) {
  const double flatnessTolerance = 0.5;

  final spline = e.spline;
  final n = spline.segmentCount;
  if (n == 0) return null;

  var bestDistance = double.infinity;
  var bestPoint = Vector2.zero();
  var bestLocal = 0.0;

  for (var i = 0; i < n; i++) {
    final cubic = spline.segment(i);
    final bbox = cubic.bbox;
    final bboxDistance = bbox.distanceTo(point);
    if (bboxDistance > tolerance || bboxDistance >= bestDistance) continue;

    cubic.forEachSegment(
      (segment, at, bt) {
        final result = segment.closestTo(point);
        if (result.distance < bestDistance) {
          bestDistance = result.distance;
          bestPoint = result.point;
          bestLocal = i + (at + result.t * (bt - at));
        }
      },
      tolerance: flatnessTolerance,
    );
  }

  if (bestDistance > tolerance) return null;
  return (bestDistance, bestPoint, bestLocal / n);
}
