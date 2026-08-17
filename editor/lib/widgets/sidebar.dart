import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_panel/selection_panel.dart';

class EditorSidebar extends StatelessWidget {
  const EditorSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: .topCenter,
      child: SelectionPanel(),
    );
  }
}
