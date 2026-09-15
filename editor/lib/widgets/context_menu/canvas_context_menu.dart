import 'package:editor/imports.dart';

class CanvasContextMenu extends HookWidget {
  const new({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ContextMenuDetector(
      onShow: (context, details) {
        final hitTest = context.editor.hitTest(details.globalPosition);
        if (hitTest.top != null) context.editor.selection.set(hitTest.top!.ref);

        return [
          CopySelectionAction(),
          PasteAction(),
          SetZOrderTopAction(),
          SetZOrderBottomAction(),
        ];
      },
      child: child,
    );
  }
}
