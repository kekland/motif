part of 'hit_test.dart';

const _vertexHitTestTolerance = 8.0;
const _edgeHitTestTolerance = 8.0;

double _computeScaledTolerance(RenderObject render, double tolerance) {
  final scale = 1.0 / render.getTransformTo(null).getMaxScaleOnAxis();
  return tolerance * scale;
}

List<CellHitTestEntry> hitTestCells(RenderObject render, List<RenderCell> renderCells, Offset position) {
  final indexed = <(CellHitTestEntry, int)>[];
  var depth = 0;

  for (final c in renderCells.reversed) {
    final localPosition = MatrixUtils.transformPoint(render.getTransformTo(c), position);
    final entry = c.hitTestCell(localPosition);
    if (entry != null) {
      indexed.add((entry, depth));
    }
    depth++;
  }

  int _priority(CellHitTestEntry r) => switch (r) {
    VertexHitTestEntry _ => 0,
    // KnotControlPointHitTestEntry _ => 1,
    // EdgeKnotHitTestEntry _ => 2,
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

VertexHitTestEntry? hitTestVertex(RenderVertex render, Offset localPosition) {
  final tolerance = _computeScaledTolerance(render, _vertexHitTestTolerance);
  final distance = localPosition.distance;
  return distance <= tolerance ? .new(render, localPosition, distance: distance) : null;
}

EdgeHitTestEntry? hitTestEdge(RenderEdge render, Offset localPosition) {
  final tolerance = _computeScaledTolerance(render, _edgeHitTestTolerance);

  const double flatnessTolerance = 0.5;

  final point = Vector2(localPosition.dx, localPosition.dy);
  final e = render.object;
  // final spline = e.path;
  final spline = CubicSpline2.cubics([.line(e.start.position, e.end.position)]);
  final n = spline.segmentCount;
  if (n == 0) return null;

  var bestDistance = double.infinity;
  var bestLocal = 0.0;

  // final weightSamples = e.weights.profile.splitIntoSegments(n);
  // final strokeWidth = e.decoration.width;

  for (var i = 0; i < n; i++) {
    final cubic = spline.segment(i);
    // final weights = weightSamples[i];
    // final maxWeight = weights.isNotEmpty ? weights.max : 1.0;

    // final bbox = cubic.bbox.inflate((strokeWidth * maxWeight) / 2);
    final bbox = cubic.bbox;
    final bboxDistance = bbox.distanceTo(point);
    if (bboxDistance > tolerance || bboxDistance >= bestDistance) continue;

    cubic.forEachSegment(
      (segment, at, bt) {
        final result = segment.closestTo(point);
        // final sample = weights.isNotEmpty ? weights.at(result.t) : null;
        // final distance = result.distance - (strokeWidth * (sample?.v ?? 1.0)) / 2;
        final distance = result.distance;

        if (distance < bestDistance) {
          bestDistance = distance;
          bestLocal = i + (at + result.t * (bt - at));
        }
      },
      tolerance: flatnessTolerance,
    );
  }

  if (bestDistance > tolerance) return null;
  return .new(render, localPosition, distance: bestDistance, t: bestLocal / n);
}
