import 'package:editor/imports.dart';

class TransientEdgesWidget extends HookWidget {
  const TransientEdgesWidget({super.key, required this.transform});

  final Matrix4 transform;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final transientEdges = useListenable(editor.transientEdges);

    return Stack(
      children: [
        for (final edge in transientEdges.instances)
          _TransientEdgeWidget(
            edge: edge,
            transform: transform,
          ),
      ],
    );
  }
}

class _TransientEdgeWidget extends HookWidget {
  const _TransientEdgeWidget({super.key, required this.edge, required this.transform});

  final TransientEdge edge;
  final Matrix4 transform;

  @override
  Widget build(BuildContext context) {
    final edge = useListenable(this.edge);

    return CustomPaint(
      painter: _TransientEdgePainter(
        edge: edge,
        transform: transform,
        primaryColor: context.colors.accent.primary,
        secondaryColor: context.colors.accent.secondary,
      ),
    );
  }
}

class _TransientEdgePainter extends CustomPainter {
  _TransientEdgePainter({
    required this.edge,
    required this.transform,
    required this.primaryColor,
    required this.secondaryColor,
  });

  final TransientEdge edge;
  final Matrix4 transform;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw control points
    final paintControlPoint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final cubic = edge.cubic.transformed(.fromListFloat64(transform.storage));
    canvas.drawLine(cubic.p0.offset, cubic.p1.offset, paintControlPoint);

    if (edge.end == null) return;

    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();

    path.moveTo(cubic.p0.x, cubic.p0.y);
    path.cubicTo(cubic.p1.x, cubic.p1.y, cubic.p2.x, cubic.p2.y, cubic.p3.x, cubic.p3.y);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TransientEdgePainter oldDelegate) =>
      oldDelegate.edge != edge ||
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.transform != transform;
}
