import 'package:editor/imports.dart';

part 'node_tile.dart';
part 'tree_painter.dart';
part 'draggable_targets.dart';

class SceneTreePanel extends HookWidget {
  const SceneTreePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final scene = context.scene;
    final root = useNode(scene.root, aspect: .children);

    final children = NodeTile.childrenToDisplay(root, {});

    return Column(
      children: [
        Subtitle(
          child: Text('Objects'),
        ),
        Divider(),
        Flexible(
          child: ListView.custom(
            childrenDelegate: SliverChildBuilderDelegate(
              (context, i) {
                final object = children[i];

                return NodeTile(
                  key: ValueKey(object.id),
                  editor: editor,
                  index: i,
                  node: object,
                );
              },
              childCount: children.length,
              findChildIndexCallback: (key) {
                final id = (key as ValueKey<NodeId>).value;
                return children.indexWhere((e) => e.id == id);
              }
            ),
          ),
        ),
      ],
    );
  }
}
