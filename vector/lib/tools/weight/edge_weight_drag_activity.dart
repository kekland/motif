import 'package:flutter/gestures.dart';
import 'package:vector/imports.dart';
import 'package:vector_math/vector_math_64.dart';

class EdgeWeightDragActivity extends DragActivity {
  EdgeWeightDragActivity({
    required this.edge,
    required this.initialT,
    required this.controller,
    this.canMove = false,
  });

  final Edge edge;
  final double initialT;
  final bool canMove;
  final VectorController controller;

  late double t;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    t = initialT;

    if (!edge.strokeWeight.hasSampleAt(t)) {
      edge.strokeWeight.insert(t, 1.0);
    }
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);

    final globalPosition = details.globalPosition;
    final localPosition = controller.globalToArtworkLocal(globalPosition).asVector2();

    if (canMove) {
      final closestPoint = edge.spline.closestTo(localPosition);
      edge.strokeWeight.remove(t);
      t = closestPoint.t;
    }

    final edgePosition = edge.spline.point(t);
    final edgeTangent = edge.spline.tangent(t);
    final edgeNormal = Vector2(-edgeTangent.y, edgeTangent.x);

    final delta = localPosition - edgePosition;
    final projectedDelta = delta.dot(edgeNormal);

    final width = edge.strokeWidth;
    final weight = ((projectedDelta / width) * 2.0).abs();
    edge.strokeWeight.insert(t, weight);
    controller.complex.notifyFor(edge);
  }
}
