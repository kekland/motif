import 'package:ui/ui.dart';

class IconButton extends StatelessWidget {
  const IconButton({
    super.key,
    required this.child,
    this.onTap,
    this.size = 32.0,
    this.color,
    this.foregroundColor,
    this.borderRadius,
  });

  final VoidCallback? onTap;
  final Color? color;
  final Color? foregroundColor;
  final Widget child;
  final double size;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureSurface(
      onTap: onTap,
      width: size,
      height: size,
      color: color ?? Surface.maybeColorOf(context),
      foregroundColor: foregroundColor,
      borderRadius: borderRadius ?? BorderRadius.circular(4.0),
      builder: (context, states) {
        return DefaultGestureReaction(
          states: states,
          child: DefaultForegroundStyle(
            iconSize: 24.0,
            child: Center(child: child),
          ),
        );
      },
    );
  }
}
