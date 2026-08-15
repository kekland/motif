part of '../slate.dart';

typedef GestureRegionDetectorBuilder =
    Widget Function(
      BuildContext context,
      HitTestBehavior behavior,
      Set<PointerDeviceKind>? supportedDevices,
      GestureCallbackBundle callbacks,
      Widget child,
    );

class GestureRegion extends StatefulWidget with GestureCallbackBundleMixin {
  const GestureRegion({
    super.key,
    this.detectorBuilder = defaultGestureRegionDetectorBuilder,
    this.builder,
    this.behavior = HitTestBehavior.opaque,
    this.cursor = SystemMouseCursors.click,
    this.supportedDevices,
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

  GestureRegion.fromSurface({
    Key? key,
    required GestureSurface surface,
    GestureRegionDetectorBuilder detectorBuilder = defaultGestureRegionDetectorBuilder,
    Widget Function(BuildContext context, Set<WidgetState> states)? builder,
  }) : this(
         key: key,
         behavior: surface.behavior,
         cursor: surface.cursor,
         supportedDevices: surface.supportedDevices,
         onTapDown: surface.onTapDown,
         onTapUp: surface.onTapUp,
         onTapCancel: surface.onTapCancel,
         onTap: surface.onTap,
         onHorizontalDragDown: surface.onHorizontalDragDown,
         onHorizontalDragStart: surface.onHorizontalDragStart,
         onHorizontalDragUpdate: surface.onHorizontalDragUpdate,
         onHorizontalDragEnd: surface.onHorizontalDragEnd,
         onHorizontalDragCancel: surface.onHorizontalDragCancel,
         onVerticalDragDown: surface.onVerticalDragDown,
         onVerticalDragStart: surface.onVerticalDragStart,
         onVerticalDragUpdate: surface.onVerticalDragUpdate,
         onVerticalDragEnd: surface.onVerticalDragEnd,
         onVerticalDragCancel: surface.onVerticalDragCancel,
         onPanDown: surface.onPanDown,
         onPanStart: surface.onPanStart,
         onPanUpdate: surface.onPanUpdate,
         onPanEnd: surface.onPanEnd,
         onPanCancel: surface.onPanCancel,
         detectorBuilder: detectorBuilder,
         builder: builder,
       );

  final HitTestBehavior behavior;
  final GestureRegionDetectorBuilder detectorBuilder;
  final Widget Function(BuildContext context, Set<WidgetState> states)? builder;
  final MouseCursor cursor;
  final Set<PointerDeviceKind>? supportedDevices;

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

  @override
  State<GestureRegion> createState() => _GestureRegionState();
}

class _GestureRegionState extends State<GestureRegion> {
  final _stopwatch = Stopwatch();
  late Set<WidgetState> _gestureDetectorState;
  late Set<WidgetState> _hoverState;
  late Duration _smallAnimationDuration;

  bool get _hasTapCallbacks => widget.gestureCallbacks.onTap != null;

  _GestureRegionState? _parent;
  var _hoveredChildCount = 0;
  bool _isDirectlyHovered = false;

  @override
  void initState() {
    super.initState();
    _gestureDetectorState = _hasTapCallbacks ? {} : {WidgetState.disabled};
    _hoverState = {};
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _smallAnimationDuration = const Duration(milliseconds: 100);
    _parent = context.findAncestorStateOfType<_GestureRegionState>();

    final newParent = context.findAncestorStateOfType<_GestureRegionState>();
    if (_parent != newParent) {
      if (_isDirectlyHovered) {
        _parent?._onChildHoverChanged(false);
        newParent?._onChildHoverChanged(true);
      }
      _parent = newParent;
    }
  }

  @override
  void didUpdateWidget(covariant GestureRegion oldWidget) {
    super.didUpdateWidget(oldWidget);
    _onOnTapChanged();
  }

  @override
  void dispose() {
    if (_isDirectlyHovered) _parent?._onChildHoverChanged(false);

    _stopwatch.stop();
    _stopwatch.reset();
    super.dispose();
  }

  void _onOnTapChanged() {
    if (!_hasTapCallbacks) {
      _gestureDetectorState = {WidgetState.disabled};
    } else if (_gestureDetectorState.contains(WidgetState.disabled)) {
      _gestureDetectorState = {};
    }

    _updateHoverState();
  }

  void _onTapStart(BuildContext context) {
    if (!mounted) return;

    setState(() => _gestureDetectorState = {WidgetState.pressed});
    _stopwatch.start();
  }

  Future<void> _onTapEnd(BuildContext context) async {
    if (!mounted) return;

    _stopwatch.stop();

    final duration = _stopwatch.elapsed;
    final durationToWaitFor = _smallAnimationDuration - duration;

    _stopwatch.reset();

    if (!durationToWaitFor.isNegative) {
      await Future<void>.delayed(durationToWaitFor);
    }

    if (!mounted) return;
    setState(() => _gestureDetectorState = _hasTapCallbacks ? {} : {WidgetState.disabled});
  }

  void _updateHoverState() {
    final isHovered = _isDirectlyHovered && _hoveredChildCount == 0 && _hasTapCallbacks;

    if (_hoverState.contains(WidgetState.hovered) != isHovered) {
      setState(() => _hoverState = isHovered ? {WidgetState.hovered} : {});
    }
  }

  void _onChildHoverChanged(bool isHovered) {
    if (!mounted) return;
    if (isHovered) {
      _hoveredChildCount++;
    } else {
      _hoveredChildCount--;
    }
    _updateHoverState();
  }

  void _onMouseEnter(PointerEnterEvent e) {
    if (!mounted) return;
    if (e.down) return;

    _isDirectlyHovered = true;
    _parent?._onChildHoverChanged(true);
    _updateHoverState();
  }

  void _onMouseExit(_) {
    if (!mounted) return;
    if (!_isDirectlyHovered) return;

    _isDirectlyHovered = false;
    _parent?._onChildHoverChanged(false);
    _updateHoverState();
  }

  @override
  Widget build(BuildContext context) {
    final isInteractable = _hasTapCallbacks;

    final child = widget.builder?.call(context, {..._hoverState, ..._gestureDetectorState});

    return MouseRegion(
      hitTestBehavior: widget.behavior,
      onEnter: _onMouseEnter,
      onExit: _onMouseExit,
      cursor: widget.cursor,
      child: Listener(
        onPointerDown: isInteractable ? (_) => _onTapStart(context) : null,
        onPointerUp: isInteractable ? (_) => _onTapEnd(context) : null,
        child: widget.detectorBuilder(
          context,
          widget.behavior,
          widget.supportedDevices,
          widget.gestureCallbacks,
          child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
