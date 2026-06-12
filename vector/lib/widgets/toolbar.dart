import 'package:vector/imports.dart';

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
        // ColorPicker(
        //   size: 36.0,
        //   value: () => strokeProperties.color,
        //   onChanged: (c) => controller.strokeProperties.color = c,
        // ),
        // const SizedBox(height: 8.0),
      ],
    );
  }
}
