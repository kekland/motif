import 'dart:math';

import 'package:editor/imports.dart';

class RotationComponentWidget extends StatelessWidget {
  const RotationComponentWidget({
    super.key,
    required this.rotation,
    this.onChanged,
  });

  final double rotation;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4.0,
      children: [
        Expanded(
          child: DoubleExpressionInputField(
            value: rotation * rad2Deg,
            onChanged: onChanged != null ? (v) => onChanged!(v * deg2Rad) : null,
            options: .new(
              leading: Icons.angle(),
              hintText: '0.0',
            ),
          ),
        ),
        IconButton(
          onTap: onChanged != null ? () => onChanged!(rotation + (pi / 2)) : null,
          child: Icons.rotateCw(),
        ),
      ],
    );
  }
}
