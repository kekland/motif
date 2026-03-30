import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:petitparser/petitparser.dart';

part 'models/srgb.dart';
part 'models/srgb_derivatives.dart';
part 'models/lab.dart';
part 'models/oklab.dart';
part 'models/display_p3.dart';
part 'models/xyz.dart';

part 'converter_css_color_4.dart';
part 'converter.dart';
part 'mixer.dart';
part 'parser.dart';
part 'serializer.dart';

/// List of color models supported by this module.
///
/// Each model should have its own class that extends [ColorData].
///
/// Note: in addition to CSS, this list includes HSV. Exclusions:
/// - a98-rgb
/// - prophoto-rgb
/// - rec2020
enum ColorModel {
  // Core models
  srgb,
  srgbLinear,
  displayP3,
  displayP3Linear,

  // sRGB derivatives
  hsl,
  hsv,
  hwb,

  // Absolute color spaces
  xyzD50,
  xyzD65,
  lab,
  lch,
  oklab,
  oklch,
}

/// Color components (analogous components) defined in CSS Color 4.
enum ColorComponent {
  red,
  green,
  blue,
  lightness,
  colorfulness,
  hue,
  opponentA,
  opponentB,
  alpha,
}

/// A base class for a color data.
///
/// Stores three double-precision values and an alpha value. Subclasses (models) should use these values to represent
/// the actual color value.
///
/// In accordance with CSS Color 4, any values can be missing or powerless. Those are represented by NaN values. Alpha
/// is always 1.0 by default.
sealed class ColorData {
  const ColorData({double v1 = .nan, double v2 = .nan, double v3 = .nan, this.alpha = 1.0})
    : _v1 = v1,
      _v2 = v2,
      _v3 = v3;

  /// Parses a color from a CSS-like color string.
  factory ColorData.parse(String str) => _colorParser.parse(str).value;

  /// Creates a [ColorData] from given [ColorModel] and values.
  factory ColorData.from({
    required ColorModel model,
    double v1 = .nan,
    double v2 = .nan,
    double v3 = .nan,
    double alpha = 1.0,
  }) {
    return switch (model) {
      .srgb => .srgb(r: v1, g: v2, b: v3, alpha: alpha),
      .srgbLinear => .srgbLinear(r: v1, g: v2, b: v3, alpha: alpha),
      .displayP3 => .displayP3(r: v1, g: v2, b: v3, alpha: alpha),
      .displayP3Linear => .displayP3Linear(r: v1, g: v2, b: v3, alpha: alpha),
      .hsl => .hsl(h: v1, s: v2, l: v3, alpha: alpha),
      .hsv => .hsv(h: v1, s: v2, v: v3, alpha: alpha),
      .hwb => .hwb(h: v1, w: v2, b: v3, alpha: alpha),
      .xyzD65 => .xyzD65(x: v1, y: v2, z: v3, alpha: alpha),
      .xyzD50 => .xyzD50(x: v1, y: v2, z: v3, alpha: alpha),
      .lab => .lab(l: v1, a: v2, b: v3, alpha: alpha),
      .lch => .lch(l: v1, c: v2, h: v3, alpha: alpha),
      .oklab => .oklab(l: v1, a: v2, b: v3, alpha: alpha),
      .oklch => .oklch(l: v1, c: v2, h: v3, alpha: alpha),
    };
  }

  /// Creates a [ColorData] from a [ui.Color] in its color space.
  factory ColorData.fromUiColor(ui.Color color) => _Converter.fromUiColor(color);

  const factory ColorData.rgb({double r, double g, double b, double alpha}) = SrgbColorData; // Alias for .srgb
  const factory ColorData.srgb({double r, double g, double b, double alpha}) = SrgbColorData;
  const factory ColorData.srgbLinear({double r, double g, double b, double alpha}) = SrgbLinearColorData;
  const factory ColorData.displayP3({double r, double g, double b, double alpha}) = DisplayP3ColorData;
  const factory ColorData.displayP3Linear({double r, double g, double b, double alpha}) = DisplayP3LinearColorData;
  const factory ColorData.hsl({double h, double s, double l, double alpha}) = HslColorData;
  const factory ColorData.hsv({double h, double s, double v, double alpha}) = HsvColorData;
  const factory ColorData.hwb({double h, double w, double b, double alpha}) = HwbColorData;
  const factory ColorData.xyzD65({double x, double y, double z, double alpha}) = XyzD65ColorData;
  const factory ColorData.xyzD50({double x, double y, double z, double alpha}) = XyzD50ColorData;
  const factory ColorData.lab({double l, double a, double b, double alpha}) = LabColorData;
  const factory ColorData.lch({double l, double c, double h, double alpha}) = LchColorData;
  const factory ColorData.oklab({double l, double a, double b, double alpha}) = OklabColorData;
  const factory ColorData.oklch({double l, double c, double h, double alpha}) = OklchColorData;

  final double _v1;
  final double _v2;
  final double _v3;
  final double alpha;

  @visibleForTesting
  (double, double, double, double) get storage => (_v1, _v2, _v3, alpha);

  /// The color model of this color.
  ColorModel get model;

  /// Copy this color with a given alpha value.
  ColorData withAlpha(double alpha);

  /// Converts this color data to a given model [T].
  T convert<T extends ColorData>() => _Converter.convert<T>(this);

  /// Converts this color data to a given [ColorModel].
  ColorData convertTo(ColorModel toModel) => _Converter.convertTo(this, toModel);

  /// Return a color data where the values of this color are unchanged and used in a different model.
  ColorData reinterpretAs(ColorModel model) => .from(model: model, v1: _v1, v2: _v2, v3: _v3, alpha: alpha);

  /// Converts this color data to a [ui.Color] in a given color space.
  ui.Color toUiColor({ui.ColorSpace colorSpace = .sRGB}) => _Converter.convertToUi(this, colorSpace: colorSpace);

  /// Returns a map of color components and their values for this color.
  Map<ColorComponent, double> get components;

  /// Returns a value for the given color component, if it exists in this color model.
  double? getComponent(ColorComponent component) => components[component];

  /// Returns a copy of this color data with the given components replaced by new values.
  ColorData copyWithComponents(Map<ColorComponent, double> components);

  /// Returns a copy of this color data where powerless or missing components (.nan) are replaced with the given
  /// components.
  ColorData resolveWithComponents(Map<ColorComponent, double> components) {
    final currentComponents = this.components;
    final resolvedComponents = <ColorComponent, double>{};

    for (final key in currentComponents.keys) {
      final value = currentComponents[key]!;
      resolvedComponents[key] = value.isNaN ? (components[key] ?? value) : value;
    }

    return copyWithComponents(resolvedComponents);
  }

  /// Mixes this color with another color by a given amount (0.0 - 1.0).
  ColorData mix(
    ColorData other,
    double amount, {
    ColorModel colorModel = .oklch,
    HueInterpolation hueMode = .shorter,
  }) => _Mixer.lerp(this, other, amount, colorModel: colorModel, hueMode: hueMode);

  /// Linearly interpolates between two given colors in a given color model at a ratio [t].
  static ColorData lerp(
    ColorData a,
    ColorData b,
    double t, {
    ColorModel colorModel = .oklab,
    HueInterpolation hueMode = .shorter,
  }) => _Mixer.lerp(a, b, t, colorModel: colorModel, hueMode: hueMode);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType &&
          _v1 == (other as ColorData)._v1 &&
          _v2 == other._v2 &&
          _v3 == other._v3 &&
          alpha == other.alpha;

  @override
  int get hashCode => Object.hash(model, _v1, _v2, _v3, alpha);
}
