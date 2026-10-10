import 'package:editor/components/props/widgets/inputs/decoration/decoration_input_field.dart';
import 'package:editor/imports.dart';

final class const DecorationsInputField({
  super.key,
  required super.value,
  super.onChanged,
  super.sessionCallbacks,
}) extends InputField<Decorations> {
  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final value = useProxyComputed(this.value, (v) => v!);
    final itemCount = useComputed(() => value().entries.length, keys: [value]).value;
    final computeds = useMemoized(
      () => List.generate(itemCount, (i) => Computed(() => value().entries.elementAtOrNull(i))),
      [itemCount, value],
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
        physics: NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        proxyDecorator: (child, i, animation) => FadeTransition(
          opacity: animation.drive(Tween(begin: 1.0, end: 0.5)),
          child: child,
        ),
        onReorderItem: (a, b) => onChanged?.call(value().reorder(a, b)),
        itemBuilder: (context, i) => DecorationEntry(
          key: ValueKey(computeds[i]),
          editor: editor,
          index: i,
          entry: computeds[i],
          onChanged: (v) => onChanged?.call(value().update(i, v)),
          onRemoved: (v) => onChanged?.call(value().remove(i)),
          sessionCallbacks: sessionCallbacks,
        ),
      ),
    );
  }
}

final class const DecorationEntry({
  super.key,
  required final Editor editor,
  required final int index,
  required final ReadonlySignal<Decoration?> entry,
  final ValueChanged<Decoration>? onChanged,
  final ValueChanged<Decoration>? onRemoved,
  final InputSessionCallbacks? sessionCallbacks,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final value = useRef(this.entry()!);
    final entry = useComputed(() {
      final v = this.entry();
      if (v == null) return value.value;
      return value.value = v;
    });

    return ListItem(
      onTap: () {},
      height: 40.0,
      reorderableIndex: index,
      padding: .only(left: 12.0, right: 4.0),
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
