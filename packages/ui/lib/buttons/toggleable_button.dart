import 'package:ui/ui.dart';

class ToggleableButton extends StatelessWidget {
  const ToggleableButton({
    super.key,
    required this.child,
    this.isActive = false,
    this.onChanged,
    this.iconSize = 24.0,
  });

  final bool isActive;
  final ValueChanged<bool>? onChanged;
  final double iconSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GestureSurface(
        onTap: onChanged != null ? () => onChanged?.call(!isActive) : null,
        color: isActive ? context.colors.accent.secondary : Surface.colorOf(context),
        builder: (context, states) => Center(
          child: DefaultForegroundStyle(
            iconSize: iconSize,
            child: DefaultGestureReaction(
              states: {
                ...states,
                if (isActive) .selected,
              },
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class ToggleableButtonRow extends StatelessWidget {
  const ToggleableButtonRow({
    super.key,
    required this.children,
    this.borderRadius,
    this.height = 32.0,
  });

  final List<Widget> children;
  final BorderRadius? borderRadius;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Surface(
      width: double.infinity,
      height: height,
      color: context.colors.surface.secondary,
      borderRadius: borderRadius ?? .circular(4.0),
      child: Row(
        children: children.map<Widget>((c) => Expanded(child: c)).interleave(VerticalDivider()).toList(),
      ),
    );
  }
}
