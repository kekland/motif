part of '../selection_activities.dart';

abstract class _BaseResizeNodesActivity extends NodeDragActivity
    with ExclusiveCursorDragActivity, KeyboardListenerDragActivity {
  _BaseResizeNodesActivity({required super.root, required super.nodes});

  @override
  Set<LogicalKeyboardKey> get keysToListen => {.shiftLeft, .shiftRight, .altLeft, .altRight};

  Rect applyResize(Rect initial, Offset delta, bool symmetric, bool keepAspectRatio);
}

mixin _SingleNodeResize on _BaseResizeNodesActivity {
  late final Size initialSize;
  late final Matrix4 initialTransform;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    final renderNode = renderNodes.single;
    initialSize = renderNode.size;
    initialTransform = renderNode.getTransformTo(renderNode.parentNode);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final node = nodes.single;
    final globalToNode = getGlobalToNode(0);

    final delta =
        MatrixUtils.transformPoint(globalToNode, details.globalPosition) -
        MatrixUtils.transformPoint(globalToNode, startDetails.globalPosition);

    final initialRect = Offset.zero & initialSize;
    var newRect = applyResize(initialRect, delta, isAltPressed, isShiftPressed);
    if (snapToPixelGrid) newRect = newRect.round();

    final topLeftParent = MatrixUtils.transformPoint(initialTransform, newRect.topLeft);

    final layoutSize = NodeLayoutSize.fixed(newRect.size.width, newRect.size.height);
    node.layout = node.layout.copyWith(size: layoutSize);
    node.transform = node.transform.copyWithTranslation(topLeftParent);
    super.onUpdate(details);
  }
}

mixin _MultiNodeResize on _BaseResizeNodesActivity {
  late final Rect initialGroupRect;
  late final List<Size> initialSizes;
  late final List<Matrix4> initialGlobalTransforms;
  late final List<Matrix4> initialGlobalToParents;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    final globalRects = renderNodes
        .map((rn) => MatrixUtils.transformRect(rn.getTransformTo(null), Offset.zero & rn.size))
        .toList();

    initialSizes = renderNodes.map((n) => n.size).toList();
    initialGroupRect = globalRects.boundingBox;
    initialGlobalTransforms = renderNodes.map((rn) => rn.getTransformTo(null)).toList();
    initialGlobalToParents = renderNodes.map((rn) => Matrix4.inverted(rn.parentNode!.getTransformTo(null))).toList();
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final delta = details.globalPosition - startDetails.globalPosition;
    var newGroupRect = applyResize(initialGroupRect, delta, isAltPressed, isShiftPressed);
    if (snapToPixelGrid) newGroupRect = newGroupRect.round();

    final sx = initialGroupRect.width == 0 ? 1.0 : newGroupRect.width / initialGroupRect.width;
    final sy = initialGroupRect.height == 0 ? 1.0 : newGroupRect.height / initialGroupRect.height;

    final groupScale = Matrix4.identity()
      ..translateByDouble(newGroupRect.left, newGroupRect.top, 0.0, 1.0)
      ..scaleByDouble(sx, sy, 1.0, 1.0)
      ..translateByDouble(-initialGroupRect.left, -initialGroupRect.top, 0.0, 1.0);

    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final Matrix4 globalTransform = groupScale * initialGlobalTransforms[i];
      final Matrix4 localTransform = initialGlobalToParents[i] * globalTransform;

      final newWidth = localTransform.scaleX * initialSizes[i].width;
      final newHeight = localTransform.scaleY * initialSizes[i].height;
      final normalizedTransform = localTransform.getWithNormalizedScale();

      final layoutSize = NodeLayoutSize.fixed(newWidth, newHeight);
      node.layout = node.layout.copyWith(size: layoutSize);
      node.transform = node.transform.copyWith(value: normalizedTransform);
    }

    super.onUpdate(details);
  }
}

abstract class _BaseEdgeResizeNodesActivity extends _BaseResizeNodesActivity {
  _BaseEdgeResizeNodesActivity({required super.root, required super.nodes, required this.edge});

  final Edge edge;

  @override
  MouseCursor get cursor => _resolveRotatingCursor(Cursors.resize, renderNodes, edge: edge);

  @override
  Rect applyResize(Rect initial, Offset delta, bool symmetric, bool keepAspectRatio) =>
      initial.applyEdgeResize(edge, delta, symmetric: symmetric, keepAspectRatio: keepAspectRatio);
}

abstract class _BaseCornerResizeNodesActivity extends _BaseResizeNodesActivity {
  _BaseCornerResizeNodesActivity({required super.root, required super.nodes, required this.corner});

  final Corner corner;

  @override
  MouseCursor get cursor => _resolveRotatingCursor(Cursors.resize, renderNodes, corner: corner);

  @override
  Rect applyResize(Rect initial, Offset delta, bool symmetric, bool keepAspectRatio) =>
      initial.applyCornerResize(corner, delta, symmetric: symmetric, keepAspectRatio: keepAspectRatio);
}

class _EdgeResizeSingleNodeActivity extends _BaseEdgeResizeNodesActivity with _SingleNodeResize {
  _EdgeResizeSingleNodeActivity({required super.root, required super.nodes, required super.edge});
}

class _CornerResizeSingleNodeActivity extends _BaseCornerResizeNodesActivity with _SingleNodeResize {
  _CornerResizeSingleNodeActivity({required super.root, required super.nodes, required super.corner});
}

class _EdgeResizeMultiNodesActivity extends _BaseEdgeResizeNodesActivity with _MultiNodeResize {
  _EdgeResizeMultiNodesActivity({required super.root, required super.nodes, required super.edge});
}

class _CornerResizeMultiNodesActivity extends _BaseCornerResizeNodesActivity with _MultiNodeResize {
  _CornerResizeMultiNodesActivity({required super.root, required super.nodes, required super.corner});
}

class ResizeNodesActivity {
  static NodeDragActivity edge({
    required RenderRootNode root,
    required List<MutableNode> nodes,
    required Edge edge,
  }) {
    if (nodes.length == 1) return _EdgeResizeSingleNodeActivity(root: root, nodes: nodes, edge: edge);
    return _EdgeResizeMultiNodesActivity(root: root, nodes: nodes, edge: edge);
  }

  static NodeDragActivity corner({
    required RenderRootNode root,
    required List<MutableNode> nodes,
    required Corner corner,
  }) {
    if (nodes.length == 1) return _CornerResizeSingleNodeActivity(root: root, nodes: nodes, corner: corner);
    return _CornerResizeMultiNodesActivity(root: root, nodes: nodes, corner: corner);
  }
}
