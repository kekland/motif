part of '_intents.dart';

final class const GlueSelectedVerticesIntent() extends CommandIntent;

final glueSelectedVerticesIntentDescriptor = CommandIntentDescriptor<GlueSelectedVerticesIntent>(
  command: 'glue-vertices',
  build: (context, args) => .new(),
  resolveDescription: (context) => 'Glue selected vertices',
);

class GlueSelectedVerticesAction extends CommandAction<GlueSelectedVerticesIntent> {
  @override
  final descriptor = glueSelectedVerticesIntentDescriptor;

  @override
  bool canInvoke(BuildContext context, GlueSelectedVerticesIntent intent) {
    final selection = context.editor.selection;
    final vertices = selection.cells.whereVertex().toList();
    return vertices.length >= 2;
  }

  @override
  void performInvoke(BuildContext context, GlueSelectedVerticesIntent intent) {
    final editor = context.editor;
    final selection = editor.selection;
    final vertices = selection.cells.whereVertex().toList();
    if (vertices.length < 2) return;

    editor.edit((txn) {
      txn.insert(GlueVerticesStatement(vertices.map((v) => v.selector()).toList()));
    });
  }
}
