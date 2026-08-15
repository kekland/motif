import 'package:flutter/widgets.dart';

class WindowTitlebar extends StatelessWidget {
  const WindowTitlebar({
    super.key,
    required this.child,
    required this.preferredHeight,
    this.trafficLightsHorizontalOffset = 6.0,
  });

  final double preferredHeight;
  final double trafficLightsHorizontalOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: preferredHeight, child: child);
  }
}
