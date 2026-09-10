import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

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

  late final Aabb2 selectionHull;

  ResizeResult applyResize(Aabb2 initial, Vec2 delta, bool symmetric, bool keepAspectRatio);

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    selectionHull = scene.bundle.query.hull(refs, space: .root);
    selectionHull.transform(worldToSpace);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final worldDelta = editor.globalToScene(details.globalPosition) - editor.globalToScene(startDetails.globalPosition);
    final delta = worldToSpace.transformDelta2(worldDelta);

    final (:anchor, :scale) = applyResize(initialHull, delta, isAltPressed, isShiftPressed);
    final transform = Mat4.identity()
      ..translate(anchor.x, anchor.y)
      ..scale(scale.x, scale.y)
      ..translate(-anchor.x, -anchor.y);

    session.apply(spaceToWorld * transform * worldToSpace);
    super.onUpdate(details);
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
  late final Side effectiveSide;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    effectiveSide = _effectiveSide(side, selectionHull, session.initialHull);
  }

  @override
  MouseCursor get cursor => resolveCursor(Cursors.resize, side: side);

  @override
  ResizeResult applyResize(Aabb2 initial, Vec2 delta, bool symmetric, bool keepAspectRatio) {
    return effectiveSide.applyResize(initial, delta, symmetric: symmetric, keepAspectRatio: keepAspectRatio);
  }
}

final class _CornerResizeActivity extends _BaseResizeActivity {
  _CornerResizeActivity(
    super.editor,
    super.cells,
    this.corner,
  );

  final Corner corner;
  late final Corner effectiveCorner;

  @override
  MouseCursor get cursor => resolveCursor(Cursors.resize, corner: corner);

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    effectiveCorner = _effectiveCorner(corner, selectionHull, session.initialHull);
  }

  @override
  ResizeResult applyResize(Aabb2 initial, Vec2 delta, bool symmetric, bool keepAspectRatio) {
    return effectiveCorner.applyResize(initial, delta, symmetric: symmetric, keepAspectRatio: keepAspectRatio);
  }
}

Side _effectiveSide(Side hit, Aabb2 own, Aabb2 hull) {
  if (hit.isVertical) {
    if (own.width >= hull.width) return hit;
    final fromLeft = (own.left - hull.left).abs(), fromRight = (hull.right - own.right).abs();
    return fromLeft <= fromRight ? .left : .right;
  } else {
    if (own.height >= hull.height) return hit;
    final fromTop = (own.top - hull.top).abs(), fromBottom = (hull.bottom - own.bottom).abs();
    return fromTop <= fromBottom ? .top : .bottom;
  }
}

Corner _effectiveCorner(Corner hit, Aabb2 own, Aabb2 hull) {
  final horizontal = _effectiveSide(hit.isLeft ? Side.left : Side.right, own, hull);
  final vertical = _effectiveSide(hit.isTop ? Side.top : Side.bottom, own, hull);
  return Corner.of(vertical, horizontal);
}
