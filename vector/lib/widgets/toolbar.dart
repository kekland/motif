import 'package:vector/imports.dart';

class VectorToolbar extends HookWidget {
  const VectorToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.watch(context);
    final tools = useComputedValue(() => controller.tool.toolset);
    final activeTool = useComputedValue(() => controller.tool.activeTool);

    return ToolbarTemplate(
      tools: tools,
      activeTool: activeTool,
      onToolSelected: (v) => controller.tool.activeTool = v,
    );
  }
}
