import 'package:blueprint/editor.dart';
import 'package:editor/imports.dart';
import 'package:editor/widgets/generators/generator_editor.dart';

class GeneratorsTab extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final selection = useListenable(context.editor.selection);
    final statementIds = selection.statements;
    final generatorStatements = statementIds.map(context.editor.statement).whereType<GeneratorStatement>().toList();

    if (generatorStatements.isEmpty) {
      return Center(
        child: Text(
          'No generator statements selected.',
          style: context.typography.subtitle.tertiary,
        ),
      );
    }

    final statement = generatorStatements.first;

    return Column(
      children: [
        Header(
          leading: Icons.generator(),
          title: Text('Generator ${statement.id}'),
        ),
        Divider(),
        Expanded(
          child: GeneratorEditorWidget(
            generator: statement.generator,
            onChanged: (v) {
              context.editor.edit(
                (txn) => txn.update<GeneratorStatement>(statement.id, (m) => m.copyWith(generator: v)),
              );
            },
          ),
        ),
      ],
    );
  }
}

class GeneratorEditorWidget extends HookWidget {
  const new({
    super.key,
    required this.generator,
    this.onChanged,
  });

  final Generator generator;
  final ValueChanged<Generator>? onChanged;

  @override
  Widget build(BuildContext context) {
    final editor = useDisposable(() => BlueprintEditor(generator));
    useEffect(() {
      void listener() => onChanged?.call(editor.value);
      editor.addListener(listener);
      return () => editor.removeListener(listener);
    }, [editor]);

    return GeneratorEditor(
      editor: editor,
    );
  }
}
