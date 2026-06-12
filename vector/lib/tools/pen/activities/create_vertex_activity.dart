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

  bool get isNewEdge => existingTransientEdge == null;

  late TransientEdge transientEdge;
  var didPassThreshold = false;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    final position = controller.globalToArtworkLocal(details.globalPosition);
    final startHitEntry = controller.hitTestCell(details.globalPosition);

    // If we're on an existing edge, we modify the end point.
    // Otherwise, start a new edge.
    if (existingTransientEdge != null) {
      transientEdge = existingTransientEdge!;
      transientEdge.end = startHitEntry?.localPosition ?? position.asVector2();
    } else {
      transientEdge = controller.transientEdges.createWithHitTest(position.asVector2(), startHitEntry);
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
    final localPosition = position.asVector2();

    if (!isNewEdge) {
      final end = transientEdge.end!;
      transientEdge.cEnd = localPosition.pointReflect(end);
    } else {
      transientEdge.cStart = localPosition;
    }
  }

  @override
  void onEnd(DragEndDetails? details) {
    super.onEnd(details);

    if (!didPassThreshold) {
      if (!isNewEdge) {
        transientEdge.cEnd = null;
      } else {
        transientEdge.cStart = null;
      }
    }

    if (!isNewEdge) {
      // Commit the transient edge.
      final endPosition = transientEdge.end!.asOffset();
      final endGlobalPosition = controller.artworkLocalToGlobal(endPosition);
      final endHitTest = controller.hitTestCell(endGlobalPosition);
      final newTransient = controller.transientEdges.commit(transientEdge, endHitTest: endHitTest, startNewEdge: true);
      onTransientEdgeCompleted(transientEdge);
      if (newTransient != null) onTransientEdgeCreated(newTransient);
    }
  }
}
