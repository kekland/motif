import 'package:editor/imports.dart';

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
              isActive: tool == activeTool,
              onTap: onToolSelected != null ? () => onToolSelected!(tool) : null,
              child: tool.buildIcon(context),
            ),
            // divider,
          ],
        );
      },
    );
  }
}

class ToolbarButton extends StatelessWidget {
  const ToolbarButton({
    super.key,
    required this.child,
    this.isActive = false,
    this.onTap,
  });

  final Widget child;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ToggleableButton(
        onChanged: (v) => onTap?.call(),
        isActive: isActive,
        borderRadius: .circular(4.0),
        foregroundColor: isActive ? null : context.colors.display.secondary,
        child: child,
      ),
    );
  }
}
