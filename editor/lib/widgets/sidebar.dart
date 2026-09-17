import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_panel/selection_panel.dart';
import 'package:editor/widgets/tool/tool_options_panel.dart';

class EditorSidebar extends StatelessWidget {
  const EditorSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Panels(
      direction: .vertical,
      panels: [
        Panel(
          constraints: .flex(1.0),
          child: SelectionPanel(),
        ),
        Panel(
          constraints: .pixels(200.0, 400.0, initial: 300.0),
          child: ToolOptionsPanel(),
        ),
      ],
    );
  }
}
