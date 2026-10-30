import 'package:shared/shared.dart';
import 'package:css/color.dart' as css_color;

part 'color_data_partial.dart';

enum ColorType {
  rgb,
  hsv,
}

sealed class ColorData {
  const ColorData(this._v1, this._v2, this._v3, {this.alpha = 1.0});

  factory ColorData.fromCss(css_color.ColorData css) {
    if (css is css_color.HsvColorData) {
      return .hsv(h: css.h, s: css.s / 100.0, v: css.v / 100.0, alpha: css.alpha);
    }

    if (css is css_color.SrgbColorData) {
      return .rgb(r: css.r, g: css.g, b: css.b, alpha: css.alpha);
    }

    return .fromCss(css.convertTo(.hsv));
  }

  static const ColorData transparent = .hsv(alpha: 0.0);
  static const ColorData red = .hsv(h: 0.0, s: 1.0, v: 1.0);
  static const ColorData green = .hsv(h: 120.0, s: 1.0, v: 1.0);
  static const ColorData blue = .hsv(h: 240.0, s: 1.0, v: 1.0);
  static const ColorData black = .hsv(h: 0.0, s: 0.0, v: 0.0);
  static const ColorData white = .hsv(h: 0.0, s: 0.0, v: 1.0);

  const factory hsv({double h, double s, double v, double alpha}) = HsvColorData;
  const factory rgb({double r, double g, double b, double alpha}) = RgbColorData;

  ColorType get type;

  final double _v1;
  final double _v2;
  final double _v3;
  final double alpha;

  css_color.ColorData get cssColor;
  css_color.ColorModel get cssModel => switch (type) {
    .hsv => .hsv,
    .rgb => .srgb,
  };

  ColorData withAlpha(double alpha);

  ColorData convertTo(ColorType type) {
    if (type == this.type) return this;
    final converted = cssColor.convertTo(switch (type) {
      .hsv => .hsv,
      .rgb => .srgb,
    });

    return .fromCss(converted);
  }

  double get v1 => _v1;
  double get v2 => _v2;
  double get v3 => _v3;

  double computeLuminance() => cssColor.convert<css_color.XyzD65ColorData>().y;
  ColorData darken(double amount) => .fromCss(cssColor.mix(.black, amount).convertTo(cssModel));
  ColorData lighten(double amount) => .fromCss(cssColor.mix(.white, amount).convertTo(cssModel));
}

final class RgbColorData extends ColorData {
  const RgbColorData({double r = .nan, double g = .nan, double b = .nan, super.alpha}) : super(r, g, b);

  @override
  ColorType get type => .rgb;

  double get r => _v1;
  double get g => _v2;
  double get b => _v3;

  @override
  css_color.ColorData get cssColor => .rgb(r: r, g: g, b: b, alpha: alpha);

  @override
  RgbColorData withAlpha(double alpha) => copyWith(alpha: alpha);
  RgbColorData copyWith({double? r, double? g, double? b, double? alpha}) => .new(
    r: r ?? this.r,
    g: g ?? this.g,
    b: b ?? this.b,
    alpha: alpha ?? this.alpha,
  );

  @override
  String toString() {
    final body = '${_double(r)} ${_double(g)} ${_double(b)}';
    if (alpha != 1.0) return 'rgb($body / ${_double(alpha)})';
    return 'rgb($body)';
  }
}

final class HsvColorData extends ColorData {
  const HsvColorData({double h = .nan, double s = .nan, double v = .nan, super.alpha}) : super(h, s, v);

  @override
  ColorType get type => .hsv;

  double get h => _v1;
  double get s => _v2;
  double get v => _v3;

  @override
  css_color.ColorData get cssColor => .hsv(h: h, s: s * 100.0, v: v * 100.0, alpha: alpha);

  @override
  HsvColorData withAlpha(double alpha) => copyWith(alpha: alpha);
  HsvColorData copyWith({double? h, double? s, double? v, double? alpha}) => .new(
    h: h ?? this.h,
    s: s ?? this.s,
    v: v ?? this.v,
    alpha: alpha ?? this.alpha,
  );

  @override
  String toString() {
    final body = '${_double(h)} ${_double(s)} ${_double(v)}';
    if (alpha != 1.0) return 'hsv($body / ${_double(alpha)})';
    return 'hsv($body)';
  }
}

String _double(double v) {
  if (v.isNaN) return 'none';
  if (v == v.roundToDouble()) return v.toInt().toString();
  return v.toStringAsFixed(4);
}
