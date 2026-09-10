import 'package:blueprint/editor.dart';
import 'package:editor/widgets/generators/generator_editor.dart';
import 'package:editor/widgets/tool/toolbar_template.dart';

import '../../imports.dart';

class GeneratorEditorWindow extends HookWidget {
  const GeneratorEditorWindow({
    super.key,
    required this.generator,
    this.onChanged,
  });

  final Generator generator;
  final ValueChanged<Generator>? onChanged;

  static WindowEntry createEntry(
    BuildContext context, {
    required Generator generator,
    ValueChanged<Generator>? onChanged,
  }) => .withContextAnchor(
    context,
    isModal: true,
    builder: (_) => GeneratorEditorWindow(
      generator: generator,
      onChanged: onChanged,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final editor = useDisposable(() => BlueprintEditor(generator));
    useEffect(() {
      void listener() => onChanged?.call(editor.value);
      editor.addListener(listener);
      return () => editor.removeListener(listener);
    }, [editor]);

    return WindowScaffold(
      leading: Icons.generator(),
      title: Text('Generator ${generator.hashCode}'),
      child: Column(
        children: [
          Surface(
            width: 600.0,
            height: 400.0,
            color: context.colors.surface.tertiary,
            child: GeneratorEditor(editor: editor),
          ),
          Divider(),
          Surface(
            height: 48.0,
            child: Row(
              children: [
                Builder(
                  builder: (context) {
                    return ToolbarButton(
                      onTap: () async {
                        final node = await WindowNavigator.pushUnique(
                          context,
                          GeneratorAddNodeWindow.createEntry(context),
                        );

                        if (node == null) return;
                        editor.add(node);
                      },
                      child: Icons.add(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorAddNodeWindow extends StatelessWidget {
  const GeneratorAddNodeWindow({super.key});

  static WindowEntry<Node> createEntry(BuildContext context) => .withContextAnchor(
    context,
    isModal: true,
    builder: (_) => GeneratorAddNodeWindow(),
  );

  @override
  Widget build(BuildContext context) {
    final nodes = <String, Node>{
      'Array': ArrayNode(),
      'Fillet': FilletNode(),
      'Vertex': VertexNode(),
    };

    return WindowScaffold(
      title: Text('Add node'),
      child: SizedBox(
        width: 200.0,
        height: 240.0,
        child: ListView(
          children: [
            for (final entry in nodes.entries) ...[
              ListItem(
                onTap: () => Navigator.pop(context, entry.value),
                title: Text(entry.key),
              ),
              Divider(),
            ],
          ],
        ),
      ),
    );
  }
}
