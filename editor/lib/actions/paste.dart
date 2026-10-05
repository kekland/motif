part of '_intents.dart';

final pasteIntentDescriptor = CommandIntentDescriptor<PasteIntent>(
  command: 'paste',
  build: (context, args) => .new(null),
  resolveShortcut: (context) => [
    PlatformSingleActivator(.keyV, control: true),
  ],
);

class PasteAction extends CommandAction<PasteIntent> with CanvasFocusAction {
  @override
  final descriptor = pasteIntentDescriptor;

  @override
  void performInvoke(BuildContext context, PasteIntent intent) async {
    final editor = context.editor;

    final value = await intent.resolve();
    final sliceData = value.custom('motif.program-slice');
    if (sliceData != null) {
      try {
        final slice = ProgramSlice.decodeRaw(sliceData);
        if (slice == null) return;

        final remapped = slice.materialize((s) => .allocate());
        editor.edit((txn) {
          for (final s in remapped.statements) txn.insert(s);
          // for (final o in remapped.styleOverrides.entries) txn.decorate(o.key, o.value);
        });

        editor.selection.setStatements(remapped.statements.map((s) => s.id));
        return;
      } catch (e) {
        print('Failed to paste custom slice: $e');
      }
    }

    final images = await value.images();
    if (images.isNotEmpty) {
      try {
        var offset = 0.0;
        final statements = <Statement>[];

        for (final imageData in images) {
          final asset = await editor.uploadImageAsset(imageData.bytes, mimeType: imageData.mimeType);
          final statement = RectangleStatement(
            transform: .translation(offset, 0.0),
            size: .fixed(asset.width.toDouble(), asset.height.toDouble()),
            edgeStyle: .none,
            faceStyle: .new(decorations: .new([.image(asset.hash)])),
          );

          statements.add(statement);
          offset += asset.width.toDouble();
        }

        editor.edit((txn) => txn.insertAll(statements));
        return;
      } catch (e) {
        print('Failed to paste image: $e');
      }
    }
  }
}
