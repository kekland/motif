import 'package:flutter/gestures.dart';
import 'package:stack_mouse_cursor/stack_mouse_cursor.dart';
import 'package:ui/ui.dart' hide DragActivity;
import 'package:stack_ui/src/utils/drag_activity.dart' as da1;
import 'package:stack_ui/src/utils/drag_activity/drag_activity.dart' as da2;

mixin ExclusiveCursorDragActivity on da1.DragActivity {
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

mixin ExclusiveCursorDragActivity2 on da2.DragActivity {
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
