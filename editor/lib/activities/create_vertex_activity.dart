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
  Object get mergeKey => transientEdge.mergeKey;
  bool get isNewEdge => existingTransientEdge == null;
  var didPassThreshold = false;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    final hitTest = editor.hitTest(details.globalPosition);
    if (existingTransientEdge != null) {
      transientEdge = existingTransientEdge!;

      final endVertex = editor.edit((txn) => txn.embedVertex(hitTest), mergeKey: mergeKey);
      transientEdge.end = editor.bundle.vertexPositionWorld(editor.handleOf(endVertex)!);
    } else {
      transientEdge = editor.transientEdges.createWithHitTest(hitTest);
      onTransientEdgeCreated(transientEdge);
    }
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final position = editor.globalToScene(details.globalPosition);

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
      final endHitTest = editor.hitTestScene(endPosition);
      final newTransient = transientEdge.commit(endHitTest: endHitTest, startNewEdge: true);
      onTransientEdgeCompleted(transientEdge);
      if (newTransient != null) onTransientEdgeCreated(newTransient);
    }
  }
}
