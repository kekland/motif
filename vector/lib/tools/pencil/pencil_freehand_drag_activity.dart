import 'package:flutter/gestures.dart';
import 'package:geometry/geometry.dart';
import 'package:vector/imports.dart';

class PencilFreehandDrawActivity extends DragActivity {
  PencilFreehandDrawActivity({required this.controller});

  static const double _kMinAcceptDistance = 0.5;
  static const int _kSmoothingWindowSize = 5;
  static const double _kSmoothingSpeedThreshold = 10.0;

  static const double _vwEpsilon = 2.0;
  static const double _schneiderErrorThreshold = 1.0;
  static const double _cornerWindowArcLength = 10.0;
  static const double _cornerStrictAngle = 1.0;
  static const double _cornerRelaxedAngle = 0.5;
  static const double _cornerSpeedRadius = 15.0;
  static const double _cornerSuppressionRadius = 12.0;

  final VectorController controller;
  late TransientStroke stroke;
  late Offset _lastAcceptedPosition;

  Offset _toLocal(Offset position) => controller.globalToArtworkLocal(position);

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    stroke = controller.transientStrokes.create(
      point: _toLocal(details.globalPosition),
      rawGlobalPoint: details.globalPosition,
      timestamp: details is DragStartDetails ? details.sourceTimeStamp : null,
    );

    _lastAcceptedPosition = details.globalPosition;
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);

    final position = details.globalPosition;
    if ((position - _lastAcceptedPosition).distance < _kMinAcceptDistance) {
      return;
    }

    _lastAcceptedPosition = position;
    _appendToStroke(details, _toLocal(position));
  }

  void _appendToStroke(DragUpdateDetails details, Offset position) {
    final length = stroke.length;
    const w = _kSmoothingWindowSize;
    const half = w ~/ 2;

    stroke.addPoint(
      position,
      rawGlobalPoint: details.globalPosition,
      timestamp: details.sourceTimeStamp,
    );

    if (length <= w) return;

    // Smooth out the point with a speed factor. Fast movements will be less smoothed to maintain accuracy.
    final targetIndex = length - half - 1;
    var sumX = 0.0, sumY = 0.0;

    for (var i = targetIndex - half; i <= targetIndex + half; i++) {
      final point = stroke.getPoint(i);
      sumX += point.dx;
      sumY += point.dy;
    }

    final rawPoint = stroke.getPoint(targetIndex);
    final smoothedPoint = Offset(sumX / w, sumY / w);
    final speedFactor = (details.delta.distance / _kSmoothingSpeedThreshold).clamp(0.0, 1.0);
    final outputPoint = Offset.lerp(smoothedPoint, rawPoint, speedFactor)!;

    stroke.setPoint(targetIndex, outputPoint);
  }

  @override
  void onEnd(DragEndDetails? details) {
    super.onEnd(details);
    controller.transientStrokes.remove(stroke);

    // Convert the stroke into a spline and commit the results into the complex
    final points = List.generate(stroke.length, (i) => stroke.getPoint(i).asVector2(), growable: false);
    final rawPoints = List.generate(stroke.length, (i) => stroke.getRawPoint(i).asVector2(), growable: false);
    final timestamps = List.generate(stroke.length, (i) => stroke.getTimestamp(i), growable: false);

    final spline = pointsToSpline(
      points,
      rawPoints: rawPoints,
      timestamps: timestamps,
      vwEpsilon: _vwEpsilon,
      schneiderErrorThreshold: _schneiderErrorThreshold,
      cornerWindowArcLength: _cornerWindowArcLength,
      cornerStrictAngle: _cornerStrictAngle,
      cornerRelaxedAngle: _cornerRelaxedAngle,
      cornerSpeedRadius: _cornerSpeedRadius,
      cornerSuppressionRadius: _cornerSuppressionRadius,
    );

    if (spline.isEmpty) return;
    if (spline.length == 1) {
      controller.complex.createVertex(spline.knots.first.p);
    } else {
      final v1 = controller.complex.createVertex(spline.knots.first.p);
      final v2 = controller.complex.createVertex(spline.knots.last.p);

      final c1 = spline.knots.first.c2;
      final c2 = spline.knots.last.c1;
      final interior = spline.knots.sublist(1, spline.knots.length - 1);

      controller.complex.createOpenEdge(v1, v2, interior: interior, c1: c1, c2: c2);
    }
  }
}
