part of '../data.dart';

/// Represents node's fill properties, like colors, gradients, patterns, etc.
final class NodeFillData with EquatableMixin {
  const NodeFillData();
  static const transparent = NodeFillData();

  @override
  List<Object?> get props => [];
}

// Convenience mixin for nodes with fill properties.
mixin NodeWithFill on Node {
  NodeFillData get fill;
}

mixin MutableNodeWithFill implements NodeWithFill {
  // dart format off
  late final Signal<NodeFillData> _fillSignal;
  @override NodeFillData get fill => _fillSignal.value;
  set fill(NodeFillData value) => _fillSignal.value = value;
  // dart format on
}
