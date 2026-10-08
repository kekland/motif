import 'package:editor/imports.dart';

final class BooleanProp(
  super.sources, {
  super.kind = .boolean,
  this.label = 'Boolean',
  super.tooltip,
}) extends Prop<bool, bool> {
  final String label;

  @override
  PropWidget? buildWidget(BuildContext context) => BooleanPropWidget(prop: this);
}

final class const BooleanPropWidget({
  super.key,
  required final BooleanProp prop,
  @override final bool isNested = false,
}) extends HookWidget with PropWidget {
  @override
  String? resolveHeader(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    final computed = usePropComputed(prop);
    final txn = usePropTransaction();
    final value = useProxyComputed(computed, (v) => v.resolve() ?? false);

    return CheckboxListItem(
      title: Text(prop.label),
      value: value,
      onChanged: (v) => prop.set(txn, v),
    );
  }
}
