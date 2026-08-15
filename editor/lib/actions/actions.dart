import 'package:editor/imports.dart';
import 'package:flutter/services.dart';

part 'intents.dart';

class SelectCellAction extends ContextAction<SelectCellIntent> {
  @override
  void invoke(SelectCellIntent intent, [BuildContext? context]) {
    final keysPressed = HardwareKeyboard.instance.logicalKeysPressed;
    final isShiftPressed =
        keysPressed.contains(LogicalKeyboardKey.shiftLeft) || keysPressed.contains(LogicalKeyboardKey.shiftRight);

    final controller = context!.editor.selection;
    if (isShiftPressed) {
      controller.add(intent.cell);
    } else {
      controller.set(intent.cell);
    }
  }
}

class ClearSelectionAction extends ContextAction<ClearSelectionIntent> {
  @override
  void invoke(ClearSelectionIntent intent, [BuildContext? context]) {
    final controller = context!.editor.selection;
    controller.clear();
  }
}

class UndoAction extends ContextAction<UndoIntent> {
  @override
  void invoke(UndoIntent intent, [BuildContext? context]) {
    final history = context!.editor.history;
    history.undo();
  }
}

class RedoAction extends ContextAction<RedoIntent> {
  @override
  void invoke(RedoIntent intent, [BuildContext? context]) {
    final history = context!.editor.history;
    history.redo();
  }
}
