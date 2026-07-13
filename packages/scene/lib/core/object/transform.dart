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

  void _setTranslationRaw(double x, double y, [double z = 0.0]) {
    value.setTranslationRaw(x, y, z);
  }

  double operator [](int index) => value[index];
  double get dx => value[12];
  double get dy => value[13];

  ObjectTransform translated(Vector2 offset) {
    final translationMatrix = Matrix4.translationValues(offset.x, offset.y, 0.0);
    return .raw(translationMatrix * value);
  }
}
