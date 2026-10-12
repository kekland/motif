import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_panel/selection_panel.dart';
import 'package:editor/widgets/tool_option_panel/tool_options_panel.dart';

final class const EditorSidebar({super.key}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final tool = useListenable(context.editor.tool).activeTool;

    final child = switch (tool) {
      CursorTool() => SelectionPanel(),
      _ => ToolOptionsPanel(),
    };

    return Panels(
      direction: .vertical,
      panels: [
        Panel(
          key: EditorPanel.selection,
          constraints: .flex(1.0),
          child: child,
        ),
      ],
    );
  }
}
