part of '../data.dart';

/// Represents node's shape properties: shape type, corner radius, etc.
sealed class NodeShapeData with EquatableMixin {
  const NodeShapeData();
  static const defaultShape = NodeShapeData.rectangle();

  const factory NodeShapeData.rectangle({BorderRadius borderRadius}) = RectangleNodeShapeData;
  const factory NodeShapeData.ellipse({double eccentricity}) = EllipseNodeShapeData;
}

final class RectangleNodeShapeData extends NodeShapeData {
  const RectangleNodeShapeData({this.borderRadius = .zero});

  final BorderRadius borderRadius;

  RectangleNodeShapeData copyWith({BorderRadius? borderRadius}) {
    return RectangleNodeShapeData(
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  List<Object?> get props => [borderRadius];
}

final class EllipseNodeShapeData extends NodeShapeData {
  const EllipseNodeShapeData({this.eccentricity = 1.0});

  final double eccentricity;

  EllipseNodeShapeData copyWith({double? eccentricity}) {
    return EllipseNodeShapeData(
      eccentricity: eccentricity ?? this.eccentricity,
    );
  }

  @override
  List<Object?> get props => [eccentricity];
}

// Convenience mixin for nodes with shape properties.
mixin NodeWithShape on Node {
  NodeShapeData get shape;
}

mixin MutableNodeWithShape implements NodeWithShape {
  // dart format off
  late final Signal<NodeShapeData> _shapeSignal;
  @override NodeShapeData get shape => _shapeSignal.value;
  set shape(NodeShapeData value) => _shapeSignal.value = value;
  // dart format on
}
