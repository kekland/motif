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

        final start = transientEdge.startVertex.position.asOffset();
        final end = transientEdge.end?.asOffset();
        final cStart = transientEdge.cStart?.asOffset();
        final cEnd = transientEdge.cEnd?.asOffset();

        // C1 handle
        if (cStart != null) {
          children.add(
            HandleWidget(
              position: cStart,
              child: ControlPointHandle(
                deltaToOrigin:
                    MatrixUtils.transformPoint(childPaintTransform, start) -
                    MatrixUtils.transformPoint(childPaintTransform, cStart),
              ),
            ),
          );
        }

        // End vertex
        if (end != null) {
          // Edge
          children.add(
            CustomPaint(
              painter: _TransientEdgePainter(
                cubic: transientEdge.cubic,
                color: context.colors.accent.primary,
                transform: childPaintTransform,
              ),
              child: const SizedBox.shrink(),
            ),
          );

          // C2 handles
          if (cEnd != null) {
            final origin = MatrixUtils.transformPoint(childPaintTransform, end);
            final cEndTransformed = MatrixUtils.transformPoint(childPaintTransform, cEnd);

            children.add(
              HandleWidget(
                position: cEnd,
                child: ControlPointHandle(
                  deltaToOrigin: origin - cEndTransformed,
                ),
              ),
            );

            final mirrorCEndPosition = end * 2 - cEnd;
            final mirrorCEndTransformed = MatrixUtils.transformPoint(childPaintTransform, mirrorCEndPosition);

            children.add(
              HandleWidget(
                position: mirrorCEndPosition,
                child: ControlPointHandle(
                  deltaToOrigin: origin - mirrorCEndTransformed,
                ),
              ),
            );
          }

          children.add(
            HandleWidget(
              position: end,
              child: VertexHandle(),
            ),
          );
        }

        // Intersections
        final intersections = transientEdge.intersections.map((i) => i.asOffset()).toList();
        for (final intersection in intersections) {
          children.add(
            HandleWidget(
              position: intersection,

              // TODO: handle for intersections
              child: ControlPointHandle(),
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
    required this.cubic,
    required this.color,
    required this.transform,
  });

  final Cubic2 cubic;
  final Color color;
  final Matrix4 transform;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = cubic.getPath();
    canvas.drawPath(path.transform(transform.storage), paint);
  }

  @override
  bool shouldRepaint(covariant _TransientEdgePainter oldDelegate) =>
      oldDelegate.cubic != cubic || oldDelegate.color != color || oldDelegate.transform != transform;
}
