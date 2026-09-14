import 'package:editor/imports.dart';

class EditorActions extends StatelessWidget {
  const new({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Actions(
      dispatcher: LoggingActionDispatcher(logger: Logger('editor.actions')),
      actions: actions,
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
      shortcuts: buildShortcuts(context),
      child: child,
    );
  }
}
