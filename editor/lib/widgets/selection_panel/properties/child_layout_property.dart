import 'package:scene/scene.dart';
import 'package:ui/ui.dart';

class ChildLayoutComponentWidget extends StatelessWidget {
  const ChildLayoutComponentWidget({
    super.key,
    required this.childLayout,
    this.onChanged,
  });

  final ChildLayout childLayout;
  final ValueChanged<ChildLayout>? onChanged;

  @override
  Widget build(BuildContext context) {
    final childLayout = this.childLayout;

    return ToggleableButtonRow(
      children: [
        ToggleableButton(
          onChanged: (v) => onChanged?.call(.stack()),
          isActive: childLayout is StackChildLayout,
          child: Icons.layoutStack(),
        ),
        ToggleableButton(
          onChanged: (v) => onChanged?.call(.flex(direction: .row)),
          isActive: childLayout is FlexChildLayout && childLayout.direction == .row,
          child: Icons.layoutRow(),
        ),
        ToggleableButton(
          onChanged: (v) => onChanged?.call(.flex(direction: .column)),
          isActive: childLayout is FlexChildLayout && childLayout.direction == .column,
          child: Icons.layoutColumn(),
        ),
      ],
    );
  }
}
