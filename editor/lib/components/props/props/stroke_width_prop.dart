import 'package:editor/imports.dart';

final class StrokeWidthProp(super.sources, {super.kind = .strokeWidth}) extends Prop<double, double> {
  @override
  PropWidget? buildWidget(BuildContext context) => StrokeWidthPropWidget(prop: this);
}

final class StrokeWidthPropWidget extends HookWidget with PropWidget {
  StrokeWidthPropWidget({
    super.key,
    required this.prop,
    this.isNested = false,
  });

  final StrokeWidthProp prop;

  @override
  final bool isNested;

  @override
  String resolveHeader(BuildContext context) => 'Stroke width';

  @override
  Widget build(BuildContext context) {
    final computed = usePropComputed(prop);
    final transaction = usePropTransaction();

    return Padding(
      padding: resolvedPadding,
      child: DoubleExpressionInputField(
        value: useMemoComputed(() => computed.value.resolve(), keys: [computed]),
        onChanged: (width) => transaction.edit((txn) => prop.set(txn, width)),
        sessionCallbacks: transaction.sessionCallbacks,
        options: .new(
          leading: Icons.weight(),
          hintText: 'Mixed',
        ),
      ),
    );
  }
}
