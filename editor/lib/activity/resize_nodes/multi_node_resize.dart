part of '../resize_nodes_activity.dart';

mixin _MultiNodeResize on _BaseResizeNodesActivity {
  @override
  void onUpdate(DragUpdateDetails details) {
    final startPosition = startDetails.globalPosition.vec2;
    final currentPosition = details.globalPosition.vec2;

    final sceneDelta = editor.globalToScene(currentPosition) - editor.globalToScene(startPosition);
    final sceneTransform = getResizeTransform(groupBbox, sceneDelta, isShiftPressed, isAltPressed);
    applyTransformToNodes(sceneTransform);

    super.onUpdate(details);
  }
}
