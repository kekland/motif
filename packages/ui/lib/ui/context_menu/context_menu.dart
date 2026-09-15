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
    final portal = usePortalEntryManager();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onSecondaryTapDown: (details) {
        final actions = onShow(context, details);
        final position = details.localPosition;

        portal.push(
          context,
          .new(
            builder: (_) => ContextMenuOverlay(
              outerContext: context,
              actions: actions,
            ),
            isModal: true,
          ),
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

class ContextMenuOverlay extends HookWidget {
  const new({
    super.key,
    required this.outerContext,
    required this.actions,
  });

  final BuildContext outerContext;
  final List<CommandAction> actions;

  @override
  Widget build(BuildContext context) {
    void submit(CommandAction action) {
      final intent = action.descriptor.build(outerContext, []);
      outerContext.invoke(intent);
      Navigator.pop(context);
    }

    return ConstrainedBox(
      constraints: .new(maxHeight: 200.0),
      child: Surface(
        width: 160.0,
        color: context.colors.surface.secondary,
        borderSide: .new(color: context.colors.divider),
        borderRadius: .circular(4.0),
        shadows: context.shadows.window,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            final command = action.descriptor.command;
            final shortcut = action.descriptor.resolveShortcut(context).firstOrNull;

            return ListItem(
              height: 28.0,
              onTap: () => submit(action),
              title: Text(
                command,
                style: context.typography.body,
              ),
              trailing: shortcut != null ? SingleActivatorWidget(value: shortcut) : null,
            );
          },
        ),
      ),
    );
  }
}
