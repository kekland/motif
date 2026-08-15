import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_panel/components/child_layout_component.dart';
import 'package:editor/widgets/selection_panel/components/size_component.dart';
import 'package:editor/widgets/selection_panel/components/transform_component.dart';
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
    print(statement);

    return switch (statement) {
      ContainerStatement _ => ContainerPanel(id: id),
      RectangleStatement _ => RectanglePanel(id: id),
      CutEdgeStatement _ => CutEdgePanel(id: id),
      GlueVerticesStatement _ => GlueVerticesPanel(id: id),
      _ => const SizedBox.shrink(),
    };
  }
}

class StatementSelectionPanel extends StatelessWidget {
  const StatementSelectionPanel({
    super.key,
    required this.id,
  });

  final StatementId id;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final statement = editor.scene.program.byId(id)!;
    if (statement is! RectangleStatement) {
      return const SizedBox.shrink();
    }

    void apply(RectangleStatement newStatement) {
      return editor.edit((txn) {
        txn.replace(id, [newStatement]);
      });
    }

    final layout = editor.scene.layout.of(id);

    return Column(
      children: [
        Surface(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          color: context.colors.surface.secondary,
          child: Row(
            children: [
              Icons.square(
                size: 20.0,
                color: context.colors.display.tertiary,
              ),
              const SizedBox(width: 4.0),
              Expanded(
                child: Row(
                  textBaseline: .alphabetic,
                  crossAxisAlignment: .baseline,
                  children: [
                    Text(
                      'Rectangle',
                      style: context.typography.subtitle.secondary,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      statement.id.toString(),
                      style: context.typography.footnote.tertiary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text('Transform', style: context.typography.body.secondary),
              const SizedBox(height: 8.0),
              TransformComponentWidget(
                transform: statement.transform,
                overridePosition: layout?.offset,
                onPositionChanged: (p) {
                  final s = TransformSession.statement(editor.scene, id);
                  s.setTranslation(p);
                },
                onRotationChanged: (r) {
                  final s = TransformSession.statement(editor.scene, id);
                  s.setRotation(r);
                },
              ),
            ],
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text('Layout', style: context.typography.body.secondary),
              const SizedBox(height: 8.0),
              SizeComponentWidget(
                size: statement.size,
                resolvedSize: layout?.size,
                onChanged: (s) => apply(statement.copyWith(size: s)),
              ),
              if (statement is ContainerStatement) ...[
                const SizedBox(height: 8.0),
                ChildLayoutComponentWidget(
                  childLayout: statement.childLayout,
                  onChanged: (l) => apply(statement.copyWith(childLayout: l)),
                ),
              ],
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}

class const StatementPanelBase({
  super.key,
  required final StatementId id,
  required final List<Widget> children,
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
        ...children,
      ],
    );
  }
}
