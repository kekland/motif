import 'package:ui/ui.dart';

class const ListItem({
  super.key,
  final VoidCallback? onTap,
  required final Widget title,
  final Widget? leading,
  final Widget? footnote,
  final Widget? trailing,
  final Color? color,
  final double? height,
  final bool isSelected = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final iconColor = isSelected ? null : context.colors.display.tertiary;
    final titleColor = isSelected ? null : context.colors.display.secondary;

    return GestureSurface(
      onTap: onTap,
      color: isSelected ? context.colors.accent.secondary : color,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: height ?? 36.0,
      child: Row(
        children: [
          if (leading != null) ...[
            DefaultForegroundStyle(
              color: iconColor,
              child: leading!,
            ),
            const SizedBox(width: 4.0),
          ],
          Expanded(
            child: Row(
              textBaseline: .alphabetic,
              crossAxisAlignment: .baseline,
              children: [
                DefaultForegroundStyle(
                  style: context.typography.subtitle.copyWith(color: titleColor),
                  child: title,
                ),
                if (footnote != null) ...[
                  const SizedBox(width: 4.0),
                  DefaultForegroundStyle(
                    style: context.typography.footnote.tertiary,
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
