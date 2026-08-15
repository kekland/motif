part of '../slate.dart';

typedef GestureCallbackBundleDef = ({
  GestureTapDownCallback? onTapDown,
  GestureTapUpCallback? onTapUp,
  VoidCallback? onTapCancel,
  VoidCallback? onTap,
  GestureDragStartCallback? onHorizontalDragStart,
  GestureDragUpdateCallback? onHorizontalDragUpdate,
  GestureDragEndCallback? onHorizontalDragEnd,
  GestureDragCancelCallback? onHorizontalDragCancel,
  GestureDragDownCallback? onHorizontalDragDown,
  GestureDragStartCallback? onVerticalDragStart,
  GestureDragUpdateCallback? onVerticalDragUpdate,
  GestureDragEndCallback? onVerticalDragEnd,
  GestureDragCancelCallback? onVerticalDragCancel,
  GestureDragDownCallback? onVerticalDragDown,
  GestureDragStartCallback? onPanStart,
  GestureDragUpdateCallback? onPanUpdate,
  GestureDragEndCallback? onPanEnd,
  GestureDragCancelCallback? onPanCancel,
  GestureDragDownCallback? onPanDown,
});

extension type const GestureCallbackBundle._(GestureCallbackBundleDef callbacks) {
  const GestureCallbackBundle.from({
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    VoidCallback? onTapCancel,
    VoidCallback? onTap,
    GestureDragStartCallback? onHorizontalDragStart,
    GestureDragUpdateCallback? onHorizontalDragUpdate,
    GestureDragEndCallback? onHorizontalDragEnd,
    GestureDragCancelCallback? onHorizontalDragCancel,
    GestureDragDownCallback? onHorizontalDragDown,
    GestureDragStartCallback? onVerticalDragStart,
    GestureDragUpdateCallback? onVerticalDragUpdate,
    GestureDragEndCallback? onVerticalDragEnd,
    GestureDragCancelCallback? onVerticalDragCancel,
    GestureDragDownCallback? onVerticalDragDown,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragEndCallback? onPanEnd,
    GestureDragCancelCallback? onPanCancel,
    GestureDragDownCallback? onPanDown,
  }) : this._((
         onTapDown: onTapDown,
         onTapUp: onTapUp,
         onTapCancel: onTapCancel,
         onTap: onTap,
         onHorizontalDragStart: onHorizontalDragStart,
         onHorizontalDragUpdate: onHorizontalDragUpdate,
         onHorizontalDragEnd: onHorizontalDragEnd,
         onHorizontalDragCancel: onHorizontalDragCancel,
         onHorizontalDragDown: onHorizontalDragDown,
         onVerticalDragStart: onVerticalDragStart,
         onVerticalDragUpdate: onVerticalDragUpdate,
         onVerticalDragEnd: onVerticalDragEnd,
         onVerticalDragCancel: onVerticalDragCancel,
         onVerticalDragDown: onVerticalDragDown,
         onPanStart: onPanStart,
         onPanUpdate: onPanUpdate,
         onPanEnd: onPanEnd,
         onPanCancel: onPanCancel,
         onPanDown: onPanDown,
       ));

  GestureTapDownCallback? get onTapDown => callbacks.onTapDown;
  GestureTapUpCallback? get onTapUp => callbacks.onTapUp;
  VoidCallback? get onTapCancel => callbacks.onTapCancel;
  VoidCallback? get onTap => callbacks.onTap;

  GestureDragStartCallback? get onHorizontalDragStart => callbacks.onHorizontalDragStart;
  GestureDragUpdateCallback? get onHorizontalDragUpdate => callbacks.onHorizontalDragUpdate;
  GestureDragEndCallback? get onHorizontalDragEnd => callbacks.onHorizontalDragEnd;
  GestureDragCancelCallback? get onHorizontalDragCancel => callbacks.onHorizontalDragCancel;
  GestureDragDownCallback? get onHorizontalDragDown => callbacks.onHorizontalDragDown;

  GestureDragStartCallback? get onVerticalDragStart => callbacks.onVerticalDragStart;
  GestureDragUpdateCallback? get onVerticalDragUpdate => callbacks.onVerticalDragUpdate;
  GestureDragEndCallback? get onVerticalDragEnd => callbacks.onVerticalDragEnd;
  GestureDragCancelCallback? get onVerticalDragCancel => callbacks.onVerticalDragCancel;
  GestureDragDownCallback? get onVerticalDragDown => callbacks.onVerticalDragDown;

  GestureDragStartCallback? get onPanStart => callbacks.onPanStart;
  GestureDragUpdateCallback? get onPanUpdate => callbacks.onPanUpdate;
  GestureDragEndCallback? get onPanEnd => callbacks.onPanEnd;
  GestureDragCancelCallback? get onPanCancel => callbacks.onPanCancel;
  GestureDragDownCallback? get onPanDown => callbacks.onPanDown;
}

mixin GestureCallbackBundleMixin {
  GestureTapDownCallback? get onTapDown;
  GestureTapUpCallback? get onTapUp;
  VoidCallback? get onTap;
  VoidCallback? get onTapCancel;

  GestureDragDownCallback? get onHorizontalDragDown;
  GestureDragStartCallback? get onHorizontalDragStart;
  GestureDragUpdateCallback? get onHorizontalDragUpdate;
  GestureDragEndCallback? get onHorizontalDragEnd;
  GestureDragCancelCallback? get onHorizontalDragCancel;

  GestureDragDownCallback? get onVerticalDragDown;
  GestureDragStartCallback? get onVerticalDragStart;
  GestureDragUpdateCallback? get onVerticalDragUpdate;
  GestureDragEndCallback? get onVerticalDragEnd;
  GestureDragCancelCallback? get onVerticalDragCancel;

  GestureDragDownCallback? get onPanDown;
  GestureDragStartCallback? get onPanStart;
  GestureDragUpdateCallback? get onPanUpdate;
  GestureDragEndCallback? get onPanEnd;
  GestureDragCancelCallback? get onPanCancel;

  GestureCallbackBundle get gestureCallbacks => .from(
    onTapDown: onTapDown,
    onTapUp: onTapUp,
    onTapCancel: onTapCancel,
    onTap: onTap,
    onHorizontalDragStart: onHorizontalDragStart,
    onHorizontalDragUpdate: onHorizontalDragUpdate,
    onHorizontalDragEnd: onHorizontalDragEnd,
    onHorizontalDragCancel: onHorizontalDragCancel,
    onHorizontalDragDown: onHorizontalDragDown,
    onVerticalDragStart: onVerticalDragStart,
    onVerticalDragUpdate: onVerticalDragUpdate,
    onVerticalDragEnd: onVerticalDragEnd,
    onVerticalDragCancel: onVerticalDragCancel,
    onVerticalDragDown: onVerticalDragDown,
    onPanStart: onPanStart,
    onPanUpdate: onPanUpdate,
    onPanEnd: onPanEnd,
    onPanCancel: onPanCancel,
    onPanDown: onPanDown,
  );
}

/* Template: class body

  // dart format off
  @override final GestureTapDownCallback? onTapDown;
  @override final GestureTapUpCallback? onTapUp;
  @override final VoidCallback? onTapCancel;
  @override final VoidCallback? onTap;
  
  @override final GestureDragDownCallback? onHorizontalDragDown;
  @override final GestureDragStartCallback? onHorizontalDragStart;
  @override final GestureDragUpdateCallback? onHorizontalDragUpdate;
  @override final GestureDragEndCallback? onHorizontalDragEnd;
  @override final GestureDragCancelCallback? onHorizontalDragCancel;
  
  @override final GestureDragDownCallback? onVerticalDragDown;
  @override final GestureDragStartCallback? onVerticalDragStart;
  @override final GestureDragUpdateCallback? onVerticalDragUpdate;
  @override final GestureDragEndCallback? onVerticalDragEnd;
  @override final GestureDragCancelCallback? onVerticalDragCancel;
  
  @override final GestureDragDownCallback? onPanDown;
  @override final GestureDragStartCallback? onPanStart;
  @override final GestureDragUpdateCallback? onPanUpdate;
  @override final GestureDragEndCallback? onPanEnd;
  @override final GestureDragCancelCallback? onPanCancel;
  // dart format on

*/

/* Template: class constructor
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onTap,
    this.onHorizontalDragDown,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onHorizontalDragCancel,
    this.onVerticalDragDown,
    this.onVerticalDragStart,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.onVerticalDragCancel,
    this.onPanDown,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
*/