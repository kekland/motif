import 'package:tool/tool.dart';
import 'package:ui/ui.dart';

class ToolbarTemplate extends StatelessWidget {
  const ToolbarTemplate({
    super.key,
    required this.tools,
    this.activeTool,
    this.onToolSelected,
    this.direction = .horizontal,
  });

  final List<Tool> tools;
  final Tool? activeTool;
  final ValueChanged<Tool?>? onToolSelected;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    final divider = direction == .vertical ? Divider(height: 0.0) : VerticalDivider(width: 0.0);

    return ListView.builder(
      padding: .zero,
      scrollDirection: direction,
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];

        return Flex(
          key: ValueKey(tool.key),
          direction: direction,
          mainAxisSize: MainAxisSize.min,
          children: [
            ToolbarButton(
              key: ValueKey(tool.key),
              tool: tool,
              isActive: tool == activeTool,
              onTap: onToolSelected != null ? () => onToolSelected!(tool) : null,
            ),
            divider,
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
