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

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    final position = controller.globalToArtworkLocal(details.globalPosition);

    if (existingTransientEdge != null) {
      transientEdge = existingTransientEdge!;
      transientEdge.endPosition = position;
      isNewEdge = false;
    } else {
      transientEdge = controller.transientEdges.create(controller.complex.createVertex(position.asVector2()));
      isNewEdge = true;
      onTransientEdgeCreated(transientEdge);
    }
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);

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
    if (!isNewEdge) onTransientEdgeCompleted(transientEdge);
  }
}
