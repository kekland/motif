import 'package:blueprint/editor/editor.dart';
import 'package:editor/imports.dart';
import 'package:editor/widgets/blueprints/shader_editor.dart';

class ShadersTab extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final selection = useListenable(context.editor.selection);
    final statementIds = selection.statements;
    if (statementIds.isEmpty) {
      return Center(
        child: Text(
          'No statements selected.',
          style: context.typography.subtitle.tertiary,
        ),
      );
    }

    if (statementIds.length > 1) {
      return Center(
        child: Text(
          'Multiple statements selected. Choose only one.',
          style: context.typography.subtitle.tertiary,
        ),
      );
    }

    return StatementShaderEditorWidget(statement: statementIds.first);
  }
}

class StatementShaderEditorWidget extends HookWidget {
  const new({super.key, required this.statement});

  final StatementId statement;

  @override
  Widget build(BuildContext context) {
    useExistingSignal(context.editor.scene.notifier.forStatement(this.statement));
    final statement = context.editor.statement(this.statement)!;

    final selectedShaderId = useState<String?>(null);

    final shaders = <(CellKind, ShaderDecoration)>[];
    if (statement is VertexStyledStatement) {
      for (final e in statement.vertexStyle.decorations.entries) {
        if (e is ShaderDecoration) shaders.add((.vertex, e));
      }
    }
    if (statement is EdgeStyledStatement) {
      for (final e in statement.edgeStyle.decorations.entries) {
        if (e is ShaderDecoration) shaders.add((.edge, e));
      }
    }
    if (statement is FaceStyledStatement) {
      for (final e in statement.faceStyle.decorations.entries) {
        if (e is ShaderDecoration) shaders.add((.face, e));
      }
    }

    if (shaders.isEmpty) {
      return Center(
        child: Text(
          'No shaders found for the selected statement.',
          style: context.typography.subtitle.tertiary,
        ),
      );
    }

    final Widget editor;
    final selected = shaders.firstWhereOrNull((e) => e.$2.id == selectedShaderId.value);
    if (selected != null) {
      final selectedDecoration = selected.$2;
      final selectedShader = selectedDecoration.shader;

      editor = ShaderEditorWidget(
        key: ValueKey(selectedDecoration.id),
        shader: selectedShader,
        onChanged: (v) {
          context.editor.edit(
            (txn) => txn.update<Statement>(statement.id, (s) {
              StatementPartial? partial;
              final kind = shaders.first.$1;
              if (kind == .vertex) {
                var vertexStyle = (statement as VertexStyledStatement).vertexStyle;
                vertexStyle = vertexStyle.copyWith(
                  decorations: vertexStyle.decorations.update(
                    selectedDecoration.id,
                    selectedDecoration.copyWith(shader: v),
                  ),
                );
                // vertexStyle.decorations.
                partial = .vertexStyle(vertexStyle);
              } else if (kind == .edge) {
                var edgeStyle = (statement as EdgeStyledStatement).edgeStyle;
                edgeStyle = edgeStyle.copyWith(
                  decorations: edgeStyle.decorations.update(
                    selectedDecoration.id,
                    selectedDecoration.copyWith(shader: v),
                  ),
                );
                partial = .edgeStyle(edgeStyle);
              } else if (kind == .face) {
                var faceStyle = (statement as FaceStyledStatement).faceStyle;
                faceStyle = faceStyle.copyWith(
                  decorations: faceStyle.decorations.update(
                    selectedDecoration.id,
                    selectedDecoration.copyWith(shader: v),
                  ),
                );
                partial = .faceStyle(faceStyle);
              }

              if (partial != null) return s.applyPartial(partial);
              return s;
            }),
          );
        },
      );
    } else {
      editor = Center(
        child: Text(
          'No shader selected',
          style: context.typography.subtitle.tertiary,
        ),
      );
    }

    return Panels(
      direction: .horizontal,
      panels: [
        Panel(
          key: #shaderList,
          constraints: .pixels(200.0, 360.0),
          child: ListView(
            children: [
              for (final (_, shader) in shaders)
                ListItem(
                  title: Text(shader.id),
                  isSelected: selectedShaderId.value == shader.id,
                  onTap: () => selectedShaderId.value = shader.id,
                ),
            ],
          ),
        ),
        Panel(
          key: #shaderEditor,
          constraints: .flex(1.0),
          child: editor,
        ),
      ],
    );
  }
}

class ShaderEditorWidget extends HookWidget {
  const new({
    super.key,
    required this.shader,
    this.onChanged,
  });

  final ShaderBlueprint shader;
  final ValueChanged<ShaderBlueprint>? onChanged;

  @override
  Widget build(BuildContext context) {
    final editor = useDisposable(() => BlueprintEditor(shader));
    useEffect(() {
      void listener() => onChanged?.call(editor.value);
      editor.addListener(listener);
      return () => editor.removeListener(listener);
    }, [editor]);

    return ShaderEditor(editor: editor);
  }
}
