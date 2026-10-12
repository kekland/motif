part of '_intents.dart';

final class const CreatePrefabIntent() extends Intent;

final createPrefabIntentDescriptor = CommandIntentDescriptor<CreatePrefabIntent>(
  command: 'create-prefab',
  build: (context, args) => .new(),
  resolveDescription: (context) => 'Creates a prefab from the current selection',
  resolveShortcut: (context) => [PlatformSingleActivator(.keyK, control: true, alt: true)],
);

class CreatePrefabAction extends CommandAction<CreatePrefabIntent> with CanvasFocusAction {
  new() : super(createPrefabIntentDescriptor);

  @override
  bool canInvoke(BuildContext context, CreatePrefabIntent intent) {
    return context.editor.selection.isNotEmpty;
  }

  @override
  void performInvoke(BuildContext context, CreatePrefabIntent intent) {
    final editor = context.editor;
    final selection = editor.selection;
    if (selection.isEmpty) return;

    editor.edit((txn) {
      final edit = editor.scene.evaluation.routePackagePrefab(selection.cells);
      txn.apply(edit);
    });
  }
}
