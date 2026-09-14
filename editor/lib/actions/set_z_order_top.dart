part of '_intents.dart';

final class const SetZOrderTopIntent() extends CommandIntent;

final setZOrderTopIntentDescriptor = CommandIntentDescriptor<SetZOrderTopIntent>(
  command: 'bring-to-front',
  build: (context, args) => .new(),
  resolveDescription: (context) => 'Brings the selection to the front',
  resolveShortcut: (context) => [.new(.bracketRight)],
);

class SetZOrderTopAction extends CommandAction<SetZOrderTopIntent> {
  @override
  final descriptor = setZOrderTopIntentDescriptor;

  @override
  bool canInvoke(BuildContext context, SetZOrderTopIntent intent) {
    return context.editor.selection.isNotEmpty;
  }

  @override
  void performInvoke(BuildContext context, SetZOrderTopIntent intent) {
    final editor = context.editor;
    final selection = editor.selection;
    if (selection.isEmpty) return;

    editor.edit((txn) {
      for (final ref in selection.cells) {
        txn.reorder(ref, .top());
      }
    });
  }
}
