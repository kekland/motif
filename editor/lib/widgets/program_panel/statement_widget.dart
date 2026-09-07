import 'package:editor/imports.dart';

class const StatementWidget({
  super.key,
  required final Statement statement,
  final bool isSelected = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = statement.name(context);
    final icon = statement.icon(context);

    return ListItem(
      onTap: () {
        final editor = context.editor;
        final products = editor.productsOf(statement.id);
        final selection = editor.selection;
        selection.setMultiple(products);
      },
      leading: icon,
      title: Text(name),
      footnote: Text(statement.id.toString()),
      isSelected: isSelected,
    );
  }
}
