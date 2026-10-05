part of '_intents.dart';

final class const CopySelectionIntent() extends Intent;

final copySelectionIntentDescriptor = CommandIntentDescriptor<CopySelectionIntent>(
  command: 'copy',
  build: (context, args) => .new(),
  resolveShortcut: (context) => [PlatformSingleActivator(.keyC, control: true)],
);

class CopySelectionAction extends CommandAction<CopySelectionIntent> with CanvasFocusAction {
  @override
  final descriptor = copySelectionIntentDescriptor;

  @override
  void performInvoke(BuildContext context, CopySelectionIntent intent) {
    final editor = context.editor;
    final selection = editor.selection;

    if (selection.isEmpty) return;

    final slice = editor.scene.evaluation.routeSlice(selection.refs.cells);
    final data = slice.encode().writeToBuffer();
    Clipboard.set([
      .custom({'motif.program-slice': data}),
    ]);
  }
}
