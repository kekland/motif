part of '../data.dart';

/// Represents node's transformation properties: translation, rotation, scale, shear, etc.
///
/// Note: the translation is not always respected during layout. If the parent of the node offers non-absolute layout
/// options, then the childrens' translations will be ignored during layout.
class NodeTransformData with EquatableMixin {
  NodeTransformData({Offset? translation, Offset? scale, double? rotation})
    : _value = Matrix4.identity()
        ..translateByDouble(translation?.dx ?? 0, translation?.dy ?? 0, 0, 1)
        ..scaleByDouble(scale?.dx ?? 1, scale?.dy ?? 1, 1, 1)
        ..rotateZ(rotation ?? 0);

  const NodeTransformData.raw(Matrix4? value) : _value = value;
  static const identity = NodeTransformData.raw(null);

  /// Transformation applied to this node.
  final Matrix4? _value;
  Matrix4 get value => _value ?? Matrix4.identity();

  @override
  List<Object?> get props => [value];

  NodeTransformData copyWith({Matrix4? value}) => .raw(Matrix4.copy(value ?? this.value));

  // --
  // Translation
  // --

  Offset get translation => value.getTranslation().xy.asOffset();
  NodeTransformData copyWithTranslation(Offset translation) => translated(translation - this.translation);
  NodeTransformData translated(Offset translation) {
    final translationMatrix = Matrix4.translationValues(translation.dx, translation.dy, 0.0);
    return NodeTransformData.raw(translationMatrix * value);
  }

  // --
  // Rotation
  // --

  double get rotation => value.getRotation().toEulerAngles().z;
  NodeTransformData copyWithRotation(double rotation, {Offset? anchor}) => rotated(
    rotation - this.rotation,
    anchor: anchor,
  );

  NodeTransformData rotatedCw({Offset? anchor}) => rotated(math.pi / 2, anchor: anchor);
  NodeTransformData rotatedCcw({Offset? anchor}) => rotated(-math.pi / 2, anchor: anchor);
  NodeTransformData rotated(double rotation, {Offset? anchor}) {
    final pivot = anchor ?? translation;

    final rotationMatrix = Matrix4.identity()
      ..translateByDouble(pivot.dx, pivot.dy, 0.0, 1.0)
      ..rotateZ(rotation)
      ..translateByDouble(-pivot.dx, -pivot.dy, 0.0, 1.0);

    return NodeTransformData.raw(rotationMatrix * value);
  }
}

// Convenience mixins for nodes that have transform properties.
mixin NodeWithTransform {
  /// Node's transformation properties.
  NodeTransformData get transform;
}

mixin MutableNodeWithTransform implements NodeWithTransform {
  // dart format off
  late final Signal<NodeTransformData> _transformSignal;
  @override NodeTransformData get transform => _transformSignal.value;
  set transform(NodeTransformData value) => _transformSignal.value = value;
  // dart format on
}
