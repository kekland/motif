import 'package:ui/ui.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.leading,
    this.onTap,
    required this.child,
  });

  final VoidCallback? onTap;
  final Widget? leading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureSurface(
      onTap: onTap,
      height: 32.0,
      color: context.colors.surface.secondary,
      borderSide: .new(color: context.colors.divider),
      borderRadius: .circular(4.0),
      child: Center(
        child: Row(
          mainAxisSize: .min,
          children: [
            const SizedBox(width: 8.0),
            if (leading != null) ...[
              DefaultForegroundStyle(
                iconSize: 20.0,
                child: leading!,
              ),
            ],
            const SizedBox(width: 4.0),
            DefaultForegroundStyle(
              textStyle: context.typography.body,
              child: child,
            ),
            const SizedBox(width: 12.0),
          ],
        ),
      ),
    );
  }
}
