import 'package:ui/ui.dart';

class IconButton extends StatelessWidget {
  const IconButton({
    super.key,
    required this.child,
    this.onTap,
    this.size = 32.0,
    this.iconSize = 16.0,
    this.color,
    this.foregroundColor,
    this.borderRadius,
    this.isFilled = true,
  });

  final VoidCallback? onTap;
  final Color? color;
  final Color? foregroundColor;
  final Widget child;
  final double size;
  final double iconSize;
  final BorderRadius? borderRadius;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    late final Color? color;

    if (this.color != null) {
      color = this.color!;
    } else if (isFilled) {
      color = context.colors.surface.secondary;
    } else {
      color = Surface.maybeColorOf(context);
    }

    return GestureSurface(
      onTap: onTap,
      width: size,
      height: size,
      color: color,
      foregroundColor: foregroundColor,
      borderSide: isFilled ? .new(color: context.colors.divider, width: 1.0) : null,
      borderRadius: borderRadius ?? BorderRadius.circular(4.0),
      child: DefaultForegroundStyle(
        iconSize: iconSize,
        child: Center(child: child),
      ),
    );
  }
}
