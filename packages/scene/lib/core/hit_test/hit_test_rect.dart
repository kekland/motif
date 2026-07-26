part of '../core.dart';

enum HitTestRectMode {
  /// Only allow nodes that intersect, but don't require to be contanied
  intersect,

  /// Only allow nodes that are fully contained
  contain,

  /// Regular (intersect for leaf nodes, contain for non-leaf nodes)
  normal,
}

bool _objectHitTestRect(
  SceneHitTestResult result,
  SceneObject object,
  Aabb2 rect, {
  HitTestRectMode mode = .normal,
}) {
  final boundingBox = object.bbox;
  if (!boundingBox.intersectsWithAabb2(rect)) return false;

  final isLeaf = object.isLeaf;
  final isContained = rect.containsAabb2(boundingBox);

  bool _addSelf() {
    result.add(SceneObjectHitTestEntry(object, boundingBox.center));
    return true;
  }

  if (isContained) return _addSelf();
  // if (mode == .contain) return false;
  if (isLeaf) return _addSelf();
  if (!isLeaf && mode == .intersect) return _addSelf();
  return _objectHitTestRectChildren(result, object, rect, mode: mode);
}

bool _objectHitTestRectChildren(
  SceneHitTestResult result,
  SceneObject object,
  Aabb2 rect, {
  HitTestRectMode mode = .normal,
}) {
  if (object.isLeaf) return false;
  var _result = false;

  for (final child in object.children.reversed) {
    final transform = object.getTransformTo(child);
    final childRect = transform.transformAabb2(rect);
    if (child.hitTestRect(result, childRect, mode: mode)) {
      _result = true;
    }
  }

  return _result;
}

// --------
// Cells
// --------

List<SceneHitTestEntry> _hitTestRectCells(
  MultiChildSceneObject parent,
  List<Cell> cells,
  Aabb2 localRect, {
  HitTestRectMode mode = .normal,
}) {
  final indexed = <(SceneHitTestEntry, int)>[];
  var depth = 0;

  for (final c in cells.reversed) {
    final entry = switch (c) {
      Vertex v => _hitTestRectVertex(v, localRect),
      Edge e => _hitTestRectEdge(e, localRect, mode: mode),
    };

    for (final e in entry) indexed.add((e, depth));
    depth++;
  }

  return indexed.map((e) => e.$1).toList();
}

List<SceneHitTestEntry> _hitTestRectVertex(Vertex vertex, Aabb2 localRect) {
  if (localRect.containsVector2(vertex.position)) {
    return [VertexHitTestEntry(vertex, vertex.position, distance: 0.0)];
  }

  return const [];
}

List<SceneHitTestEntry> _hitTestRectEdge(
  Edge edge,
  Aabb2 localRect, {
  HitTestRectMode mode = .normal,
}) {
  final bboxTight = edge.bboxTight;

  // If we've fully selected the edge, return it immediately
  if (localRect.containsAabb2(bboxTight)) {
    final center = bboxTight.center;
    return [EdgeHitTestEntry(edge, .new(center.x, center.y), distance: 0.0, t: 0.5)];
  }

  // Otherwise, iterate through edge's knots.
  final result = <SceneHitTestEntry>[];
  final path = edge.path;

  final n = path.knots.length;

  for (var i = 1; i < n - 1; i++) {
    final knot = path.knot(i);
    final position = knot.p;

    if (localRect.containsVector2(position)) {
      result.add(
        EdgeKnotHitTestEntry(
          knot,
          .new(position.x, position.y),
          distance: 0.0,
          edge: edge,
          index: i,
        ),
      );
    }
  }

  return result;
}
