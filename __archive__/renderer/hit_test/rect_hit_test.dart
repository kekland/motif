part of 'hit_test.dart';

enum ObjectHitTestRectMode {
  /// Only allow nodes that intersect, but don't require to be contanied
  intersect,

  /// Only allow nodes that are fully contained
  contain,

  /// Regular (intersect for leaf nodes, contain for non-leaf nodes)
  normal,
}

List<CellHitTestEntry> rectHitTestCells(
  RenderObject render,
  List<RenderCell> renderCells,
  Rect rect, {
  ObjectHitTestRectMode mode = .normal,
}) {
  final indexed = <(CellHitTestEntry, int)>[];
  var depth = 0;

  for (final c in renderCells.reversed) {
    final localRect = MatrixUtils.transformRect(render.getTransformTo(c), rect);
    final entry = c.hitTestCellRect(localRect, mode: mode);
    if (entry != null) {
      indexed.add((entry, depth));
    }
    depth++;
  }

  return indexed.map((e) => e.$1).toList();
}

VertexHitTestEntry? rectHitTestVertex(RenderVertex render, Rect rect) {
  if (rect.contains(.zero)) {
    return .new(render, .zero, distance: 0.0);
  }

  return null;
}

EdgeHitTestEntry? rectHitTestEdge(
  RenderEdge render,
  Rect rect, {
  ObjectHitTestRectMode mode = .normal,
}) {
  final edge = render.object;
  final bbox = edge.bboxTight;

  // If the edge is enclosed in the selection, return the entire edge
  if (mode == .contain && rect.containsAabb2(bbox)) {
    final center = bbox.center;
    return .new(render, center.offset, t: 0.5, distance: 0.0);
  } else if (mode != .contain && rect.overlapsAabb2(bbox)) {
    final center = bbox.center;
    return .new(render, center.offset, t: 0.5, distance: 0.0);
  }

  return null;
}
