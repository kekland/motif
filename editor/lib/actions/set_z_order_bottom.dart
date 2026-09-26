part of '_intents.dart';

final class const SetZOrderBottomIntent() extends CommandIntent;

final setZOrderBottomIntentDescriptor = CommandIntentDescriptor<SetZOrderBottomIntent>(
  command: 'send-to-back',
  build: (context, args) => .new(),
  resolveDescription: (context) => 'Sends the selection to the back',
  resolveShortcut: (context) => [.new(.bracketLeft)],
);

class SetZOrderBottomAction extends CommandAction<SetZOrderBottomIntent> with CanvasFocusAction {
  @override
  final descriptor = setZOrderBottomIntentDescriptor;

  @override
  bool canInvoke(BuildContext context, SetZOrderBottomIntent intent) {
    return context.editor.selection.isNotEmpty;
  }

  @override
  void performInvoke(BuildContext context, SetZOrderBottomIntent intent) {
    final editor = context.editor;
    final selection = editor.selection;
    if (selection.isEmpty) return;

    editor.edit((txn) {
      for (final ref in selection.cells) {
        txn.reorder(ref, .bottom());
      }
    });
  }
}
