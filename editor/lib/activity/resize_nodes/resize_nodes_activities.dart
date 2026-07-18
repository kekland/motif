part of '../resize_nodes_activity.dart';

abstract class _BaseResizeNodesActivity extends NodeGroupActivity
    with ExclusiveCursorDragActivity, KeyboardListenerDragActivity {
  _BaseResizeNodesActivity(super.editor, {required super.nodes});

  @override
  Set<LogicalKeyboardKey> get keysToListen => {.shiftLeft, .shiftRight, .altLeft, .altRight};

  Aabb2 applyResize(Aabb2 initial, Vector2 delta, bool symmetric, bool keepAspectRatio);
  Matrix4 getResizeTransform(Aabb2 initial, Vector2 delta, bool symmetric, bool keepAspectRatio) {
    final newBbox = applyResize(initial, delta, symmetric, keepAspectRatio);
    final sx = initial.width == 0 ? 1.0 : newBbox.width / initial.width;
    final sy = initial.height == 0 ? 1.0 : newBbox.height / initial.height;

    return Matrix4.identity()
      ..translateByDouble(newBbox.min.x, newBbox.min.y, 0.0, 1.0)
      ..scaleByDouble(sx, sy, 1.0, 1.0)
      ..translateByDouble(-initial.min.x, -initial.min.y, 0.0, 1.0);
  }
}

abstract class _BaseEdgeResizeNodesActivity extends _BaseResizeNodesActivity {
  _BaseEdgeResizeNodesActivity(
    super.editor, {
    required super.nodes,
    required this.edge,
  });

  final ui.Edge edge;

  @override
  MouseCursor get cursor => Cursors.resize;

  @override
  Aabb2 applyResize(Aabb2 initial, Vector2 delta, bool symmetric, bool keepAspectRatio) {
    return edge.applyResize(initial, delta, symmetric: symmetric, keepAspectRatio: keepAspectRatio);
  }
}

class _BaseCornerResizeNodesActivity extends _BaseResizeNodesActivity {
  _BaseCornerResizeNodesActivity(
    super.editor, {
    required super.nodes,
    required this.corner,
  });

  final ui.Corner corner;

  @override
  MouseCursor get cursor => Cursors.resize;

  @override
  Aabb2 applyResize(Aabb2 initial, Vector2 delta, bool symmetric, bool keepAspectRatio) {
    return corner.applyResize(initial, delta, symmetric: symmetric, keepAspectRatio: keepAspectRatio);
  }
}

class _EdgeResizeSingleNodeActivity extends _BaseEdgeResizeNodesActivity with _SingleNodeResize {
  _EdgeResizeSingleNodeActivity(super.editor, {required super.nodes, required super.edge});
}

class _CornerResizeSingleNodeActivity extends _BaseCornerResizeNodesActivity with _SingleNodeResize {
  _CornerResizeSingleNodeActivity(super.editor, {required super.nodes, required super.corner});
}

class _EdgeResizeMultiNodeActivity extends _BaseEdgeResizeNodesActivity with _MultiNodeResize {
  _EdgeResizeMultiNodeActivity(super.editor, {required super.nodes, required super.edge});
}

class _CornerResizeMultiNodeActivity extends _BaseCornerResizeNodesActivity with _MultiNodeResize {
  _CornerResizeMultiNodeActivity(super.editor, {required super.nodes, required super.corner});
}
