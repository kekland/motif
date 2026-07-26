part of '../../core.dart';

ResolvedSize _layoutStack(
  StackContainerChildLayout layout,
  ObjectSize size,
  LayoutConstraints constraints,
  List<SceneObject> children,
) {
  for (final child in children) {
    child.layout(constraints);
  }

  return size.resolve(constraints);
}
