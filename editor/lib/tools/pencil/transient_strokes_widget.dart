import 'package:editor/imports.dart';

class TransientStrokesWidget extends HookWidget {
  const TransientStrokesWidget({super.key, required this.transform});

  final Matrix4 transform;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final transientStrokes = useListenable(editor.transientStrokes);

    return Stack(
      children: [
        for (final stroke in transientStrokes.instances)
          _TransientStrokeWidget(
            stroke: stroke,
            transform: transform,
          ),
      ],
    );
  }
}

class _TransientStrokeWidget extends HookWidget {
  const _TransientStrokeWidget({super.key, required this.stroke, required this.transform});

  final TransientStroke stroke;
  final Matrix4 transform;

  @override
  Widget build(BuildContext context) {
    final stroke = useListenable(this.stroke);

    return CustomPaint(
      painter: _TransientStrokePainter(
        stroke: stroke,
        transform: transform,
      ),
    );
  }
}

class _TransientStrokePainter extends CustomPainter {
  _TransientStrokePainter({
    required this.stroke,
    required this.transform,
  });

  final TransientStroke stroke;
  final Matrix4 transform;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final p0 = stroke.data.point(0);
    path.moveTo(p0.x, p0.y);

    for (var i = 1; i < stroke.data.length; i++) {
      final pi = stroke.data.point(i);
      path.lineTo(pi.x, pi.y);
    }

    canvas.drawPath(
      path.transform(transform.storage),
      Paint()
        ..color = const Color(0xFFFFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    path.reset();
    if (stroke.predictions.isNotEmpty) {
      final p0 = stroke.predictions.point(0);
      path.moveTo(p0.x, p0.y);

      for (var i = 1; i < stroke.predictions.length; i++) {
        final pi = stroke.predictions.point(i);
        path.lineTo(pi.x, pi.y);
      }

      canvas.drawPath(
        path.transform(transform.storage),
        Paint()
          ..color = const Color(0x80FFFFFF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }
  }

  @override
  bool shouldRepaint(_TransientStrokePainter oldDelegate) => true;
}
