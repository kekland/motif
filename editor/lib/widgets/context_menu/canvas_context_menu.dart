import 'package:editor/imports.dart';

class CanvasContextMenu extends HookWidget {
  const new({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) async {
        final hitTest = context.editor.hitTest(details.globalPosition);
        if (hitTest.top != null) context.editor.selection.set(hitTest.top!.ref);

        final actions = <CommandAction>[
          CopySelectionAction(),
          PasteAction(),
          SetZOrderTopAction(),
          SetZOrderBottomAction(),
        ];

        final items = actions
            .map(
              (a) => ContextMenuItem(
                a,
                label: a.descriptor.command,
                shortcut: a.descriptor.resolveShortcut(context).firstOrNull,
              ),
            )
            .toList();

        final action = await ContextMenu.push<CommandAction?>(
          context,
          ContextMenu(items),
          details: details,
        );

        if (action != null && context.mounted) {
          final intent = action.descriptor.build(context, []);
          context.invoke(intent);
        }
      },
      child: child,
    );
  }
}
