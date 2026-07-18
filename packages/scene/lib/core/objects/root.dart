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
  ReadonlySignal<RootObject> call() => _scene!._signalFor(this);

  @override
  bool hitTestSelf(Vector2 localPosition, {Matrix4? globalToScene}) => true;
}
