import 'package:design/imports.dart';

class DesignToolbar extends HookWidget {
  const DesignToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DesignController.watch(context);
    final tools = useComputedValue(() => controller.tool.toolset);
    final activeTool = useComputedValue(() => controller.tool.activeTool);

    return ToolbarTemplate(
      tools: tools,
      activeTool: activeTool,
      onToolSelected: (v) => controller.tool.activeTool = v,
    );
  }
}
