import 'dart:math' as math;

import 'package:expressions/expressions.dart' as expr;
import 'package:vector_math/vector_math_64.dart' as vm;

vm.Vector4? _parseHexColor(String hex) {
  var _hex = hex;
  if (_hex.startsWith('#')) _hex = _hex.substring(1);

  // Check if it only contains hex digits.
  final hexOnlyRegex = RegExp(r'^[0-9a-fA-F]+$');
  if (_hex.contains('0x') || !hexOnlyRegex.hasMatch(_hex)) return null;

  // F -> FFFFFF, AB -> ABABAB
  if (_hex.length == 1 || _hex.length == 2) {
    final v = int.parse(_hex * (2 ~/ _hex.length), radix: 16);
    return vm.Vector4(v.toDouble(), v.toDouble(), v.toDouble(), 255.0);
  }

  // ABC -> AABBCC, ABCD -> AABBCCDD, ABCDE -> AABBCCDE
  if (_hex.length == 3 || _hex.length == 4 || _hex.length == 5) {
    final r = int.parse(_hex[0] * 2, radix: 16);
    final g = int.parse(_hex[1] * 2, radix: 16);
    final b = int.parse(_hex[2] * 2, radix: 16);
    var a = 255.0;

    if (_hex.length == 4) a = int.parse(_hex[3] * 2, radix: 16).toDouble();
    if (_hex.length == 5) a = int.parse(_hex.substring(3), radix: 16).toDouble();

    return vm.Vector4(r.toDouble(), g.toDouble(), b.toDouble(), a);
  }

  // ABCDEF -> ABCDEF, ABCDEFA -> ABCDEFAA, ABCDEFAB -> ABCDEFAB
  if (_hex.length == 6 || _hex.length == 7 || _hex.length == 8) {
    final r = int.parse(_hex.substring(0, 2), radix: 16);
    final g = int.parse(_hex.substring(2, 4), radix: 16);
    final b = int.parse(_hex.substring(4, 6), radix: 16);
    var a = 255.0;

    if (_hex.length == 7) a = int.parse(_hex[6] * 2, radix: 16).toDouble();
    if (_hex.length == 8) a = int.parse(_hex.substring(6), radix: 16).toDouble();

    return vm.Vector4(r.toDouble(), g.toDouble(), b.toDouble(), a);
  }

  return null;
}

final _constructors = <String, dynamic>{
  'vec2': (num x, num y) => vm.Vector2(x.toDouble(), y.toDouble()),
  'vec3': (num x, num y, num z) => vm.Vector3(x.toDouble(), y.toDouble(), z.toDouble()),
  'vec4': (num x, num y, num z, num w) => vm.Vector4(x.toDouble(), y.toDouble(), z.toDouble(), w.toDouble()),
  'rgb': (num r, num g, num b) => vm.Vector4(r.toDouble(), g.toDouble(), b.toDouble(), 255.0),
  'rgba': (num r, num g, num b, num a) => vm.Vector4(r.toDouble(), g.toDouble(), b.toDouble(), a.toDouble()),
  'hex': (String hex) {
    final color = _parseHexColor(hex);
    if (color == null) throw FormatException('Invalid hex color: $hex');
    return color;
  },
};

final _constants = <String, dynamic>{
  'e': math.e,
  'pi': math.pi,
  'black': vm.Vector4(0, 0, 0, 1),
  'white': vm.Vector4(1, 1, 1, 1),
  'red': vm.Vector4(1, 0, 0, 1),
  'green': vm.Vector4(0, 1, 0, 1),
  'blue': vm.Vector4(0, 0, 1, 1),
};

final _methods = <String, dynamic>{
  'sqrt': (num x) => math.sqrt(x),
  'sin': (num x) => math.sin(x),
  'cos': (num x) => math.cos(x),
  'tan': (num x) => math.tan(x),
  'asin': (num x) => math.asin(x),
  'acos': (num x) => math.acos(x),
  'atan': (num x) => math.atan(x),
  'atan2': (num y, num x) => math.atan2(y, x),
  'log': (num x) => math.log(x),
  'log10': (num x) => math.log(x) / math.ln10,
  'log2': (num x) => math.log(x) / math.ln2,
  'exp': (num x) => math.exp(x),
  'pow': (num b, num e) => math.pow(b, e),
  'max': (num a, num b) => math.max(a, b),
  'min': (num a, num b) => math.min(a, b),
  'abs': (num x) => x.abs(),
  'sign': (num x) => x.sign,
  'floor': (num x) => x.floor(),
  'ceil': (num x) => x.ceil(),
  'round': (num x) => x.round(),
};

final _context = <String, dynamic>{
  ..._constructors,
  ..._constants,
  ..._methods,
};

final _evaluator = expr.ExpressionEvaluator();

String _replaceHexColors(String expr) {
  final hexColorRegex = RegExp(r'#[0-9a-fA-F]{1,8}');
  return expr.replaceAllMapped(hexColorRegex, (match) {
    final hex = match.group(0)!;
    if (_parseHexColor(hex) != null) {
      return 'hex("$hex")';
    }
    return hex;
  });
}

T evaluateExpression<T>(String expression) {
  final isColor = T == vm.Vector4;
  if (isColor && _parseHexColor(expression) != null) return _parseHexColor(expression) as T;

  var _expression = expression;
  if (isColor) _expression = _replaceHexColors(_expression);

  final parsedExpression = expr.Expression.parse(_expression);
  final result = _evaluator.eval(parsedExpression, _context);

  if (result is! T) {
    throw ArgumentError('Expression did not evaluate to expected type. Expected: $T, got: ${result.runtimeType}');
  }

  return result;
}
