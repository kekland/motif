import 'package:design/imports.dart';

class MarqueeOverlay extends StatelessWidget {
  const MarqueeOverlay({super.key, required this.rect});

  final Rect rect;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.accent.primary;
    
    return Positioned.fromRect(
      rect: rect,
      child: Container(
        decoration: BoxDecoration(
          color: color.withScaledAlpha(0.1),
          border: Border.all(color: color, width: 2.0),
        ),
      ),
    );
  }
}