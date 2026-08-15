import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mouse_cursor/mouse_cursor.dart';

part 'drag_activity_mixins.dart';
part 'drag_activity_recognizer.dart';

abstract class DragActivity {
  DragActivity({this._onStart, this._onEnd});

  final VoidCallback? _onStart;
  final VoidCallback? _onEnd;

  late final PositionedGestureDetails startDetails;
  DragUpdateDetails? _lastUpdateDetails;
  DragUpdateDetails? get lastUpdateDetails => _lastUpdateDetails;

  PointerEvent? _pointerEvent;
  PointerEvent? get pointerEvent => _pointerEvent;

  Set<PointerDeviceKind>? get supportedDevices => null;
  Set<PointerDeviceKind>? get devicesToAcceptImmediately => null;
  bool shouldAcceptPanZoom(PointerPanZoomStartEvent event) => false;
  int get maxPointers => 1;
  bool shouldAccept(PointerDownEvent event) => true;

  @mustCallSuper
  void onStart(PositionedGestureDetails details) {
    startDetails = details;
    _onStart?.call();
  }

  @mustCallSuper
  void onUpdate(DragUpdateDetails details) {
    _lastUpdateDetails = details;
  }

  @mustCallSuper
  void onEnd(DragEndDetails? details) {
    _onEnd?.call();
  }

  void onCancel() {
    _onEnd?.call();
  }
}
