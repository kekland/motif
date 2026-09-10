part of '../prop.dart';

final class ModifierStackWidget extends StatelessWidget {
  const new({
    super.key,
    required this.id,
  });

  final StatementId id;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final modifiers = editor.scene.evaluation.stackOf(id);

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
              IconButton(
                isFilled: false,
                onTap: () {
                  final modifier = GeneratorStatement(selectors: [.new(id)], generator: .empty());
                  context.editor.edit((txn) => txn.attach(id, modifier));
                },
                child: Icons.add(),
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
