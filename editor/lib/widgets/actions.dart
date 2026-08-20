import 'package:editor/imports.dart';

class EditorActions extends StatelessWidget {
  const new({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Actions(
      dispatcher: LoggingActionDispatcher(logger: Logger('editor.actions')),
      actions: {
        SelectCellIntent: SelectCellAction(),
        ClearSelectionIntent: ClearSelectionAction(),
        UndoIntent: UndoAction(),
        RedoIntent: RedoAction(),
        DeleteSelectionIntent: DeleteSelectionAction(),
        CopySelectionIntent: CopySelectionAction(),
        PasteIntent: PasteAction(),
      },
      child: child,
    );
  }
}

class EditorShortcuts extends StatelessWidget {
  const new({super.key, required this.child});

  final Widget child;

  static final _isApple = switch (defaultTargetPlatform) {
    TargetPlatform.macOS || TargetPlatform.iOS => true,
    _ => false,
  };

  @override
  Widget build(BuildContext context) {
    final meta = _isApple;
    final ctrl = !_isApple;

    return Shortcuts(
      shortcuts: {
        SingleActivator(.escape): intents.clearSelection(),
        SingleActivator(.delete): intents.deleteSelection(),
        SingleActivator(.backspace): intents.deleteSelection(),
        SingleActivator(.keyZ, meta: meta, control: ctrl): intents.undo(),
        SingleActivator(.keyZ, meta: meta, control: ctrl, shift: true): intents.redo(),
        SingleActivator(.keyY, meta: meta, control: ctrl): intents.redo(),
        SingleActivator(.keyC, meta: meta, control: ctrl): intents.copySelection(),
        SingleActivator(.keyV, meta: meta, control: ctrl): intents.paste(),
      },
      child: child,
    );
  }
}
