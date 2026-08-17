part of '../color.dart';

/// https://www.w3.org/TR/css-color-4/#the-hsl-notation
/// - h: 0-360 (nan if s <= 0.001)
/// - s: 0-100
/// - l: 0-100
final class HslColorData extends ColorData {
  const HslColorData({double h = .nan, double s = .nan, double l = .nan, super.alpha}) : super(v1: h, v2: s, v3: l);
  static const _epsilon = 1 / 1000.0;

  double get h => s <= _epsilon ? .nan : _v1;
  double get s => _v2;
  double get l => _v3;

  @override
  ColorModel get model => .hsl;

  @override
  HslColorData withAlpha(double alpha) => copyWith(alpha: alpha);
  HslColorData copyWith({double? h, double? s, double? l, double? alpha}) =>
      .new(h: h ?? this.h, s: s ?? this.s, l: l ?? this.l, alpha: alpha ?? this.alpha);

  @override
  Map<ColorComponent, double> get components => {
    .hue: h,
    .colorfulness: s,
    .lightness: l,
    .alpha: alpha,
  };

  @override
  HslColorData copyWithComponents(Map<ColorComponent, double> components) => copyWith(
    h: components[ColorComponent.hue] ?? h,
    s: components[ColorComponent.colorfulness] ?? s,
    l: components[ColorComponent.lightness] ?? l,
    alpha: components[ColorComponent.alpha] ?? alpha,
  );

  @override
  String toString() => _Serializer.toCssString(this, modelName: 'hsl');
}

/// Doesn't exist in CSS Color 4, but is pretty common.
/// - h: 0-360 (nan if v <= 0.001)
/// - s: 0-100
/// - v: 0-100
final class HsvColorData extends ColorData {
  const HsvColorData({double h = .nan, double s = .nan, double v = .nan, super.alpha}) : super(v1: h, v2: s, v3: v);
  static const _epsilon = 1 / 1000.0;

  double get h => s <= _epsilon ? .nan : _v1;
  double get s => _v2;
  double get v => _v3;

  @override
  ColorModel get model => .hsv;

  @override
  HsvColorData withAlpha(double alpha) => copyWith(alpha: alpha);
  HsvColorData copyWith({double? h, double? s, double? v, double? alpha}) =>
      .new(h: h ?? this.h, s: s ?? this.s, v: v ?? this.v, alpha: alpha ?? this.alpha);

  @override
  Map<ColorComponent, double> get components => {
    .hue: h,
    .colorfulness: s,
    .alpha: alpha,
  };

  @override
  HsvColorData copyWithComponents(Map<ColorComponent, double> components) => copyWith(
    h: components[ColorComponent.hue] ?? h,
    s: components[ColorComponent.colorfulness] ?? s,
    alpha: components[ColorComponent.alpha] ?? alpha,
  );

  @override
  String toString() => _Serializer.toCssString(this, modelName: 'hsv');
}

/// https://www.w3.org/TR/css-color-4/#the-hwb-notation
/// - h: 0-360 (nan if w + b >= 99.999)
/// - w: 0-100
/// - b: 0-100
final class HwbColorData extends ColorData {
  const HwbColorData({double h = .nan, double w = .nan, double b = .nan, super.alpha}) : super(v1: h, v2: w, v3: b);
  static const _epsilon = 100.0 - (1 / 1000.0);

  double get h => (w + b) >= _epsilon ? .nan : _v1;
  double get w => _v2;
  double get b => _v3;

  @override
  ColorModel get model => .hwb;

  @override
  HwbColorData withAlpha(double alpha) => copyWith(alpha: alpha);
  HwbColorData copyWith({double? h, double? w, double? b, double? alpha}) =>
      .new(h: h ?? this.h, w: w ?? this.w, b: b ?? this.b, alpha: alpha ?? this.alpha);

  @override
  Map<ColorComponent, double> get components => {
    .hue: h,
    .alpha: alpha,
  };

  @override
  HwbColorData copyWithComponents(Map<ColorComponent, double> components) => copyWith(
    h: components[ColorComponent.hue] ?? h,
    alpha: components[ColorComponent.alpha] ?? alpha,
  );

  @override
  String toString() => _Serializer.toCssString(this, modelName: 'hwb');
}
