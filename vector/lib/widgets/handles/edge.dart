part of '../handles_overlay.dart';

class EdgeHandles extends StatelessWidget {
  const EdgeHandles({
    super.key,
    required this.edge,
    required this.childPaintTransform,
    this.hoveredCell,
    this.onKnotPointerDown,
    this.onKnotControlPointPointerDown,
    this.onOpenEdgeControlPointPointerDown,
  });

  final Edge edge;
  final Matrix4 childPaintTransform;
  final Cell? hoveredCell;
  final void Function(PointerDownEvent, CubicKnot2)? onKnotPointerDown;
  final void Function(PointerDownEvent, (CubicKnot2, bool))? onKnotControlPointPointerDown;
  final void Function(PointerDownEvent, (OpenEdge, bool))? onOpenEdgeControlPointPointerDown;

  @override
  Widget build(BuildContext context) {
    final children = <HandleWidget>[];

    final knots = switch (edge) {
      OpenEdge e => e.interior,
      ClosedEdge e => e.spline.knots,
    };

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

      if (cIn != null) {
        _addControlPointHandle(p, cIn, (e) => onKnotControlPointPointerDown?.call(e, (knot, true)));
      }

      if (cOut != null) {
        _addControlPointHandle(p, cOut, (e) => onKnotControlPointPointerDown?.call(e, (knot, false)));
      }

      children.add(
        HandleWidget(
          position: knot.p.asOffset(),
          child: KnotHandle(
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

      if (cStart != null) {
        _addControlPointHandle(start, cStart, (e) => onOpenEdgeControlPointPointerDown?.call(e, (edge, true)));
      }

      if (cEnd != null) {
        _addControlPointHandle(end, cEnd, (e) => onOpenEdgeControlPointPointerDown?.call(e, (edge, false)));
      }
    }

    return HandlesLayout(
      childPaintTransform: childPaintTransform,
      children: children,
    );
  }
}
