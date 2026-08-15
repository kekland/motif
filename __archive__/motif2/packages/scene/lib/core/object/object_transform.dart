part of '../core.dart';

extension type ObjectTransform._(Matrix4 value) {
  ObjectTransform({
    Vector2? translation,
    Vector2? scale,
    double? rotation,
  }) : this._(
         .identity()
           ..translateByVector2(translation ?? .zero())
           ..scaleByDouble(scale?.x ?? 1.0, scale?.y ?? 1.0, 1.0, 1.0)
           ..rotateZ(rotation ?? 0.0),
       );

  ObjectTransform.translationValues(double x, double y, [double z = 0.0])
    : this._(.identity()..translateByDouble(x, y, z, 1.0));

  ObjectTransform.raw(Matrix4 m) : this._(m);
  ObjectTransform.identity() : this._(.identity());

  void _setFrom(ObjectTransform other) {
    value.setFrom(other.value);
  }

  double operator [](int index) => value[index];
  double get dx => value[12];
  double get dy => value[13];

  Vector2 get translation => value.getTranslation().xy;
  ObjectTransform copyWithTranslation(Vector2 translation) => translated(translation - this.translation);
  ObjectTransform translated(Vector2 translation) {
    final translationMatrix = Matrix4.translationValues(translation.x, translation.y, 0.0);
    return .raw(translationMatrix * value);
  }

  double get rotation => value.getRotation().toEulerAngles().z;
  ObjectTransform copyWithRotation(double rotation, {Vector2? anchor}) => rotated(
    rotation - this.rotation,
    anchor: anchor,
  );

  ObjectTransform rotatedCw({Vector2? anchor}) => rotated(math.pi / 2.0, anchor: anchor);
  ObjectTransform rotatedCcw({Vector2? anchor}) => rotated(-math.pi / 2.0, anchor: anchor);
  ObjectTransform rotated(double rotation, {Vector2? anchor}) {
    final pivot = anchor ?? translation;
    final matrix = Matrix4.identity()
      ..translateByVector2(pivot)
      ..rotateZ(rotation)
      ..translateByVector2(-pivot);

    return .raw(matrix * value);
  }

  ObjectTransform clone() => .raw(value.clone());
}
