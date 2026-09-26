part of '_intents.dart';

final class const RedoIntent() extends CommandIntent;

final redoIntentDescriptor = CommandIntentDescriptor<RedoIntent>(
  command: 'redo',
  build: (context, args) => .new(),
  resolveShortcut: (context) => [
    PlatformSingleActivator(.keyY, control: true),
    PlatformSingleActivator(.keyZ, control: true, shift: true),
  ],
);

class RedoAction extends CommandAction<RedoIntent> with CanvasFocusAction {
  @override
  final descriptor = redoIntentDescriptor;

  @override
  void performInvoke(BuildContext context, RedoIntent intent) {
    final history = context.editor.history;
    history.redo();
  }
}
