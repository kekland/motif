import 'package:vector/imports.dart';

class StrokeWidthWindow extends StatelessWidget {
  const StrokeWidthWindow({super.key});

  static WindowEntry createEntry(BuildContext context) {
    return WindowEntry.withContextAnchor(
      context,
      builder: (_) => StrokeWidthWindow(),
      isModal: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WindowScaffold(
      child: Container(
        width: 480.0,
        height: 480.0,
        child: CheckerboardWidget(
          color1: context.colors.surface.primary,
          color2: context.colors.surface.secondary,
        ),
      ),
    );
  }
}
