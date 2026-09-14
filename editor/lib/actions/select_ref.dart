part of '_intents.dart';

final class const SelectRefIntent(final Ref ref) extends Intent;

class SelectRefAction extends ContextAction<SelectRefIntent> {
  @override
  void invoke(SelectRefIntent intent, [BuildContext? context]) {
    final keysPressed = HardwareKeyboard.instance.logicalKeysPressed;
    final isShiftPressed =
        keysPressed.contains(LogicalKeyboardKey.shiftLeft) || keysPressed.contains(LogicalKeyboardKey.shiftRight);

    final controller = context!.editor.selection;
    if (isShiftPressed) {
      controller.add(intent.ref);
    } else {
      controller.set(intent.ref);
    }
  }
}
