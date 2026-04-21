import 'package:ui/ui.dart';

class DropdownButton extends StatelessWidget {
  const DropdownButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureSurface(
      onTap: () {},
      color: context.colors.surface.secondary,
      borderSide: .new(color: context.colors.divider, width: 0.0),
      borderRadius: .circular(4.0),
      padding: .symmetric(horizontal: 8.0),
      height: 32.0,
      child: Center(
        widthFactor: 1.0,
        child: Row(
          mainAxisSize: .min,
          children: [
            DefaultForegroundStyle(
              textStyle: context.typography.caption2.secondary,
              child: Text('HSV'),
            ),
            SizedBox(width: 4.0),
            Icons.chevronDown(
              size: 16.0,
              color: context.colors.display.tertiary,
            ),
          ],
        ),
      ),
    );
  }
}
