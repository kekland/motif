part of '../prop.dart';

final class ModifierStackWidget extends StatelessWidget {
  const new({
    super.key,
    required this.statements,
  });

  final List<Statement> statements;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final modifiers = editor.scene.evaluation.stackOf(statements.first.id);

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
          if (modifier is GeneratorStatement) ...[
            Button(
              onTap: () {
                WindowNavigator.pushUnique(
                  context,
                  GeneratorEditorWindow.createEntry(
                    context,
                    generator: modifier.generator,
                    onChanged: (g) {
                      editor.edit(
                        (txn) => txn.update<GeneratorStatement>(modifier.id, (m) => m.copyWith(generator: g)),
                      );
                    },
                  ),
                );
              },
              child: Text('Show'),
            ),
          ],
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
        final possibleModifiers = context.editor.evaluation.possibleModifiersFor(statements);
        final items = possibleModifiers.map(
          (f) => ContextMenuItem(
            f,
            label: f.type.name(context),
            icon: f.type.icon(context),
          ),
        );

        final result = await ContextMenu.push<ModifierFactory>(
          context,
          .new(items.toList()),
        );

        if (result != null && context.mounted) {
          context.editor.edit((txn) => result.apply(txn));
        }
      },
    );
  }
}
