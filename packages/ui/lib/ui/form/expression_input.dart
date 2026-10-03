import 'package:ui/ui.dart';

final _logger = Logger('ExpressionInputField');

class ExpressionInputField<T> extends ValueTextInputField<T> {
  ExpressionInputField({
    super.key,
    required super.valueToString,
    required T? Function(String) evaluateExpression,
    required super.value,
    super.onChanged,
    super.sessionCallbacks,
    super.options = const .new(),
  }) : super(
         valueFromString: (s) {
           try {
             return evaluateExpression(s);
           } catch (e) {
             _logger.warning('Failed to evaluate expression: $s: $e');
             return null;
           }
         },
       );
}

class IntExpressionInputField extends ExpressionInputField<int> {
  IntExpressionInputField({
    super.key,
    required super.value,
    super.sessionCallbacks,
    super.onChanged,
    super.options,
  }) : super(
         valueToString: (v) {
           if (v == null) return '';
           return v.toString();
         },
         evaluateExpression: (s) => evaluateExpression<num>(s).toInt(),
       );
}

class DoubleExpressionInputField extends ExpressionInputField<double> {
  DoubleExpressionInputField({
    super.key,
    required super.value,
    super.sessionCallbacks,
    super.onChanged,
    super.options,
    this.fractionDigits = 3,
  }) : super(
         valueToString: (v) {
           if (v == null) return '';
           if (v % 1 < precisionErrorTolerance) {
             return v.toInt().toString();
           }

           final str = v.toStringAsFixed(fractionDigits);
           return str;
         },
         evaluateExpression: (s) => evaluateExpression<num>(s).toDouble(),
       );

  final int fractionDigits;
}
