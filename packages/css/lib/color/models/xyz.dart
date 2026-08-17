part of '../color.dart';

/// Base class for XYZ color data (with unspecified white point).
/// - x: 0-inf
/// - y: 0-inf
/// - z: 0-inf
sealed class _XyzColorData extends ColorData {
  const _XyzColorData({double x = .nan, double y = .nan, double z = .nan, super.alpha}) : super(v1: x, v2: y, v3: z);

  double get x => _v1;
  double get y => _v2;
  double get z => _v3;

  @override
  Map<ColorComponent, double> get components => {
    .red: x,
    .green: y,
    .blue: z,
    .alpha: alpha,
  };
}

/// https://www.w3.org/TR/css-color-4/#predefined-xyz
/// - x: 0-inf
/// - y: 0-inf
/// - z: 0-inf
final class XyzD65ColorData extends _XyzColorData {
  const XyzD65ColorData({super.x, super.y, super.z, super.alpha});

  @override
  ColorModel get model => .xyzD65;

  @override
  XyzD65ColorData withAlpha(double alpha) => copyWith(alpha: alpha);
  XyzD65ColorData copyWith({double? x, double? y, double? z, double? alpha}) =>
      .new(x: x ?? this.x, y: y ?? this.y, z: z ?? this.z, alpha: alpha ?? this.alpha);

  @override
  XyzD65ColorData copyWithComponents(Map<ColorComponent, double> components) => copyWith(
    x: components[ColorComponent.red] ?? x,
    y: components[ColorComponent.green] ?? y,
    z: components[ColorComponent.blue] ?? z,
    alpha: components[ColorComponent.alpha] ?? alpha,
  );

  @override
  String toString() => _Serializer.toCssString(this, modelName: 'xyz-d65', hasOwnFunction: false);
}

/// https://www.w3.org/TR/css-color-4/#predefined-xyz
/// - x: 0-inf
/// - y: 0-inf
/// - z: 0-inf
final class XyzD50ColorData extends _XyzColorData {
  const XyzD50ColorData({super.x, super.y, super.z, super.alpha});

  @override
  ColorModel get model => .xyzD50;

  @override
  XyzD50ColorData withAlpha(double alpha) => copyWith(alpha: alpha);
  XyzD50ColorData copyWith({double? x, double? y, double? z, double? alpha}) =>
      .new(x: x ?? this.x, y: y ?? this.y, z: z ?? this.z, alpha: alpha ?? this.alpha);

  @override
  XyzD50ColorData copyWithComponents(Map<ColorComponent, double> components) => copyWith(
    x: components[ColorComponent.red] ?? x,
    y: components[ColorComponent.green] ?? y,
    z: components[ColorComponent.blue] ?? z,
    alpha: components[ColorComponent.alpha] ?? alpha,
  );

  @override
  String toString() => _Serializer.toCssString(this, modelName: 'xyz-d50', hasOwnFunction: false);
}
