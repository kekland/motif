import 'package:design/imports.dart';
import 'package:flutter/services.dart';

class SelectNodeAction extends ContextAction<SelectNodeIntent> {
  @override
  void invoke(SelectNodeIntent intent, [BuildContext? context]) {
    final keysPressed = HardwareKeyboard.instance.logicalKeysPressed;
    final isShiftPressed =
        keysPressed.contains(LogicalKeyboardKey.shiftLeft) || keysPressed.contains(LogicalKeyboardKey.shiftRight);

    final controller = DesignController.of(context!).selection;
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
    final controller = DesignController.of(context!).selection;
    controller.clearSelection();
  }
}

class DeleteSelectionAction extends ContextAction<DeleteSelectionIntent> {
  @override
  void invoke(DeleteSelectionIntent intent, [BuildContext? context]) {
    final controller = DesignController.of(context!);
    final selection = controller.selection;
    final selectedNodes = selection.selectedNodes;

    for (final node in selectedNodes) {
      if (node is! MutableNode) continue;
      node.detach().dispose();
    }

    selection.clearSelection();
  }
}

class MoveSelectionAction extends ContextAction<MoveSelectionIntent> {
  @override
  void invoke(MoveSelectionIntent intent, [BuildContext? context]) {
    final controller = DesignController.of(context!);
    final selection = controller.selection;
    final selectedNodes = selection.selectedNodes;

    for (final node in selectedNodes) {
      if (node is! MutableNode) continue;
      node.transform = node.transform.translated(intent.offset);
    }
  }
}
