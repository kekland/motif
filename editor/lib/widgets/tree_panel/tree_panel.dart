import 'package:editor/imports.dart';

class TreePanel extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final tree = useListenable(context.editor.scene.tree);
    final selection = useListenable(context.editor.selection);
    final flattened = tree.flattened;

    return ListView.builder(
      itemCount: flattened.length,
      itemBuilder: (context, index) {
        final node = flattened[index] as ObjectSceneNode;
        final statement = node.statement;
        return ListItem(
          onTap: () => context.editor.selection.setStatement(statement.id),
          leading: statement.icon(context),
          title: Text(statement.name(context)),
          padding: EdgeInsets.only(left: node.depth * 8.0, right: 8.0),
          isSelected: selection.statements.contains(statement.id),
        );
      },
    );
  }
}
