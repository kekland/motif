import 'package:editor/imports.dart';

class EditorActions extends StatelessWidget {
  const EditorActions({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Actions(
      dispatcher: LoggingActionDispatcher(logger: Logger('editor.actions')),
      actions: {
        SelectNodeIntent: SelectObjectAction(),
        ClearSelectionIntent: ClearSelectionAction(),
      },
      child: child,
    );
  }
}

class EditorShortcuts extends StatelessWidget {
  const EditorShortcuts({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        SingleActivator(.escape): intents.clearSelection(),
      },
      child: child,
    );
  }
}
