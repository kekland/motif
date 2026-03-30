part of '../color.dart';

/// https://www.w3.org/TR/css-color-4/#specifying-lab-lch
/// - l: 0-100
/// - a: -0.4-0.4
/// - b: -0.4-0.4
final class OklabColorData extends ColorData {
  const OklabColorData({double l = .nan, double a = .nan, double b = .nan, super.alpha}) : super(v1: l, v2: a, v3: b);

  double get l => _v1;
  double get a => _v2;
  double get b => _v3;

  @override
  ColorModel get model => .oklab;

  @override
  OklabColorData withAlpha(double alpha) => copyWith(alpha: alpha);
  OklabColorData copyWith({double? l, double? a, double? b, double? alpha}) =>
      .new(l: l ?? this.l, a: a ?? this.a, b: b ?? this.b, alpha: alpha ?? this.alpha);

  @override
  Map<ColorComponent, double> get components => {
    .lightness: l,
    .opponentA: a,
    .opponentB: b,
    .alpha: alpha,
  };

  @override
  OklabColorData copyWithComponents(Map<ColorComponent, double> components) => copyWith(
    l: components[ColorComponent.lightness] ?? l,
    a: components[ColorComponent.opponentA] ?? a,
    b: components[ColorComponent.opponentB] ?? b,
    alpha: components[ColorComponent.alpha] ?? alpha,
  );

  @override
  String toString() => _Serializer.toCssString(this, modelName: 'oklab');
}

/// https://www.w3.org/TR/css-color-4/#specifying-lab-lch
/// - l: 0-100
/// - c: 0-inf
/// - h: 0-360 (nan if c <= 0.000004)
final class OklchColorData extends ColorData {
  const OklchColorData({double l = .nan, double c = .nan, double h = .nan, super.alpha}) : super(v1: l, v2: c, v3: h);
  static const _epsilon = 0.000004;

  double get l => _v1;
  double get c => _v2;
  double get h => c <= _epsilon ? .nan : _v3;

  @override
  ColorModel get model => .oklch;

  @override
  OklchColorData withAlpha(double alpha) => copyWith(alpha: alpha);
  OklchColorData copyWith({double? l, double? c, double? h, double? alpha}) =>
      .new(l: l ?? this.l, c: c ?? this.c, h: h ?? this.h, alpha: alpha ?? this.alpha);

  @override
  Map<ColorComponent, double> get components => {
    .lightness: l,
    .colorfulness: c,
    .hue: h,
    .alpha: alpha,
  };

  @override
  OklchColorData copyWithComponents(Map<ColorComponent, double> components) => copyWith(
    l: components[ColorComponent.lightness] ?? l,
    c: components[ColorComponent.colorfulness] ?? c,
    h: components[ColorComponent.hue] ?? h,
    alpha: components[ColorComponent.alpha] ?? alpha,
  );

  @override
  String toString() => _Serializer.toCssString(this, modelName: 'oklch');
}
