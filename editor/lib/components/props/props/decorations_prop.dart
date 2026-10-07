import 'package:editor/components/props/widgets/inputs/decoration/decorations_input_field.dart';
import 'package:editor/imports.dart';

final class DecorationsProp(super.sources, {super.kind = .decorations}) extends Prop<Decorations, Decorations> {
  @override
  PropWidget? buildWidget(BuildContext context) => DecorationsPropWidget(prop: this);

  @override
  Widget? buildHeaderButton(BuildContext context) => DecorationsAddButtonWidget(prop: this);
}

final class DecorationsPropWidget extends HookWidget with PropWidget {
  const new({
    super.key,
    required this.prop,
    this.padding,
    this.emptyStateLabel,
  });

  final DecorationsProp prop;
  final EdgeInsets? padding;
  final String? emptyStateLabel;

  @override
  bool get isNested => false;

  @override
  String resolveHeader(BuildContext context) => 'Decorations';

  @override
  Widget build(BuildContext context) {
    final txn = usePropTransaction();
    final computed = usePropComputed(prop);
    final isMixed = useProxyComputedValue(computed, (v) => v.isMixed);

    if (isMixed) {
      return Padding(
        padding: PropWidget.padding,
        child: Text(
          'Tap on + to reset mixed styles',
          style: context.typography.caption.tertiary,
        ),
      );
    }

    final isNotEmpty = useComputed(() => computed().resolve()!.isNotEmpty, keys: [computed]).value;

    if (!isNotEmpty && emptyStateLabel != null) {
      return Padding(
        padding: PropWidget.padding,
        child: Text(
          emptyStateLabel!,
          style: context.typography.caption.tertiary,
        ),
      );
    }

    final verticalPadding = EdgeInsets.only(
      top: isNotEmpty ? (padding?.top ?? 0.0) : 0.0,
      bottom: isNotEmpty ? (padding?.bottom ?? 0.0) : 0.0,
    );

    return Padding(
      padding: verticalPadding,
      child: DecorationsInputField(
        value: useProxyComputed(computed, (v) => v.resolve()!),
        onChanged: (v) => prop.set(txn, v),
        sessionCallbacks: txn.sessionCallbacks,
      ),
    );
  }
}

final class DecorationsAddButtonWidget extends HookWidget {
  const new({super.key, required this.prop});

  final DecorationsProp prop;

  @override
  Widget build(BuildContext context) {
    final txn = usePropTransaction();

    return IconButton.flat(
      onTap: () {
        final value = prop.resolve();
        final isMixed = value.isMixed;

        if (isMixed) {
          prop.set(txn, .white);
        } else {
          final resolved = value.resolve()!;
          final added = resolved.append(.color(.white));
          prop.set(txn, added);
        }
      },
      child: Icons.add(),
    );
  }
}
