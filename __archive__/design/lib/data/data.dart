import 'dart:math' as math;

import 'package:design/imports.dart';
import 'package:tree/tree.dart' as tree;

part 'properties/fill.dart';
part 'properties/layout.dart';
part 'properties/shape.dart';
part 'properties/transform.dart';

part 'nodes/container.dart';
part 'nodes/root.dart';
part 'nodes/text.dart';
part 'nodes/vector.dart';

List<ImmutableNode> _nodeListToImmutable(List<MutableNode> nodes) => nodes.map((n) => n.copyAsImmutable()).toList();
List<MutableNode> _nodeListToMutable(List<ImmutableNode> nodes) => nodes.map((n) => n.copyAsMutable()).toList();

/// An interface representing an abstract node in the design tree.
///
/// There are two direct subclasses: [ImmutableNode] and [MutableNode].
///
/// All nodes have a [transform] and [layout] properties.
abstract interface class Node with NodeWithLayout, NodeWithTransform implements tree.Node {
  @override
  List<Node> get children;

  @override
  Node? get parent;

  /// Name of the node. Not necessarily unique.
  String get name;
}

/// An immutable node in the design tree. Can only be modified by creating a new instance with updated properties.
///
/// Can be copied to a mutable node using [copyAsMutable] method, which creates a mutable copy of this node and its
/// descendants.
abstract class ImmutableNode extends tree.ImmutableNodeBase<ImmutableNode, MutableNode>
    with tree.NodeImplementations<ImmutableNode>
    implements Node {
  ImmutableNode({
    super.children,
    super.parent,
    this.name = '',
    this.transform = .identity,
    this.layout = .zero,
  });

  // dart format off
  @override final String name;
  @override final NodeTransformData transform;
  @override final NodeLayoutData layout;
  // dart format on

  @override
  ImmutableNode copyWith({
    ImmutableNode? parent,
    List<ImmutableNode>? children,
    String? name,
    NodeTransformData? transform,
    NodeLayoutData? layout,
  });

  @override
  String toString() => 'ImmutableNode($name, children: ${children.length})';
}

/// A mutable node in the design tree. Can be modified by updating its properties directly.
///
/// Note: mutable nodes are [ChangeNotifier]s. Make sure to dispose them properly to avoid memory leaks.
///
/// Can be copied to an immutable node using [copyAsImmutable] method, which creates an immutable copy of this node and
/// its descendants.
abstract class MutableNode extends tree.MutableNodeBase<MutableNode, ImmutableNode>
    with tree.NodeImplementations<MutableNode>, MutableNodeWithTransform, MutableNodeWithLayout
    implements Node {
  MutableNode({
    super.children,
    String name = '',
    NodeTransformData transform = .identity,
    NodeLayoutData layout = .zero,
  }) {
    _nameSignal = $signal(name);
    _transformSignal = $signal(transform);
    _layoutSignal = $signal(layout);

    notifyListenersOn([_nameSignal, _transformSignal, _layoutSignal]);
  }

  // dart format off
  late final Signal<String> _nameSignal;
  @override String get name => _nameSignal.value;
  set name(String value) => _nameSignal.value = value;
  // dart format on

  @override
  String toString() => 'MutableNode($name, children: ${children.length})';
}
