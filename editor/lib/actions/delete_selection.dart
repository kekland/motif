part of '_intents.dart';

final class const DeleteSelectionIntent() extends CommandIntent;

final deleteSelectionIntentDescriptor = CommandIntentDescriptor<DeleteSelectionIntent>(
  command: 'delete-selection',
  build: (context, args) => .new(),
  resolveDescription: (context) => 'Deletes the selected cells',
  resolveShortcut: (context) => [.new(.delete), .new(.backspace)],
);

class DeleteSelectionAction extends CommandAction<DeleteSelectionIntent> {
  @override
  final descriptor = deleteSelectionIntentDescriptor;

  @override
  void performInvoke(BuildContext context, DeleteSelectionIntent intent) {
    final editor = context.editor;
    final selection = editor.selection;
    if (selection.isEmpty) return;

    final targets = <CellRef>{};
    final work = [...selection.cells];
    while (work.isNotEmpty) {
      final r = work.removeLast();
      if (!targets.add(r)) continue;
      work.addAll(editor.bundle.cellDirectDependents(r));
    }

    editor.edit((txn) => txn.delete(targets));
    selection.clear();
  }
}
