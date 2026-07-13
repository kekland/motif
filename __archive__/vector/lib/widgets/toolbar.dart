import 'generators/select_generator_window.dart';

import '../imports.dart';

class VectorToolbar extends HookWidget {
  const VectorToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.watch(context);
    final tools = useComputedValue(() => controller.tool.toolset);
    final activeTool = useComputedValue(() => controller.tool.activeTool);

    return Column(
      children: [
        Expanded(
          child: ToolbarTemplate(
            direction: .vertical,
            tools: tools,
            activeTool: activeTool,
            onToolSelected: (v) => controller.tool.activeTool = v,
          ),
        ),
        const SizedBox(height: 8.0),
        Divider(),
        Builder(
          builder: (context) => ToolbarButton(
            isActive: false,
            onTap: () => WindowNavigator.pushUnique(
              context,
              SymbolsWindow.createEntry(context, controller: controller),
            ),
            child: Icons.symbols(),
          ),
        ),
        Divider(),
        Builder(
          builder: (context) => ToolbarButton(
            isActive: false,
            onTap: () => WindowNavigator.pushUnique(
              context,
              SelectGeneratorWindow.createEntry(
                context,
                controller: controller,
              ),
            ),
            child: Icons.generator(),
          ),
        ),
      ],
    );
  }
}
