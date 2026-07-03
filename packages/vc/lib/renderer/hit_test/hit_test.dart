import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:geometry/geometry.dart';
import 'package:vc/renderer.dart';

List<CellHitTestEntry> hitTestRenderComplex(
  RenderVectorComplex renderComplex,
  ui.Offset position,
  CellHitTestTolerance tolerance,
) {
  final complex = renderComplex.complex;
  final indexed = <(CellHitTestEntry, int)>[];
  var depth = 0;

  for (final c in complex.reversedCells) {
    final List<CellHitTestEntry> results = switch (c) {
      Vertex v => hitTestVertex(renderComplex, v, position, tolerance.vertex),
      Edge e => hitTestEdge(renderComplex, e, position, tolerance.edge, tolerance.knot, tolerance.controlPoint),
    };

    for (final result in results) indexed.add((result, depth));
    depth++;
  }

  int _priority(CellHitTestEntry r) => switch (r) {
    VertexHitTestEntry _ => 0,
    KnotControlPointHitTestEntry _ => 1,
    EdgeKnotHitTestEntry _ => 2,
    EdgeHitTestEntry _ => 3,
    // FaceHitTestEntry _ => 2,
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

List<VertexHitTestEntry> hitTestVertex(
  RenderVectorComplex complex,
  Vertex vertex,
  ui.Offset position,
  double tolerance,
) {
  final result = _hitTestVertexRaw(vertex, Vector2(position.dx, position.dy), tolerance);
  return result != null ? [VertexHitTestEntry(complex, position, cell: vertex, distance: result)] : [];
}

List<CellHitTestEntry> hitTestEdge(
  RenderVectorComplex complex,
  Edge edge,
  ui.Offset position,
  double edgeTolerance,
  double knotTolerance,
  double controlPointTolerance,
) {
  final p = Vector2(position.dx, position.dy);

  final edgeResult = _hitTestEdgeRaw(edge, p, edgeTolerance);
  final knotResult = _hitTestEdgeKnotRaw(edge, p, knotTolerance);
  final controlPointResult = _hitTestKnotControlPointRaw(edge, p, controlPointTolerance);

  return [
    if (edgeResult != null)
      EdgeHitTestEntry(
        complex,
        position,
        cell: edge,
        distance: edgeResult.$1,
        t: edgeResult.$2,
      ),

    if (knotResult != null)
      EdgeKnotHitTestEntry(
        complex,
        position,
        cell: edge,
        distance: knotResult.$1,
        t: knotResult.$2,
        knotIndex: knotResult.$3,
      ),

    if (controlPointResult != null)
      KnotControlPointHitTestEntry(
        complex,
        position,
        cell: edge,
        distance: controlPointResult.$1,
        knotIndex: controlPointResult.$2,
        isIn: controlPointResult.$3,
      ),
  ];
}

double? _hitTestPoint(Vector2 target, Vector2 point, double tolerance) {
  final diff = (target - point)..absolute();
  final max = math.max(diff.x, diff.y);
  if (max > tolerance) return null;
  return max;
}

double? _hitTestVertexRaw(Vertex v, Vector2 point, double tolerance) => _hitTestPoint(v.position, point, tolerance);

(double distance, double t, int knotIndex)? _hitTestEdgeKnotRaw(Edge e, Vector2 point, double tolerance) {
  final spline = e.path;
  final n = spline.segmentCount;
  if (n == 0) return null;

  int? knotIndex;
  var bestKnotDistance = double.infinity;

  // Check for knots
  for (var i = 0; i <= n; i++) {
    final knot = spline.knot(i);
    final distance = (knot.p - point).length;
    if (distance < tolerance && distance < bestKnotDistance) {
      bestKnotDistance = distance;
      knotIndex = i;
    }
  }

  if (knotIndex == null) return null;
  return (bestKnotDistance, knotIndex / n, knotIndex);
}

(double distance, double t)? _hitTestEdgeRaw(Edge e, Vector2 point, double tolerance) {
  const double flatnessTolerance = 0.5;

  final spline = e.path;
  final n = spline.segmentCount;
  if (n == 0) return null;

  var bestDistance = double.infinity;
  var bestLocal = 0.0;

  final weightSamples = e.weights.profile.splitIntoSegments(n);
  final strokeWidth = e.decoration.width;

  for (var i = 0; i < n; i++) {
    final cubic = spline.segment(i);
    final weights = weightSamples[i];
    final maxWeight = weights.isNotEmpty ? weights.max : 1.0;

    final bbox = cubic.bbox.inflate((strokeWidth * maxWeight) / 2);
    final bboxDistance = bbox.distanceTo(point);
    if (bboxDistance > tolerance || bboxDistance >= bestDistance) continue;

    cubic.forEachSegment(
      (segment, at, bt) {
        final result = segment.closestTo(point);
        final sample = weights.isNotEmpty ? weights.at(result.t) : null;
        final distance = result.distance - (strokeWidth * (sample?.v ?? 1.0)) / 2;

        if (distance < bestDistance) {
          bestDistance = distance;
          bestLocal = i + (at + result.t * (bt - at));
        }
      },
      tolerance: flatnessTolerance,
    );
  }

  if (bestDistance > tolerance) return null;
  return (bestDistance, bestLocal / n);
}

(double distance, int knotIndex, bool isIn)? _hitTestKnotControlPointRaw(
  Edge e,
  Vector2 point,
  double tolerance,
) {
  final spline = e.path;
  final n = spline.length;
  if (n == 0) return null;

  (int, bool)? bestKnot;
  var bestDistance = double.infinity;

  for (var i = 0; i < n; i++) {
    final knot = spline.knot(i);
    final cIn = knot.cIn;
    if (cIn != null) {
      final distance = (cIn - point).length;
      if (distance < tolerance && distance < bestDistance) {
        bestDistance = distance;
        bestKnot = (i, true);
      }
    }

    final cOut = knot.cOut;
    if (cOut != null) {
      final distance = (cOut - point).length;
      if (distance < tolerance && distance < bestDistance) {
        bestDistance = distance;
        bestKnot = (i, false);
      }
    }
  }

  if (bestKnot == null) return null;
  return (bestDistance, bestKnot.$1, bestKnot.$2);
}
