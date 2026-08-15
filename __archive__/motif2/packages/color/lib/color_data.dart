import 'dart:ui' as ui;
import 'package:css/color.dart' as css_color;

sealed class ColorData {
  const ColorData(this._v1, this._v2, this._v3, {this.alpha = 1.0});

  static const ColorData transparent = .hsv(alpha: 0.0);
  static const ColorData red = .hsv(h: 0.0, s: 1.0, v: 1.0);
  static const ColorData green = .hsv(h: 120.0, s: 1.0, v: 1.0);
  static const ColorData blue = .hsv(h: 240.0, s: 1.0, v: 1.0);
  static const ColorData black = .hsv(h: 0.0, s: 0.0, v: 0.0);
  static const ColorData white = .hsv(h: 0.0, s: 0.0, v: 1.0);

  const factory ColorData.hsv({double h, double s, double v, double alpha}) = HsvColorData;

  final double _v1;
  final double _v2;
  final double _v3;
  final double alpha;

  css_color.ColorData get cssColor;
  ui.Color toUiColor({ui.ColorSpace colorSpace = .sRGB}) => cssColor.toUiColor(colorSpace: colorSpace);
  ColorData withAlpha(double alpha);
}

final class HsvColorData extends ColorData {
  const HsvColorData({double h = .nan, double s = .nan, double v = .nan, super.alpha}) : super(h, s, v);

  double get h => _v1;
  double get s => _v2;
  double get v => _v3;

  @override
  css_color.ColorData get cssColor => .hsv(h: h, s: s * 100.0, v: v * 100.0, alpha: alpha);

  @override
  HsvColorData withAlpha(double alpha) => HsvColorData(h: h, s: s, v: v, alpha: alpha);
  HsvColorData copyWith({double? h, double? s, double? v, double? alpha}) => HsvColorData(
    h: h ?? this.h,
    s: s ?? this.s,
    v: v ?? this.v,
    alpha: alpha ?? this.alpha,
  );
}
