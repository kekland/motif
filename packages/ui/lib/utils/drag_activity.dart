import 'package:flutter/gestures.dart';
import 'package:stack_mouse_cursor/stack_mouse_cursor.dart';
import 'package:ui/ui.dart';

mixin ExclusiveCursorDragActivity on DragActivity {
  MouseCursor get cursor;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    ExclusiveMouseCursor.instance.set(cursor);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    ExclusiveMouseCursor.instance.set(cursor);
    super.onUpdate(details);
  }

  @override
  void onEnd(DragEndDetails? details) {
    ExclusiveMouseCursor.instance.release();
    super.onEnd(details);
  }
}
