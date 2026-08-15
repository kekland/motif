part of '../core.dart';

final class RootObject extends SceneObject with MultiChildSceneObject {
  RootObject({
    List<SceneNode> children = const [],
  }) : super(size: .infinity, transform: .identity()) {
    _constraints = ObjectConstraints.none;
    _addChildren(children);
  }

  @override
  MultiChildSceneObject? get parent => null;

  @override
  int get depth => 0;

  @override
  bool get isLayoutBoundary => true;

  @override
  set size(ObjectSize value) => throw UnsupportedError('RootSceneObject size cannot be changed.');

  @override
  set transform(ObjectTransform value) => throw UnsupportedError('RootSceneObject transform cannot be changed.');

  @override
  bool hitTestSelf(Vector2 localPosition, {Matrix4? globalToScene}) => true;

  @override
  void layout([covariant LayoutConstraints? constraints]) {
    _resolvedSize = .new(.infinity, .infinity);
    super.layout(constraints);
  }

  @override
  void performLayout(ObjectConstraints constraints) {
    for (final child in children) {
      if (child is SceneObject) {
        child.layout(constraints);
      } else {
        child.layout();
      }
    }

    _resolvedSize = size.resolve(constraints);
  }

  @override
  NodeType get type => .root;
}
