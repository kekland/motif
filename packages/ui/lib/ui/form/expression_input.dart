import 'package:flutter/gestures.dart';
import 'package:ui/ui.dart';

final _logger = Logger('ExpressionInputField');

class ExpressionInputField<T> extends HookWidget {
  const ExpressionInputField({
    super.key,
    required this.valueToString,
    required this.evaluateExpression,
    required this.value,
    this.onChanged,
    this.supportedDevices,
    this.options = const .new(),
  });

  final ReadonlySignal<T?> value;
  final ValueChanged<T>? onChanged;
  final String Function(T?) valueToString;
  final T Function(String) evaluateExpression;
  final TextFieldOptions options;
  final Set<PointerDeviceKind>? supportedDevices;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    final didChange = useRef(false);

    useSignalEffect(() {
      final v = value();
      if (didChange.value) return;
      controller.text = valueToString(v);
      return null;
    }, keys: [value]);

    void onEditingComplete() {
      try {
        final result = evaluateExpression(controller.text);

        onChanged?.call(result);
        controller.text = valueToString(result);
      } catch (e) {
        _logger.warning('Failed to parse expression: ${controller.text}: $e');
        controller.text = valueToString(value.value);
      }

      didChange.value = false;
    }

    $useListenerEffect(focusNode, () {
      if (!focusNode.hasFocus) onEditingComplete();
    });

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: (_) => didChange.value = true,
      onEditingComplete: onEditingComplete,
      supportedDevices: supportedDevices,
      options: options,
    );
  }
}

class DoubleExpressionInputField extends StatelessWidget {
  const DoubleExpressionInputField({
    super.key,
    required this.value,
    this.onChanged,
    this.fractionDigits = 3,
    this.supportedDevices,
    this.options = const .new(),
  });

  final ReadonlySignal<double?> value;
  final ValueChanged<double>? onChanged;
  final int fractionDigits;
  final Set<PointerDeviceKind>? supportedDevices;
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
      supportedDevices: supportedDevices,
      evaluateExpression: (s) => evaluateExpression<num>(s).toDouble(),
      options: options,
    );
  }
}
