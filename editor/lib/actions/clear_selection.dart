part of '_intents.dart';

final class const ClearSelectionIntent() extends Intent;

final clearSelectionIntentDescriptor = CommandIntentDescriptor<ClearSelectionIntent>(
  command: 'clear-selection',
  build: (context, args) => .new(),
  resolveDescription: (context) => 'Clears the current selection',
  resolveShortcut: (context) => [.new(.escape)],
);

class ClearSelectionAction extends CommandAction<ClearSelectionIntent> with CanvasFocusAction {
  new() : super(clearSelectionIntentDescriptor);

  @override
  void performInvoke(BuildContext context, ClearSelectionIntent intent) {
    final controller = context.editor.selection;
    controller.clear();
  }
}
