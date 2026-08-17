import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_panel/statements/container_panel.dart';
import 'package:editor/widgets/selection_panel/statements/cut_edge_panel.dart';
import 'package:editor/widgets/selection_panel/statements/glue_vertices_panel.dart';
import 'package:editor/widgets/selection_panel/statements/rectangle_panel.dart';

class const StatementPanel({
  super.key,
  required final StatementId id,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final statement = context.editor.statement(id);
    // print(statement);

    return switch (statement) {
      ContainerStatement _ => ContainerPanel(id: id),
      RectangleStatement _ => RectanglePanel(id: id),
      CutEdgeStatement _ => CutEdgePanel(id: id),
      GlueVerticesStatement _ => GlueVerticesPanel(id: id),
      _ => const SizedBox.shrink(),
    };
  }
}

class const StatementPanelBase({
  super.key,
  required final StatementId id,
  final Widget? child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final statement = context.editor.statement(id);
    final name = statement.name(context);
    final icon = statement.icon(context);

    return Column(
      children: [
        Header(
          leading: icon,
          title: Text(name),
          footnote: Text(statement.id.value),
        ),
        Divider(),
        ?child,
      ],
    );
  }
}
