import 'package:editor/imports.dart';

final class EdgeStyleProperty extends StatelessWidget {
  const new({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final EdgeStyle value;
  final ValueChanged<EdgeStyle> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.0,
      children: [
        ColorField(
          value: value.color,
          onChanged: (color) => onChanged(value.copyWith(color: color)),
        ),
        DoubleExpressionInputField(
          value: value.width,
          onChanged: (width) => onChanged(value.copyWith(width: width)),
          options: .new(
            leading: Icons.weight(),
            hintText: '0',
          ),
        ),
      ],
    );
  }
}
