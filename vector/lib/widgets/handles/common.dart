part of '../handles_overlay.dart';

class BaseHandleWidget extends StatelessWidget {
  const BaseHandleWidget({
    super.key,
    required this.size,
    required this.isSelected,
    required this.isHovered,
    required this.borderRadius,
    this.touchSize = 24.0,
    this.rotation = 0.0,
    this.onPointerDown,
    this.cursor,
  });

  final double size;
  final double touchSize;
  final bool isSelected;
  final bool isHovered;
  final BorderRadius borderRadius;
  final double rotation;
  final PointerDownEventListener? onPointerDown;
  final MouseCursor? cursor;

  @override
  Widget build(BuildContext context) {
    final fillColor = isSelected ? context.colors.accent.primary : Colors.white;
    final borderColor = isSelected ? Colors.white : context.colors.accent.primary;
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

    child = SizedBox(
      width: touchSize,
      height: touchSize,
      child: Center(child: child),
    );

    if (onPointerDown != null) {
      child = Listener(
        onPointerDown: onPointerDown,
        behavior: .translucent,
        child: child,
      );
    }

    if (cursor != null) {
      child = MouseRegion(
        cursor: cursor!,
        hitTestBehavior: .translucent,
        child: child,
      );
    }

    child = Transform.rotate(
      angle: rotation,
      child: child,
    );

    return child;
  }
}
