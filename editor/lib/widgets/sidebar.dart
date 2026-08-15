import 'package:editor/imports.dart';
import 'package:editor/widgets/program_panel/program_panel.dart';
import 'package:editor/widgets/selection_panel/selection_panel.dart';

class EditorSidebar extends StatelessWidget {
  const EditorSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Panels(
      direction: .vertical,
      panels: [
        Panel(
          constraints: .pixels(480.0, .infinity),
          child: SelectionPanel(),
        ),
        Panel(
          constraints: .flex(1.0),
          child: ProgramPanel(),
        ),
      ],
    );
  }
}
