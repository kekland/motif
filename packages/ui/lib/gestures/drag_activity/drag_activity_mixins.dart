part of './drag_activity.dart';

mixin KeyboardListenerDragActivity on DragActivity {
  Set<LogicalKeyboardKey> get keysToListen;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    HardwareKeyboard.instance.addHandler(_handler);
  }

  @override
  void onEnd(DragEndDetails? details) {
    HardwareKeyboard.instance.removeHandler(_handler);
    super.onEnd(details);
  }

  bool isKeyPressed(Set<LogicalKeyboardKey> keys) => keys.any((k) => HardwareKeyboard.instance.isLogicalKeyPressed(k));
  bool get isShiftPressed => HardwareKeyboard.instance.isShiftPressed;
  bool get isControlPressed => HardwareKeyboard.instance.isControlPressed;
  bool get isAltPressed => HardwareKeyboard.instance.isAltPressed;
  bool get isMetaPressed => HardwareKeyboard.instance.isMetaPressed;

  bool _handler(KeyEvent event) {
    if (lastUpdateDetails == null) return false;

    if (keysToListen.any((k) => event.logicalKey == k)) {
      onUpdate(lastUpdateDetails!);
      return true;
    }

    return false;
  }
}

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

  void updateCursor(MouseCursor cursor) => _set(cursor);

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
