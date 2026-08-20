import 'dart:convert';

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
      controller.add(intent.ref);
    } else {
      controller.set(intent.ref);
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

class DeleteSelectionAction extends ContextAction<DeleteSelectionIntent> {
  @override
  void invoke(DeleteSelectionIntent intent, [BuildContext? context]) {
    final editor = context!.editor;
    final selection = editor.selection;

    if (selection.isEmpty) return;

    editor.edit((txn) {
      final statements = selection.statements;
      for (final s in statements) txn.remove(s);
    });

    selection.clear();
  }
}

class CopySelectionAction extends ContextAction<CopySelectionIntent> {
  @override
  void invoke(CopySelectionIntent intent, [BuildContext? context]) {
    final editor = context!.editor;
    final selection = editor.selection;

    if (selection.isEmpty) return;

    final slice = editor.scene.slice(selection.statements);
    final data = base64Encode(slice.encode().writeToBuffer());
    Clipboard.setData(.new(text: data));
  }
}

class PasteAction extends ContextAction<PasteIntent> {
  @override
  void invoke(PasteIntent intent, [BuildContext? context]) async {
    final editor = context!.editor;

    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData == null || clipboardData.text == null) return;

    final slice = SceneSlice.decodeRaw(base64Decode(clipboardData.text!));
    if (slice == null) return;

    final remapped = slice.remap();
    editor.edit((txn) {
      for (final s in remapped.statements) txn.insert(s);
      for (final o in remapped.styleOverrides.entries) txn.decorate(o.key, o.value);
    });

    editor.selection.setStatements(remapped.statements.map((s) => s.id));
  }
}
