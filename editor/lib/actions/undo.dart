part of '_intents.dart';

final class const UndoIntent() extends Intent;

final undoIntentDescriptor = CommandIntentDescriptor<UndoIntent>(
  command: 'undo',
  build: (context, args) => .new(),
  resolveShortcut: (context) => [PlatformSingleActivator(.keyZ, control: true)],
);

class UndoAction extends CommandAction<UndoIntent> with CanvasFocusAction {
  new() : super(undoIntentDescriptor);

  @override
  void performInvoke(BuildContext context, UndoIntent intent) {
    final history = context.editor.history;
    history.undo();
  }
}
