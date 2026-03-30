part of 'color.dart';

// Base building blocks
final _sign = pattern('+-');
final _digits = digit().plus();
final _decimal = (char('.') & _digits).flatten().map(double.parse);
final _exponent = (pattern('eE') & _sign.optional() & _digits).flatten().map(double.parse);

// Numeric values
final _$number = (_digits & _decimal.optional()) | _decimal;
final _number = (_sign.optional() & _$number & _exponent.optional()).flatten().trim().map(double.parse);
final _percentage = (_number & char('%')).trim().map((s) => s[0] / 100.0);
final _none = string('none', ignoreCase: true).trim().constant(double.nan);
final _hexDigit = pattern('0-9a-f', ignoreCase: true);

// Angles (resolves to degrees)
final _degUnit = string('deg', ignoreCase: true);
final _gradUnit = string('grad', ignoreCase: true);
final _radUnit = string('rad', ignoreCase: true);
final _turnUnit = string('turn', ignoreCase: true);

final _degrees = (_number & _degUnit).map((r) => r[0]).cast<double>();
final _gradians = (_number & _gradUnit).map((r) => (r[0] / 400.0) * 360.0).cast<double>();
final _radians = (_number & _radUnit).map((r) => (r[0] / math.pi) * 180.0).cast<double>();
final _turns = (_number & _turnUnit).map((r) => r[0] * 360.0).cast<double>();
final _angle = (_degrees | _gradians | _radians | _turns).cast<double>();

// Separators
final _comma = char(',').trim().optional();

// Color component values
Parser<double> _componentValue(double min, double max) =>
    (_percentage.map((v) => v * (max - min) + min) | _number).cast();
Parser<double> _component(double min, double max) => (_componentValue(min, max) | _none).cast();

// Hue values
final _hueValue = (_angle | _number).map((v) => (v as double) % 360.0);
final _hue = (_hueValue | _none).cast<double>();

// Alpha values
final _alphaValue = (_percentage | _number).cast();
final _alphaSlash = (char('/') | char(',')).trim();
final _alpha = (_alphaSlash & (_alphaValue | _none)).map((v) => v[1] as double);

// Clamp (preserving NaN)
double _clamp(double v, double min, double max) => v.isNaN ? .nan : v.clamp(min, max);

// Generic color function parser
Parser<T> _colorFunction<T extends ColorData>(
  List<String> names,
  List<Parser<double>> componentParsers,
  T Function(List<double> components, double alpha) constructor,
) {
  final sequence = <Parser>[];
  for (var i = 0; i < componentParsers.length; i++) {
    sequence.add(componentParsers[i]);
    if (i < componentParsers.length - 1) sequence.add(_comma);
  }

  final componentSequence = sequence.toSequenceParser().map((v) {
    return [for (var i = 0; i < v.length; i += 2) v[i] as double];
  });

  final parser =
      names.map((n) => string(n, ignoreCase: true)).toChoiceParser().trim() &
      char('(').trim() &
      componentSequence &
      _alpha.optional() &
      char(')').trim();

  return parser.map((values) {
    final components = values[2] as List<double>;
    final a = values[3] as double? ?? 1.0;
    return constructor(components, a);
  });
}

final _srgbParser = _colorFunction<SrgbColorData>(
  ['rgba', 'rgb'],
  [_component(0, 255), _component(0, 255), _component(0, 255)],
  (c, a) => .new(
    r: c[0] / 255.0,
    g: c[1] / 255.0,
    b: c[2] / 255.0,
    alpha: _clamp(a, 0.0, 1.0),
  ),
);

/// Extension from CSS parser: allow 1-8 digits. CSS only allows 3, 4, 6, or 8.
final _hexParser = (char('#') & _hexDigit.repeat(1, 8)).trim().map((v) {
  final d = v[1];
  final length = v.length;

  // F -> FFFFFF, AB -> ABABAB
  if (length == 1 || length == 2) {
    final v = int.parse(d * (2 ~/ length), radix: 16) / 255.0;
    return SrgbColorData(r: v, g: v, b: v);
  }

  // ABC -> AABBCC, ABCD -> AABBCCDD, ABCDE -> AABBCCDE
  if (length == 3 || length == 4 || length == 5) {
    final r = int.parse(d[0] * 2, radix: 16) / 255.0;
    final g = int.parse(d[1] * 2, radix: 16) / 255.0;
    final b = int.parse(d[2] * 2, radix: 16) / 255.0;
    var a = 1.0;

    if (d.length == 4) a = int.parse(d[3] * 2, radix: 16).toDouble() / 255.0;
    if (d.length == 5) a = int.parse(d.substring(3), radix: 16).toDouble() / 255.0;

    return SrgbColorData(r: r, g: g, b: b, alpha: a);
  }

  // ABCDEF -> ABCDEF, ABCDEFA -> ABCDEFAA, ABCDEFAB -> ABCDEFAB
  if (length == 6 || length == 7 || length == 8) {
    final r = int.parse(d.substring(0, 2), radix: 16) / 255.0;
    final g = int.parse(d.substring(2, 4), radix: 16) / 255.0;
    final b = int.parse(d.substring(4, 6), radix: 16) / 255.0;
    var a = 1.0;

    if (length == 7) a = int.parse(d[6] * 2, radix: 16).toDouble() / 255.0;
    if (length == 8) a = int.parse(d.substring(6), radix: 16).toDouble() / 255.0;

    return SrgbColorData(r: r, g: g, b: b, alpha: a);
  }

  throw ArgumentError.value(v, 'invalid hex color');
});

final _hslParser = _colorFunction<HslColorData>(
  ['hsla', 'hsl'],
  [_hue, _component(0, 100), _component(0, 100)],
  (c, a) => .new(
    h: c[0] % 360.0,
    s: _clamp(c[1], 0.0, 100.0),
    l: _clamp(c[2], 0.0, 100.0),
    alpha: _clamp(a, 0.0, 1.0),
  ),
);

final _hsvParser = _colorFunction<HsvColorData>(
  ['hsva', 'hsv'],
  [_hue, _component(0, 100), _component(0, 100)],
  (c, a) => .new(
    h: c[0] % 360.0,
    s: _clamp(c[1], 0.0, 100.0),
    v: _clamp(c[2], 0.0, 100.0),
    alpha: _clamp(a, 0.0, 1.0),
  ),
);

final _hwbParser = _colorFunction<HwbColorData>(
  ['hwb'],
  [_hue, _component(0, 100), _component(0, 100)],
  (c, a) => .new(
    h: c[0] % 360.0,
    w: _clamp(c[1], 0.0, 100.0),
    b: _clamp(c[2], 0.0, 100.0),
    alpha: _clamp(a, 0.0, 1.0),
  ),
);

final _labParser = _colorFunction<LabColorData>(
  ['lab'],
  [_component(0.0, 100.0), _component(-125, 125), _component(-125, 125)],
  (c, a) => .new(
    l: _clamp(c[0], 0.0, 100.0),
    a: c[1],
    b: c[2],
    alpha: _clamp(a, 0.0, 1.0),
  ),
);

final _lchParser = _colorFunction<LchColorData>(
  ['lch'],
  [_component(0.0, 100.0), _component(0.0, 150.0), _hue],
  (c, a) => .new(
    l: _clamp(c[0], 0.0, 100.0),
    c: _clamp(c[1], 0.0, .infinity),
    h: c[2] % 360.0,
    alpha: _clamp(a, 0.0, 1.0),
  ),
);

final _oklabParser = _colorFunction<OklabColorData>(
  ['oklab'],
  [_component(0.0, 1.0), _component(-0.4, 0.4), _component(-0.4, 0.4)],
  (c, a) => .new(
    l: _clamp(c[0], 0.0, 1.0),
    a: c[1],
    b: c[2],
    alpha: _clamp(a, 0.0, 1.0),
  ),
);

final _oklchParser = _colorFunction<OklchColorData>(
  ['oklch'],
  [_component(0.0, 1.0), _component(0.0, 0.4), _hue],
  (c, a) => .new(
    l: _clamp(c[0], 0.0, 1.0),
    c: _clamp(c[1], 0.0, .infinity),
    h: c[2] % 360.0,
    alpha: _clamp(a, 0.0, 1.0),
  ),
);

// Generic color function
Parser<ColorModel> _modelParser(String s, ColorModel m) => string(s, ignoreCase: true).trim().constant(m);
final _xyz = _modelParser('xyz', .xyzD65);
final _xyzD65 = _modelParser('xyz-d65', .xyzD65);
final _xyzD50 = _modelParser('xyz-d50', .xyzD50);
final _xyzSpace = (_xyzD65 | _xyzD50 | _xyz).cast<ColorModel>();
final _xyzParams = _xyzSpace & _component(0.0, 1.0).repeatSeparated(_comma, 3, 3).map((r) => r.elements);

final _srgb = _modelParser('srgb', .srgb);
final _srgbLinear = _modelParser('srgb-linear', .srgbLinear);
final _displayP3 = _modelParser('display-p3', .displayP3);
final _displayP3Linear = _modelParser('display-p3-linear', .displayP3Linear);
// omitted: a98-rgb, prophoto-rgb, rec2020
final _predefinedRgb = (_srgbLinear | _srgb | _displayP3Linear | _displayP3).cast<ColorModel>();
final _predefinedRgbParams = _predefinedRgb & _component(0.0, 1.0).repeatSeparated(_comma, 3, 3).map((r) => r.elements);

final _colorspaceParams = _predefinedRgbParams | _xyzParams;
final _$predefinedColorParser =
    string('color', ignoreCase: true).trim() &
    char('(').trim() &
    _colorspaceParams &
    _alpha.optional() &
    char(')').trim();

final _predefinedColorParser = _$predefinedColorParser.map((v) {
  final colorModel = v[2][0] as ColorModel;
  final [double v1, double v2, double v3] = v[2][1];
  final alpha = _clamp(v[3] as double? ?? 1.0, 0.0, 1.0);

  return switch (colorModel) {
    .xyzD65 => XyzD65ColorData(x: v1, y: v2, z: v3, alpha: alpha),
    .xyzD50 => XyzD50ColorData(x: v1, y: v2, z: v3, alpha: alpha),
    .srgb => SrgbColorData(r: v1, g: v2, b: v3, alpha: alpha),
    .srgbLinear => SrgbLinearColorData(r: v1, g: v2, b: v3, alpha: alpha),
    .displayP3 => DisplayP3ColorData(r: v1, g: v2, b: v3, alpha: alpha),
    .displayP3Linear => DisplayP3LinearColorData(r: v1, g: v2, b: v3, alpha: alpha),
    _ => throw ArgumentError.value(colorModel, 'unknown color model'),
  };
});

final _$colorParser =
    _srgbParser |
    _hexParser |
    _hslParser |
    _hsvParser |
    _hwbParser |
    _labParser |
    _lchParser |
    _oklabParser |
    _oklchParser |
    _predefinedColorParser;

final _colorParser = _$colorParser.cast<ColorData>();
