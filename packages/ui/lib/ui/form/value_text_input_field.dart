import 'package:ui/ui.dart';

class ValueTextInputField<T> extends InputField<T> {
  const ValueTextInputField({
    super.key,
    required super.value,
    this.valueFromString,
    this.valueToString,
    this.onTap,
    super.onChanged,
    super.sessionCallbacks,
    super.options,
  });

  final String Function(T?)? valueToString;
  final T? Function(String)? valueFromString;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    final didChange = useRef(false);

    final valueToString = this.valueToString ?? (v) => v?.toString() ?? '';
    final valueFromString = this.valueFromString ?? (_) => null;

    useSignalEffect(() {
      final v = value();
      if (didChange.value) return;
      controller.text = valueToString(v);
      return null;
    }, keys: [value]);

    void onEditingComplete() {
      final result = valueFromString(controller.text);
      if (result == null) {
        controller.text = valueToString(value());
        return;
      }

      onChanged?.call(result);
      controller.text = valueToString(result);
      didChange.value = false;
    }

    useListenerEffect(focusNode, () {
      if (!focusNode.hasFocus) onEditingComplete();
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
