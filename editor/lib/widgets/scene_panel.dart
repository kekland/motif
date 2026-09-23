import 'package:editor/widgets/program_panel/program_panel.dart';
import 'package:editor/widgets/tree_panel/tree_panel.dart';
import 'package:ui/ui.dart';

enum ScenePanelMode {
  program,
  tree,
}

class ScenePanel extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = useState(ScenePanelMode.tree);

    return Column(
      mainAxisSize: .max,
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: ListItem(
                  leading: Icons.tree(),
                  title: Text('Tree'),
                  onTap: () => mode.value = .tree,
                  isSelected: mode.value == .tree,
                ),
              ),
              VerticalDivider(),
              Expanded(
                child: ListItem(
                  leading: Icons.program(),
                  title: Text('Program'),
                  onTap: () => mode.value = .program,
                  isSelected: mode.value == .program,
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Expanded(
          child: switch (mode.value) {
            .tree => TreePanel(),
            .program => ProgramPanel(),
          },
        ),
      ],
    );
  }
}
