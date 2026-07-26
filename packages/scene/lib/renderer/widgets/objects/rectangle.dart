part of '../widgets.dart';

class RectangleObjectWidget extends StatelessWidget {
  const RectangleObjectWidget({super.key, required this.object});

  final RectangleObject object;

  @override
  Widget build(BuildContext context) {
    return SceneObjectBuilder(
      object: object,
      builder: (context, child) => DecoratedBox(
        decoration: BoxDecoration(color: Colors.blue),
        child: child,
      ),
    );
  }
}
