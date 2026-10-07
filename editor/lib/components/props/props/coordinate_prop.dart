import 'package:editor/imports.dart';

enum CoordinateAxis { x, y }

final class CoordinateProp(super.sources, {super.kind = .coordinate}) extends Prop<double, double> {
  @override
  PropWidget? buildWidget(BuildContext context) => CoordinatePropWidget(prop: this);
}

final class CoordinatePropWidget extends HookWidget with PropWidget {
  const new({
    super.key,
    required this.prop,
    this.axis,
    this.isNested = false,
  });

  final CoordinateProp prop;
  final CoordinateAxis? axis;

  @override
  final bool isNested;

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

    return Padding(
      padding: resolvedPadding,
      child: DoubleExpressionInputField(
        value: useMemoComputed(() => computed.value.resolve(), keys: [computed]),
        onChanged: (v) => prop.set(transaction, v),
        sessionCallbacks: transaction.sessionCallbacks,
        options: .new(
          leading: icon,
          textStyle: isOverridden ? context.typography.body.tertiary : null,
          hintText: 'Mixed',
        ),
      ),
    );
  }
}
