import 'package:ui/ui.dart';

Future<T?> _pushDialog<T>(BuildContext context, WidgetBuilder builder) {
  final entry = PortalEntry<T>(
    animationStyle: context.animations.window,
    builder: builder,
    scrimBuilder: (context, animation) => AnimatedBuilder(
      animation: animation,
      builder: (context, _) => ColoredBox(
        color: context.colors.modalScrim.withScaledAlpha(animation.value),
      ),
    ),
    transitionBuilder: (context, animation, child) => FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 0.9,
          end: 1.0,
        ).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.33),
            end: .zero,
          ).animate(animation),
          child: child,
        ),
      ),
    ),
    anchorBuilder: (context, anchor, child) => Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 360.0),
          child: child,
        ),
      ),
    ),
    isModal: true,
  );

  return entry.push(context);
}

extension ContextDialog on BuildContext {
  Future<T?> pushDialog<T>(WidgetBuilder builder) {
    return _pushDialog<T>(this, builder);
  }
}

class DialogScaffold extends StatelessWidget {
  const new({super.key, required this.child, this.title});

  final Widget? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Surface(
      borderRadius: .circular(8.0),
      color: context.colors.surface.primary,
      borderSide: .new(color: context.colors.divider),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Header(
            padding: const EdgeInsets.only(left: 8.0, right: 2.0),
            trailing: IconButton.flat(
              onTap: () => Navigator.of(context).maybePop(),
              child: Icons.close(),
            ),
            title: title ?? const SizedBox.shrink(),
          ),
          Divider(),
          child,
        ],
      ),
    );
  }
}
