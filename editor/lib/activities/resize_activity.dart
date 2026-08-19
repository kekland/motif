import 'package:editor/imports.dart';

class ResizeActivity {
  static DragActivity side(Editor editor, Iterable<Ref> refs, {required Side side}) {
    return _SideResizeActivity(editor, refs, side);
  }

  static DragActivity corner(Editor editor, Iterable<Ref> refs, {required Corner corner}) {
    return _CornerResizeActivity(editor, refs, corner);
  }
}

abstract class _BaseResizeActivity extends TransformActivity {
  _BaseResizeActivity(super.editor, super.cells);

  Aabb2 applyResize(Aabb2 initial, Vec2 delta, bool symmetric, bool keepAspectRatio);

  @override
  void onUpdate(DragUpdateDetails details) {
    final worldDelta = editor.globalToScene(details.globalPosition) - editor.globalToScene(startDetails.globalPosition);
    final delta = worldToSpace.transformDelta2(worldDelta);

    final target = applyResize(initialHull, delta, isAltPressed, isShiftPressed);
    final transform = _bboxTransform(initialHull, target);

    session.apply(spaceToWorld * transform * worldToSpace);
    super.onUpdate(details);
  }

  Mat4 _bboxTransform(Aabb2 from, Aabb2 to) {
    final sx = from.width == 0 ? 1.0 : to.width / from.width;
    final sy = from.height == 0 ? 1.0 : to.height / from.height;
    return Mat4.identity()
      ..translate(to.min.x, to.min.y)
      ..scale(sx, sy)
      ..translate(-from.min.x, -from.min.y);
  }

  @override
  MouseCursor resolveCursor(RotatingMouseCursor cursor, {Side? side, Corner? corner, Mat4? transform}) {
    return super.resolveCursor(cursor, side: side, corner: corner, transform: spaceToWorld);
  }
}

final class _SideResizeActivity extends _BaseResizeActivity {
  _SideResizeActivity(
    super.editor,
    super.cells,
    this.side,
  );

  final Side side;

  @override
  MouseCursor get cursor => resolveCursor(Cursors.resize, side: side);

  @override
  Aabb2 applyResize(Aabb2 initial, Vec2 delta, bool symmetric, bool keepAspectRatio) {
    return side.applyResize(initial, delta, symmetric: symmetric, keepAspectRatio: keepAspectRatio);
  }
}

final class _CornerResizeActivity extends _BaseResizeActivity {
  _CornerResizeActivity(
    super.editor,
    super.cells,
    this.corner,
  );

  final Corner corner;

  @override
  MouseCursor get cursor => resolveCursor(Cursors.resize, corner: corner);

  @override
  Aabb2 applyResize(Aabb2 initial, Vec2 delta, bool symmetric, bool keepAspectRatio) {
    return corner.applyResize(initial, delta, symmetric: symmetric, keepAspectRatio: keepAspectRatio);
  }
}
