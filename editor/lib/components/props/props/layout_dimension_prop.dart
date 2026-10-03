import 'package:editor/imports.dart';

final class LayoutDimensionProp(super.sources, {super.kind = .layoutDimension})
    extends Prop<LayoutDimension, LayoutDimension> {
  @override
  PropWidget? buildWidget(BuildContext context) => LayoutDimensionPropWidget(prop: this);
}

final class LayoutDimensionPropWidget extends HookWidget with PropWidget {
  const new({
    super.key,
    required this.prop,
    this.axis,
  });

  final LayoutDimensionProp prop;
  final CoordinateAxis? axis;

  @override
  String resolveHeader(BuildContext context) => 'Layout Dimension';

  @override
  Widget build(BuildContext context) {
    final computed = usePropComputed(prop);
    final isOverridden = useComputed(() => computed.value.isOverridden, keys: [computed]).value;
    final transaction = usePropTransaction();

    final type = useComputed(() => computed.value.resolve()?.type, keys: [computed]).value;
    final value = useMemoComputed(() => computed.value.resolve()?.value, keys: [computed]);

    final icon = switch (axis) {
      .x => Icons.w(),
      .y => Icons.h(),
      _ => null,
    };

    final iconTurns = switch (axis) {
      .x => 0,
      .y => 1,
      _ => 0,
    };

    final typePicker = ToggleableButtonRow(
      borderRadius: .vertical(bottom: .circular(4.0)),
      height: 28.0,
      children: [
        ToggleableButton(
          isActive: type == .fixed,
          onChanged: (v) => transaction.edit((txn) => prop.set(txn, .fixed(value() ?? 0.0))),
          iconSize: 16.0,
          child: type == .fixed ? Icons.layoutSizeFixed() : Icons.layoutSizeNonFixed(),
        ),
        ToggleableButton(
          isActive: type == .contain,
          onChanged: (v) => transaction.edit((txn) => prop.set(txn, .contain())),
          iconSize: 16.0,
          child: RotatedBox(quarterTurns: iconTurns + 1, child: Icons.layoutSizeContain()),
        ),
        ToggleableButton(
          isActive: type == .expand,
          onChanged: (v) => transaction.edit((txn) => prop.set(txn, .expand())),
          iconSize: 16.0,
          child: RotatedBox(quarterTurns: iconTurns + 1, child: Icons.layoutSizeExpand()),
        ),
      ],
    );

    return DoubleExpressionInputField(
      value: value,
      onChanged: (v) => transaction.edit((txn) => prop.set(txn, .fixed(v))),
      sessionCallbacks: transaction.sessionCallbacks,
      options: .new(
        leading: icon,
        textStyle: isOverridden ? context.typography.body.tertiary : null,
        hintText: 'Mixed',
        padding: .zero,
        builder: (context, child) => Column(
          children: [
            Padding(
              padding: .symmetric(horizontal: 6.0),
              child: child,
            ),
            Divider(),
            typePicker,
          ],
        ),
      ),
    );
  }
}
