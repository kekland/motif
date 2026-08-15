part of 'color.dart';

class _Converter {
  /// Converts the given color data to the target color model [T].
  static T convert<T extends ColorData>(ColorData v) => convertTo(v, typeToModel<T>()) as T;

  /// Converts the given color data to the target color model [target].
  static ColorData convertTo(ColorData v, ColorModel target) {
    final from = v.model;
    final to = target;

    if (from == to) return v;
    if (isInSrgbFamily(from) && isInSrgbFamily(to)) return fromSrgb(toSrgb(v), to);
    return fromXyzD65(toXyzD65(v), to);
  }

  /// Converts the given color data to a [ui.Color] in the given [colorSpace].
  ///
  /// Note: by default, out-of-gamut colors are clipped. I should probably implement gamut mapping algorithms at some
  /// point, but at the moment, we're just using extended SRGB gamut.
  static ui.Color convertToUi(ColorData v, {ui.ColorSpace colorSpace = .sRGB}) {
    double _safe(double c) => c.isNaN ? 0.0 : c;

    if (colorSpace == .sRGB) {
      final srgb = toSrgb(v);
      return ui.Color.from(
        red: _safe(srgb.r).clamp(0.0, 1.0),
        green: _safe(srgb.g).clamp(0.0, 1.0),
        blue: _safe(srgb.b).clamp(0.0, 1.0),
        alpha: _safe(srgb.alpha).clamp(0.0, 1.0),
        colorSpace: .sRGB,
      );
    } else if (colorSpace == .extendedSRGB) {
      final srgb = toSrgb(v);
      return ui.Color.from(
        red: _safe(srgb.r),
        green: _safe(srgb.g),
        blue: _safe(srgb.b),
        alpha: _safe(srgb.alpha).clamp(0.0, 1.0),
        colorSpace: .extendedSRGB,
      );
    } else if (colorSpace == .displayP3) {
      final dp3 = convert<DisplayP3ColorData>(v);
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

  /// Converts the given XYZ D65 color data to the [target] color model.
  static ColorData fromXyzD65(XyzD65ColorData v, ColorModel target) => switch (target) {
    // Core
    .srgb => srgbLinearToSrgb(xyzD65ToSrgbLinear(v)),
    .srgbLinear => xyzD65ToSrgbLinear(v),
    .displayP3 => displayP3LinearToDisplayP3(xyzD65ToDisplayP3Linear(v)),
    .displayP3Linear => xyzD65ToDisplayP3Linear(v),

    // sRGB derivatives
    .hsl => srgbToHsl(srgbLinearToSrgb(xyzD65ToSrgbLinear(v))),
    .hsv => srgbToHsv(srgbLinearToSrgb(xyzD65ToSrgbLinear(v))),
    .hwb => srgbToHwb(srgbLinearToSrgb(xyzD65ToSrgbLinear(v))),

    // Absolute color spaces
    .xyzD65 => v,
    .xyzD50 => xyzD65ToXyzD50(v),
    .lab => xyzD50ToLab(xyzD65ToXyzD50(v)),
    .lch => labToLch(xyzD50ToLab(xyzD65ToXyzD50(v))),
    .oklab => xyzD65ToOklab(v),
    .oklch => oklabToOklch(xyzD65ToOklab(v)),
  };

  /// Converts the given color data to XYZ D65 color data.
  static XyzD65ColorData toXyzD65(ColorData v) => switch (v) {
    // Core
    SrgbLinearColorData v => srgbLinearToXyzD65(v),
    SrgbColorData v => srgbLinearToXyzD65(srgbToSrgbLinear(v)),
    DisplayP3LinearColorData v => displayP3LinearToXyzD65(v),
    DisplayP3ColorData v => displayP3LinearToXyzD65(displayP3ToDisplayP3Linear(v)),

    // sRGB derivatives
    HslColorData v => srgbLinearToXyzD65(srgbToSrgbLinear(hslToSrgb(v))),
    HsvColorData v => srgbLinearToXyzD65(srgbToSrgbLinear(hsvToSrgb(v))),
    HwbColorData v => srgbLinearToXyzD65(srgbToSrgbLinear(hwbToSrgb(v))),

    // Absolute color spaces
    XyzD65ColorData v => v,
    XyzD50ColorData v => xyzD50ToXyzD65(v),
    LabColorData v => xyzD50ToXyzD65(labToXyzD50(v)),
    LchColorData v => xyzD50ToXyzD65(labToXyzD50(lchToLab(v))),
    OklabColorData v => oklabToXyzD65(v),
    OklchColorData v => oklabToXyzD65(oklchToOklab(v)),
  };

  /// Converts the given sRGB color data to [target] model, using [fromXyzD65] if there's no direct conversion.
  static ColorData fromSrgb(SrgbColorData v, ColorModel target) => switch (target) {
    .srgb => v,
    .srgbLinear => srgbToSrgbLinear(v),
    .hsl => srgbToHsl(v),
    .hsv => srgbToHsv(v),
    .hwb => srgbToHwb(v),
    _ => fromXyzD65(srgbLinearToXyzD65(srgbToSrgbLinear(v)), target),
  };

  /// Converts the given color data to sRGB, using [toXyzD65] if there's no direct conversion.
  static SrgbColorData toSrgb(ColorData v) => switch (v) {
    SrgbColorData v => v,
    SrgbLinearColorData v => srgbLinearToSrgb(v),
    HslColorData v => hslToSrgb(v),
    HsvColorData v => hsvToSrgb(v),
    HwbColorData v => hwbToSrgb(v),
    _ => srgbLinearToSrgb(xyzD65ToSrgbLinear(toXyzD65(v))),
  };

  /// Whether the given color is in the "sRGB family" of color models (i.e. can be converted to/from sRGB without doing
  /// an absolute color conversion via XYZ D65).
  static bool isInSrgbFamily(ColorModel model) => switch (model) {
    .srgb => true,
    .srgbLinear => true,
    .hsl => true,
    .hsv => true,
    .hwb => true,
    _ => false,
  };

  /// Returns the model enum for type [T].
  static ColorModel typeToModel<T extends ColorData>() {
    return switch (T) {
      const (SrgbLinearColorData) => .srgbLinear,
      const (SrgbColorData) => .srgb,
      const (DisplayP3LinearColorData) => .displayP3Linear,
      const (DisplayP3ColorData) => .displayP3,
      const (HslColorData) => .hsl,
      const (HsvColorData) => .hsv,
      const (HwbColorData) => .hwb,
      const (XyzD50ColorData) => .xyzD50,
      const (XyzD65ColorData) => .xyzD65,
      const (LabColorData) => .lab,
      const (LchColorData) => .lch,
      const (OklabColorData) => .oklab,
      const (OklchColorData) => .oklch,
      _ => throw AssertionError('unreachable'),
    };
  }

  /*
    srgb-linear, srgb
  */

  static XyzD65ColorData srgbLinearToXyzD65(SrgbLinearColorData v) {
    final (x, y, z) = _linearRgbToXyz((v.r, v.g, v.b));
    return .new(x: x, y: y, z: z, alpha: v.alpha);
  }

  static SrgbLinearColorData xyzD65ToSrgbLinear(XyzD65ColorData v) {
    final (r, g, b) = _xyzToLinearSrgb((v.x, v.y, v.z));
    return .new(r: r, g: g, b: b, alpha: v.alpha);
  }

  static SrgbLinearColorData srgbToSrgbLinear(SrgbColorData v) {
    final (r, g, b) = _srgbToLinearRgb((v.r, v.g, v.b));
    return .new(r: r, g: g, b: b, alpha: v.alpha);
  }

  static SrgbColorData srgbLinearToSrgb(SrgbLinearColorData v) {
    final (r, g, b) = _linearRgbToSrgb((v.r, v.g, v.b));
    return .new(r: r, g: g, b: b, alpha: v.alpha);
  }

  /*
    display-p3-linear, display-p3
  */

  static XyzD65ColorData displayP3LinearToXyzD65(DisplayP3LinearColorData v) {
    final (x, y, z) = _linearDisplayP3ToXyz((v.r, v.g, v.b));
    return .new(x: x, y: y, z: z, alpha: v.alpha);
  }

  static DisplayP3LinearColorData xyzD65ToDisplayP3Linear(XyzD65ColorData v) {
    final (r, g, b) = _xyzToLinearDisplayP3((v.x, v.y, v.z));
    return .new(r: r, g: g, b: b, alpha: v.alpha);
  }

  static DisplayP3LinearColorData displayP3ToDisplayP3Linear(DisplayP3ColorData v) {
    final (r, g, b) = _displayP3ToLinearDisplayP3((v.r, v.g, v.b));
    return .new(r: r, g: g, b: b, alpha: v.alpha);
  }

  static DisplayP3ColorData displayP3LinearToDisplayP3(DisplayP3LinearColorData v) {
    final (r, g, b) = _linearDisplayP3ToDisplayP3((v.r, v.g, v.b));
    return .new(r: r, g: g, b: b, alpha: v.alpha);
  }

  /*
    srgb derivatives
  */

  static SrgbColorData hslToSrgb(HslColorData v) {
    final (r, g, b) = _hslToRgb((v.h, v.s, v.l));
    return .new(r: r, g: g, b: b, alpha: v.alpha);
  }

  static HslColorData srgbToHsl(SrgbColorData v) {
    final (h, s, l) = _rgbToHsl((v.r, v.g, v.b));
    return .new(h: h, s: s, l: l, alpha: v.alpha);
  }

  static SrgbColorData hsvToSrgb(HsvColorData v) {
    final (r, g, b) = _hsvToRgb((v.h, v.s, v.v));
    return .new(r: r, g: g, b: b, alpha: v.alpha);
  }

  static HsvColorData srgbToHsv(SrgbColorData v) {
    final (h, s, value) = _rgbToHsv((v.r, v.g, v.b));
    return .new(h: h, s: s, v: value, alpha: v.alpha);
  }

  static SrgbColorData hwbToSrgb(HwbColorData v) {
    final (r, g, b) = _hwbToRgb((v.h, v.w, v.b));
    return .new(r: r, g: g, b: b, alpha: v.alpha);
  }

  static HwbColorData srgbToHwb(SrgbColorData v) {
    final (h, w, b) = _rgbToHwb((v.r, v.g, v.b));
    return .new(h: h, w: w, b: b, alpha: v.alpha);
  }

  /*
    Absolute color spaces
  */

  static XyzD65ColorData xyzD50ToXyzD65(XyzD50ColorData v) {
    final (x, y, z) = _xyzD50ToD65((v.x, v.y, v.z));
    return .new(x: x, y: y, z: z, alpha: v.alpha);
  }

  static XyzD50ColorData xyzD65ToXyzD50(XyzD65ColorData v) {
    final (x, y, z) = _xyzD65ToD50((v.x, v.y, v.z));
    return .new(x: x, y: y, z: z, alpha: v.alpha);
  }

  static XyzD50ColorData labToXyzD50(LabColorData v) {
    final (x, y, z) = _labToXyz((v.l, v.a, v.b));
    return .new(x: x, y: y, z: z, alpha: v.alpha);
  }

  static LabColorData xyzD50ToLab(XyzD50ColorData v) {
    final (l, a, b) = _xyzToLab((v.x, v.y, v.z));
    return .new(l: l, a: a, b: b, alpha: v.alpha);
  }

  static LchColorData labToLch(LabColorData v) {
    final (l, c, h) = _labToLch((v.l, v.a, v.b));
    return .new(l: l, c: c, h: h, alpha: v.alpha);
  }

  static LabColorData lchToLab(LchColorData v) {
    final (l, a, b) = _lchToLab((v.l, v.c, v.h));
    return .new(l: l, a: a, b: b, alpha: v.alpha);
  }

  static OklabColorData xyzD65ToOklab(XyzD65ColorData v) {
    final (l, a, b) = _xyzToOklab((v.x, v.y, v.z));
    return .new(l: l, a: a, b: b, alpha: v.alpha);
  }

  static XyzD65ColorData oklabToXyzD65(OklabColorData v) {
    final (x, y, z) = _oklabToXyz((v.l, v.a, v.b));
    return .new(x: x, y: y, z: z, alpha: v.alpha);
  }

  static OklchColorData oklabToOklch(OklabColorData v) {
    final (l, c, h) = _oklabToOklch((v.l, v.a, v.b));
    return .new(l: l, c: c, h: h, alpha: v.alpha);
  }

  static OklabColorData oklchToOklab(OklchColorData v) {
    final (l, a, b) = _oklchToOklab((v.l, v.c, v.h));
    return .new(l: l, a: a, b: b, alpha: v.alpha);
  }
}
