import 'package:editor/imports.dart';
import 'package:editor/widgets/program_panel/program_panel.dart';
import 'package:editor/widgets/tree_panel/tree_panel.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';

enum ScenePanelMode {
  program,
  tree,
}

class ScenePanel extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = useState(ScenePanelMode.tree);
    final clients = useListenable(context.editor.clients).clients;

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
        Divider(),
        SizedBox(
          height: 36.0,
          child: ListView.separated(
            scrollDirection: .horizontal,
            itemCount: 1 + clients.length,
            padding: const .symmetric(horizontal: 8.0),
            separatorBuilder: (context, i) => SizedBox(width: 2.0),
            itemBuilder: (context, i) {
              if (i == 0) {
                return SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: BoringAvatar(
                    name: context.editor.clients.ownId ?? '',
                    palette: .new(Colors.primaries),
                    shape: CircleBorder(),
                    type: .marble,
                  ),
                );
              }

              final client = clients[i - 1];
              return SizedBox(
                width: 24.0,
                height: 24.0,
                child: BoringAvatar(
                  name: client.id,
                  palette: .new(Colors.primaries),
                  shape: CircleBorder(),
                  type: .marble,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
