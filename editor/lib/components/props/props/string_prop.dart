import 'package:editor/imports.dart';

final class StringProp(
  super.sources, {
  super.kind = .string,
  this.label = 'String',
  super.tooltip,
}) extends Prop<String, String> {
  final String label;

  @override
  PropWidget? buildWidget(BuildContext context) => StringPropWidget(prop: this);
}

final class const StringPropWidget({
  super.key,
  required final StringProp prop,
  @override final bool isNested = false,
  final InputFieldOptions options = const .new(),
  final FocusNode? focusNode,
}) extends HookWidget with PropWidget {
  @override
  String? resolveHeader(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    final computed = usePropComputed(prop);
    final txn = usePropTransaction();
    final value = useProxyComputed(computed, (v) => v.resolve() ?? '');

    return TextInputField(
      value: value,
      onChanged: (v) => prop.set(txn, v),
      options: options,
      focusNode: focusNode,
    );
  }
}
