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
      title: title,
      footnote: footnote,
      trailing: trailing,
      padding: padding,
      height: 36.0,
    );
  }
}
