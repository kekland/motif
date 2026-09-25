import 'dart:math' as math;

import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

class CreateVertexActivity extends DragActivity with KeyboardListenerDragActivity {
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

  static Vec2 computePosition(
    Editor editor,
    Offset globalPosition, {
    Vec2? startPosition,
    bool isShiftPressed = false,
    bool topological = true,
    bool snapToPixel = false,
  }) {
    var position = editor.globalToScene(globalPosition);

    if (topological) {
      final hitTest = editor.hitTestScene(position);
      if (hitTest.vertices.isNotEmpty) {
        final vertex = hitTest.vertices.first.ref;
        return editor.bundle.vertexPosition(editor.handleOf(vertex)!, space: .root);
      } else if (hitTest.edges.isNotEmpty) {
        final edge = hitTest.edges.first;
        return editor.bundle.edgeCubic(editor.handleOf(edge.ref)!, space: .root).point(edge.t);
      }
    }

    if (snapToPixel) {
      position = position.round();
      if (startPosition != null) startPosition = startPosition.round();
    }

    if (startPosition != null && isShiftPressed) {
      var delta = position - startPosition;
      delta = delta.snappedToAngle(math.pi / 4);
      position = startPosition + delta;
    }

    return position;
  }

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    final hitTest = editor.hitTest(details.globalPosition);
    final position = computePosition(
      editor,
      details.globalPosition,
      startPosition: existingTransientEdge?.start,
      isShiftPressed: isShiftPressed,
      topological: topological,
      snapToPixel: snapToPixel,
    );

    final mergeKey = existingTransientEdge?.mergeKey ?? Object();

    final vertex = editor.edit(
      (txn) => txn.embedVertex(
        hitTest,
        topological: topological,
        destructive: destructive,
        position: position,
      ),
      mergeKey: mergeKey,
    );

    if (existingTransientEdge != null) {
      transientEdge = existingTransientEdge!;
      transientEdge.end = editor.bundle.vertexPosition(editor.handleOf(vertex)!, space: .root);
    } else {
      transientEdge = editor.transientEdges.create(vertex, mergeKey: mergeKey);
      onTransientEdgeCreated(transientEdge);
    }
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final position = computePosition(
      editor,
      details.globalPosition,
      startPosition: !isNewEdge ? transientEdge.end : transientEdge.start,
      isShiftPressed: isShiftPressed,
      snapToPixel: snapToPixel,
      topological: false,
    );

    if (!didPassThreshold) {
      final delta = (details.globalPosition - startDetails.globalPosition).distance;
      if (delta >= kTouchSlop) didPassThreshold = true;
    }

    if (!isNewEdge) {
      if (isAltPressed) {
        transientEdge.nextCStart = position;
      } else {
        final end = transientEdge.end!;
        transientEdge.cEnd = position.pointReflect(end);
      }
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
