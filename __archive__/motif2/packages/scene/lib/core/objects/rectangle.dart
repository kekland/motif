part of '../core.dart';

final class RectangleObject extends SceneObject with TopologicalSceneObject, SceneObjectWithShape {
  RectangleObject({
    super.id,
    super.transform,
    super.size,
    ObjectShape shape = .default_,
  }) {
    _shape = shape;
  }

  @override
  Topology produceTopology(ResolvedSize size) => shape.produceTopology(size);

  @override
  NodeType get type => .rectangle;
}
