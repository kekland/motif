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
      },
      child: child,
    );
  }
}

class EditorShortcuts extends StatelessWidget {
  const new({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        SingleActivator(.escape): intents.clearSelection(),
        SingleActivator(.keyZ, meta: true, control: true): intents.undo(),
        SingleActivator(.keyY, meta: true, control: true): intents.redo(),
      },
      child: child,
    );
  }
}
