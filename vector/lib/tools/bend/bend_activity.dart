import 'package:flutter/gestures.dart';
import 'package:geometry/geometry.dart';
import 'package:vector/imports.dart';
import 'package:vector_math/vector_math_64.dart';

abstract class BendDragActivity extends DragActivity {
  BendDragActivity._(this.controller, this.hitTest);

  factory BendDragActivity.create(VectorController controller, CellHitTestEntry hitTest) {
    if (hitTest is EdgeKnotHitTestEntry) {
      return EdgeKnotBendDragActivity(controller, hitTest);
    } else if (hitTest is EdgeHitTestEntry) {
      return EdgeCubicBendDragActivity(controller, hitTest);
    }

    throw UnimplementedError('Unsupported hit test type for bend tool: ${hitTest.runtimeType}');
  }

  final VectorController controller;
  final CellHitTestEntry hitTest;
}

class EdgeCubicBendDragActivity extends BendDragActivity {
  EdgeCubicBendDragActivity(super.controller, EdgeHitTestEntry super.hitTest) : super._();

  @override
  EdgeHitTestEntry get hitTest => super.hitTest as EdgeHitTestEntry;

  Edge get edge => hitTest.edge;
  CubicSpline2 get spline => edge.spline;
  double get t => hitTest.t;

  late double localT;
  late CubicKnot2 k1;
  late CubicKnot2 k2;

  late Vector2 initialC1;
  late Vector2 initialC2;
  late Vector2 initialPosition;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    final knots = spline.knotsAt(t);
    k1 = knots.$1;
    k2 = knots.$2;

    initialC1 = (k1.cOut ?? k1.p).clone();
    initialC2 = (k2.cIn ?? k2.p).clone();

    final segment = spline.segmentAt(t);
    localT = segment.$2;
    initialPosition = segment.$1.point(localT);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);

    final targetPosition = controller.globalToArtworkLocal(details.globalPosition).asVector2();
    final delta = targetPosition - initialPosition;

    final u = 1.0 - localT;
    final w1 = 3.0 * u * u * localT;
    final w2 = 3.0 * u * localT * localT;

    final denominator = w1 * w1 + w2 * w2;
    if (denominator > 1e-6) {
      final deltaC1 = delta * (w1 / denominator);
      final deltaC2 = delta * (w2 / denominator);

      k1.cOut = initialC1 + deltaC1;
      k2.cIn = initialC2 + deltaC2;

      controller.complex.notifyFor(edge);
    }
  }
}

class EdgeKnotBendDragActivity extends BendDragActivity {
  EdgeKnotBendDragActivity(super.controller, EdgeKnotHitTestEntry super.hitTest) : super._();

  @override
  EdgeKnotHitTestEntry get hitTest => super.hitTest as EdgeKnotHitTestEntry;

  Edge get edge => hitTest.edge;
  CubicSpline2 get spline => edge.spline;
  int get knotIndex => hitTest.knotIndex;

  late CubicKnot2 knot;
  late final Vector2 startPosition;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    knot = hitTest.knot;
    startPosition = knot.p;
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);

    final localPosition = controller.globalToArtworkLocal(details.globalPosition);
    final delta = localPosition.asVector2() - startPosition;

    knot.p = startPosition + delta;
    controller.complex.notifyFor(edge);
  }
}
