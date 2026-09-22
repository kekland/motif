part of '../color_input_window.dart';

class _DragHandle extends StatelessWidget {
  const _DragHandle({
    super.key,
    this.innerColor,
    this.expandWidth = false,
    this.expandHeight = false,
  });

  static const size = 16.0;

  final bool expandWidth;
  final bool expandHeight;
  final Color? innerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: expandWidth ? .infinity : size,
      height: expandHeight ? .infinity : size,
      padding: .all(size / 4.0),
      decoration: BoxDecoration(
        borderRadius: .circular(size / 2.0),
        color: Colors.white,
        boxShadow: context.shadows.small,
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: innerColor,
            borderRadius: .circular(size / 2.0),
          ),
        ),
      ),
    );
  }
}
