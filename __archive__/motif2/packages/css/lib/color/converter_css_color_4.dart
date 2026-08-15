part of 'color.dart';

// Port of https://www.w3.org/TR/css-color-4 (Section 7.1, 7.2, 8.1, 8.2, 18)
//
// Used in converter.dart as a low-level conversion utility which contains all the math.
//
// Credits:
// - https://en.wikipedia.org/wiki/SRGB
// - http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
// - https://github.com/LeaVerou/color.js/pull/360/files
// - https://github.com/LeaVerou/color.js/pull/354/files
// - https://bottosson.github.io/posts/oklab/
// - https://github.com/color-js/color.js/pull/357

typedef _Base = (double, double, double);
typedef _Hsl = (double h, double s, double l);
typedef _Hsv = (double h, double s, double v);
typedef _Hwb = (double h, double w, double b);
typedef _Srgb = (double r, double g, double b);
typedef _LinearSrgb = (double r, double g, double b);
typedef _DisplayP3 = (double r, double g, double b);
typedef _LinearDisplayP3 = (double r, double g, double b);
typedef _XyzD65 = (double x, double y, double z);
typedef _XyzD50 = (double x, double y, double z);
typedef _Lab = (double l, double a, double b);
typedef _Lch = (double l, double c, double h);
typedef _Oklab = (double l, double a, double b);
typedef _Oklch = (double l, double c, double h);

/*
  Utilities
*/

double _maybeNan(double v) => v.isNaN ? 0 : v;
_Base _maybeNanTuple(_Base t) => (_maybeNan(t.$1), _maybeNan(t.$2), _maybeNan(t.$3));
double _min3(double a, double b, double c) => math.min(a, math.min(b, c));
double _max3(double a, double b, double c) => math.max(a, math.max(b, c));

/*
  Own additions
*/

/// - h - hue as degrees 0..360
/// - s - saturation in reference range [0, 100]
/// - v - value in reference range [0, 100]
/// - returns: hsl values, hue as degrees 0..360, saturation and lightness in reference range [0, 100]
_Hsl _hsvToHsl(_Hsv hsv) {
  const epsilon = 1 / 100000.0;

  var (h, s, v) = _maybeNanTuple(hsv);
  s /= 100.0;
  v /= 100.0;

  final l = v * (1 - s / 2);
  final s2 = l == 0 || l == 1 ? 0.0 : (v - l) / math.min(l, 1 - l);
  if (s2 < epsilon) h = .nan;

  return (h, s2 * 100.0, l * 100.0);
}

/// - h - hue as degrees 0..360
/// - s - saturation in reference range [0, 100]
/// - l - lightness in reference range [0, 100]
/// - returns: hsv values, hue as degrees 0..360, saturation and value in reference range [0, 100]
_Hsv _hslToHsv(_Hsl hsl) {
  const epsilon = 1 / 100000.0;

  var (h, s, l) = _maybeNanTuple(hsl);
  s /= 100.0;
  l /= 100.0;

  final v = l + s * math.min(l, 1 - l);
  final s2 = v == 0 ? 0.0 : 2 * (1 - l / v);
  if (s2 < epsilon) h = .nan;

  return (h, s2 * 100.0, v * 100.0);
}

/// - h - hue as degrees 0..360
/// - s - saturation in reference range [0, 100]
/// - v - value in reference range [0, 100]
/// - returns: sRGB components, in-gamut colors in range [0, 1]
_Srgb _hsvToRgb(_Hsv hsv) {
  return _hslToRgb(_hsvToHsl(hsv));
}

/// - r - red component 0..1
/// - g - green component 0..1
/// - b - blue component 0..1
/// - returns: hsv values, hue as degrees 0..360, saturation and value in reference range [0, 100]
_Hsv _rgbToHsv(_Srgb rgb) {
  return _hslToHsv(_rgbToHsl(rgb));
}

/*
  8.2 (excrept): rgbToHue
*/

/// - r - red component 0..1
/// - g - green component 0..1
/// - b - blue component 0..1
/// - returns: hue as degrees 0..360 (or NaN if saturation is 0)
double _rgbToHue(_Srgb rgb) {
  var (r, g, b) = _maybeNanTuple(rgb);
  final max = _max3(r, g, b);
  final min = _min3(r, g, b);
  final d = max - min;
  var h = double.nan;

  if (d != 0.0) {
    // dart format off
    if (max == r)      h = (g - b) / d + (g < b ? 6 : 0);
    else if (max == g) h = (b - r) / d + 2;
    else               h = (r - g) / d + 4;
    // dart format on

    h *= 60.0;
  }

  if (h >= 360.0) h -= 360.0;
  return h;
}

/*
  7.1/7.2. HSL <-> sRGB
*/

// Adjustments: _rgbToHsl uses _rgbToHue method instead of re-rewriting it here.

/// - h - hue as degrees 0..360
/// - s - saturation in reference range [0, 100]
/// - l - lightness in reference range [0, 100]
/// - returns: sRGB components, in-gamut colors in range [0, 1]
_Srgb _hslToRgb(_Hsl hsl) {
  var (h, s, l) = _maybeNanTuple(hsl);
  s /= 100.0;
  l /= 100.0;

  double f(int n) {
    final k = (n + h / 30.0) % 12.0;
    final a = s * math.min(l, 1 - l);
    return l - a * math.max(-1, _min3(k - 3, 9 - k, 1));
  }

  return (f(0), f(8), f(4));
}

/// - r - red component 0..1
/// - g - green component 0..1
/// - b - blue component 0..1
/// - returns: HSL values, hue as degrees 0..360, saturation and lightness in reference range [0, 100]
_Hsl _rgbToHsl(_Srgb rgb) {
  const epsilon = 1.0 / 100000.0;

  var (r, g, b) = _maybeNanTuple(rgb);

  final max = _max3(r, g, b);
  final min = _min3(r, g, b);

  var (h, s, l) = (_rgbToHue(rgb), 0.0, (max + min) / 2.0);
  final d = max - min;

  if (d != 0) {
    s = (l == 0 || l == 1) ? 0 : (max - l) / math.min(l, 1 - l);
  }

  if (s < 0.0) {
    h += 180.0;
    s = s.abs();
  }

  if (h >= 360.0) h -= 360.0;
  if (s <= epsilon) h = .nan;

  return (h, s * 100.0, l * 100.0);
}

/*
  8.1/8.2. HWB <-> sRGB
*/

/// - h - hue as degrees 0..360
/// - w - whiteness in reference range [0, 100]
/// - b - blackness in reference range [0, 100]
/// - returns: sRGB components, in-gamut colors in range [0, 1]
_Srgb _hwbToRgb(_Hwb hwb) {
  var (h, w, b) = _maybeNanTuple(hwb);
  w /= 100.0;
  b /= 100.0;

  if (w + b >= 1) {
    final gray = w / (w + b);
    return (gray, gray, gray);
  }

  var rgb = _hslToRgb((h, 100.0, 50.0));

  double f(double c) => c * (1 - w - b) + w;
  rgb = (f(rgb.$1), f(rgb.$2), f(rgb.$3));

  return rgb;
}

/// - r - red component 0..1
/// - g - green component 0..1
/// - b - blue component 0..1
/// - returns: HWB values, hue as degrees 0..360, whiteness and blackness in reference range [0, 100]
_Hwb _rgbToHwb(_Srgb rgb) {
  const epsilon = 1.0 / 100000.0;

  var (r, g, b) = _maybeNanTuple(rgb);
  var hue = _rgbToHue(rgb);

  final white = _min3(r, g, b);
  final black = 1 - _max3(r, g, b);
  if (white + black >= 1 - epsilon) hue = double.nan;

  return (hue, white * 100.0, black * 100.0);
}

/*
  18. Color conversions
*/

const _d50 = (0.3457 / 0.3585, 1.00000, (1.0 - 0.3457 - 0.3585) / 0.3585);

// ignore: unused_element
const _d65 = (0.3127 / 0.3290, 1.00000, (1.0 - 0.3127 - 0.3290) / 0.3290);

typedef _Matrix = ((double, double, double), (double, double, double), (double, double, double));

@pragma('vm:prefer-inline')
(double, double, double) _multiplyMatrix(_Matrix m, (double, double, double) v) {
  final (a, b, c) = v;
  final (r1, r2, r3) = m;

  return (
    r1.$1 * a + r1.$2 * b + r1.$3 * c,
    r2.$1 * a + r2.$2 * b + r2.$3 * c,
    r3.$1 * a + r3.$2 * b + r3.$3 * c,
  );
}

// sRGB functions

@pragma('vm:prefer-inline')
double _srgbChannelToLinearRGB(double c) {
  final sign = c.sign;
  final abs = c.abs();

  if (abs <= 0.04045) return c / 12.92;
  return sign * (math.pow((abs + 0.055) / 1.055, 2.4)).toDouble();
}

_LinearSrgb _srgbToLinearRgb(_Srgb value) {
  final (r, g, b) = value;
  return (_srgbChannelToLinearRGB(r), _srgbChannelToLinearRGB(g), _srgbChannelToLinearRGB(b));
}

@pragma('vm:prefer-inline')
double _linearRgbChannelToSrgb(double c) {
  final sign = c.sign;
  final abs = c.abs();

  if (abs <= 0.0031308) return c * 12.92;
  return sign * (1.055 * math.pow(abs, 1.0 / 2.4) - 0.055);
}

_Srgb _linearRgbToSrgb(_LinearSrgb value) {
  final (r, g, b) = _maybeNanTuple(value);
  return (_linearRgbChannelToSrgb(r), _linearRgbChannelToSrgb(g), _linearRgbChannelToSrgb(b));
}

_XyzD65 _linearRgbToXyz(_LinearSrgb value) {
  const M = (
    // dart format off
    ( 506752 / 1228815,  87881 / 245763,   12673 / 70218   ),
    (  87098 /  409605, 175762 / 245763,   12673 / 175545  ),
    (   7918 /  409605,  87881 / 737289, 1001167 / 1053270 ),
    // dart format on
  );

  return _multiplyMatrix(M, _maybeNanTuple(value));
}

_LinearSrgb _xyzToLinearSrgb(_XyzD65 value) {
  const M = (
    // dart format off
    (   12831 /   3959,    -329 /    214, -1974 /   3959 ),
    ( -851781 / 878810, 1648619 / 878810, 36519 / 878810 ),
    (     705 /  12673,   -2585 /  12673,   705 /    667 ),
    // dart format on
  );

  return _multiplyMatrix(M, _maybeNanTuple(value));
}

// display-p3 functions

_LinearDisplayP3 _displayP3ToLinearDisplayP3(_DisplayP3 value) => _srgbToLinearRgb(value);
_DisplayP3 _linearDisplayP3ToDisplayP3(_LinearDisplayP3 value) => _linearRgbToSrgb(value);

_XyzD65 _linearDisplayP3ToXyz(_LinearDisplayP3 value) {
  const M = (
    // dart format off
		( 608311 / 1250200, 189793 / 714400,  198249 / 1000160 ),
		(  35783 /  156275, 247089 / 357200,  198249 / 2500400 ),
		(      0 /       1,  32229 / 714400, 5220557 / 5000800 ),
    // dart format on
  );

  return _multiplyMatrix(M, _maybeNanTuple(value));
}

_LinearDisplayP3 _xyzToLinearDisplayP3(_XyzD65 value) {
  const M = (
    // dart format off
		( 446124 / 178915, -333277 / 357830, -72051 / 178915 ),
		( -14852 /  17905,   63121 /  35810,    423 /  17905 ),
		(  11844 / 330415,  -50337 / 660830, 316169 / 330415 ),
  );

  return _multiplyMatrix(M, _maybeNanTuple(value));
}

/* !!
  Omitted: prophoto-rgb, a98-rgb, Rec. 2020
*/

// Chromatic adaptation

_XyzD50 _xyzD65ToD50(_XyzD65 value) {
  const M = (
    // dart format off
		(  1.0479297925449969,    0.022946870601609652,  -0.05019226628920524  ),
		(  0.02962780877005599,   0.9904344267538799,    -0.017073799063418826 ),
		( -0.009243040646204504,  0.015055191490298152,   0.7518742814281371   ),
    // dart format on
  );

  return _multiplyMatrix(M, _maybeNanTuple(value));
}

_XyzD65 _xyzD50ToD65(_XyzD50 value) {
  const M = (
    // dart format off
		(  0.955473421488075,    -0.02309845494876471,   0.06325924320057072  ),
		( -0.0283697093338637,    1.0099953980813041,    0.021041441191917323 ),
		(  0.012314014864481998, -0.020507649298898964,  1.330365926242124    ),
  );

  return _multiplyMatrix(M, _maybeNanTuple(value));
}

// CIE Lab and LCH 
// Note: CSS uses D50 white point for CIELAB/LCH.

@pragma('vm:prefer-inline')
double _cbrt(double v) => v.sign * math.pow(v.abs(), 1.0 / 3.0);

@pragma('vm:prefer-inline')
double _pow3(double v) => math.pow(v, 3.0).toDouble();

@pragma('vm:prefer-inline')
double _ft(double v) {
  const epsilon = 216 / 24389;
  const kappa = 24389 / 27;
  if (v > epsilon) return _cbrt(v);
  return (kappa * v + 16.0) / 116.0;
}

_Lab _xyzToLab(_XyzD50 value) {
  final v = _maybeNanTuple(value);
  final (x, y, z) = (v.$1 / _d50.$1, v.$2 / _d50.$2, v.$3 / _d50.$3);
  final f = (_ft(x), _ft(y), _ft(z));

  return (
    (116.0 * f.$2) - 16.0,
    500.0 * (f.$1 - f.$2),
    200.0 * (f.$2 - f.$3),
  );
}

_XyzD50 _labToXyz(_Lab value) {
  final v = _maybeNanTuple(value);

  const kappa = 24389 / 27;
  const epsilon = 216 / 24389;

  final f1 = (v.$1 + 16.0) / 116.0;
  final f0 = (v.$2 / 500.0) + f1;
  final f2 = f1 - (v.$3 / 200.0);

  final f0pow3 = math.pow(f0, 3.0);
  final f2pow3 = math.pow(f2, 3.0);

  final xyz = (
    // dart format off
    f0pow3 > epsilon           ? f0pow3                                   : (116.0 * f0 - 16.0) / kappa,
    v.$1 > kappa * epsilon ? math.pow((v.$1 + 16.0) / 116.0, 3.0) : v.$1 / kappa,
    f2pow3 > epsilon           ?           f2pow3                         : (116.0 * f2 - 16.0) / kappa,
    // dart format on
  );

  return (xyz.$1 * _d50.$1, xyz.$2 * _d50.$2, xyz.$3 * _d50.$3);
}

const _rad2deg = 180.0 / math.pi;
const _deg2rad = math.pi / 180.0;

_Lch _labToLch(_Lab value) {
  final v = _maybeNanTuple(value);

  const epsilon = 0.0015;
  final chroma = math.sqrt(math.pow(v.$2, 2.0) + math.pow(v.$3, 2.0));
  var hue = math.atan2(v.$3, v.$2) * _rad2deg;

  if (hue < 0) hue += 360.0;
  if (chroma <= epsilon) hue = double.nan;

  return (v.$1, chroma, hue);
}

_Lab _lchToLab(_Lch value) {
  final v = _maybeNanTuple(value);

  return (
    v.$1,
    v.$2 * math.cos(v.$3 * _deg2rad),
    v.$2 * math.sin(v.$3 * _deg2rad),
  );
}

// OkLab and OKLCH

_Oklab _xyzToOklab(_XyzD65 value) {
  const xyzToLms = (
    // dart format off
		( 0.8190224379967030, 0.3619062600528904, -0.1288737815209879 ),
		( 0.0329836539323885, 0.9292868615863434,  0.0361446663506424 ),
		( 0.0481771893596242, 0.2642395317527308,  0.6335478284694309 ),
    // dart format on
  );

  const lmsToOklab = (
    // dart format off
		( 0.2104542683093140,  0.7936177747023054, -0.0040720430116193 ),
		( 1.9779985324311684, -2.4285922420485799,  0.4505937096174110 ),
		( 0.0259040424655478,  0.7827717124575296, -0.8086757549230774 ),
    // dart format on
  );

  final lms = _multiplyMatrix(xyzToLms, _maybeNanTuple(value));
  return _multiplyMatrix(lmsToOklab, (_cbrt(lms.$1), _cbrt(lms.$2), _cbrt(lms.$3)));
}

_XyzD65 _oklabToXyz(_Oklab value) {
  const lmsToXyz = (
    // dart format off
		(  1.2268798758459243, -0.5578149944602171,  0.2813910456659647 ),
		( -0.0405757452148008,  1.1122868032803170, -0.0717110580655164 ),
		( -0.0763729366746601, -0.4214933324022432,  1.5869240198367816 ),
    // dart format on
  );

  const oklabToLms = (
    // dart format off
		( 1.0000000000000000,  0.3963377773761749,  0.2158037573099136 ),
		( 1.0000000000000000, -0.1055613458156586, -0.0638541728258133 ),
		( 1.0000000000000000, -0.0894841775298119, -1.2914855480194092 ),
    // dart format on
  );

  final lmsnl = _multiplyMatrix(oklabToLms, _maybeNanTuple(value));
  return _multiplyMatrix(lmsToXyz, (_pow3(lmsnl.$1), _pow3(lmsnl.$2), _pow3(lmsnl.$3)));
}

_Oklch _oklabToOklch(_Oklab value) {
  final v = _maybeNanTuple(value);

  const epsilon = 0.000004;
  var hue = math.atan2(v.$3, v.$2) * _rad2deg;
  final chroma = math.sqrt(math.pow(v.$2, 2.0) + math.pow(v.$3, 2.0));
  if (hue < 0) hue += 360.0;
  if (chroma <= epsilon) hue = double.nan;

  return (v.$1, chroma, hue);
}

_Oklab _oklchToOklab(_Oklch value) {
  final v = _maybeNanTuple(value);

  return (
    v.$1,
    v.$2 * math.cos(v.$3 * _deg2rad),
    v.$2 * math.sin(v.$3 * _deg2rad),
  );
}
