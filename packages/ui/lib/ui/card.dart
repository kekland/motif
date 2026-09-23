import 'package:ui/ui.dart';

class Card extends StatelessWidget {
  const new({
    super.key,
    required this.child,
    this.onTap,
    this.trailing,
  });

  final VoidCallback? onTap;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return GestureSurface(
      onTap: onTap,
      borderRadius: .circular(8.0),
      borderSide: .new(color: context.colors.divider),
      color: context.colors.surface.secondary,
      child: Column(
        children: [
          Expanded(child: child),
          if (trailing != null) ...[
            Divider(),
            trailing!,
          ],
        ],
      ),
    );
  }
}
