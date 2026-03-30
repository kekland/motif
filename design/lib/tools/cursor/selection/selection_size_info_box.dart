part of '../selection_overlay.dart';

class SelectionSizeInfoBox extends StatelessWidget {
  const SelectionSizeInfoBox({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Surface(
      color: context.colors.accent.secondary,
      borderRadius: BorderRadius.circular(4.0),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
      child: Text(
        '${size.width.toStringAsFixed(0)}×${size.height.toStringAsFixed(0)}',
        style: context.typography.footnote,
      ),
    );
  }
}
