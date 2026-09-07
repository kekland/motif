import 'dart:ui' as ui;

import 'color.dart';

extension ColorToUiColor on ColorData {
  /// Converts this color data to a [ui.Color] in a given color space.
  ui.Color toUiColor({ui.ColorSpace colorSpace = .sRGB}) => FlutterConverter.convertToUi(this, colorSpace: colorSpace);
}

final class FlutterConverter {
  /// Converts the given color data to a [ui.Color] in the given [colorSpace].
  ///
  /// Note: by default, out-of-gamut colors are clipped. I should probably implement gamut mapping algorithms at some
  /// point, but at the moment, we're just using extended SRGB gamut.
  static ui.Color convertToUi(ColorData v, {ui.ColorSpace colorSpace = .sRGB}) {
    double _safe(double c) => c.isNaN ? 0.0 : c;

    if (colorSpace == .sRGB) {
      final srgb = Converter.toSrgb(v);
      return ui.Color.from(
        red: _safe(srgb.r).clamp(0.0, 1.0),
        green: _safe(srgb.g).clamp(0.0, 1.0),
        blue: _safe(srgb.b).clamp(0.0, 1.0),
        alpha: _safe(srgb.alpha).clamp(0.0, 1.0),
        colorSpace: .sRGB,
      );
    } else if (colorSpace == .extendedSRGB) {
      final srgb = Converter.toSrgb(v);
      return ui.Color.from(
        red: _safe(srgb.r),
        green: _safe(srgb.g),
        blue: _safe(srgb.b),
        alpha: _safe(srgb.alpha).clamp(0.0, 1.0),
        colorSpace: .extendedSRGB,
      );
    } else if (colorSpace == .displayP3) {
      final dp3 = Converter.convert<DisplayP3ColorData>(v);
      return ui.Color.from(
        red: _safe(dp3.r),
        green: _safe(dp3.g),
        blue: _safe(dp3.b),
        alpha: _safe(dp3.alpha).clamp(0.0, 1.0),
        colorSpace: .displayP3,
      );
    }

    throw ArgumentError('Unsupported color space: $colorSpace');
  }

  /// Converts the given [ui.Color] to a color data.
  static ColorData fromUiColor(ui.Color color) {
    final colorSpace = color.colorSpace;

    if (colorSpace == .sRGB || colorSpace == .extendedSRGB) {
      return .srgb(r: color.r, g: color.g, b: color.b, alpha: color.a);
    } else if (colorSpace == .displayP3) {
      return .displayP3(r: color.r, g: color.g, b: color.b, alpha: color.a);
    }

    throw ArgumentError('Unsupported color space: $colorSpace');
  }
}
