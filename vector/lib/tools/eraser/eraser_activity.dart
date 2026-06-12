import 'package:flutter/gestures.dart';
import 'package:geometry/geometry.dart';
import 'package:vector/imports.dart';

typedef EraserCallback = void Function(Offset position, double radius);

class EraserActivity extends DragActivity {
  EraserActivity({
    required this.controller,
    this.onPositionUpdate,
  });

  final VectorController controller;
  final EraserCallback? onPositionUpdate;

  late final VectorComplex complex;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    complex = controller.complex;

    final localPosition = controller.globalToArtworkLocal(details.globalPosition);
    const baseRadius = 16.0;
    final scale = 1 / controller.computeScale();
    onPositionUpdate?.call(localPosition, baseRadius * scale);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final localPosition = controller.globalToArtworkLocal(details.globalPosition);
    const baseRadius = 16.0;
    final scale = 1 / controller.computeScale();

    final pressure = (pointerEvent?.pressure ?? 1.0).clamp(1.0, double.infinity);
    final radius = baseRadius * pressure * scale;
    final radiusSq = radius * radius;

    onPositionUpdate?.call(localPosition, radius);

    final position = localPosition.asVector2();
    final circle = Circle2(position, radius);

    for (final edge in complex.edges) {
      final spline = edge.spline;

      // Check if edge is fully contained in the circle
      final bbox = spline.bboxTight;
      if (circle.containsAabb(bbox)) {
        complex.hardDelete(edge);
        continue;
      }

      final intersections = spline.intersectWithCircle(circle);
      if (intersections.isEmpty) continue;

      final ts = intersections.map((i) => i.tA).toList();
      ts.sort((a, b) => a.compareTo(b));
      ts.removeWhere((t) => (t <= 0.0) || (t >= 1.0));
      if (ts.isEmpty) continue;

      final result = complex.cutEdgeMultiple(edge, ts);

      for (final subEdge in result.edges) {
        final mid = subEdge.spline.point(0.5);
        final dx = mid.x - circle.center.x;
        final dy = mid.y - circle.center.y;
        final distanceSq = dx * dx + dy * dy;

        const eps = 1e-9;
        final isInside = distanceSq < (radiusSq + eps);
        if (isInside) {
          complex.hardDelete(subEdge);
        }
      }
    }

    for (final vertex in complex.vertices) {
      final vertexPosition = vertex.position;
      final distanceSqr = (vertexPosition - position).length2;
      if (vertex.degree == 0 && distanceSqr < radiusSq) {
        complex.hardDelete(vertex);
        print('delete');
      }
    }

    super.onUpdate(details);
  }
}
