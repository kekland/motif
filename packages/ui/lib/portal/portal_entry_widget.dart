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

class PortalEntryWidgetState<T> extends State<PortalEntryWidget<T>> with SingleTickerProviderStateMixin {
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

  late final _focusScopeNode = FocusScopeNode();
  late final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (animationStyle.duration != .zero) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }

  Future<void> onPop() async {
    if (animationStyle.reverseDuration != .zero) {
      await _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animation.dispose();
    _focusScopeNode.dispose();
    _focusNode.dispose();
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

    return Material(
      type: .transparency,
      child: Stack(
        children: [
          if (entry.isModal) ...[
            Positioned.fill(
              child: Listener(
                behavior: .opaque,
                onPointerDown: (_) => entry.pop(),
              ),
            ),
          ],
          FocusScope(
            node: _focusScopeNode,
            autofocus: true,
            onKeyEvent: (_, event) {
              if (entry.isModal && event is KeyDownEvent && event.logicalKey == .escape) {
                entry.pop();
                return .handled;
              }

              return .ignored;
            },
            child: Focus(
              focusNode: _focusNode,
              autofocus: true,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _defaultAnchorBuilder(BuildContext context, PortalAnchor? anchor, Widget child) {
  return PortalPositioned(
    edgePadding: const EdgeInsets.all(16.0),
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
