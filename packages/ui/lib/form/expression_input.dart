import 'package:flutter/foundation.dart';
import 'package:ui/ui.dart';

final _logger = Logger('ExpressionInputField');

class ExpressionInputField<T> extends HookWidget {
  const ExpressionInputField({
    super.key,
    required this.valueToString,
    required this.evaluateExpression,
    this.value,
    this.onChanged,
    this.options = const .new(),
  });

  final T? value;
  final ValueChanged<T>? onChanged;
  final String Function(T?) valueToString;
  final T Function(String) evaluateExpression;
  final TextFieldOptions options;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    final didChange = useRef(false);

    useEffect(() {
      if (didChange.value) return;
      controller.text = valueToString(value);
      return null;
    }, [value]);

    void onEditingComplete() {
      try {
        final result = evaluateExpression(controller.text);

        onChanged?.call(result);
        controller.text = valueToString(result);
      } catch (e) {
        _logger.warning('Failed to parse expression: ${controller.text}: $e');
        controller.text = valueToString(value);
      }

      didChange.value = false;
    }

    useListenerEffect(focusNode, () {
      if (!focusNode.hasFocus) {
        onEditingComplete();
      }
    });

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: (_) => didChange.value = true,
      onEditingComplete: onEditingComplete,
      options: options,
    );
  }
}

class DoubleExpressionInputField extends StatelessWidget {
  const DoubleExpressionInputField({
    super.key,
    this.value,
    this.onChanged,
    this.fractionDigits = 3,
    this.options = const .new(),
  });

  final double? value;
  final ValueChanged<double>? onChanged;
  final int fractionDigits;
  final TextFieldOptions options;

  String _valueToString(double? value) {
    if (value == null) return '';
    if (value % 1 < precisionErrorTolerance) {
      return value.toInt().toString();
    }

    final str = value.toStringAsFixed(fractionDigits);
    return str;
  }

  @override
  Widget build(BuildContext context) {
    return ExpressionInputField<double>(
      value: value,
      onChanged: onChanged,
      valueToString: _valueToString,
      evaluateExpression: (s) => evaluateExpression<num>(s).toDouble(),
      options: options,
    );
  }
}
