part of 'color.dart';

class _Serializer {
  static String _double(double v) {
    if (v.isNaN) return 'none';
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(4);
  }

  static String toCssString(
    ColorData colorData, {
    required String modelName,
    bool hasOwnFunction = true,
  }) {
    final values = [_double(colorData._v1), _double(colorData._v2), _double(colorData._v3)];
    final alpha = colorData.alpha == 1.0 ? null : _double(colorData.alpha);
    var valueStr = values.join(' ');
    if (alpha != null) valueStr += ' / $alpha';

    if (hasOwnFunction) {
      return '$modelName($valueStr)';
    } else {
      return 'color($modelName $valueStr)';
    }
  }
}
