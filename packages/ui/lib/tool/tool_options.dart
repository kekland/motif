import 'package:ui/ui.dart';

abstract class ToolOption<T> {
  ToolOption(this.key, this.value);

  final String key;
  final T value;

  ToolOption<T> copyWith({T? value});

  Signal<T> createSignal() => Signal<T>(value);

  Widget build(BuildContext context, ReadonlySignal<T> signal, ValueChanged<T> onChanged) {
    return HookBuilder(
      builder: (context) => performBuild(context, signal, onChanged),
    );
  }

  Widget performBuild(BuildContext context, ReadonlySignal<T> value, ValueChanged<T> onChanged);
}
