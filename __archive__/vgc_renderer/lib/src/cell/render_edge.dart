part of '../render_cell.dart';

final class RenderEdge extends RenderCell<Edge> {
  RenderEdge({required Edge edge}) : super(cell: edge);
  Edge get edge => cell;

  @override
  void performLayout() {
    final bbox = edge.boundingBoxApproximate;
    size = Size(bbox.max.x - bbox.min.x, bbox.max.y - bbox.min.y);
  }

  @override
  void paint(PaintingContext context, Offset offset) {}

  @override
  CellHitTestEntry? hitTestCell(Offset position, {CellHitTestTolerance tolerance = .defaultTolerance}) {
    return _hitTestRenderEdge(this, position, tolerance.edge);
  }
}

EdgeHitTestEntry? _hitTestRenderEdge(RenderEdge render, Offset position, double tolerance) {
  final result = _hitTestEdgeRaw(render.edge, Vector2(position.dx, position.dy), tolerance);
  if (result == null) return null;

  if (result.$4 != null) {
    return EdgeKnotHitTestEntry(
      render,
      distance: result.$1,
      localPosition: result.$2,
      t: result.$3,
      knotIndex: result.$4!,
    );
  }

  return EdgeHitTestEntry(
    render,
    distance: result.$1,
    localPosition: result.$2,
    t: result.$3,
  );
}

(double distance, Vector2, double t, int? knotIndex)? _hitTestEdgeRaw(Edge e, Vector2 point, double tolerance) {
  const double flatnessTolerance = 0.5;

  final spline = e.spline;
  final n = spline.segmentCount;
  if (n == 0) return null;

  var bestDistance = double.infinity;
  var bestPoint = Vector2.zero();
  var bestLocal = 0.0;

  final weightSamples = e.strokeWeight.splitIntoSegments(n);

  for (var i = 0; i < n; i++) {
    final cubic = spline.segment(i);
    final weights = weightSamples[i];
    final maxWeight = weights.max;

    final bbox = cubic.bbox.inflate((e.strokeWidth + maxWeight) / 2);
    final bboxDistance = bbox.distanceTo(point);
    if (bboxDistance > tolerance || bboxDistance >= bestDistance) continue;

    cubic.forEachSegment(
      (segment, at, bt) {
        final result = segment.closestTo(point);
        final sample = weights.at(result.t);
        final distance = result.distance - (e.strokeWidth * sample.v) / 2;

        if (distance < bestDistance) {
          bestDistance = distance;
          bestPoint = result.point;
          bestLocal = i + (at + result.t * (bt - at));
        }
      },
      tolerance: flatnessTolerance,
    );
  }

  if (bestDistance > tolerance) return null;

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

  return (bestDistance, bestPoint, bestLocal / n, knotIndex);
}
