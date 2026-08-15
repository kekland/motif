import 'package:editor/imports.dart';
import 'package:editor/widgets/tool/toolbar_template.dart';

class EditorToolbar extends HookWidget {
  const EditorToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useListenable(context.editor.tool);
    final activeTool = useComputedValue(() => controller.activeTool);

    return SizedBox(
      width: 48.0,
      child: Column(
        children: [
          Expanded(
            child: ToolbarTemplate(
              tools: controller.toolset,
              activeTool: activeTool,
              onToolSelected: (v) => controller.activeTool = v,
              direction: .vertical,
            ),
          ),
        ],
      ),
    );
  }
}
