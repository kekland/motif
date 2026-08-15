part of 'widgets.dart';

class SceneObjectBuilder extends HookWidget {
  const SceneObjectBuilder({
    super.key,
    required this.object,
    required this.builder,
  });

  final SceneObject object;
  final Widget Function(BuildContext context, Widget? child)? builder;

  @override
  Widget build(BuildContext context) {
    useListenable(object(.paint));

    final builder = this.builder;
    final child = SceneObjectChildrenWidget(object: object);

    return RenderSceneObjectWidget(
      object: object,
      child: builder?.call(context, child),
    );
  }
}
