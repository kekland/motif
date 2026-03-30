import 'package:ui/ui.dart';

class DefaultGestureReaction extends StatelessWidget {
  const DefaultGestureReaction({
    super.key,
    required this.states,
    required this.child,
  });

  final Set<WidgetState> states;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isSelected = states.contains(WidgetState.selected);
    final isHovered = states.contains(WidgetState.hovered);
    final isPressed = states.contains(WidgetState.pressed);

    return DefaultForegroundStyle(
      iconWeight: 200.0,
      iconFill: isSelected ? 1.0 : 0.0,
      iconGrade: isHovered || isSelected ? 100.0 : 0.0,
      color: isPressed ? context.colors.accent.primary : null,
      child: child,
    );
  }
}
