part of '../color_picker_window.dart';

class _DragHandle extends StatelessWidget {
  const _DragHandle({super.key, this.innerColor});
  static const size = 16.0;

  final Color? innerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: context.shadows.small,
      ),
      child: Center(
        child: Container(
          width: size / 2,
          height: size / 2,
          decoration: BoxDecoration(shape: BoxShape.circle, color: innerColor),
        ),
      ),
    );
  }
}
