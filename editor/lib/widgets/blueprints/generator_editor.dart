import 'package:blueprint/editor.dart';
import 'package:editor/imports.dart';

import 'blueprint_editor.dart';

class GeneratorEditor extends HookWidget {
  const GeneratorEditor({
    super.key,
    required this.editor,
  });

  final BlueprintEditor<GeneratorBlueprint> editor;

  @override
  Widget build(BuildContext context) {
    return BlueprintEditorWidget(
      editor: editor,
      nodeFactories: {
        ...blueprintGeneratorIONodeFactories(context),
        ...blueprintPrimitivesNodeFactories(context),
        ...blueprintGeometryNodeFactories(context),
        ...blueprintQueryNodeFactories(context),
        ...blueprintFieldNodeFactories(context),
        ...blueprintMathNodeFactories(context),
        ...blueprintColorNodeFactories(context),
      },
      colorResolvers: blueprintColorResolvers(context),
      socketValueBuilders: blueprintSocketValueBuilders(context),
      enums: blueprintEnums(context),
    );
  }
}
