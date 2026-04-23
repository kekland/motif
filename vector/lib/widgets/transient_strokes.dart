import 'package:vector/imports.dart';

class TransientStrokesWidget extends StatelessWidget {
  const TransientStrokesWidget({super.key, required this.transientStrokes});

  final TransientStrokes transientStrokes;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: transientStrokes,
      builder: (context, _) {
        final strokes = transientStrokes.strokes;

        return Stack(
          children: [
            for (final stroke in strokes) CustomPaint(painter: TransientStrokePainter(stroke: stroke)),
          ],
        );
      },
    );
  }
}

class TransientStrokePainter extends CustomPainter {
  TransientStrokePainter({required this.stroke}) : super(repaint: stroke);

  final TransientStroke stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..strokeCap = .round
      ..strokeJoin = .round;

    final paint2 = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0;

    canvas.drawRawPoints(.polygon, stroke.points, paint);
    canvas.drawRawPoints(.points, stroke.points, paint2);
  }

  @override
  bool shouldRepaint(TransientStrokePainter oldDelegate) => true;
}
