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

class ToolbarTemplate extends StatelessWidget {
  const ToolbarTemplate({
    super.key,
    required this.tools,
    this.activeTool,
    this.onToolSelected,
  });

  final List<Tool> tools;
  final Tool? activeTool;
  final ValueChanged<Tool?>? onToolSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];

        return Row(
          key: ValueKey(tool.key),
          mainAxisSize: MainAxisSize.min,
          children: [
            ToolbarButton(
              key: ValueKey(tool.key),
              tool: tool,
              isActive: tool == activeTool,
              onTap: onToolSelected != null ? () => onToolSelected!(tool) : null,
            ),
            VerticalDivider(width: 1.0),
          ],
        );
      },
    );
  }
}

class ToolbarButton extends StatelessWidget {
  const ToolbarButton({
    super.key,
    required this.tool,
    required this.isActive,
    this.onTap,
  });

  final Tool tool;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ToggleableButton(
      onChanged: (v) => onTap?.call(),
      isActive: isActive,
      child: tool.buildIcon(context),
    );
  }
}
