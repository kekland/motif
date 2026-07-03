import 'package:ui/ui.dart';

class Subtitle extends StatelessWidget {
  const Subtitle({
    super.key,
    this.leading,
    required this.child,
    this.trailing,
  });

  final Widget? leading;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: .new(minHeight: 40.0),
      child: Surface(
        padding: .symmetric(vertical: 8.0),
        child: Row(
          children: [
            const SizedBox(width: 12.0),
            if (leading != null) ...[
              DefaultForegroundStyle(
                iconSize: 20.0,
                child: leading!,
              ),
              const SizedBox(width: 4.0),
            ],

            Expanded(
              child: DefaultForegroundStyle(
                textStyle: context.typography.subtitle,
                maxLines: 1,
                overflow: .ellipsis,
                child: child,
              ),
            ),

            if (trailing != null) ...[
              const SizedBox(width: 4.0),
              DefaultForegroundStyle(
                iconSize: 20.0,
                child: trailing!,
              ),
            ],
            const SizedBox(width: 8.0),
          ],
        ),
      ),
    );
  }
}
