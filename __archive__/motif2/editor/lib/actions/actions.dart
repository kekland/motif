import 'package:editor/imports.dart';
import 'package:flutter/services.dart';

part 'intents.dart';

class SelectObjectAction extends ContextAction<SelectNodeIntent> {
  @override
  void invoke(SelectNodeIntent intent, [BuildContext? context]) {
    final keysPressed = HardwareKeyboard.instance.logicalKeysPressed;
    final isShiftPressed =
        keysPressed.contains(LogicalKeyboardKey.shiftLeft) || keysPressed.contains(LogicalKeyboardKey.shiftRight);

    final controller = context!.selection;
    if (isShiftPressed) {
      controller.add(intent.node);
    } else {
      controller.set(intent.node);
    }
  }
}

class ClearSelectionAction extends ContextAction<ClearSelectionIntent> {
  @override
  void invoke(ClearSelectionIntent intent, [BuildContext? context]) {
    final controller = context!.selection;
    controller.clear();
  }
}
