part of '../widgets.dart';

class ContainerObjectWidget extends StatelessWidget {
  const ContainerObjectWidget({super.key, required this.object});

  final ContainerObject object;

  @override
  Widget build(BuildContext context) {
    return SceneObjectBuilder(
      object: object,
      builder: (context) => Container(
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 1.0),
        ),
        child: Stack(
          children: object.children.map(SceneNodeWidget.from).toList(),
        ),
      ),
    );
  }
}
