import 'package:ui/ui.dart';

class WindowScaffold extends StatelessWidget {
  const WindowScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Surface(
      color: context.colors.surface.primary,
      shadows: context.shadows.window,
      borderSide: BorderSide(color: context.colors.divider),
      borderRadius: BorderRadius.circular(4.0),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: .min,
          children: [
            SizedBox(
              height: 40.0,
              child: Row(
                mainAxisSize: .min,
                children: [
                  const SizedBox(width: 12.0),
                  Expanded(child: Text('colors', style: context.typography.caption1.tertiary)),
                  const SizedBox(width: 8.0),
                  IconButton(
                    onTap: () => Navigator.of(context).maybePop(),
                    foregroundColor: context.colors.display.tertiary,
                    child: Icons.close(),
                  ),
                  const SizedBox(width: 4.0),
                ],
              ),
            ),
            Divider(height: 1.0, color: context.colors.divider),
            child,
          ],
        ),
      ),
    );
  }
}
