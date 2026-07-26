import 'package:scene/renderer.dart';
import 'package:ui/ui.dart';

class SceneObjectChildrenWidget extends HookWidget {
  const SceneObjectChildrenWidget({super.key, required this.object});

  final SceneObject object;

  @override
  Widget build(BuildContext context) {
    useListenable(object(.children));
    final children = object.children;

    return CustomMultiChildLayout(
      delegate: SceneContainerLayoutDelegate(childCount: children.length),
      children: [
        for (var i = 0; i < children.length; i++)
          LayoutId(
            key: ValueKey(children[i].id),
            id: i,
            child: sceneNodeWidget(context, children[i]),
          ),
      ],
    );
  }
}

class SceneContainerLayoutDelegate extends MultiChildLayoutDelegate {
  SceneContainerLayoutDelegate({super.relayout, required this.childCount});

  final int childCount;

  @override
  void performLayout(Size size) {
    const constraints = BoxConstraints();
    for (var i = 0; i < childCount; i++) {
      layoutChild(i, constraints);
      positionChild(i, .zero);
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) =>
      oldDelegate is SceneContainerLayoutDelegate && oldDelegate.childCount != childCount;
}
