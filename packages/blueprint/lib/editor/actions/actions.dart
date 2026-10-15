import 'package:blueprint/editor.dart';
import 'package:native/native.dart';
import 'package:ui/ui.dart';

final intents = (
  selectAll: SelectAllIntent.new,
  selectNode: SelectNodeIntent.new,
  selectConnection: SelectConnectionIntent.new,
  deleteSelection: DeleteSelectionIntent.new,
  clearSelection: ClearSelectionIntent.new,
  copySelection: CopySelectionIntent.new,
  paste: PasteIntent.new,
  undo: UndoIntent.new,
  redo: RedoIntent.new,
);

final actions = <Type, Action>{
  SelectAllIntent: SelectAllAction(),
  SelectNodeIntent: SelectNodeAction(),
  SelectConnectionIntent: SelectConnectionAction(),
  DeleteSelectionIntent: DeleteSelectionAction(),
  ClearSelectionIntent: ClearSelectionAction(),
  CopySelectionIntent: CopySelectionAction(),
  PasteIntent: PasteAction(),
  UndoIntent: UndoAction(),
  RedoIntent: RedoAction(),
};

Map<SingleActivator, Intent> buildShortcuts(BuildContext context) {
  final shortcuts = <SingleActivator, Intent>{};

  for (final action in actions.values) {
    if (action is! CommandAction) continue;

    final descriptor = action.descriptor;
    final shortcut = descriptor.resolveShortcut(context);
    if (shortcut.isEmpty) continue;

    final intent = descriptor.build?.call(context, []);
    if (intent != null) for (final s in shortcut) shortcuts[s] = intent;
  }

  return shortcuts;
}

final class const SelectAllIntent() extends Intent;
final class const SelectNodeIntent(final NodeId id) extends Intent;
final class const SelectConnectionIntent(final Connection connection) extends Intent;
final class const DeleteSelectionIntent() extends Intent;
final class const ClearSelectionIntent() extends Intent;
final class const CopySelectionIntent() extends Intent;
final class const UndoIntent() extends Intent;
final class const RedoIntent() extends Intent;

final class SelectAllAction extends CommandAction<SelectAllIntent> with CanvasFocusAction {
  SelectAllAction()
    : super(
        .new(
          command: 'select-all',
          build: (context, _) => .new(),
          resolveShortcut: (context) => [PlatformSingleActivator(.keyA, control: true)],
        ),
      );

  @override
  void performInvoke(BuildContext context, SelectAllIntent intent) {
    final editor = BlueprintEditor.of(context);
    editor.selection.selectAll();
  }
}

final class SelectNodeAction extends CommandAction<SelectNodeIntent> with CanvasFocusAction {
  SelectNodeAction() : super(.new(command: 'select-node'));

  @override
  void performInvoke(BuildContext context, SelectNodeIntent intent) {
    final editor = BlueprintEditor.of(context);

    if (context.keyboard.isShiftPressed) {
      editor.selection.addNode(intent.id);
    } else {
      editor.selection.selectNode(intent.id);
    }
  }
}

final class SelectConnectionAction extends CommandAction<SelectConnectionIntent> with CanvasFocusAction {
  SelectConnectionAction() : super(.new(command: 'select-connection'));

  @override
  void performInvoke(BuildContext context, SelectConnectionIntent intent) {
    final editor = BlueprintEditor.of(context);

    if (context.keyboard.isShiftPressed) {
      editor.selection.addConnection(intent.connection);
    } else {
      editor.selection.selectConnection(intent.connection);
    }
  }
}

final class ClearSelectionAction extends CommandAction<ClearSelectionIntent> with CanvasFocusAction {
  ClearSelectionAction()
    : super(
        .new(
          command: 'clear-selection',
          build: (context, _) => .new(),
          resolveShortcut: (context) => [SingleActivator(.escape)],
        ),
      );

  @override
  void performInvoke(BuildContext context, ClearSelectionIntent intent) {
    final editor = BlueprintEditor.of(context);
    editor.selection.clear();
  }
}

final class DeleteSelectionAction extends CommandAction<DeleteSelectionIntent> with CanvasFocusAction {
  DeleteSelectionAction()
    : super(
        .new(
          command: 'delete-selection',
          build: (context, _) => .new(),
          resolveShortcut: (context) => [.new(.delete), .new(.backspace)],
        ),
      );

  @override
  void performInvoke(BuildContext context, DeleteSelectionIntent intent) {
    final editor = BlueprintEditor.of(context);

    editor.edit(() {
      for (final connection in editor.selection.connections) {
        editor.disconnect(connection.input, connection.output, index: connection.index);
      }

      for (final node in editor.selection.nodes) {
        if (editor.isFixed(node)) continue;
        editor.remove(node);
      }
    });
  }
}

final class CopySelectionAction extends CommandAction<CopySelectionIntent> with CanvasFocusAction {
  CopySelectionAction()
    : super(
        .new(
          command: 'copy-selection',
          build: (context, _) => .new(),
          resolveShortcut: (context) => [PlatformSingleActivator(.keyC, control: true)],
        ),
      );

  @override
  void performInvoke(BuildContext context, CopySelectionIntent intent) {
    final editor = BlueprintEditor.of(context);
    final slice = editor.value.slice(editor.selection.nodes);
    performCopy(editor, slice);
  }
}

void performCopy(BlueprintEditor editor, BlueprintSlice slice) {
  final data = editor.encodeSlice(slice);
  Clipboard.set([
    .custom({'motif.blueprint-slice': data}),
  ]);
}

final class PasteAction extends CommandAction<PasteIntent> with CanvasFocusAction {
  new()
    : super(
        .new(
          command: 'paste',
          build: (context, _) => .new(null),
          resolveShortcut: (context) => [PlatformSingleActivator(.keyV, control: true)],
        ),
      );

  @override
  void performInvoke(BuildContext context, PasteIntent intent) async {
    final editor = BlueprintEditor.of(context);

    final value = await intent.resolve();
    final sliceData = value.custom('motif.blueprint-slice');
    if (sliceData == null) return;

    try {
      final slice = editor.decodeSlice(sliceData);
      editor.pasteSlice(slice);
    } catch (e) {
      debugPrint('Failed to decode blueprint slice: $e');
    }
  }
}

final class RedoAction extends CommandAction<RedoIntent> with CanvasFocusAction {
  new()
    : super(
        .new(
          command: 'redo',
          build: (context, args) => .new(),
          resolveShortcut: (context) => [
            PlatformSingleActivator(.keyY, control: true),
            PlatformSingleActivator(.keyZ, control: true, shift: true),
          ],
        ),
      );

  @override
  void performInvoke(BuildContext context, RedoIntent intent) {
    final editor = BlueprintEditor.of(context);
    editor.history.redo();
  }
}

final class UndoAction extends CommandAction<UndoIntent> with CanvasFocusAction {
  new()
    : super(
        .new(
          command: 'undo',
          build: (context, args) => .new(),
          resolveShortcut: (context) => [PlatformSingleActivator(.keyZ, control: true)],
        ),
      );

  @override
  void performInvoke(BuildContext context, UndoIntent intent) {
    final editor = BlueprintEditor.of(context);
    editor.history.undo();
  }
}

mixin CanvasFocusAction<T extends Intent> on ContextAction<T> {
  @override
  bool isEnabled(T intent, [BuildContext? context]) {
    final editor = BlueprintEditor.of(context!);
    if (!editor.canvasHasFocus) return false;
    return super.isEnabled(intent, context);
  }
}
