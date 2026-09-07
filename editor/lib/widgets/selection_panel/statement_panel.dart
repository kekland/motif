import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_panel/props/prop.dart';

class const StatementPanel({
  super.key,
  required final List<StatementId> statements,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final rawProps = <List<PropSource>>[];
    for (final id in statements) {
      final statement = editor.statement(id);
      rawProps.add(statement!.props.toList());
    }

    final props = Prop.intersect(rawProps);

    late final Widget? icon, title, footnote;
    if (statements.length == 1) {
      final statement = context.editor.statement(statements.single)!;
      icon = statement.icon(context);
      title = Text(statement.name(context));
      footnote = Text(statement.id.toString());
    } else {
      icon = Icons.stacks();
      title = Text('${statements.length} statements');
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
      ],
    );
  }
}
