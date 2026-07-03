import 'package:ui/ui.dart';

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    this.leading,
    this.trailing,
    required this.title,
    this.onTap,
  });

  final VoidCallback? onTap;
  final Widget? leading;
  final Widget? trailing;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return GestureSurface(
      onTap: onTap,
      child: Subtitle(
        leading: leading,
        trailing: trailing,
        child: title,
      ),
    );
  }
}
