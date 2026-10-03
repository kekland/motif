import 'package:editor/imports.dart';

enum CoordinateAxis { x, y }

final class CoordinateProp(super.sources, {super.kind = .coordinate}) extends Prop<double, double> {
  @override
  PropWidget? buildWidget(BuildContext context) => CoordinatePropWidget(prop: this);
}

final class CoordinatePropWidget extends HookWidget with PropWidget {
  const new({super.key, required this.prop, this.axis});

  final CoordinateProp prop;
  final CoordinateAxis? axis;

  @override
  String resolveHeader(BuildContext context) => 'Coordinate';

  @override
  Widget build(BuildContext context) {
    final computed = usePropComputed(prop);
    final isOverridden = useComputed(() => computed.value.isOverridden, keys: [computed]).value;
    final transaction = usePropTransaction();

    final icon = switch (axis) {
      .x => Icons.x(),
      .y => Icons.y(),
      _ => null,
    };

    return DoubleExpressionInputField(
      value: useMemoComputed(() => computed.value.resolve(), keys: [computed]),
      onChanged: (v) => transaction.edit((txn) => prop.set(txn, v)),
      sessionCallbacks: transaction.sessionCallbacks,
      options: .new(
        leading: icon,
        textStyle: isOverridden ? context.typography.body.tertiary : null,
        hintText: 'Mixed',
      ),
    );
  }
}
