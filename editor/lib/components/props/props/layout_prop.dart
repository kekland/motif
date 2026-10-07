import 'package:editor/imports.dart';

final class LayoutProp(super.sources, {super.kind = .layout}) extends Prop<Layout, Layout> {
  @override
  PropWidget? buildWidget(BuildContext context) => LayoutPropWidget(prop: this);
}

final class LayoutPropWidget extends HookWidget with PropWidget {
  const LayoutPropWidget({
    super.key,
    required this.prop,
    this.isNested = false,
  });

  final LayoutProp prop;

  @override
  final bool isNested;

  @override
  String resolveHeader(BuildContext context) => 'Layout';

  @override
  Widget build(BuildContext context) {
    final computed = usePropComputed(prop);
    final transaction = usePropTransaction();
    final value = useProxyComputedValue(computed, (v) => v.resolve());

    return Padding(
      padding: resolvedPadding,
      child: ToggleableButtonRow(
        children: [
          ToggleableButton(
            onChanged: (v) => transaction.edit((txn) => prop.set(txn, .stack())),
            isActive: value is StackLayout,
            child: Icons.layoutStack(),
          ),
          ToggleableButton(
            onChanged: (v) => transaction.edit((txn) => prop.set(txn, .flex(direction: .row))),
            isActive: value is FlexLayout && value.direction == .row,
            child: Icons.layoutRow(),
          ),
          ToggleableButton(
            onChanged: (v) => transaction.edit((txn) => prop.set(txn, .flex(direction: .column))),
            isActive: value is FlexLayout && value.direction == .column,
            child: Icons.layoutColumn(),
          ),
        ],
      ),
    );
  }
}
