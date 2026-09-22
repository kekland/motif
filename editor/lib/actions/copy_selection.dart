part of '_intents.dart';

final class const CopySelectionIntent() extends CommandIntent;

final copySelectionIntentDescriptor = CommandIntentDescriptor<CopySelectionIntent>(
  command: 'copy',
  build: (context, args) => .new(),
  resolveShortcut: (context) => [PlatformSingleActivator(.keyC, control: true)],
);

class CopySelectionAction extends CommandAction<CopySelectionIntent> {
  @override
  final descriptor = copySelectionIntentDescriptor;

  @override
  void performInvoke(BuildContext context, CopySelectionIntent intent) {
    final editor = context.editor;
    final selection = editor.selection;

    if (selection.isEmpty) return;

    // final slice = editor.scene.evaluation.routeSlice(selection.refs.cells);
    // final data = base64Encode(slice.encode().writeToBuffer());
    // Clipboard.setData(.new(text: data));
  }
}
