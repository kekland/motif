part of '../core.dart';

final class RootObject extends SceneObject with MultiChildSceneObject {
  RootObject({
    List<SceneNode> children = const [],
  }) : super(size: .infinity, transform: .identity()) {
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
  void performLayout(LayoutConstraints constraints) {
    for (final child in children) child.layout(constraints);
    _resolvedSize = size.resolve(constraints);
  }

  @override
  NodeType get type => .root;
}
