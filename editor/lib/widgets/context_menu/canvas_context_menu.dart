import 'package:ui/ui.dart';

class CanvasContextMenu extends HookWidget {
  const new({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ContextMenuDetector(
      onShow: (context, details) {
        return [];
      },
      child: child,
    );
  }
}
