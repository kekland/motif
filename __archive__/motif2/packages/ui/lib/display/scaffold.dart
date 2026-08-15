import 'package:ui/ui.dart';
import 'package:stack_ui/stack_ui.dart' as ui;

class Scaffold extends StatelessWidget {
  const Scaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ui.Scaffold(
      backgroundColor: context.colors.surface.primary,
      child: child,
    );
  }
}
