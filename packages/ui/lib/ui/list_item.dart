import 'package:ui/ui.dart';

class const ListItem({
  super.key,
  final VoidCallback? onTap,
  required final Widget leading,
  required final Widget title,
  final Widget? footnote,
  final Widget? trailing,
  final Color? color,
  final double? height,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureSurface(
      onTap: onTap,
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      height: height ?? 32.0,
      child: Row(
        children: [
          DefaultForegroundStyle(
            color: context.colors.display.tertiary,
            child: leading,
          ),
          const SizedBox(width: 4.0),
          Expanded(
            child: Row(
              textBaseline: .alphabetic,
              crossAxisAlignment: .baseline,
              children: [
                DefaultForegroundStyle(
                  style: context.typography.subtitle.secondary,
                  child: title,
                ),
                if (footnote != null) ...[
                  const SizedBox(width: 4.0),
                  DefaultForegroundStyle(
                    style: context.typography.footnote.secondary,
                    child: footnote!,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 4.0),
            DefaultForegroundStyle(
              color: context.colors.display.tertiary,
              child: trailing!,
            ),
          ],
        ],
      ),
    );
  }
}
