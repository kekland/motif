part of '../data.dart';

mixin ContainerNode implements Node, NodeWithFill {
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
  });

  ImmutableContainerNode.fromMutable(MutableContainerNode node)
    : this(
        name: node.name,
        layout: node.layout,
        transform: node.transform,
        fill: node.fill,
        children: _nodeListToImmutable(node.children),
      );

  @override
  final NodeFillData fill;

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
  }) => .new(
    parent: parent ?? this.parent,
    children: children ?? this.children.toList(),
    name: name ?? this.name,
    transform: transform ?? this.transform,
    layout: layout ?? this.layout,
    fill: fill ?? this.fill,
  );
}

final class MutableContainerNode extends MutableNode with ContainerNode, MutableNodeWithFill {
  MutableContainerNode({
    super.children,
    super.name,
    super.layout,
    super.transform,
    NodeFillData fill = .transparent,
  }) {
    _fillSignal = $signal(fill);
    notifyListenersOn([_fillSignal]);
  }

  MutableContainerNode.fromImmutable(ImmutableContainerNode node)
    : this(
        name: node.name,
        layout: node.layout,
        transform: node.transform,
        fill: node.fill,
        children: _nodeListToMutable(node.children),
      );

  @override
  ImmutableContainerNode copyAsImmutable() => .fromMutable(this);
}
