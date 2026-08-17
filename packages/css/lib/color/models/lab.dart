part of '../color.dart';

/// https://www.w3.org/TR/css-color-4/#specifying-lab-lch
/// - l: 0-100
/// - a: -128-127
/// - b: -128-127
final class LabColorData extends ColorData {
  const LabColorData({double l = .nan, double a = .nan, double b = .nan, super.alpha}) : super(v1: l, v2: a, v3: b);

  double get l => _v1;
  double get a => _v2;
  double get b => _v3;

  @override
  ColorModel get model => .lab;

  @override
  LabColorData withAlpha(double alpha) => copyWith(alpha: alpha);
  LabColorData copyWith({double? l, double? a, double? b, double? alpha}) =>
      .new(l: l ?? this.l, a: a ?? this.a, b: b ?? this.b, alpha: alpha ?? this.alpha);

  @override
  Map<ColorComponent, double> get components => {
    .lightness: l,
    .opponentA: a,
    .opponentB: b,
    .alpha: alpha,
  };

  @override
  LabColorData copyWithComponents(Map<ColorComponent, double> components) => copyWith(
    l: components[ColorComponent.lightness] ?? l,
    a: components[ColorComponent.opponentA] ?? a,
    b: components[ColorComponent.opponentB] ?? b,
    alpha: components[ColorComponent.alpha] ?? alpha,
  );

  @override
  String toString() => _Serializer.toCssString(this, modelName: 'lab');
}

/// https://www.w3.org/TR/css-color-4/#specifying-lab-lch
/// - l: 0-100
/// - c: 0-inf
/// - h: 0-360 (nan if c <= 0.0015)
final class LchColorData extends ColorData {
  const LchColorData({double l = .nan, double c = .nan, double h = .nan, super.alpha}) : super(v1: l, v2: c, v3: h);
  static const _epsilon = 0.0015;

  double get l => _v1;
  double get c => _v2;
  double get h => c <= _epsilon ? .nan : _v3;

  @override
  ColorModel get model => .lch;

  @override
  LchColorData withAlpha(double alpha) => copyWith(alpha: alpha);
  LchColorData copyWith({double? l, double? c, double? h, double? alpha}) =>
      .new(l: l ?? this.l, c: c ?? this.c, h: h ?? this.h, alpha: alpha ?? this.alpha);

  @override
  Map<ColorComponent, double> get components => {
    .lightness: l,
    .colorfulness: c,
    .hue: h,
    .alpha: alpha,
  };

  @override
  LchColorData copyWithComponents(Map<ColorComponent, double> components) => copyWith(
    l: components[ColorComponent.lightness] ?? l,
    c: components[ColorComponent.colorfulness] ?? c,
    h: components[ColorComponent.hue] ?? h,
    alpha: components[ColorComponent.alpha] ?? alpha,
  );

  @override
  String toString() => _Serializer.toCssString(this, modelName: 'lch');
}
