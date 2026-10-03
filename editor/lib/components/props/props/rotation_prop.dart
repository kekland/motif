import 'package:editor/imports.dart';

final class RotationProp(super.sources, {super.kind = .rotation}) extends Prop<Angle2, Angle2> {
  @override
  PropWidget? buildWidget(BuildContext context) => RotationPropWidget(prop: this);
}

final class RotationPropWidget extends HookWidget with PropWidget {
  const new({super.key, required this.prop});

  final RotationProp prop;

  @override
  String resolveHeader(BuildContext context) => 'Rotation';

  @override
  Widget build(BuildContext context) {
    final transaction = usePropTransaction();
    final computed = usePropComputed(prop);
    final isOverridden = useComputed(() => computed.value.isOverridden, keys: [computed]).value;

    return Padding(
      padding: PropWidget.padding,
      child: DoubleExpressionInputField(
        value: useMemoComputed(() => computed.value.resolve()?.deg, keys: [computed]),
        onChanged: (v) => transaction.edit((txn) => prop.set(txn, .fromDeg(v))),
        sessionCallbacks: transaction.sessionCallbacks,
        options: .new(
          leading: Icons.angle(),
          textStyle: isOverridden ? context.typography.body.tertiary : null,
          trailing: Text('°'),
          hintText: 'Mixed',
        ),
      ),
    );
  }
}
