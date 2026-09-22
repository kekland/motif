part of '../prop.dart';

final class ModifierStackWidget extends StatelessWidget {
  const new({
    super.key,
    required this.statements,
  });

  final List<Statement> statements;

  @override
  Widget build(BuildContext context) {
    final modifiers = statements.first.modifiers;

    return Column(
      children: [
        Header(
          leading: Icons.applyModifier(),
          title: Text('Modifiers'),
          padding: const .only(left: 8.0, right: 4.0),
          trailing: Row(
            children: [
              IconButton(
                isFilled: false,
                onTap: () {},
                child: Icons.visibility(),
              ),
              ModifierAddButton(
                statements: statements,
              ),
            ],
          ),
        ),
        Divider(),
        for (final modifier in modifiers) ...[
          Text(
            modifier.name(context),
            style: context.typography.body.tertiary,
          ),
          // if (modifier is GeneratorStatement) ...[
          //   Button(
          //     onTap: () {
          //       WindowNavigator.pushUnique(
          //         context,
          //         GeneratorEditorWindow.createEntry(
          //           context,
          //           generator: (modifier as GeneratorStatement).generator,
          //           onChanged: (g) {
          //             editor.edit(
          //               (txn) => txn.update<GeneratorStatement>(modifier.id, (m) => m.copyWith(generator: g)),
          //             );
          //           },
          //         ),
          //       );
          //     },
          //     child: Text('Show'),
          //   ),
          // ],
        ],
      ],
    );
  }
}

class ModifierAddButton extends StatelessWidget {
  const new({
    super.key,
    required this.statements,
  });

  final List<Statement> statements;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      isFilled: false,
      child: Icons.add(),
      onTap: () async {
        final ids = statements.map((s) => s.id).toList();
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
