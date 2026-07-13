part of '../core.dart';

final class RootObject extends SceneObject with MultiChildSceneObject {
  RootObject() : super(size: .infinity, transform: .identity());

  @override
  int get depth => 0;

  @override
  set size(ObjectSize value) => throw UnsupportedError('RootSceneObject size cannot be changed.');

  @override
  set transform(ObjectTransform value) => throw UnsupportedError('RootSceneObject transform cannot be changed.');

  @override
  ReadonlySignal<RootObject> call() => _scene!._signalFor(this);
}
