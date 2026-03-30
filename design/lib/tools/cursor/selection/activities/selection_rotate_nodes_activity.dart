part of '../selection_activities.dart';

class CornerRotateNodesActivity extends NodeDragActivity
    with ExclusiveCursorDragActivity, KeyboardListenerDragActivity {
  CornerRotateNodesActivity({required super.root, required super.nodes, required this.corner});

  final Corner corner;

  @override
  MouseCursor get cursor => _resolveRotatingCursor(Cursors.rotate, renderNodes, corner: corner);

  @override
  Set<LogicalKeyboardKey> get keysToListen => {.shiftLeft, .shiftRight};

  late final Offset groupPivot;
  late final double initialPointerAngle;
  late final List<Matrix4> initialGlobalTransforms;
  late final List<Matrix4> initialGlobalToParents;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    final globalRects = renderNodes
        .map((rn) => MatrixUtils.transformRect(rn.getTransformTo(null), Offset.zero & rn.size))
        .toList();

    groupPivot = globalRects.boundingBox.center;

    initialGlobalTransforms = renderNodes.map((rn) => rn.getTransformTo(null)).toList();
    initialGlobalToParents = renderNodes.map((rn) => Matrix4.inverted(rn.parentNode!.getTransformTo(null))).toList();

    final startDelta = startDetails.globalPosition - groupPivot;
    initialPointerAngle = math.atan2(startDelta.dy, startDelta.dx);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final currentDelta = details.globalPosition - groupPivot;
    final currentPointerAngle = math.atan2(currentDelta.dy, currentDelta.dx);

    var angleDiff = currentPointerAngle - initialPointerAngle;

    if (isShiftPressed) {
      final rotationSnapAngle = rotationSnapStepDegrees * degrees2Radians;
      angleDiff = (angleDiff / rotationSnapAngle).round() * rotationSnapAngle;
    }

    final groupRotate = Matrix4.identity()
      ..translateByDouble(groupPivot.dx, groupPivot.dy, 0.0, 1.0)
      ..rotateZ(angleDiff)
      ..translateByDouble(-groupPivot.dx, -groupPivot.dy, 0.0, 1.0);

    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final Matrix4 globalTransform = groupRotate * initialGlobalTransforms[i];
      final Matrix4 localTransform = initialGlobalToParents[i] * globalTransform;
      node.transform = node.transform.copyWith(value: localTransform);
    }

    super.onUpdate(details);
  }
}
