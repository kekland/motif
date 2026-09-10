import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:ui/ui.dart';

import 'activities.dart';
import 'window_proxy_navigator.dart';

/// A widget that hosts the Overlay for windows.
class WindowNavigator extends StatefulWidget {
  const WindowNavigator({super.key, required this.child});

  static WindowNavigatorState of(BuildContext context) => maybeOf(context)!;
  static WindowNavigatorState? maybeOf(BuildContext context) => context.findAncestorStateOfType<WindowNavigatorState>();

  static Future<T?> push<T>(BuildContext context, WindowEntry<T> entry) {
    final navigator = of(context);
    return navigator.push(context, entry);
  }

  static Future<T?>? pushUnique<T>(BuildContext context, WindowEntry<T> entry) {
    final navigator = of(context);
    return navigator.pushUnique(context, entry);
  }

  final Widget child;

  @override
  State<WindowNavigator> createState() => WindowNavigatorState();
}

class WindowNavigatorState extends State<WindowNavigator> {
  final _overlayKey = GlobalKey<OverlayState>();
  OverlayState get overlay => _overlayKey.currentState!;

  final _entries = <BuildContext, List<WindowEntry>>{};

  Future<T?> push<T>(BuildContext context, WindowEntry<T> entry) {
    _entries[context] ??= [];
    _entries[context]!.add(entry);

    entry.addRemovedListener(() => _onEntryRemoved(entry));
    return entry.push(context);
  }

  void _onEntryRemoved(WindowEntry entry) {
    for (final entries in _entries.values) {
      entries.remove(entry);
    }
  }

  Future<T?>? pushUnique<T>(BuildContext context, WindowEntry<T> entry) {
    final entries = _entries[context];

    if (entries != null) {
      for (final e in entries) {
        if (e.runtimeType == entry.runtimeType) {
          return null;
        }
      }
    }

    return push(context, entry);
  }

  @override
  void dispose() {
    for (final entries in _entries.values) {
      for (final entry in entries) entry.remove();
    }

    _entries.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      key: _overlayKey,
      initialEntries: [
        OverlayEntry(builder: (context) => widget.child, canSizeOverlay: true),
      ],
    );
  }
}

class WindowEntry<T> extends OverlayEntry {
  WindowEntry({
    required super.builder,
    this.anchor,
    this.isModal = false,
    this.animationStyle = .noAnimation,
    this.transitionBuilder = _defaultWindowTransitionBuilder,
  });

  static WindowAnchor createAnchorForContext(
    BuildContext context, {
    EdgeInsets padding = .zero,
  }) {
    final overlay = context.findAncestorStateOfType<WindowNavigatorState>()!;
    final overlayBox = overlay.context.findRenderObject() as RenderBox;
    final renderBox = context.findRenderObject() as RenderBox;
    final rect = MatrixUtils.transformRect(renderBox.getTransformTo(overlayBox), (Offset.zero & renderBox.size));
    return .new(rect: padding.inflateRect(rect));
  }

  factory WindowEntry.withContextAnchor(
    BuildContext context, {
    required WidgetBuilder builder,
    AnimationStyle animationStyle = AnimationStyle.noAnimation,
    WindowTransitionBuilder transitionBuilder = _defaultWindowTransitionBuilder,
  }) => WindowEntry(
    builder: builder,
    anchor: createAnchorForContext(context),
    animationStyle: animationStyle,
    transitionBuilder: transitionBuilder,
  );

  final AnimationStyle animationStyle;
  final WindowAnchor? anchor;
  final bool isModal;
  final WindowTransitionBuilder transitionBuilder;

  var _isActive = false;
  bool get isActive => _isActive;
  bool get isRemoved => !_isActive;

  final _removedNotifier = ChangeNotifier();

  void addRemovedListener(VoidCallback listener) => _removedNotifier.addListener(listener);
  void removeRemovedListener(VoidCallback listener) => _removedNotifier.removeListener(listener);

  Completer<T?>? _completer;

  @override
  WidgetBuilder get builder {
    return (context) => WindowWidget<T>(
      entry: this,
      builder: super.builder,
      transitionBuilder: transitionBuilder,
    );
  }

  Future<T?> push(BuildContext context) {
    insert(context);
    return _completer!.future;
  }

  void insert(BuildContext context) {
    if (_isActive) return;
    final root = context.findAncestorStateOfType<WindowNavigatorState>()!;
    root.overlay.insert(this);
    _isActive = true;
    _completer = Completer<T?>();
  }

  void _resolve(T? result) {
    _completer!.complete(result);
  }

  @override
  void remove() {
    if (!_isActive) return;
    super.remove();

    if (!_completer!.isCompleted) {
      _completer!.complete(null);
    }

    _isActive = false;

    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    _removedNotifier.notifyListeners();
  }

  @override
  void dispose() {
    if (_isActive) remove();
    _removedNotifier.dispose();
    super.dispose();
  }
}

typedef WindowTransitionBuilder = Widget Function(BuildContext context, Animation<double> animation, Widget child);

Widget _defaultWindowTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Widget child,
) {
  return FadeTransition(opacity: animation, child: child);
}

class WindowWidget<T> extends StatefulWidget {
  const WindowWidget({
    super.key,
    required this.entry,
    required this.builder,
    this.transitionBuilder = _defaultWindowTransitionBuilder,
  });

  final WindowEntry<T> entry;
  final WidgetBuilder builder;
  final WindowTransitionBuilder transitionBuilder;

  @override
  State<WindowWidget<T>> createState() => WindowWidgetState<T>();
}

class WindowWidgetState<T> extends State<WindowWidget<T>> with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: animationStyle.duration,
  );
  late final _animation = CurvedAnimation(
    parent: _animationController,
    curve: animationStyle.curve ?? Curves.linear,
    reverseCurve: animationStyle.reverseCurve,
  );

  WindowEntry get entry => widget.entry;

  AnimationStyle get animationStyle => widget.entry.animationStyle;
  bool get isModal => widget.entry.isModal;
  WindowAnchor? get anchor => widget.entry.anchor;

  Rect? _rect;
  Rect? get rect => _rect;

  @override
  void initState() {
    super.initState();

    if (animationStyle.duration != .zero) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }

    _animationController.addStatusListener((status) {
      if (status == .dismissed) widget.entry.remove();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.builder(context);
    child = widget.transitionBuilder(context, _animation, child);

    // Navigator.of(context).pop();

    return Listener(
      behavior: .translucent,
      onPointerDown: (d) {
        if (!widget.entry.isModal) return;

        final position = d.localPosition;
        if (!_rect!.contains(position)) {
          widget.entry.remove();
        }
      },
      child: _WindowPositioned(
        rect: rect,
        edgePadding: const EdgeInsets.only(top: 64.0, left: 16.0, right: 16.0, bottom: 16.0),
        onInitialRectComputed: (r) => _rect = r,
        anchor: widget.entry.anchor,
        // windowConstraints: BoxConstraints.loose(Size.square(400.0)),
        child: Stack(
          clipBehavior: .none,
          children: [
            WindowProxyNavigator<T>(
              onPop: (result) {
                widget.entry._resolve(result);
                _animationController.reverse();
              },
              child: Material(
                type: .transparency,
                child: child,
              ),
            ),

            // TODO: allow configurable draggable area.
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              height: 48.0,
              child: DragActivityDetector(
                behavior: HitTestBehavior.translucent,
                activityFactory: (_) => WindowMoveActivity(
                  initialRect: rect!,
                  onChanged: (r) => setState(() => _rect = r),
                ),
                child: SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WindowAnchor {
  const WindowAnchor({required this.rect, this.alignment});

  final Rect rect;
  final Alignment? alignment;
}

class _WindowPositioned extends SingleChildRenderObjectWidget {
  const _WindowPositioned({
    super.key,
    required Widget super.child,
    this.rect,
    this.anchor,
    this.onInitialRectComputed,
    this.windowConstraints,
    this.edgePadding = .zero,
  });

  final Rect? rect;
  final WindowAnchor? anchor;
  final ValueChanged<Rect>? onInitialRectComputed;
  final BoxConstraints? windowConstraints;
  final EdgeInsets edgePadding;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderWindowPositioned(
      rect: rect,
      anchor: anchor,
      onInitialRectComputed: onInitialRectComputed,
      windowConstraints: windowConstraints,
      edgePadding: edgePadding,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderWindowPositioned renderObject,
  ) {
    renderObject
      ..rect = rect
      ..windowConstraints = windowConstraints
      ..edgePadding = edgePadding;
  }
}

class _RenderWindowPositioned extends RenderProxyBox {
  _RenderWindowPositioned({
    this._windowConstraints,
    this._rect,
    this._anchor,
    this._onInitialRectComputed,
    this._edgePadding = .zero,
  });

  BoxConstraints? _windowConstraints;
  BoxConstraints? get windowConstraints => _windowConstraints;
  set windowConstraints(BoxConstraints? value) {
    if (value == _windowConstraints) return;
    _windowConstraints = value;
    markNeedsLayout();
  }

  Rect? _rect;
  Rect? get rect => _rect;
  set rect(Rect? value) {
    if (value == _rect) return;
    _rect = value;
    markNeedsLayout();
  }

  EdgeInsets _edgePadding;
  EdgeInsets get edgePadding => _edgePadding;
  set edgePadding(EdgeInsets value) {
    if (value == _edgePadding) return;
    _edgePadding = value;
    markNeedsLayout();
  }

  final WindowAnchor? _anchor;
  final ValueChanged<Rect>? _onInitialRectComputed;

  static Rect _fitRect(Rect r, Rect container) {
    double _d(double start, double end, double min, double max) {
      if (start < min) return min - start;
      if (end > max) return max - end;
      return 0.0;
    }

    return r.shift(
      .new(
        _d(r.left, r.right, container.left, container.right),
        _d(r.top, r.bottom, container.top, container.bottom),
      ),
    );
  }

  void _recomputeRect() {
    child!.layout(windowConstraints ?? constraints.loosen(), parentUsesSize: true);

    final childSize = child!.size;
    final container = _edgePadding.deflateRect(Offset.zero & constraints.biggest);

    final Offset topLeft;
    final anchor = _anchor;

    if (anchor == null) {
      topLeft = container.center - childSize.center(.zero);
    } else if (anchor.alignment != null) {
      final a = anchor.alignment!;
      topLeft = a.withinRect(anchor.rect) - (-a).alongSize(childSize);
    } else {
      final below = anchor.rect.bottom + 8.0;
      final above = anchor.rect.top - 8.0 - childSize.height;
      final fitsBelow = below + childSize.height <= container.bottom;
      final fitsAbove = above >= container.top;
      topLeft = Offset(
        anchor.rect.center.dx - childSize.width / 2.0,
        !fitsBelow && fitsAbove ? above : below,
      );
    }

    _rect = _fitRect(topLeft & childSize, container);
    _onInitialRectComputed?.call(_rect!);
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    // If no rect is passed - try to compute an initial rect.
    if (rect == null) {
      _recomputeRect();
      return;
    }

    final rectConstraints = BoxConstraints.tight(rect!.size);
    child!.layout(rectConstraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final childOffset = offset + rect!.topLeft;
    context.paintChild(child!, childOffset);
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    transform.translateByDouble(rect!.left, rect!.top, 0.0, 1.0);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return result.addWithPaintOffset(
      offset: rect!.topLeft,
      position: position,
      hitTest: (result, position) => child!.hitTest(result, position: position),
    );
  }
}
