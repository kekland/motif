import 'package:ui/ui.dart';
import 'package:geometry/geometry.dart';

class PositionComponentWidget extends StatelessWidget {
  const PositionComponentWidget({
    super.key,
    required this.position,
    this.overridePosition,
    this.onChanged,
  });

  final Vec2 position;
  final Vec2? overridePosition;
  final ValueChanged<Vec2>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4.0,
      children: [
        Expanded(
          child: DoubleExpressionInputField(
            value: position.x,
            onChanged: onChanged != null ? (v) => onChanged!(position.withX(v)) : null,
            options: .new(
              leading: Icons.x(),
              textStyle: overridePosition != null ? context.typography.body.tertiary : null,
              hintText: '0',
            ),
          ),
        ),
        Expanded(
          child: DoubleExpressionInputField(
            value: position.y,
            onChanged: onChanged != null ? (v) => onChanged!(position.withY(v)) : null,
            options: .new(
              leading: Icons.y(),
              textStyle: overridePosition != null ? context.typography.body.tertiary : null,
              hintText: '0',
            ),
          ),
        ),
      ],
    );
  }
}
