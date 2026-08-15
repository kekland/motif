part of '../core.dart';

final class ContainerObject extends SceneObject with MultiChildSceneObject, TopologicalSceneObject, SceneObjectWithShape {
  ContainerObject({
    super.id,
    super.transform,
    super.size,
    this._childLayout = .stack,
    ObjectShape shape = .default_,
    List<SceneNode> children = const [],
  }) {
    _shape = shape;
    _children.addAll(children);
  }

  ContainerChildLayout _childLayout;
  ContainerChildLayout get childLayout => _childLayout;
  set childLayout(ContainerChildLayout value) {
    if (_childLayout == value) return;
    _childLayout = value;
    _markNeedsLayout(.size);
  }

  @override
  bool controlsChildTransform(SceneObject child) {
    return _childLayout.type == .flex;
  }

  @override
  Topology produceTopology(ResolvedSize size) => shape.produceTopology(size);

  @override
  void performLayout(ObjectConstraints constraints) {
    final sceneObjects = <SceneObject>[];
    for (final child in children) {
      if (child is SceneObject) {
        sceneObjects.add(child);
      } else {
        child.layout();
      }
    }

    _resolvedSize = _childLayout.layout(size, constraints, sceneObjects);
    super.performLayout(constraints);
  }

  @override
  NodeType get type => .container;
}
