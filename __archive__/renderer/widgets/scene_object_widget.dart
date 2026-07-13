part of 'widgets.dart';

class SceneObjectWidget extends StatelessWidget {
  const SceneObjectWidget({super.key, required this.object});
  const SceneObjectWidget.from(SceneObject object, {Key? key}) : this(object: object, key: key);

  final SceneObject object;

  @override
  Widget build(BuildContext context) {
    return switch (object) {
      ContainerObject o => ContainerObjectWidget(object: o),
      RectangleObject o => RectangleObjectWidget(object: o),
      _ => throw UnimplementedError('unknown object ${object.runtimeType} (${object.id})'),
    };
  }
}
