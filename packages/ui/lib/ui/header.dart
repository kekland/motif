import 'package:ui/ui.dart';

class const Header({
  super.key,
  required final Widget title,
  final Widget? leading,
  final Widget? footnote,
  final Widget? trailing,
  final EdgeInsets? padding,
  final VoidCallback? onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListItem(
      onTap: onTap,
      color: context.colors.surface.secondary,
      leading: leading,
      title: Row(
        crossAxisAlignment: .baseline,
        textBaseline: .alphabetic,
        children: [
          DefaultForegroundStyle(
            style: context.typography.subtitle.secondary,
            child: title,
          ),
          if (footnote != null) ...[
            const SizedBox(width: 4.0),
            Flexible(
              child: DefaultForegroundStyle(
                style: context.typography.footnote.tertiary,
                maxLines: 1,
                overflow: .ellipsis,
                child: footnote!,
              ),
            ),
          ],
        ],
      ),
      trailing: trailing,
      padding: padding,
      height: 36.0,
    );
  }
}
