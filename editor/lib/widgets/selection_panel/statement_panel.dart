import 'package:editor/imports.dart';

class const StatementPanel({
  super.key,
  required final List<StatementId> statementIds,
}) extends HookWidget {
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
    final isSingle = statementIds.length == 1;

    late final Widget? icon, title;
    if (isSingle) {
      final statement = context.editor.statement(statementIds.single)!;
      final prop = useMemoized(() => resolveStatementNameProp(context, editor.scene, statement.id), [statement.id]);
      icon = null;
      title = StringPropWidget(
        prop: prop,
        options: .new(
          leading: statement.resolveIcon(context),
          isFlat: true,
          padding: .symmetric(horizontal: 8.0),
          borderRadius: .zero,
          fillHeight: true,
        ),
      );
    } else {
      icon = Icons.stacks();
      title = Text('${statementIds.length} statements');
    }

    return Column(
      children: [
        Header(
          padding: isSingle ? .zero : null,
          leading: icon,
          title: title,
        ),
        Divider(),
        PropListBuilder(props: props),
        Divider(),
      ],
    );
  }
}
