part of 'handles.dart';

class BaseHandleWidget extends StatelessWidget {
  const BaseHandleWidget({
    super.key,
    required this.size,
    required this.isSelected,
    required this.isHovered,
    required this.borderRadius,
    this.rotation = 0.0,
    this.accentColor,
  });

  final double size;
  final bool isSelected;
  final bool isHovered;
  final BorderRadius borderRadius;
  final double rotation;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final accentColor = this.accentColor ?? context.colors.accent.primary;
    final fillColor = isSelected ? accentColor : Colors.white;
    final borderColor = isSelected ? Colors.white : accentColor;
    final borderSize = isSelected || isHovered ? 2.0 : 1.0;
    final shadow = isSelected || isHovered ? context.shadows.medium : context.shadows.small;

    Widget child = DecoratedBox(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: borderRadius,
        border: .all(color: borderColor, width: borderSize),
        boxShadow: shadow,
      ),
      child: SizedBox.square(dimension: size),
    );

    child = Transform.rotate(
      angle: rotation,
      child: child,
    );

    return child;
  }
}
