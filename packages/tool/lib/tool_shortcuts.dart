import 'package:ui/ui.dart';
import 'package:tool/tool.dart';

class SelectToolIntent extends Intent {
  const SelectToolIntent(this.tool);

  final Tool tool;
}

class ToolShortcuts extends StatelessWidget {
  const ToolShortcuts({
    super.key,
    required this.controller,
    required this.child,
  });

  final ToolController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final shortcuts = <LogicalKeySet, Intent>{};

    for (final tool in controller.toolset) {
      if (tool.shortcut == null) continue;
      shortcuts[tool.shortcut!] = SelectToolIntent(tool);
    }

    return Actions(
      actions: {
        SelectToolIntent: CallbackAction<SelectToolIntent>(
          onInvoke: (intent) => controller.activeTool = intent.tool,
        ),
      },
      child: Shortcuts(
        shortcuts: shortcuts,
        child: child,
      ),
    );
  }
}
