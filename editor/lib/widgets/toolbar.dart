import 'package:editor/imports.dart';

class EditorToolbar extends HookWidget {
  const EditorToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useListenable(context.tool);
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
          // IconButton(
          //   onTap: () => context.editor.moveR2(),
          //   child: Icons.b(),
          // ),
        ],
      ),
    );
  }
}
