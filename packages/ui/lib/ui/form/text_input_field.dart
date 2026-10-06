import 'package:ui/ui.dart';

String _valueToString(String? v) => v ?? '';
String _valueFromString(String? v) => v ?? '';

final class const TextInputField({
  super.key,
  required super.value,
  super.onChanged,
  super.sessionCallbacks,
  super.options,
  super.onTap,
  super.valueToString = _valueToString,
  super.valueFromString = _valueFromString,
}) extends ValueTextInputField<String>;
