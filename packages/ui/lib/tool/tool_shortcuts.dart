import 'package:ui/ui.dart';

class SelectToolIntent extends CommandIntent {
  const SelectToolIntent(this.tool);

  final Tool tool;
}

class SelectToolAction extends ContextAction<SelectToolIntent> {
  SelectToolAction(
    this.controller, {
    required this.canInvoke,
  });
  final ToolController controller;
  final bool Function(BuildContext context) canInvoke;

  @override
  bool isEnabled(SelectToolIntent intent, [BuildContext? context]) {
    if (context == null) return true;
    return canInvoke(context);
  }

  @override
  void invoke(SelectToolIntent intent, [BuildContext? context]) {
    controller.activeTool = intent.tool;
  }
}

class ToolShortcuts extends StatelessWidget {
  const ToolShortcuts({
    super.key,
    required this.controller,
    required this.canInvoke,
    required this.child,
  });

  final ToolController controller;
  final bool Function(BuildContext context) canInvoke;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final shortcuts = <SingleActivator, Intent>{};

    for (final tool in controller.toolset) {
      if (tool.shortcut == null) continue;
      shortcuts[tool.shortcut!] = SelectToolIntent(tool);
    }

    return Actions(
      actions: {
        SelectToolIntent: SelectToolAction(controller, canInvoke: canInvoke),
      },
      child: Shortcuts(
        shortcuts: shortcuts,
        child: child,
      ),
    );
  }
}
