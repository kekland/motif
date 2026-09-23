import 'package:flutter/material.dart';

class SliverSpacer extends StatelessWidget {
  const SliverSpacer({
    super.key,
    required this.size,
  });

  /// The size of the spacer.
  final double size;

  @override
  Widget build(BuildContext context) {
    // Get the scroll axis from the context
    final scrollable = Scrollable.of(context);
    final direction = scrollable.axisDirection;
    final axis = axisDirectionToAxis(direction);

    late final Widget child;

    if (axis == Axis.horizontal) {
      child = SizedBox(width: size);
    } else if (axis == Axis.vertical) {
      child = SizedBox(height: size);
    }

    return SliverToBoxAdapter(child: child);
  }
}
