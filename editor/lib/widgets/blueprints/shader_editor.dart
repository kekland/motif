import 'package:editor/imports.dart';
import 'package:blueprint/editor.dart';

import 'blueprint_editor.dart';

class ShaderEditor extends HookWidget {
  const ShaderEditor({
    super.key,
    required this.editor,
  });

  final BlueprintEditor<ShaderBlueprint> editor;

  @override
  Widget build(BuildContext context) {
    return BlueprintEditorWidget(
      editor: editor,
      nodeFactories: {
        ...blueprintShaderIONodeFactories(context),
        ...blueprintMathNodeFactories(context),
        ...blueprintColorNodeFactories(context),
      },
      colorResolvers: blueprintColorResolvers(context),
      socketValueBuilders: blueprintSocketValueBuilders(context),
      enums: blueprintEnums(context),
    );
  }
}
