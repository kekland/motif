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
        final mergeKey = Object();
        editor.edit((txn) {
          for (final s in remapped.statements) txn.insert(s);
          // for (final o in remapped.styleOverrides.entries) txn.decorate(o.key, o.value);
        }, mergeKey: mergeKey);

        editor.edit((txn) {
          final session = TransformSession.statements(
            editor.scene,
            remapped.statements.map((s) => s.id),
            transaction: txn,
          );

          session.apply(Mat4.translation2(editor.canvasPosition));
        }, mergeKey: mergeKey);

        editor.selection.setStatements(remapped.statements.map((s) => s.id));
        return;
      } catch (e) {
        print('Failed to paste custom slice: $e');
      }
    }

    final images = await value.images();
    if (images.isNotEmpty) {
      try {
        Vec2 offset = editor.canvasPosition;
        final statements = <Statement>[];

        for (final imageData in images) {
          final asset = await editor.uploadImageAsset(imageData.bytes, mimeType: imageData.mimeType);
          final statement = RectangleStatement(
            transform: .translation2(offset),
            size: .fixed(asset.width.toDouble(), asset.height.toDouble()),
            edgeStyle: .none,
            faceStyle: .new(decorations: .new([.image(asset.hash)])),
          );

          statements.add(statement);
          offset = .new(offset.x + asset.width.toDouble(), offset.y);
        }

        editor.edit((txn) => txn.insertAll(statements));
        return;
      } catch (e) {
        print('Failed to paste image: $e');
      }
    }

    final text = value.text();
    if (text != null && text.isNotEmpty) {
      try {
        final textFormat = TextFormat.default_(editor.builtinFonts.catalog);
        final family = editor.builtinFonts.catalog[textFormat.fontFamily];
        final face = textFormat.resolveClosest(family);
        final asset = family.assetFor(face);
        editor.maybeAddAsset(asset);

        final statement = TextStatement(
          transform: .translation2(editor.canvasPosition),
          textFormat: textFormat,
          edgeStyle: .none,
          faceStyle: .new(decorations: .white),
          size: .contain(),
          text: text,
        );

        editor.edit((txn) => txn.insert(statement));
        return;
      } catch (e) {
        print('Failed to paste text: $e');
      }
    }
  }
}
