import 'package:ui/ui.dart';

class TextFormField extends TextFormFieldBase {
  TextFormField({
    super.autovalidateMode,
    super.enabled,
    super.initialValue,
    super.key,
    super.onChanged,
    super.validator,
    super.inputFormatters,
    TextFieldOptions options = const .new(),
  }) : super(
         builder: (context, controller, errorText, inputFormatters) {
           return TextField(
             controller: controller,
             inputFormatters: inputFormatters,
             options: options,
           );
         },
       );
}

class IntTextFormField extends IntTextFormFieldBase {
  IntTextFormField({
    super.autovalidateMode,
    super.enabled,
    super.initialValue,
    super.key,
    super.onChanged,
    super.validator,
    super.min,
    super.max,
    TextFieldOptions options = const .new(),
  }) : super(
         builder: (context, controller, errorText, inputFormatters) {
           return TextField(
             controller: controller,
             inputFormatters: inputFormatters,
             options: options,
           );
         },
       );
}

class DoubleTextFormField extends DoubleTextFormFieldBase {
  DoubleTextFormField({
    super.autovalidateMode,
    super.enabled,
    super.initialValue,
    super.key,
    super.onChanged,
    super.validator,
    super.min,
    super.max,
    TextFieldOptions options = const .new(),
  }) : super(
         builder: (context, controller, errorText, inputFormatters) {
           return TextField(
             controller: controller,
             inputFormatters: inputFormatters,
             options: options,
           );
         },
       );
}
