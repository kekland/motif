import 'dart:convert';

import 'package:editor/imports.dart';
import 'package:flutter/services.dart';

part 'intents.dart';

bool get isTextFieldFocused {
  final context = FocusManager.instance.primaryFocus?.context;
  if (context == null) return false;
  return context.findAncestorStateOfType<EditableTextState>() != null;
}

abstract class EditorAction<T extends Intent> extends ContextAction<T> {
  @override
  bool isEnabled(T intent, [BuildContext? context]) => !isTextFieldFocused;
}

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

class UndoAction extends EditorAction<UndoIntent> {
  @override
  void invoke(UndoIntent intent, [BuildContext? context]) {
    final history = context!.editor.history;
    history.undo();
  }
}

class RedoAction extends EditorAction<RedoIntent> {
  @override
  void invoke(RedoIntent intent, [BuildContext? context]) {
    final history = context!.editor.history;
    history.redo();
  }
}

class DeleteSelectionAction extends EditorAction<DeleteSelectionIntent> {
  @override
  void invoke(DeleteSelectionIntent intent, [BuildContext? context]) {
    final editor = context!.editor;
    final selection = editor.selection;
    if (selection.isEmpty) return;

    editor.edit((txn) {
      final statements = selection.statements;
      txn.dissolve(statements);
    });

    selection.clear();
  }
}

class CopySelectionAction extends EditorAction<CopySelectionIntent> {
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

class PasteAction extends EditorAction<PasteIntent> {
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
