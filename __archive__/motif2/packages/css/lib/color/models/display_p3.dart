part of '../color.dart';

/// https://www.w3.org/TR/css-color-4/#predefined-display-p3
/// - r: 0-1
/// - g: 0-1
/// - b: 0-1
final class DisplayP3ColorData extends ColorData {
  const DisplayP3ColorData({double r = .nan, double g = .nan, double b = .nan, super.alpha})
    : super(v1: r, v2: g, v3: b);

  double get r => _v1;
  double get g => _v2;
  double get b => _v3;

  @override
  ColorModel get model => .displayP3;

  @override
  DisplayP3ColorData withAlpha(double alpha) => copyWith(alpha: alpha);
  DisplayP3ColorData copyWith({double? r, double? g, double? b, double? alpha}) =>
      .new(r: r ?? this.r, g: g ?? this.g, b: b ?? this.b, alpha: alpha ?? this.alpha);

  @override
  Map<ColorComponent, double> get components => {
    .red: r,
    .green: g,
    .blue: b,
    .alpha: alpha,
  };

  @override
  DisplayP3ColorData copyWithComponents(Map<ColorComponent, double> components) => copyWith(
    r: components[ColorComponent.red] ?? r,
    g: components[ColorComponent.green] ?? g,
    b: components[ColorComponent.blue] ?? b,
    alpha: components[ColorComponent.alpha] ?? alpha,
  );

  @override
  String toString() => _Serializer.toCssString(this, modelName: 'display-p3', hasOwnFunction: false);
}

/// https://www.w3.org/TR/css-color-4/#predefined-display-p3
/// - r: 0-1
/// - g: 0-1
/// - b: 0-1
final class DisplayP3LinearColorData extends ColorData {
  const DisplayP3LinearColorData({double r = .nan, double g = .nan, double b = .nan, super.alpha})
    : super(v1: r, v2: g, v3: b);

  double get r => _v1;
  double get g => _v2;
  double get b => _v3;

  @override
  ColorModel get model => .displayP3Linear;

  @override
  DisplayP3LinearColorData withAlpha(double alpha) => copyWith(alpha: alpha);
  DisplayP3LinearColorData copyWith({double? r, double? g, double? b, double? alpha}) =>
      .new(r: r ?? this.r, g: g ?? this.g, b: b ?? this.b, alpha: alpha ?? this.alpha);

  @override
  Map<ColorComponent, double> get components => {
    .red: r,
    .green: g,
    .blue: b,
    .alpha: alpha,
  };

  @override
  DisplayP3LinearColorData copyWithComponents(Map<ColorComponent, double> components) => copyWith(
    r: components[ColorComponent.red] ?? r,
    g: components[ColorComponent.green] ?? g,
    b: components[ColorComponent.blue] ?? b,
    alpha: components[ColorComponent.alpha] ?? alpha,
  );

  @override
  String toString() => _Serializer.toCssString(this, modelName: 'display-p3-linear', hasOwnFunction: false);
}
