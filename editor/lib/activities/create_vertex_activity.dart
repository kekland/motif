import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

class CreateVertexActivity extends DragActivity {
  CreateVertexActivity({
    required this.editor,
    required this.onTransientEdgeCreated,
    required this.onTransientEdgeCompleted,
    required this.edgeStyle,
    this.existingTransientEdge,
    this.snapToPixel = false,
    this.topological = true,
    this.destructive = true,
  });

  final Editor editor;
  final bool topological;
  final bool snapToPixel;
  final bool destructive;
  final EdgeStyle edgeStyle;

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

      final endVertex = editor.edit(
        (txn) => txn.embedVertex(
          hitTest,
          topological: topological,
          destructive: destructive,
          snapToPixel: snapToPixel,
        ),
        mergeKey: mergeKey,
      );

      transientEdge.end = editor.bundle.vertexPosition(editor.handleOf(endVertex)!, space: .root);
    } else {
      transientEdge = editor.transientEdges.createWithHitTest(
        hitTest,
        topological: topological,
        destructive: destructive,
        snapToPixel: snapToPixel,
      );

      onTransientEdgeCreated(transientEdge);
    }
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    var position = editor.globalToScene(details.globalPosition);
    if (snapToPixel) position = position.round();

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
  void onEnd(DragEndDetails details) {
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
      final newTransient = transientEdge.commit(
        endHitTest: endHitTest,
        startNewEdge: true,
        topological: topological,
        destructive: destructive,
        edgeStyle: edgeStyle,
      );

      onTransientEdgeCompleted(transientEdge);
      if (newTransient != null) onTransientEdgeCreated(newTransient);
    }
  }
}
