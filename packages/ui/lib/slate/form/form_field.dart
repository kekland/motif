import 'package:flutter/widgets.dart' hide FormField, FormFieldState;
import 'package:flutter/widgets.dart' as widgets show FormField, FormFieldState;

class FormField<T> extends widgets.FormField<T> {
  const FormField({
    super.key,
    required super.builder,
    this.onChanged,
    super.enabled,
    super.autovalidateMode,
    super.initialValue,
    super.validator,
    this.shouldRevalidateIfError = true,
  });

  final ValueChanged<T?>? onChanged;
  final bool shouldRevalidateIfError;

  static InheritedFormFieldState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedFormFieldState>();
  }

  @override
  FormFieldState<T> createState() => FormFieldState<T>();
}

class FormFieldState<T> extends widgets.FormFieldState<T> {
  @override
  FormField<T> get widget => super.widget as FormField<T>;

  bool _hadError = false;

  void maybeRevalidate(FormFieldState state) {
    _hadError |= state.hasError;

    if (widget.shouldRevalidateIfError && _hadError) {
      state.validate();
    }
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    widget.onChanged?.call(value);
    maybeRevalidate(this);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedFormFieldState(
      errorText: errorText,
      child: super.build(context),
    );
  }
}

class InheritedFormFieldState extends InheritedWidget {
  const InheritedFormFieldState({
    super.key,
    required this.errorText,
    required super.child,
  });

  final String? errorText;

  bool get hasError => errorText != null;

  @override
  bool updateShouldNotify(InheritedFormFieldState oldWidget) {
    return errorText != oldWidget.errorText;
  }
}
