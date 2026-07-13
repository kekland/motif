part of 'widgets.dart';

class SceneObjectBuilder extends StatelessWidget {
  const SceneObjectBuilder({
    super.key,
    required this.object,
    required this.builder,
  });

  final SceneObject object;
  final WidgetBuilder? builder;

  @override
  Widget build(BuildContext context) {
    final builder = this.builder;

    return RenderSceneObjectLayoutTransformWidget(
      object: object,
      child: RenderSceneObjectWidget(
        object: object,
        child: builder != null ? HookBuilder(builder: builder) : null,
      ),
    );
  }
}
