part of '_intents.dart';

final pasteIntentDescriptor = CommandIntentDescriptor<PasteIntent>(
  command: 'paste',
  build: (context, args) => .new(null),
  resolveShortcut: (context) => [
    PlatformSingleActivator(.keyV, control: true),
  ],
);

class PasteAction extends CommandAction<PasteIntent> with CanvasFocusAction {
  new() : super(pasteIntentDescriptor);

  @override
  void performInvoke(BuildContext context, PasteIntent intent) async {
    final editor = context.editor;

    final value = await intent.resolve();
    final sliceData = value.custom('motif.program-slice');

    ProgramSlice? insertions;
    List<StatementId>? selection;

    if (sliceData != null) {
      try {
        final slice = ProgramSlice.decodeRaw(sliceData);
        if (slice == null) return;
        insertions = slice;
      } catch (e, st) {
        logger.warning('failed to paste slice', e, st);
      }
    }

    final images = await value.images();
    if (images.isNotEmpty) {
      try {
        final assets = <ImageAsset>[];

        for (final imageData in images) {
          final asset = await editor.uploadImageAsset(imageData.bytes, mimeType: imageData.mimeType);
          assets.add(asset);
        }

        if (editor.selection.isNotEmpty) {
          final statements = editor.selection.statements.map(editor.scene.statement).whereType<FaceStyledStatement>();
          if (statements.isNotEmpty) {
            // Add image decorations per statement
            final decorations = assets.map((a) => ImageDecoration(a.hash)).toList();

            editor.edit((txn) {
              for (final statement in statements) {
                final style = statement.faceStyle;
                final newStyle = style.copyWith(decorations: style.decorations.appendAll(decorations));
                txn.updatePartial(statement.id, .faceStyle(newStyle));
              }
            });

            selection = statements.map((s) => s.id).toList();
            return;
          }
        }

        Vec2 offset = .zero();
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

        insertions = .new(statements: statements);
        return;
      } catch (e, st) {
        logger.warning('failed to paste image', e, st);
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

        insertions = .new(
          statements: [
            TextStatement(
              textFormat: textFormat,
              edgeStyle: .none,
              faceStyle: .new(decorations: .white),
              size: .contain(),
              text: text,
            ),
          ],
        );
      } catch (e, st) {
        logger.warning('failed to paste text', e, st);
      }
    }

    if (insertions != null) {
      final parents = <FrameRef>{};
      final created = <FrameRef, List<StatementId>>{};

      editor.edit((txn) {
        final selected = editor.selection.statements.map(editor.statement);
        final targetParents = selected.whereType<FramedStatement>().map((f) => f.frame).toSet();

        var totalBbox = Aabb2.invertedInfinity();

        if (targetParents.isEmpty) {
          targetParents.add(.root);
        }

        for (final targetFrame in targetParents) {
          final materialized = insertions!.materialize((_, _) => .allocate());
          final ids = materialized.statements.map((s) => s.id).toList();
          txn.insertAll(materialized.statements);
          txn.flush();

          final targets = <CellRef>{};
          for (final id in ids) targets.addAll(editor.productsOf(id));

          // try to find a parent
          var frame = targetFrame;
          while (frame != .root) {
            final result = txn.evaluation.routeReparent(targets, frame);

            if (result is! ReparentSuccess) {
              frame = editor.bundle.query.parent(frame)!;
            } else {
              break;
            }
          }

          if (!parents.add(frame)) {
            for (final id in ids) txn.remove(id);
            continue;
          }

          created[frame] ??= [];
          created[frame]!.addAll(ids);

          if (frame != .root) txn.reparent(targets, frame);
          txn.flush();

          if (frame == .root) {
            totalBbox.hull(editor.scene.query.bbox(ids, space: .root));
          } else {
            final bbox = editor.scene.query.bbox(ids, space: frame);
            final session = TransformSession.statements(editor.scene, ids, transaction: txn);
            final parentBbox = editor.bundle.query.bbox(frame)!;
            final offset = bbox.center - parentBbox.center;
            session.apply(Mat4.translation2(-offset));
          }
        }

        final offset = editor.canvasPosition - totalBbox.center;
        final session = TransformSession.statements(
          editor.scene,
          created[FrameRef.root] ?? <StatementId>[],
          transaction: txn,
        );
        session.apply(Mat4.translation2(offset));
      });

      selection = created.values.expand((ids) => ids).toList();
    }

    if (selection != null) {
      editor.selection.setStatements(selection);
      editor.canvasUtils.showOnScreen(selection);
    }
  }
}
