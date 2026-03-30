part of '../data.dart';

mixin RootNode implements Node {
  @override
  bool get isLeaf => false;
}

final class ImmutableRootNode extends ImmutableNode with RootNode {
  ImmutableRootNode({
    super.parent,
    super.children,
  }) : super(layout: .infinity, transform: .identity, name: 'root');

  ImmutableRootNode.fromMutable(MutableRootNode node) : this(children: _nodeListToImmutable(node.children));

  @override
  MutableRootNode copyAsMutable() => .fromImmutable(this);

  @override
  ImmutableRootNode copyWith({
    ImmutableNode? parent,
    List<ImmutableNode>? children,
    String? name,
    NodeTransformData? transform,
    NodeLayoutData? layout,
  }) => .new(parent: parent ?? this.parent, children: children ?? this.children);
}

final class MutableRootNode extends MutableNode with RootNode {
  MutableRootNode({super.children}) : super(layout: .infinity, transform: .identity, name: 'root');

  MutableRootNode.fromImmutable(ImmutableRootNode node) : this(children: _nodeListToMutable(node.children));

  @override
  ImmutableRootNode copyAsImmutable() => .fromMutable(this);
}
