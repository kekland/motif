import 'package:ui/ui.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.leading,
    required this.child,
    this.onTap,
    this.height,
  });

  final VoidCallback? onTap;
  final Widget? leading;
  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureSurface(
      onTap: onTap,
      height: height ?? 28.0,
      color: context.colors.surface.secondary,
      borderSide: .new(color: context.colors.divider, width: 1.0),
      borderRadius: .circular(4.0),
      padding: const .symmetric(horizontal: 8.0),
      child: DefaultForegroundStyle(
        style: context.typography.body,
        iconSize: 16.0,
        child: Center(
          widthFactor: 1.0,
          child: Row(
            mainAxisSize: .min,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 4.0),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  const new({super.key, required this.buttons});

  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.0,
      children: buttons,
    );
  }
}
