import 'package:flutter/rendering.dart';
import 'package:vector/imports.dart';

part 'base.dart';
part 'layout.dart';

class VertexHandle extends StatelessWidget {
  const VertexHandle({
    super.key,
    this.isSelected = false,
    this.isHovered = false,
  });

  static const double size = 10.0;

  final bool isSelected;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    return BaseHandleWidget(
      size: size,
      borderRadius: .circular(2.0),
      isSelected: isSelected,
      isHovered: isHovered,
    );
  }
}
