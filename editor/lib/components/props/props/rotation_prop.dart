import 'package:editor/imports.dart';

final class RotationProp(
  super.sources, {
  super.kind = .rotation,
  super.tooltip = const .new('Controls how the statement is rotated'),
}) extends Prop<Angle2, Angle2> {
  @override
  PropWidget? buildWidget(BuildContext context) => RotationPropWidget(prop: this);
}

final class RotationPropWidget extends HookWidget with PropWidget {
  const new({
    super.key,
    required this.prop,
    this.isNested = false,
  });

  final RotationProp prop;

  @override
  final bool isNested;

  @override
  String resolveHeader(BuildContext context) => 'Rotation';

  @override
  Widget build(BuildContext context) {
    final txn = usePropTransaction();
    final computed = usePropComputed(prop);
    final isOverridden = useComputed(() => computed.value.isOverridden, keys: [computed]).value;

    return Padding(
      padding: resolvedPadding,
      child: DoubleExpressionInputField(
        value: useMemoComputed(() => computed.value.resolve()?.deg, keys: [computed]),
        onChanged: (v) => prop.set(txn, .fromDeg(v)),
        sessionCallbacks: txn.sessionCallbacks,
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
