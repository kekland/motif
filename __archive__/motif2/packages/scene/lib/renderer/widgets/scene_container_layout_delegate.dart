import 'package:scene/renderer.dart';
import 'package:ui/ui.dart';

class SceneObjectChildrenWidget extends HookWidget {
  const SceneObjectChildrenWidget({super.key, required this.object});

  final SceneObject object;

  @override
  Widget build(BuildContext context) {
    useListenable(object(.children));
    final children = object.children;

    final widgetChildren = <LayoutId>[];
    var i = 0;
    for (final child in children) {
      final widget = sceneNodeWidget(context, child);
      if (widget != null) {
        widgetChildren.add(
          LayoutId(
            key: ValueKey(child.id),
            id: i,
            child: widget,
          ),
        );
        i++;
      }
    }

    return CustomMultiChildLayout(
      delegate: SceneContainerLayoutDelegate(childCount: i),
      children: widgetChildren
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
