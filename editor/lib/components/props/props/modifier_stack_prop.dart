import 'package:editor/components/props/widgets/inputs/modifier/modifier_input_field.dart';
import 'package:editor/imports.dart';

final class ModifierStackProp(
  super.sources, {
  super.kind = .modifierStack,
}) extends Prop<ModifierStack, ModifierStack> {
  @override
  PropWidget? buildWidget(BuildContext context) => ModifierStackPropWidget(prop: this);

  @override
  Widget? buildHeaderButton(BuildContext context) => ModifierAddButton();
}

final class const ModifierStackPropWidget({
  super.key,
  required final ModifierStackProp prop,
  @override final bool isNested = false,
}) extends HookWidget with PropWidget {
  @override
  String? resolveHeader(BuildContext context) => 'Modifiers';

  @override
  Widget build(BuildContext context) {
    final txn = usePropTransaction();
    final computed = usePropComputed(prop);
    final value = useProxyComputed(computed, (v) => v.resolve());
    final isMixed = useProxyComputedValue(computed, (v) => v.isMixed);

    if (isMixed) {
      return Text('Mixed modifiers');
    }

    final isNotEmpty = useProxyComputedValue(value, (v) => v!.isNotEmpty);
    final itemCount = useProxyComputedValue(value, (v) => v!.length);
    final computeds = useMemoized(
      () => List.generate(itemCount, (i) => Computed(() => value()!.entries.elementAtOrNull(i))),
      [itemCount, value],
    );

    useEffect(() {
      final values = computeds;
      return () {
        for (final c in values) c.dispose();
      };
    }, [computeds]);

    return Column(
      children: [
        for (final (i, c) in computeds.indexed) ...[
          ModifierInputField(
            value: c,
            onChanged: (v) => prop.set(txn, value()!.update(i, v)),
            onRemove: () => prop.set(txn, value()!.remove(i)),
          ),
        ],

        if (isNotEmpty) const SizedBox(height: 8.0),
      ],
    );
  }
}

final class const ModifierAddButton({super.key}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useListenable(context.editor.selection);
    final ids = context.editor.selection.statements;
    final statements = ids.map(context.editor.scene.statement).nonNulls.toList();

    return IconButton(
      isFilled: false,
      child: Icons.add(),
      onTap: () async {
        final possibleModifiers = ModifierFactory.forStatements(statements);
        final items = possibleModifiers.map(
          (f) => ContextMenuItem(
            f,
            label: f.kind!.name(context),
            icon: f.kind!.icon(context),
          ),
        );

        final result = await ContextMenu.push<ModifierFactory>(
          context,
          .new([
            .item(
              ModifierFactory(null, (txn) => txn.wrapGenerator(ids)),
              label: 'Generator',
              icon: Icons.generator(),
            ),
            ...items,
          ]),
        );

        if (result != null && context.mounted) {
          context.editor.edit((txn) => result.apply(txn));
        }
      },
    );
  }
}

final class ModifierFactory {
  const ModifierFactory(this.kind, this.apply);

  final ModifierKind? kind;
  final void Function(SceneTransaction txn) apply;

  static List<ModifierFactory> forStatements(List<Statement> statements) {
    final ids = statements.map((s) => s.id).toList();
    final applicable = ModifierKind.values.where((k) => statements.every(k.appliesTo)).toList();

    return [
      for (final kind in applicable)
        switch (kind) {
          .fillet => ModifierFactory(
            kind,
            (txn) {
              for (final id in ids) txn.attach(id, FilletModifier(radius: .new(16, 16)));
            },
          ),
        },
    ];
  }
}
