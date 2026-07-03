import 'dart:ui' as ui;

import 'package:geometry/geometry.dart';
import 'package:vc/renderer.dart';

List<CellHitTestEntry> rectHitTestRenderComplex(
  RenderVectorComplex renderComplex,
  ui.Rect rect,
) {
  final aabb = Aabb2.minMax(.new(rect.left, rect.top), .new(rect.right, rect.bottom));

  final complex = renderComplex.complex;
  final indexed = <(CellHitTestEntry, int)>[];
  var depth = 0;

  for (final c in complex.reversedCells) {
    final List<CellHitTestEntry> results = switch (c) {
      Vertex v => rectHitTestVertex(renderComplex, v, aabb),
      Edge e => rectHitTestEdge(renderComplex, e, aabb),
      _ => [],
    };

    for (final result in results) indexed.add((result, depth));
    depth++;
  }

  return indexed.map((e) => e.$1).toList();
}

List<VertexHitTestEntry> rectHitTestVertex(
  RenderVectorComplex complex,
  Vertex vertex,
  Aabb2 rect,
) {
  final position = vertex.position;
  if (rect.containsVector2(position)) {
    return [.new(complex, .new(position.x, position.y), cell: vertex, distance: 0.0)];
  }

  return [];
}

List<CellHitTestEntry> rectHitTestEdge(
  RenderVectorComplex complex,
  Edge edge,
  Aabb2 rect,
) {
  final bboxTight = edge.bboxTight;

  // If we've fully selected the edge, return it immediately
  if (rect.containsAabb2(bboxTight)) {
    final center = bboxTight.center;
    return [EdgeHitTestEntry(complex, .new(center.x, center.y), cell: edge, distance: 0.0, t: 0.5)];
  }

  // Otherwise, iterate through edge's knots.
  final result = <CellHitTestEntry>[];
  final path = edge.path;
  final n = path.length;
  for (final (i, knot) in path.knots.indexed) {
    final t = i / n;
    final position = knot.p;
    if (rect.containsVector2(position)) {
      result.add(
        EdgeKnotHitTestEntry(complex, .new(position.x, position.y), cell: edge, distance: 0.0, knotIndex: i, t: t),
      );
    }
  }

  return result;
}
