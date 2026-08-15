import 'dart:math' as math;

import 'package:editor/imports.dart';
import 'package:editor/imports.dart' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

final class RotateActivity extends TransformActivity {
  RotateActivity(super.editor, super.cells, {required this.corner});

  final ui.Corner corner;

  @override
  Set<LogicalKeyboardKey> get keysToListen => {.shiftLeft, .shiftRight};

  @override
  MouseCursor get cursor => resolveCursor(Cursors.rotate, corner: corner);

  late final Vec2 pivot;
  late final double initialAngle;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    pivot = spaceToWorld.transform2(initialHull.center);

    final start = editor.globalToScene(startDetails.globalPosition) - pivot;
    initialAngle = math.atan2(start.y, start.x);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final current = editor.globalToScene(details.globalPosition) - pivot;
    var angle = math.atan2(current.y, current.x) - initialAngle;

    if (isShiftPressed) {
      const step = math.pi / 12;
      angle = (angle / step).roundToDouble() * step;
    }

    session.rotateBy(angle, pivot: pivot);
    super.onUpdate(details);
  }
}
