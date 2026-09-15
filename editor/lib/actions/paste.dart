part of '_intents.dart';

final class const PasteIntent() extends CommandIntent;

final pasteIntentDescriptor = CommandIntentDescriptor<PasteIntent>(
  command: 'paste',
  build: (context, args) => .new(),
  resolveShortcut: (context) => [
    PlatformSingleActivator(.keyV, control: true),
  ],
);

class PasteAction extends CommandAction<PasteIntent> {
  @override
  final descriptor = pasteIntentDescriptor;

  @override
  void performInvoke(BuildContext context, PasteIntent intent) async {
    final editor = context.editor;

    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData == null || clipboardData.text == null) return;

    final slice = ProgramSlice.decodeRaw(base64Decode(clipboardData.text!));
    if (slice == null) return;

    final remapped = slice.materialize((s) => .allocate());
    editor.edit((txn) {
      for (final s in remapped.statements) txn.insert(s);
      // for (final o in remapped.styleOverrides.entries) txn.decorate(o.key, o.value);
    });

    editor.selection.setStatements(remapped.statements.map((s) => s.id));
  }
}
