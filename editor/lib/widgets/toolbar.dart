import 'package:editor/imports.dart';
import 'package:editor/widgets/tool/toolbar_template.dart';

class EditorToolbar extends HookWidget {
  const EditorToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final controller = useListenable(editor.tool);
    final activeTool = useComputedValue(() => controller.activeTool);

    final isTablet = defaultTargetPlatform == .iOS || defaultTargetPlatform == .android;

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
          if (isTablet) ...[
            Divider(),
            ToolbarButton(
              onTap: () => editor.invoke(intents.deleteSelection()),
              child: Icons.delete(),
            ),
            ToolbarButton(
              onTap: () => editor.invoke(intents.undo()),
              child: Icons.undo(),
            ),
            ToolbarButton(
              onTap: () => editor.invoke(intents.redo()),
              child: Icons.redo(),
            ),
          ],
        ],
      ),
    );
  }
}
