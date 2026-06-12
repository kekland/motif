part of '../handles_overlay.dart';

class EdgeHandles extends StatelessWidget {
  const EdgeHandles({
    super.key,
    required this.edge,
    required this.childPaintTransform,
    this.selection = const {},
    this.hoveredCell,
    this.onKnotPointerDown,
    this.onKnotControlPointPointerDown,
    this.onOpenEdgeControlPointPointerDown,
  });

  final Edge edge;
  final Matrix4 childPaintTransform;
  final Set<Object> selection;
  final Cell? hoveredCell;
  final void Function(PointerDownEvent, CubicKnot2)? onKnotPointerDown;
  final void Function(PointerDownEvent, (CubicKnot2, bool))? onKnotControlPointPointerDown;
  final void Function(PointerDownEvent, (OpenEdge, bool))? onOpenEdgeControlPointPointerDown;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    var isEdgeInSelection = false;
    if (edge is OpenEdge) {
      final edge = this.edge as OpenEdge;
      isEdgeInSelection = selection.contains(edge) || selection.contains(edge.start) || selection.contains(edge.end);
    } else {
      isEdgeInSelection = selection.contains(edge);
    }

    final knots = switch (edge) {
      OpenEdge e => e.interior,
      ClosedEdge e => e.spline.knots,
    };

    for (final k in knots) {
      isEdgeInSelection |= selection.contains(k);
    }

    if (!isEdgeInSelection) return const SizedBox.shrink();

    void _addControlPointHandle(Offset origin, Offset controlPoint, PointerDownEventListener? onPointerDown) {
      final delta =
          MatrixUtils.transformPoint(childPaintTransform, origin) -
          MatrixUtils.transformPoint(childPaintTransform, controlPoint);

      final widget = HandleWidget(
        position: controlPoint,
        child: ControlPointHandle(
          deltaToOrigin: delta,
          onPointerDown: onPointerDown,
        ),
      );

      children.add(widget);
    }

    for (final knot in knots) {
      final p = knot.p.asOffset();
      final cIn = knot.cIn?.asOffset();
      final cOut = knot.cOut?.asOffset();

      if (isEdgeInSelection || selection.contains(knot)) {
        if (cIn != null) {
          _addControlPointHandle(p, cIn, (e) => onKnotControlPointPointerDown?.call(e, (knot, true)));
        }

        if (cOut != null) {
          _addControlPointHandle(p, cOut, (e) => onKnotControlPointPointerDown?.call(e, (knot, false)));
        }
      }

      children.add(
        HandleWidget(
          position: knot.p.asOffset(),
          child: KnotHandle(
            isSelected: selection.contains(knot),
            onPointerDown: (e) => onKnotPointerDown?.call(e, knot),
          ),
        ),
      );
    }

    if (edge is OpenEdge) {
      // For open edges, we also need to add control point handles for the start and end vertices.
      final edge = this.edge as OpenEdge;
      final start = edge.start.position.asOffset();
      final end = edge.end.position.asOffset();
      final cStart = edge.cStart?.asOffset();
      final cEnd = edge.cEnd?.asOffset();

      if (isEdgeInSelection) {
        if (cStart != null) {
          _addControlPointHandle(start, cStart, (e) => onOpenEdgeControlPointPointerDown?.call(e, (edge, true)));
        }

        if (cEnd != null) {
          _addControlPointHandle(end, cEnd, (e) => onOpenEdgeControlPointPointerDown?.call(e, (edge, false)));
        }
      }
    }

    if (isEdgeInSelection) {
      children.add(
        IgnorePointer(
          child: CustomPaint(
            painter: _EdgeSelectionPainter(
              edge: edge,
              color: context.colors.accent.primary,
              transform: childPaintTransform,
            ),
          ),
        ),
      );
    }

    return HandlesLayout(
      childPaintTransform: childPaintTransform,
      children: children,
    );
  }
}

class _EdgeSelectionPainter extends CustomPainter {
  const _EdgeSelectionPainter({required this.edge, required this.color, required this.transform});

  final Color color;
  final Edge edge;
  final Matrix4 transform;

  @override
  void paint(Canvas canvas, Size size) {
    final path = edge.getPath().transform(transform.storage);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _EdgeSelectionPainter oldDelegate) {
    return oldDelegate.edge != edge || oldDelegate.color != color;
  }
}
