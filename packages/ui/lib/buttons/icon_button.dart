import 'package:ui/ui.dart';

class IconButton extends StatelessWidget {
  const IconButton({super.key, required this.child, this.onTap, this.size = 32.0, this.color, this.foregroundColor});

  final VoidCallback? onTap;
  final Color? color;
  final Color? foregroundColor;
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureSurface(
      onTap: onTap,
      width: size,
      height: size,
      color: color ?? context.colors.surface.primary,
      foregroundColor: foregroundColor,
      borderRadius: BorderRadius.circular(4.0),
      builder: (context, states) {
        return DefaultGestureReaction(
          states: states,
          child: DefaultForegroundStyle(
            iconSize: 20.0,
            child: Center(child: child),
          ),
        );
      },
    );
  }
}
