import 'dart:math' as math;

import 'package:editor/imports.dart';
import 'package:editor/imports.dart' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

class RotateNodesActivity extends NodeGroupActivity with ExclusiveCursorDragActivity, KeyboardListenerDragActivity {
  RotateNodesActivity(super.editor, {required super.nodes, required this.corner});

  final ui.Corner corner;

  @override
  Set<LogicalKeyboardKey> get keysToListen => {.shiftLeft, .shiftRight};

  @override
  MouseCursor get cursor => Cursors.rotate;

  late final Vector2 groupPivot;
  late final double initialAngle;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    groupPivot = groupBbox.center;

    final startPosition = editor.globalToScene(startDetails.globalPosition.vec2);
    final startDelta = startPosition - groupPivot;
    initialAngle = math.atan2(startDelta.y, startDelta.x);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final currentPosition = editor.globalToScene(details.globalPosition.vec2);
    final currentDelta = currentPosition - groupPivot;
    final currentAngle = math.atan2(currentDelta.y, currentDelta.x);

    var angleDiff = currentAngle - initialAngle;

    final sceneTransform = Matrix4.identity()
      ..translateByDouble(groupPivot.x, groupPivot.y, 0.0, 1.0)
      ..rotateZ(angleDiff)
      ..translateByDouble(-groupPivot.x, -groupPivot.y, 0.0, 1.0);

    applyTransformToNodes(sceneTransform);
    super.onUpdate(details);
  }
}
