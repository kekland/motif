import 'package:ui/ui.dart';

class const Header({
  super.key,
  required final Widget title,
  final Widget? leading,
  final Widget? footnote,
  final Widget? trailing,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListItem(
      color: context.colors.surface.secondary,
      leading: leading,
      title: title,
      footnote: footnote,
      trailing: trailing,
      height: 36.0,
    );
  }
}
