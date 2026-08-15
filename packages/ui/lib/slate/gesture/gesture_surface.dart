part of '../slate.dart';

typedef GestureSurfaceEffectBuilder = Widget Function(BuildContext context, GestureSurface surface);

class GestureSurface extends Surface with GestureCallbackBundleMixin {
  const GestureSurface({
    super.key,
    super.animationStyle,
    super.width,
    super.height,
    super.padding,
    super.color,
    super.foregroundColor,
    super.gradient,
    super.clipBehavior,
    super.borderRadius,
    super.shadows,
    super.borderSide,
    super.child,
    super.shape,
    this.behavior = HitTestBehavior.opaque,
    this.ignoreDisabled = false,
    this.effectBuilder,
    this.cursor = SystemMouseCursors.click,
    this.builder,
    this.supportedDevices,
    this.state = const {},
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
  });

  final Widget Function(BuildContext context, Set<WidgetState> states)? builder;
  final GestureSurfaceEffectBuilder? effectBuilder;
  final HitTestBehavior behavior;
  final bool ignoreDisabled;
  final Set<PointerDeviceKind>? supportedDevices;
  final Set<WidgetState> state;

  final MouseCursor cursor;

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

  Widget? resolveChild(BuildContext context, Set<WidgetState>? states) {
    return builder?.call(context, states ?? {}) ?? child;
  }

  Widget buildSurface(
    BuildContext context, {
    required Set<WidgetState>? state,
    required Widget? child,
    required EdgeInsets? padding,
    bool materialIsContainer = true,
  }) {
    return Surface(
      animationStyle: animationStyle,
      width: width,
      height: height,
      padding: padding,
      shape: shape,
      color: color,
      gradient: gradient,
      foregroundColor: foregroundColor,
      clipBehavior: clipBehavior,
      borderRadius: borderRadius,
      borderSide: borderSide,
      shadows: shadows,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final GestureSurfaceEffectBuilder effectBuilder;

    effectBuilder = gestureSurfaceTintEffect;

    return effectBuilder(context, this);
  }
}
