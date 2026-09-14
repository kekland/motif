part of '_intents.dart';

final class const SelectAllIntent() extends CommandIntent;

final selectAllIntentDescriptor = CommandIntentDescriptor<SelectAllIntent>(
  command: 'select-all',
  build: (context, args) => .new(),
  resolveDescription: (context) => 'Selects all cells in the program',
  resolveShortcut: (context) => [PlatformSingleActivator(.keyA, control: true)],
);

class SelectAllAction extends CommandAction<SelectAllIntent> {
  @override
  final descriptor = selectAllIntentDescriptor;

  @override
  void performInvoke(BuildContext context, SelectAllIntent intent) {
    final controller = context.editor.selection;
    final scene = context.editor.scene;

    final refs = <CellRef>{};
    for (final s in scene.program.statements) {
      refs.addAll(scene.productsOf(s.id));
    }

    controller.setMultiple(refs);
  }
}
