part of '../data.dart';

/// Represents node's fill properties, like colors, gradients, patterns, etc.
final class NodeFillData with EquatableMixin {
  const NodeFillData({required this.color});

  static const transparent = NodeFillData(color: .transparent);
  static const red = NodeFillData(color: .red);
  static const green = NodeFillData(color: .green);
  static const blue = NodeFillData(color: .blue);

  final ColorData color;

  NodeFillData copyWith({ColorData? color}) {
    return NodeFillData(
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [color];
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
