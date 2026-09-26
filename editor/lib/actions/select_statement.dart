part of '_intents.dart';

final class const SelectStatementIntent(final StatementId id) extends Intent;

class SelectStatementAction extends ContextAction<SelectStatementIntent> with CanvasFocusAction {
  @override
  void invoke(SelectStatementIntent intent, [BuildContext? context]) {
    final keysPressed = HardwareKeyboard.instance.logicalKeysPressed;
    final isShiftPressed =
        keysPressed.contains(LogicalKeyboardKey.shiftLeft) || keysPressed.contains(LogicalKeyboardKey.shiftRight);

    final controller = context!.editor.selection;
    if (isShiftPressed) {
      controller.addStatement(intent.id);
    } else {
      controller.setStatement(intent.id);
    }
  }
}
