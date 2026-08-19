import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

abstract class TransformActivity extends DragActivity with ExclusiveCursorDragActivity, KeyboardListenerDragActivity {
  TransformActivity(this.editor, this.refs, {super.onStart, super.onEnd});

  final Editor editor;
  Scene get scene => editor.scene;

  final Iterable<Ref> refs;

  @override
  Set<LogicalKeyboardKey> get keysToListen => {.shiftLeft, .shiftRight, .altLeft, .altRight};

  late final TransformSession session;
  Mat4 get worldToSpace => session.worldToSpace;
  Mat4 get spaceToWorld => session.spaceToWorld;
  Aabb2 get initialHull => session.initialHull;

  @override
  void onStart(PositionedGestureDetails details) {
    session = .of(editor.scene, refs);
    super.onStart(details);
  }

  MouseCursor resolveCursor(RotatingMouseCursor cursor, {Side? side, Corner? corner, Mat4? transform}) {
    final globalToScene = editor.renderScene.getTransformTo(null);
    final totalTransform = globalToScene;
    if (transform != null) totalTransform.multiply(transform.asVM());
    return cursor.resolveRaw(totalTransform, side: side, corner: corner);
  }
}
