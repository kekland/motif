part of 'portal.dart';

class PortalEntryWidget<T> extends StatefulWidget {
  const new({
    super.key,
    required this.entry,
    this.anchor,
  });

  final PortalEntry<T> entry;
  final PortalAnchor? anchor;

  @override
  State<PortalEntryWidget<T>> createState() => PortalEntryWidgetState<T>();
}

class PortalEntryWidgetState<T> extends State<PortalEntryWidget<T>> with TickerProviderStateMixin {
  PortalEntry<T> get entry => widget.entry;
  PortalAnchor? get anchor => widget.anchor;
  AnimationStyle get animationStyle => entry.animationStyle;

  late final _animationController = AnimationController(
    vsync: this,
    duration: animationStyle.duration,
    reverseDuration: animationStyle.reverseDuration,
  );

  late final _animation = CurvedAnimation(
    parent: _animationController,
    curve: animationStyle.curve ?? Curves.linear,
    reverseCurve: animationStyle.reverseCurve,
  );

  late final _scrimDimAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  late final _scrimDimAnimation = CurvedAnimation(
    parent: _scrimDimAnimationController,
    curve: Curves.easeInOut,
  );

  late final _focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();

    if (animationStyle.duration != .zero) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }

    _scrimDimAnimationController.value = 1.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_focusScopeNode.hasFocus) {
        _focusScopeNode.requestFocus();
      }
    });
  }

  Future<void> onPop() async {
    if (animationStyle.reverseDuration != .zero) {
      await _animationController.reverse();
    }
  }

  Timer? _showScrimTimer;
  var hidingScrim = false;

  Future<void> hideScrim() async {
    if (_scrimDimAnimationController.status != .forward) {
      _scrimDimAnimationController.animateTo(0.0);
    }

    _showScrimTimer?.cancel();
    _showScrimTimer = Timer(Duration(seconds: 2), () {
      if (!mounted) return;
      _scrimDimAnimationController.animateTo(1.0);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animation.dispose();
    _scrimDimAnimationController.dispose();
    _scrimDimAnimation.dispose();
    _focusScopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = entry.builder(context);

    final transitionBuilder = entry.transitionBuilder ?? _defaultTransitionBuilder;
    child = transitionBuilder(context, _animation, child);

    child = PortalProxyNavigator(
      onPop: (result) => entry.pop(result: result),
      child: child,
    );

    final anchorBuilder = entry.anchorBuilder ?? _defaultAnchorBuilder;
    child = anchorBuilder(context, anchor, child);

    final scrim = entry.scrimBuilder?.call(context, _animation) ?? const SizedBox.expand();

    return Material(
      type: .transparency,
      child: Stack(
        children: [
          Positioned.fill(
            child: FadeTransition(
              opacity: _scrimDimAnimation,
              child: scrim,
            ),
          ),
          if (entry.isModal) ...[
            Positioned.fill(
              child: Listener(
                behavior: .translucent,
                onPointerDown: (e) {
                  entry.pop(pointerId: e.pointer);
                },
              ),
            ),
          ],
          FocusScope(
            node: _focusScopeNode,
            autofocus: true,
            descendantsAreFocusable: true,
            onKeyEvent: (_, event) {
              if (entry.isModal && event is KeyDownEvent && event.logicalKey == .escape) {
                entry.pop();
                return .handled;
              }

              return .ignored;
            },
            child: child,
          ),
        ],
      ),
    );
  }
}

Widget _defaultAnchorBuilder(BuildContext context, PortalAnchor? anchor, Widget child) {
  return PortalPositioned(
    edgePadding: const EdgeInsets.all(8.0),
    anchor: anchor,
    child: child,
  );
}

Widget _defaultTransitionBuilder(BuildContext context, Animation<double> animation, Widget child) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}
