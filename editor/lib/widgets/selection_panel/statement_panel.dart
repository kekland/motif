import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_panel/props/prop.dart';

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
      rawProps.add(statement.props.toList());
    }

    final props = Prop.intersect(rawProps);

    late final Widget? icon, title, footnote;
    if (statementIds.length == 1) {
      final statement = context.editor.statement(statementIds.single)!;
      icon = statement.icon(context);
      title = Text(statement.name(context));
      footnote = Text(statement.id.toString());
    } else {
      icon = Icons.stacks();
      title = Text('${statementIds.length} statements');
      footnote = null;
    }

    return Column(
      children: [
        Header(
          leading: icon,
          title: title,
          footnote: footnote,
        ),
        Divider(),
        PropListBuilder(
          scene: editor.scene,
          props: props,
        ),
        Divider(),
        ModifierStackWidget(
          statements: statements,
        ),
        Divider(),
      ],
    );
  }
}
