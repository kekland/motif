import 'package:ui/ui.dart';

class WindowMoveActivity extends DragActivity {
  WindowMoveActivity({
    required this.initialRect,
    required this.onChanged,
  });

  final Rect initialRect;
  final ValueChanged<Rect> onChanged;

  @override
  void onUpdate(DragUpdateDetails details) {
    final delta = details.globalPosition - startDetails.globalPosition;
    final newRect = initialRect.shift(delta);
    onChanged(newRect);

    super.onUpdate(details);
  }
}

class WindowEdgeResizeActivity extends DragActivity {
  WindowEdgeResizeActivity({
    required this.initialRect,
    required this.onChanged,
    required this.side,
  });

  final Side side;
  final Rect initialRect;
  final ValueChanged<Rect> onChanged;

  @override
  void onUpdate(DragUpdateDetails details) {
    final delta = details.globalPosition - startDetails.globalPosition;
    final newAabb = side.applyResize(initialRect.aabb2, delta.vec2);
    onChanged(newAabb.rect);
    super.onUpdate(details);
  }
}

class WindowCornerResizeActivity extends DragActivity {
  WindowCornerResizeActivity({
    required this.initialRect,
    required this.onChanged,
    required this.corner,
  });

  final Corner corner;
  final Rect initialRect;
  final ValueChanged<Rect> onChanged;

  @override
  void onUpdate(DragUpdateDetails details) {
    final delta = details.globalPosition - startDetails.globalPosition;
    final newAabb = corner.applyResize(initialRect.aabb2, delta.vec2);
    onChanged(newAabb.rect);
    super.onUpdate(details);
  }
}
