import 'package:editor/imports.dart';

abstract class ToolOption<T> {
  ToolOption(this.key, this.value);

  final String key;
  final T value;

  ToolOption<T> copyWith({T? value});

  Prop createProp(ToolController controller);
}
