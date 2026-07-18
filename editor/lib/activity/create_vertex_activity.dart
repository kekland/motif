import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

class CreateVertexActivity extends DragActivity {
  CreateVertexActivity({
    required this.editor,
    required this.onTransientEdgeCreated,
    required this.onTransientEdgeCompleted,
    this.existingTransientEdge,
  });

  final Editor editor;

  final TransientEdge? existingTransientEdge;
  final ValueChanged<TransientEdge> onTransientEdgeCreated;
  final ValueChanged<TransientEdge> onTransientEdgeCompleted;

  late TransientEdge transientEdge;
  bool get isNewEdge => existingTransientEdge == null;
  var didPassThreshold = false;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    final startHitTest = editor.hitTestScene(details.globalPosition.vec2);
    if (existingTransientEdge != null) {
      transientEdge = existingTransientEdge!;

      final endVertex = editor.scene.topology.embedVertexAtHitTest(startHitTest, depth: transientEdge.parent.depth);
      transientEdge.end = endVertex.position;
    } else {
      transientEdge = editor.transientEdges.createWithHitTest(startHitTest);
      onTransientEdgeCreated(transientEdge);
    }
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final position = editor.globalToLocal(transientEdge.parent, details.globalPosition.vec2);

    if (!didPassThreshold) {
      final delta = (details.globalPosition - startDetails.globalPosition).distance;
      if (delta >= kTouchSlop) didPassThreshold = true;
    }

    if (!isNewEdge) {
      final end = transientEdge.end!;
      transientEdge.cEnd = position.pointReflect(end);
    } else {
      transientEdge.cStart = position;
    }

    super.onUpdate(details);
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
      final endPosition = transientEdge.end!;
      final endGlobalPosition = editor.localToGlobal(transientEdge.parent, endPosition);
      final endHitTest = editor.hitTestScene(endGlobalPosition);
      final newTransient = transientEdge.commit(endHitTest: endHitTest, startNewEdge: true);
      onTransientEdgeCompleted(transientEdge);
      if (newTransient != null) onTransientEdgeCreated(newTransient);
    }
  }
}
