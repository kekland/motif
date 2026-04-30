part of '../handles_overlay.dart';

class TransientEdgeHandles extends StatelessWidget {
  const TransientEdgeHandles({
    super.key,
    required this.transientEdge,
    required this.childPaintTransform,
  });

  final TransientEdge transientEdge;
  final Matrix4 childPaintTransform;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: transientEdge,
      builder: (context, _) {
        final children = <Widget>[];

        final startPosition = transientEdge.start.position.asOffset();
        final endPosition = transientEdge.endPosition;
        final c1Position = transientEdge.c1Position;
        final c2Position = transientEdge.c2Position;

        // C1 handle
        if (c1Position != null) {
          children.add(
            HandleWidget(
              position: c1Position,
              child: ControlPointHandle(
                deltaToOrigin:
                    MatrixUtils.transformPoint(childPaintTransform, startPosition) -
                    MatrixUtils.transformPoint(childPaintTransform, c1Position),
              ),
            ),
          );
        }

        // End vertex
        if (endPosition != null) {
          // Edge
          children.add(
            CustomPaint(
              painter: _TransientEdgePainter(
                start: startPosition,
                end: endPosition,
                c1: c1Position,
                c2: c2Position,
                color: context.colors.accent.primary,
                transform: childPaintTransform,
              ),
              child: const SizedBox.shrink(),
            ),
          );

          // C2 handles
          if (c2Position != null) {
            final origin = MatrixUtils.transformPoint(childPaintTransform, endPosition);
            final c2Transformed = MatrixUtils.transformPoint(childPaintTransform, c2Position);

            children.add(
              HandleWidget(
                position: c2Position,
                child: ControlPointHandle(
                  deltaToOrigin: origin - c2Transformed,
                ),
              ),
            );

            final mirrorC2Position = endPosition + (endPosition - c2Position);
            final mirrorC2Transformed = MatrixUtils.transformPoint(childPaintTransform, mirrorC2Position);

            children.add(
              HandleWidget(
                position: mirrorC2Position,
                child: ControlPointHandle(
                  deltaToOrigin: origin - mirrorC2Transformed,
                ),
              ),
            );
          }

          children.add(
            HandleWidget(
              position: endPosition,
              child: VertexHandle(),
            ),
          );
        }

        return IgnorePointer(
          child: HandlesLayout(
            childPaintTransform: childPaintTransform,
            children: children,
          ),
        );
      },
    );
  }
}

class _TransientEdgePainter extends CustomPainter {
  const _TransientEdgePainter({
    required this.start,
    required this.end,
    this.c1,
    this.c2,
    required this.color,
    required this.transform,
  });

  final Offset start;
  final Offset end;
  final Offset? c1;
  final Offset? c2;
  final Color color;
  final Matrix4 transform;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path()..moveTo(start.dx, start.dy);
    path.cubicTo(c1?.dx ?? start.dx, c1?.dy ?? start.dy, c2?.dx ?? end.dx, c2?.dy ?? end.dy, end.dx, end.dy);
    canvas.drawPath(path.transform(transform.storage), paint);
  }

  @override
  bool shouldRepaint(covariant _TransientEdgePainter oldDelegate) =>
      oldDelegate.start != start || oldDelegate.end != end || oldDelegate.color != color;
}
