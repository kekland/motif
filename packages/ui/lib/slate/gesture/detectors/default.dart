part of '../../slate.dart';

Widget defaultGestureRegionDetectorBuilder(
  BuildContext context,
  HitTestBehavior behavior,
  Set<PointerDeviceKind>? supportedDevices,
  GestureCallbackBundle callbacks,
  Widget child,
) {
  return GestureDetector(
    behavior: behavior,
    supportedDevices: supportedDevices,
    onTap: callbacks.onTap,
    onTapDown: callbacks.onTapDown,
    onTapUp: callbacks.onTapUp,
    onTapCancel: callbacks.onTapCancel,
    onHorizontalDragStart: callbacks.onHorizontalDragStart,
    onHorizontalDragUpdate: callbacks.onHorizontalDragUpdate,
    onHorizontalDragEnd: callbacks.onHorizontalDragEnd,
    onHorizontalDragCancel: callbacks.onHorizontalDragCancel,
    onHorizontalDragDown: callbacks.onHorizontalDragDown,
    onVerticalDragStart: callbacks.onVerticalDragStart,
    onVerticalDragUpdate: callbacks.onVerticalDragUpdate,
    onVerticalDragEnd: callbacks.onVerticalDragEnd,
    onVerticalDragCancel: callbacks.onVerticalDragCancel,
    onVerticalDragDown: callbacks.onVerticalDragDown,
    onPanStart: callbacks.onPanStart,
    onPanUpdate: callbacks.onPanUpdate,
    onPanEnd: callbacks.onPanEnd,
    onPanCancel: callbacks.onPanCancel,
    onPanDown: callbacks.onPanDown,
    child: child,
  );
}
