part of 'widgets.dart';

class SceneNodeWidget extends StatelessWidget {
  const SceneNodeWidget({super.key, required this.node});
  const SceneNodeWidget.from(SceneNode node, {Key? key}) : this(node: node, key: key);

  final SceneNode node;

  @override
  Widget build(BuildContext context) {
    return switch (node) {
      ContainerObject o => ContainerObjectWidget(object: o),
      RectangleObject o => RectangleObjectWidget(object: o),

      Cell c => RenderCellWidget(cell: c),
      _ => throw UnimplementedError(),
    };
  }
}
