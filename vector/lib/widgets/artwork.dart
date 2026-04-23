import 'package:vector/imports.dart';
import 'package:vector/widgets/transient_strokes.dart';
import 'package:vgc/debug/debug_draw.dart';
import 'package:vgc/vgc.dart';

class ArtworkWidget extends StatelessWidget {
  const ArtworkWidget({super.key, required this.controller});

  final VectorController controller;

  @override
  Widget build(BuildContext context) {
    final complex = controller.complex;

    return Stack(
      children: [
        Positioned.fill(
          child: TransientStrokesWidget(
            transientStrokes: controller.transientStrokes,
          ),
        ),
        CustomPaint(
          key: controller.artworkKey,
          painter: _VectorComplexPainter(
            complex: complex,
            repaint: complex,
          ),
        ),
      ],
    );
  }
}

class _VectorComplexPainter extends CustomPainter {
  const _VectorComplexPainter({
    required this.complex,
    super.repaint,
  });

  final VectorComplex complex;

  @override
  void paint(Canvas canvas, Size size) {
    drawDebugVectorComplex(canvas, complex);
  }

  @override
  bool shouldRepaint(_VectorComplexPainter oldDelegate) => true;
}
