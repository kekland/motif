import 'package:ui/ui.dart';

class ContextMenuDetector extends HookWidget {
  const new({
    super.key,
    required this.onShow,
    required this.child,
  });

  final List<CommandAction> Function(BuildContext, TapDownDetails) onShow;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final portal = usePortalEntry(
      () => .new(
        builder: (context) => ContextMenuOverlay(),
        isModal: true,
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onSecondaryTapDown: (details) {
        final actions = onShow(context, details);
        final position = details.localPosition;
        portal.push(
          context,
          anchor: .compute(
            context,
            rect: position & .zero,
            alignment: .bottomRight,
            padding: const .all(8.0),
          ),
        );
      },
      child: child,
    );
  }
}

class ContextMenuOverlay extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Surface(
      width: 160.0,
      height: 200.0,
      color: context.colors.surface.secondary,
      borderSide: .new(color: context.colors.divider),
      borderRadius: .circular(4.0),
      shadows: context.shadows.window,
    );
  }
}
