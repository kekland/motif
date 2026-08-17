part of '../color.dart';

/// https://www.w3.org/TR/css-color-4/#predefined-sRGB
/// - r: 0-1
/// - g: 0-1
/// - b: 0-1
final class SrgbColorData extends ColorData {
  const SrgbColorData({double r = .nan, double g = .nan, double b = .nan, super.alpha}) : super(v1: r, v2: g, v3: b);

  double get r => _v1;
  double get g => _v2;
  double get b => _v3;

  @override
  ColorModel get model => .srgb;

  @override
  SrgbColorData withAlpha(double alpha) => copyWith(alpha: alpha);
  SrgbColorData copyWith({double? r, double? g, double? b, double? alpha}) =>
      .new(r: r ?? this.r, g: g ?? this.g, b: b ?? this.b, alpha: alpha ?? this.alpha);

  @override
  Map<ColorComponent, double> get components => {
    .red: r,
    .green: g,
    .blue: b,
    .alpha: alpha,
  };

  @override
  SrgbColorData copyWithComponents(Map<ColorComponent, double> components) => copyWith(
    r: components[ColorComponent.red] ?? r,
    g: components[ColorComponent.green] ?? g,
    b: components[ColorComponent.blue] ?? b,
    alpha: components[ColorComponent.alpha] ?? alpha,
  );

  @override
  String toString() => _Serializer.toCssString(this, modelName: 'rgb');
}

/// https://www.w3.org/TR/css-color-4/#predefined-sRGB-linear
/// - r: 0-1
/// - g: 0-1
/// - b: 0-1
final class SrgbLinearColorData extends ColorData {
  const SrgbLinearColorData({double r = .nan, double g = .nan, double b = .nan, super.alpha})
    : super(v1: r, v2: g, v3: b);

  double get r => _v1;
  double get g => _v2;
  double get b => _v3;

  @override
  ColorModel get model => .srgbLinear;

  @override
  SrgbLinearColorData withAlpha(double alpha) => copyWith(alpha: alpha);
  SrgbLinearColorData copyWith({double? r, double? g, double? b, double? alpha}) =>
      .new(r: r ?? this.r, g: g ?? this.g, b: b ?? this.b, alpha: alpha ?? this.alpha);

  @override
  Map<ColorComponent, double> get components => {
    .red: r,
    .green: g,
    .blue: b,
    .alpha: alpha,
  };

  @override
  SrgbLinearColorData copyWithComponents(Map<ColorComponent, double> components) => copyWith(
    r: components[ColorComponent.red] ?? r,
    g: components[ColorComponent.green] ?? g,
    b: components[ColorComponent.blue] ?? b,
    alpha: components[ColorComponent.alpha] ?? alpha,
  );

  @override
  String toString() => _Serializer.toCssString(this, modelName: 'srgb-linear', hasOwnFunction: false);
}
