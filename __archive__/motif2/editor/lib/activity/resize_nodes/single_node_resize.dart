part of '../resize_nodes_activity.dart';

mixin _SingleNodeResize on _BaseResizeNodesActivity {
  SceneNode get node => nodes.first;

  late final Aabb2 initialBbox;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    final node = this.node;
    initialBbox = node.bbox;
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final node = this.node;

    final startPosition = startDetails.globalPosition.vec2;
    final currentPosition = details.globalPosition.vec2;

    final delta = editor.globalToLocal(node, currentPosition) - editor.globalToLocal(node, startPosition);
    final transform = getResizeTransform(initialBbox, delta, isAltPressed, isShiftPressed);

    node.applySnapshot(initialSnapshots.first);
    node.applyTransform(transform);
    super.onUpdate(details);
  }
}
