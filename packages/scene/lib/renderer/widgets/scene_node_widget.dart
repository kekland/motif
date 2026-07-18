part of 'widgets.dart';

class SceneNodeWidget extends StatelessWidget {
  const SceneNodeWidget({super.key, required this.node});
  const SceneNodeWidget.from(SceneNode node, {Key? key}) : this(node: node, key: key);

  final SceneNode node;

  @override
  Widget build(BuildContext context) {
    return switch (node) {
      ContainerObject o => ContainerObjectWidget(key: ValueKey(o), object: o),
      RectangleObject o => RectangleObjectWidget(key: ValueKey(o), object: o),

      Cell c => RenderCellWidget(key: ValueKey(c), cell: c),
      _ => throw UnimplementedError(),
    };
  }
}
