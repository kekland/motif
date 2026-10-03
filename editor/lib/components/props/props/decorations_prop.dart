import 'package:editor/imports.dart';
import 'package:editor/widgets/form/decoration/decoration_input_field.dart';

final class DecorationsProp(super.sources, {super.kind = .decorations}) extends Prop<Decorations, Decorations> {
  @override
  PropWidget? buildWidget(BuildContext context) => DecorationsPropWidget(prop: this);

  @override
  Widget? buildHeaderButton(BuildContext context) => DecorationsAddButtonWidget(prop: this);
}

final class DecorationsPropWidget extends HookWidget with PropWidget {
  const new({super.key, required this.prop});

  final DecorationsProp prop;

  @override
  String resolveHeader(BuildContext context) => 'Decorations';

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;

    final transaction = usePropTransaction();
    final computed = usePropComputed(prop);
    final isMixed = useComputed(() => computed().isMixed, keys: [computed]).value;

    if (isMixed) {
      return Padding(
        padding: PropWidget.padding,
        child: Text(
          'Tap on + to reset mixed styles',
          style: context.typography.caption.tertiary,
        ),
      );
    }

    final itemCount = useComputed(() => computed().resolve()!.entries.length, keys: [computed]).value;
    final computeds = useMemoized(
      () => List.generate(itemCount, (i) => Computed(() => computed().resolve()!.entries[i])),
      [itemCount, computed],
    );

    useEffect(() {
      final values = computeds;
      return () {
        for (final c in values) c.dispose();
      };
    }, [computeds]);

    return DragBoundary(
      child: ReorderableList(
        shrinkWrap: true,
        itemCount: itemCount,
        proxyDecorator: (child, i, animation) => FadeTransition(
          opacity: animation.drive(Tween(begin: 1.0, end: 0.5)),
          child: child,
        ),
        onReorderItem: (a, b) => transaction.edit((txn) => prop.set(txn, computed().resolve()!.reorder(a, b))),
        itemBuilder: (context, i) => DecorationEntry(
          key: ValueKey(computeds[i]),
          editor: editor,
          index: i,
          entry: computeds[i],
          onChanged: (v) => transaction.edit((txn) => prop.set(txn, computed().resolve()!.update(i, v))),
          onRemoved: (v) => transaction.edit((txn) => prop.set(txn, computed().resolve()!.remove(v))),
          sessionCallbacks: transaction.sessionCallbacks,
        ),
      ),
    );
  }
}

final class DecorationsAddButtonWidget extends HookWidget {
  const new({super.key, required this.prop});

  final DecorationsProp prop;

  @override
  Widget build(BuildContext context) {
    final transaction = usePropTransaction();

    return IconButton.flat(
      onTap: () {
        final value = prop.resolve(context.editor.scene);
        final isMixed = value.isMixed;

        if (isMixed) {
          transaction.edit((txn) => prop.set(txn, .white));
        } else {
          final resolved = value.resolve()!;
          final added = resolved.append(.color(.white));
          transaction.edit((txn) => prop.set(txn, added));
        }
      },
      child: Icons.add(),
    );
  }
}

final class const DecorationEntry({
  super.key,
  required final Editor editor,
  required final int index,
  required final ReadonlySignal<Decoration> entry,
  final ValueChanged<Decoration>? onChanged,
  final ValueChanged<Decoration>? onRemoved,
  final InputSessionCallbacks? sessionCallbacks,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return ListItem(
      onTap: () {},
      height: 40.0,
      reorderableIndex: index,
      title: DecorationInputField(
        editor: editor,
        value: entry,
        onChanged: onChanged,
        sessionCallbacks: sessionCallbacks,
      ),
      trailing: IconButton.flat(
        onTap: () => onRemoved?.call(entry.value),
        child: Icons.remove(),
      ),
    );
  }
}

final class const ColorDecorationBody({
  super.key,
  required final ReadonlySignal<ColorDecoration> entry,
  final ValueChanged<ColorDecoration>? onChanged,
  final InputSessionCallbacks? sessionCallbacks,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return ColorInputField(
      value: useMemoComputed(() => entry.value.color.partial),
      onChanged: (p) => onChanged?.call(.new(p.apply(entry.value.color))),
      sessionCallbacks: sessionCallbacks,
    );
  }
}

final class const ImageDecorationBody({
  super.key,
  required final ReadonlySignal<ImageDecoration> entry,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
