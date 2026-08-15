part of 'color.dart';

/// Methods of interpolating the colors' hues.
enum HueInterpolation {
  /// The "shortest path" between the hues is taken. This is usually the default method.
  shorter,

  /// The "longest path" between the hues is taken.
  longer,

  /// The hue is always increasing, i.e. the interpolation will go through 360 degrees if needed.
  increasing,

  /// The hue is always decreasing, i.e. the interpolation will go through 0 degrees if needed.
  decreasing,
}

class _Mixer {
  /// Linearly interpolates between two colors in a given color model at a ratio [t].
  ///
  /// The interpolation of hue can be customized with [hueMode]. By default, the shortest path is taken.
  ///
  /// The interpolation is consistent with the definition of interpolation in CSS Color 4:
  /// - https://www.w3.org/TR/css-color-4/#interpolation
  static ColorData lerp(
    ColorData a,
    ColorData b,
    double t, {
    ColorModel colorModel = .oklab,
    HueInterpolation hueMode = .shorter,
  }) {
    final components1 = a.components;
    final components2 = b.components;

    var c1 = a.convertTo(colorModel);
    var c2 = b.convertTo(colorModel);

    c1 = c1.resolveWithComponents(components2);
    c2 = c2.resolveWithComponents(components1);

    return _lerp(c1, c2, t, hueMode: hueMode);
  }

  @pragma('vm:prefer-inline')
  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  static double _lerpValue(double v1, double v2, double t) {
    if (v1.isNaN && v2.isNaN) return double.nan;
    if (v1.isNaN) return v2;
    if (v2.isNaN) return v1;
    return _lerpDouble(v1, v2, t);
  }

  static double _lerpAlpha(double a1, double a2, double t) => _lerpValue(a1, a2, t);

  static double _lerpPremultiplied(double v1, double a1, double v2, double a2, double t) {
    final p1 = a1.isNaN ? v1 : v1 * a1;
    final p2 = a2.isNaN ? v2 : v2 * a2;
    final p = _lerpDouble(p1, p2, t);
    final a = _lerpAlpha(a1, a2, t);
    return (a == 0.0 || a.isNaN) ? p : p / a;
  }

  static double _lerpHue(double h1, double h2, double t, {HueInterpolation mode = .shorter}) {
    if (h1.isNaN && h2.isNaN) return double.nan;
    if (h1.isNaN) return h2;
    if (h2.isNaN) return h1;

    var delta = h2 - h1;
    if (mode == .shorter) {
      // Interpolate hues, taking the "shortest" path.
      if (delta > 180.0) {
        h1 += 360.0;
      } else if (delta < -180.0) {
        h2 += 360.0;
      }
    } else if (mode == .longer) {
      // Interpolate taking the "longest" path.
      if (delta > 0.0 && delta < 180.0) {
        h1 += 360.0;
      } else if (delta > -180.0 && delta <= 0.0) {
        h2 += 360.0;
      }
    } else if (mode == .increasing) {
      // Interpolate, making sure that h2 > h1
      if (delta < 0.0) h2 += 360.0;
    } else if (mode == .decreasing) {
      // Interpolate, making sure that h1 > h2
      if (delta > 0.0) h1 += 360.0;
    }

    var result = _lerpDouble(h1, h2, t);
    if (result < 0.0) result += 360.0;

    return result % 360.0;
  }

  static T _lerp<T extends ColorData>(T a, T b, double t, {HueInterpolation hueMode = .shorter}) => switch (a.model) {
    .displayP3 => _lerpDisplayP3(a as DisplayP3ColorData, b as DisplayP3ColorData, t) as T,
    .displayP3Linear => _lerpDisplayP3Linear(a as DisplayP3LinearColorData, b as DisplayP3LinearColorData, t) as T,
    .srgb => _lerpSrgb(a as SrgbColorData, b as SrgbColorData, t) as T,
    .srgbLinear => _lerpSrgbLinear(a as SrgbLinearColorData, b as SrgbLinearColorData, t) as T,
    .hsl => _lerpHsl(a as HslColorData, b as HslColorData, t, hueMode: hueMode) as T,
    .hsv => _lerpHsv(a as HsvColorData, b as HsvColorData, t, hueMode: hueMode) as T,
    .hwb => _lerpHwb(a as HwbColorData, b as HwbColorData, t, hueMode: hueMode) as T,
    .lab => _lerpLab(a as LabColorData, b as LabColorData, t) as T,
    .lch => _lerpLch(a as LchColorData, b as LchColorData, t, hueMode: hueMode) as T,
    .oklab => _lerpOklab(a as OklabColorData, b as OklabColorData, t) as T,
    .oklch => _lerpOklch(a as OklchColorData, b as OklchColorData, t, hueMode: hueMode) as T,
    .xyzD65 => _lerpXyzD65(a as XyzD65ColorData, b as XyzD65ColorData, t) as T,
    .xyzD50 => _lerpXyzD50(a as XyzD50ColorData, b as XyzD50ColorData, t) as T,
  };

  static DisplayP3ColorData _lerpDisplayP3(
    DisplayP3ColorData a,
    DisplayP3ColorData b,
    double t,
  ) => .new(
    r: _lerpPremultiplied(a.r, a.alpha, b.r, b.alpha, t),
    g: _lerpPremultiplied(a.g, a.alpha, b.g, b.alpha, t),
    b: _lerpPremultiplied(a.b, a.alpha, b.b, b.alpha, t),
    alpha: _lerpAlpha(a.alpha, b.alpha, t),
  );

  static DisplayP3LinearColorData _lerpDisplayP3Linear(
    DisplayP3LinearColorData a,
    DisplayP3LinearColorData b,
    double t,
  ) => .new(
    r: _lerpPremultiplied(a.r, a.alpha, b.r, b.alpha, t),
    g: _lerpPremultiplied(a.g, a.alpha, b.g, b.alpha, t),
    b: _lerpPremultiplied(a.b, a.alpha, b.b, b.alpha, t),
    alpha: _lerpAlpha(a.alpha, b.alpha, t),
  );

  static SrgbColorData _lerpSrgb(
    SrgbColorData a,
    SrgbColorData b,
    double t,
  ) => .new(
    r: _lerpPremultiplied(a.r, a.alpha, b.r, b.alpha, t),
    g: _lerpPremultiplied(a.g, a.alpha, b.g, b.alpha, t),
    b: _lerpPremultiplied(a.b, a.alpha, b.b, b.alpha, t),
    alpha: _lerpAlpha(a.alpha, b.alpha, t),
  );

  static SrgbLinearColorData _lerpSrgbLinear(
    SrgbLinearColorData a,
    SrgbLinearColorData b,
    double t,
  ) => .new(
    r: _lerpPremultiplied(a.r, a.alpha, b.r, b.alpha, t),
    g: _lerpPremultiplied(a.g, a.alpha, b.g, b.alpha, t),
    b: _lerpPremultiplied(a.b, a.alpha, b.b, b.alpha, t),
    alpha: _lerpAlpha(a.alpha, b.alpha, t),
  );

  static HslColorData _lerpHsl(
    HslColorData a,
    HslColorData b,
    double t, {
    HueInterpolation hueMode = .shorter,
  }) => .new(
    h: _lerpHue(a.h, b.h, t, mode: hueMode),
    s: _lerpPremultiplied(a.s, a.alpha, b.s, b.alpha, t),
    l: _lerpPremultiplied(a.l, a.alpha, b.l, b.alpha, t),
    alpha: _lerpAlpha(a.alpha, b.alpha, t),
  );

  static HsvColorData _lerpHsv(
    HsvColorData a,
    HsvColorData b,
    double t, {
    HueInterpolation hueMode = .shorter,
  }) => .new(
    h: _lerpHue(a.h, b.h, t, mode: hueMode),
    s: _lerpPremultiplied(a.s, a.alpha, b.s, b.alpha, t),
    v: _lerpPremultiplied(a.v, a.alpha, b.v, b.alpha, t),
    alpha: _lerpAlpha(a.alpha, b.alpha, t),
  );

  static HwbColorData _lerpHwb(
    HwbColorData a,
    HwbColorData b,
    double t, {
    HueInterpolation hueMode = .shorter,
  }) => .new(
    h: _lerpHue(a.h, b.h, t, mode: hueMode),
    w: _lerpPremultiplied(a.w, a.alpha, b.w, b.alpha, t),
    b: _lerpPremultiplied(a.b, a.alpha, b.b, b.alpha, t),
    alpha: _lerpAlpha(a.alpha, b.alpha, t),
  );

  static LabColorData _lerpLab(
    LabColorData a,
    LabColorData b,
    double t,
  ) => .new(
    l: _lerpPremultiplied(a.l, a.alpha, b.l, b.alpha, t),
    a: _lerpPremultiplied(a.a, a.alpha, b.a, b.alpha, t),
    b: _lerpPremultiplied(a.b, a.alpha, b.b, b.alpha, t),
    alpha: _lerpAlpha(a.alpha, b.alpha, t),
  );

  static LchColorData _lerpLch(
    LchColorData a,
    LchColorData b,
    double t, {
    HueInterpolation hueMode = .shorter,
  }) => .new(
    l: _lerpPremultiplied(a.l, a.alpha, b.l, b.alpha, t),
    c: _lerpPremultiplied(a.c, a.alpha, b.c, b.alpha, t),
    h: _lerpHue(a.h, b.h, t, mode: hueMode),
    alpha: _lerpAlpha(a.alpha, b.alpha, t),
  );

  static OklabColorData _lerpOklab(
    OklabColorData a,
    OklabColorData b,
    double t,
  ) => .new(
    l: _lerpPremultiplied(a.l, a.alpha, b.l, b.alpha, t),
    a: _lerpPremultiplied(a.a, a.alpha, b.a, b.alpha, t),
    b: _lerpPremultiplied(a.b, a.alpha, b.b, b.alpha, t),
    alpha: _lerpAlpha(a.alpha, b.alpha, t),
  );

  static OklchColorData _lerpOklch(
    OklchColorData a,
    OklchColorData b,
    double t, {
    HueInterpolation hueMode = .shorter,
  }) => .new(
    l: _lerpPremultiplied(a.l, a.alpha, b.l, b.alpha, t),
    c: _lerpPremultiplied(a.c, a.alpha, b.c, b.alpha, t),
    h: _lerpHue(a.h, b.h, t, mode: hueMode),
    alpha: _lerpAlpha(a.alpha, b.alpha, t),
  );

  static XyzD65ColorData _lerpXyzD65(
    XyzD65ColorData a,
    XyzD65ColorData b,
    double t,
  ) => .new(
    x: _lerpPremultiplied(a.x, a.alpha, b.x, b.alpha, t),
    y: _lerpPremultiplied(a.y, a.alpha, b.y, b.alpha, t),
    z: _lerpPremultiplied(a.z, a.alpha, b.z, b.alpha, t),
    alpha: _lerpAlpha(a.alpha, b.alpha, t),
  );

  static XyzD50ColorData _lerpXyzD50(
    XyzD50ColorData a,
    XyzD50ColorData b,
    double t,
  ) => .new(
    x: _lerpPremultiplied(a.x, a.alpha, b.x, b.alpha, t),
    y: _lerpPremultiplied(a.y, a.alpha, b.y, b.alpha, t),
    z: _lerpPremultiplied(a.z, a.alpha, b.z, b.alpha, t),
    alpha: _lerpAlpha(a.alpha, b.alpha, t),
  );
}
