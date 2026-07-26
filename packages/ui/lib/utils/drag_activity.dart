import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:stack_mouse_cursor/stack_mouse_cursor.dart';
import 'package:ui/ui.dart';

mixin ExclusiveCursorDragActivity on DragActivity {
  MouseCursor get cursor;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    _set(cursor);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    _set(cursor);
    super.onUpdate(details);
  }

  @override
  void onEnd(DragEndDetails? details) {
    ExclusiveMouseCursor.instance.release();
    super.onEnd(details);
  }

  MouseCursor? _cursorToSet;
  var _isScheduled = false;
  void _set(MouseCursor cursor) {
    _cursorToSet = cursor;

    if (_isScheduled) return;
    _isScheduled = true;

    SchedulerBinding.instance.scheduleFrameCallback(
      (_) {
        ExclusiveMouseCursor.instance.set(_cursorToSet!);
        _isScheduled = false;
      },
      scheduleNewFrame: false,
    );
  }
}
