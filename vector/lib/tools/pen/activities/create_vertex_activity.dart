part of 'pen_activities.dart';

class CreateVertexActivity extends DragActivity {
  CreateVertexActivity({
    required this.controller,
    required this.onTransientEdgeCreated,
    required this.onTransientEdgeCompleted,
    this.existingTransientEdge,
  });

  final VectorController controller;
  final TransientEdge? existingTransientEdge;
  final ValueChanged<TransientEdge> onTransientEdgeCreated;
  final ValueChanged<TransientEdge> onTransientEdgeCompleted;

  late bool isNewEdge;
  late TransientEdge transientEdge;
  var didPassThreshold = false;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    final position = controller.globalToArtworkLocal(details.globalPosition);
    final startHitEntry = controller.hitTestCell(details.globalPosition);

    if (existingTransientEdge != null) {
      transientEdge = existingTransientEdge!;
      transientEdge.endPosition = position;
      isNewEdge = false;
    } else {
      late final Vertex vtx;

      if (startHitEntry is VertexHitTestEntry) {
        vtx = startHitEntry.vertex;
      } else if (startHitEntry is EdgeHitTestEntry) {
        final edge = startHitEntry.edge;
        final t = startHitEntry.t;
        final result = controller.complex.cutEdge(edge, t);
        vtx = result.vertex;
      } else {
        vtx = controller.complex.createVertex(position.asVector2());
      }

      transientEdge = controller.transientEdges.create(vtx);
      isNewEdge = true;
      onTransientEdgeCreated(transientEdge);
    }
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);
    if (!didPassThreshold) {
      final delta = (details.globalPosition - startDetails.globalPosition).distance;
      if (delta >= kTouchSlop) didPassThreshold = true;
    }

    final position = controller.globalToArtworkLocal(details.globalPosition);
    if (!isNewEdge) {
      final point = transientEdge.endPosition!;
      transientEdge.cEndPosition = point + (point - position);
    } else {
      transientEdge.cStartPosition = position;
    }
  }

  @override
  void onEnd(DragEndDetails? details) {
    super.onEnd(details);

    if (!didPassThreshold) {
      if (!isNewEdge) {
        transientEdge.cEndPosition = null;
      } else {
        transientEdge.cStartPosition = null;
      }
    }

    if (!isNewEdge) onTransientEdgeCompleted(transientEdge);
  }
}
