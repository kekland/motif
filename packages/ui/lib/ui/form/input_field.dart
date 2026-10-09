import 'package:ui/ui.dart';

extension type InputSessionCallbacks._((VoidCallback?, VoidCallback?) _) {
  InputSessionCallbacks({
    VoidCallback? onStartEditing,
    VoidCallback? onEndEditing,
  }) : _ = (onStartEditing, onEndEditing);

  VoidCallback? get onStart => _.$1;
  VoidCallback? get onEnd => _.$2;

  void start() => onStart?.call();
  void end() => onEnd?.call();
}

abstract class InputField<T> extends HookWidget {
  const InputField({
    super.key,
    required this.value,
    this.sessionCallbacks,
    this.onChanged,
    this.options = const .new(),
    this.focusNode,
  });

  final ReadonlySignal<T?> value;
  final InputSessionCallbacks? sessionCallbacks;
  final ValueChanged<T>? onChanged;
  final InputFieldOptions options;
  final FocusNode? focusNode;
}
