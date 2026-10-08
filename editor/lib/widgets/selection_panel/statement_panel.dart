import 'package:editor/imports.dart';

class const StatementPanel({
  super.key,
  required final List<StatementId> statementIds,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final statements = <Statement>[];
    final rawProps = <List<PropSource>>[];

    for (final id in statementIds) {
      final statement = editor.statement(id);
      statements.add(statement!);
      rawProps.add(statement.resolveProps(editor.scene).toList());
    }

    final props = Prop.intersect(rawProps);

    late final Widget? icon, title;
    if (statementIds.length == 1) {
      final statement = context.editor.statement(statementIds.single)!;
      icon = statement.resolveIcon(context);
      title = Text(statement.resolveName(context));
    } else {
      icon = Icons.stacks();
      title = Text('${statementIds.length} statements');
    }

    return Column(
      children: [
        Header(
          leading: icon,
          title: title,
        ),
        Divider(),
        PropListBuilder(props: props),
        Divider(),
        // ModifierStackWidget(
        //   statements: statements,
        // ),
        // Divider(),
      ],
    );
  }
}
