part of '../data.dart';

mixin ContainerNode implements Node, NodeWithShape, NodeWithFill {
  @override
  bool get isLeaf => false;
}

final class ImmutableContainerNode extends ImmutableNode with ContainerNode {
  ImmutableContainerNode({
    super.parent,
    super.children,
    super.name,
    super.layout,
    super.transform,
    this.fill = .transparent,
    this.shape = .defaultShape,
  });

  ImmutableContainerNode.fromMutable(MutableContainerNode node)
    : this(
        name: node.name,
        layout: node.layout,
        transform: node.transform,
        fill: node.fill,
        shape: node.shape,
        children: _nodeListToImmutable(node.children),
      );

  // dart format off 
  @override final NodeFillData fill;
  @override final NodeShapeData shape;
  // dart format on

  @override
  MutableContainerNode copyAsMutable() => .fromImmutable(this);

  @override
  ImmutableContainerNode copyWith({
    ImmutableNode? parent,
    List<ImmutableNode>? children,
    String? name,
    NodeTransformData? transform,
    NodeLayoutData? layout,
    NodeFillData? fill,
    NodeShapeData? shape,
  }) => .new(
    parent: parent ?? this.parent,
    children: children ?? this.children.toList(),
    name: name ?? this.name,
    transform: transform ?? this.transform,
    layout: layout ?? this.layout,
    fill: fill ?? this.fill,
    shape: shape ?? this.shape,
  );
}

final class MutableContainerNode extends MutableNode with ContainerNode, MutableNodeWithShape, MutableNodeWithFill {
  MutableContainerNode({
    super.children,
    super.name,
    super.layout,
    super.transform,
    NodeFillData fill = .transparent,
    NodeShapeData shape = .defaultShape,
  }) {
    _fillSignal = $signal(fill);
    _shapeSignal = $signal(shape);
    notifyListenersOn([_fillSignal, _shapeSignal]);
  }

  MutableContainerNode.fromImmutable(ImmutableContainerNode node)
    : this(
        name: node.name,
        layout: node.layout,
        transform: node.transform,
        fill: node.fill,
        shape: node.shape,
        children: _nodeListToMutable(node.children),
      );

  @override
  ImmutableContainerNode copyAsImmutable() => .fromMutable(this);
}
