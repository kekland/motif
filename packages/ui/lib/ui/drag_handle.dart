import 'package:ui/ui.dart';

class DragHandle extends HookWidget {
  const new({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final isHovering = useState(false);

    return MouseRegion(
      onEnter: (_) => isHovering.value = true,
      onExit: (_) => isHovering.value = false,
      child: ReorderableDragStartListener(
        index: index,
        child: MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: SizedBox(
            width: 12.0,
            height: 36.0,
            child: Icons.dragHandle(
              color: context.colors.display.tertiary.withScaledAlpha(isHovering.value ? 1.0 : 0.5),
              size: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
