import 'package:ui/slate.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide FormField, FormFieldState;

typedef TextFormFieldBuilder =
    Widget Function(
      BuildContext context,
      TextEditingController controller,
      String? errorText,
      List<TextInputFormatter>? inputFormatters,
    );

class AbstractTextFormFieldBase<T> extends FormField<T> {
  AbstractTextFormFieldBase({
    super.key,
    super.autovalidateMode,
    super.enabled,
    super.initialValue,
    super.validator,
    super.onChanged,
    this.inputFormatters,
    required this.valueToString,
    required this.stringToValue,
    required TextFormFieldBuilder builder,
  }) : super(
         builder: (_state) {
           final state = _state as TextFormFieldState;

           return builder.call(
             _state.context,
             state.controller,
             state.errorText,
             inputFormatters,
           );
         },
       );

  final String Function(T value) valueToString;
  final T Function(String value) stringToValue;
  final List<TextInputFormatter>? inputFormatters;

  @override
  TextFormFieldState<T> createState() => TextFormFieldState<T>();
}

class TextFormFieldState<T> extends FormFieldState<T> {
  @override
  AbstractTextFormFieldBase<T> get widget => super.widget as AbstractTextFormFieldBase<T>;

  late TextEditingController controller;

  String _valueToString(T? value) => value != null ? widget.valueToString(value) : '';
  T? _stringToValue(String value) => value.isNotEmpty ? widget.stringToValue(value) : null;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: _valueToString(widget.initialValue));
    setValue(_stringToValue(controller.text));
    controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    didChange(_stringToValue(controller.text));
  }

  @override
  void reset() {
    controller.dispose();
    controller = TextEditingController(text: _valueToString(widget.initialValue));
    controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

// --
// Concrete implementations for common types
// --

class TextFormFieldBase extends AbstractTextFormFieldBase<String> {
  TextFormFieldBase({
    super.key,
    required super.builder,
    super.autovalidateMode,
    super.enabled,
    super.initialValue,
    super.onChanged,
    super.validator,
    super.inputFormatters,
  }) : super(
         stringToValue: (value) => value,
         valueToString: (value) => value,
       );
}

class IntTextFormFieldBase extends AbstractTextFormFieldBase<int> {
  IntTextFormFieldBase({
    super.key,
    required super.builder,
    super.autovalidateMode,
    super.enabled,
    super.initialValue,
    super.onChanged,
    super.validator,
    int? min,
    int? max,
  }) : super(
         stringToValue: (value) => int.tryParse(value) ?? 0,
         valueToString: (value) => value.toString(),
         inputFormatters: [
           IntTextInputFormatter(
             min: min ?? IntTextInputFormatter.minSafeValue,
             max: max ?? IntTextInputFormatter.maxSafeValue,
           ),
         ],
       );
}

class DoubleTextFormFieldBase extends AbstractTextFormFieldBase<double> {
  DoubleTextFormFieldBase({
    super.key,
    required super.builder,
    super.autovalidateMode,
    super.enabled,
    super.initialValue,
    super.onChanged,
    super.validator,
    double? min,
    double? max,
  }) : super(
         stringToValue: (value) => double.tryParse(value) ?? 0.0,
         valueToString: (value) => value.toString(),
         inputFormatters: [
           DoubleTextInputFormatter(
             min: min ?? DoubleTextInputFormatter.minSafeValue,
             max: max ?? DoubleTextInputFormatter.maxSafeValue,
           ),
         ],
       );
}
