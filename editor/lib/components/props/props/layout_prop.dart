import 'package:editor/imports.dart';

final class LayoutProp(super.sources, {super.kind = .layout}) extends Prop<Layout, Layout> {
  @override
  PropWidget? buildWidget(BuildContext context) => LayoutPropWidget(prop: this);
}

final class LayoutPropWidget extends HookWidget with PropWidget {
  const LayoutPropWidget({super.key, required this.prop});

  final LayoutProp prop;

  @override
  String resolveHeader(BuildContext context) => 'Layout';

  @override
  Widget build(BuildContext context) {
    final computed = usePropComputed(prop);
    final transaction = usePropTransaction();
    final value = useComputed(() => computed.value.resolve()).value;

    return ToggleableButtonRow(
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
    );
  }
}
