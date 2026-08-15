part of '../widgets.dart';

class ContainerObjectWidget extends StatelessWidget {
  const ContainerObjectWidget({super.key, required this.object});

  final ContainerObject object;

  @override
  Widget build(BuildContext context) {
    return SceneObjectBuilder(
      object: object,
      builder: (context, child) => DecoratedBox(
        position: .background,
        decoration: BoxDecoration(
          // color: Colors.blue.withScaledAlpha(0.5),
          border: Border.all(color: Colors.red, width: 0.0),
        ),
        child: child,
      ),
    );
  }
}
