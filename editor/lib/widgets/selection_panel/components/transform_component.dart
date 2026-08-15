import 'package:editor/widgets/selection_panel/components/position_component.dart';
import 'package:editor/widgets/selection_panel/components/rotation_component.dart';
import 'package:ui/ui.dart';
import 'package:geometry/geometry.dart';

class TransformComponentWidget extends StatelessWidget {
  const TransformComponentWidget({
    super.key,
    required this.transform,
    this.overridePosition,
    this.onPositionChanged,
    this.onRotationChanged,
  });

  final Mat4 transform;
  final Vec2? overridePosition;
  final ValueChanged<Vec2>? onPositionChanged;
  final ValueChanged<double>? onRotationChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PositionComponentWidget(
          position: transform.translation2,
          overridePosition: overridePosition,
          onChanged: onPositionChanged,
        ),
        const SizedBox(height: 8.0),
        RotationComponentWidget(
          rotation: transform.rotationZ,
          onChanged: onRotationChanged,
        ),
      ],
    );
  }
}
