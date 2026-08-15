part of 'widgets.dart';

Widget? sceneNodeWidget(BuildContext context, SceneNode node) {
  final key = ObjectKey(node);

  return switch (node) {
    ContainerObject o => ContainerObjectWidget(key: key, object: o),
    RectangleObject o => RectangleObjectWidget(key: key, object: o),

    Cell c => RenderCellWidget(key: key, cell: c),
    _ => null,
  };
}
