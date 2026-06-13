import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:geometry/geometry.dart';
import 'package:ink_stroke_modeler/ink_stroke_modeler.dart' as modeler;
import 'package:vector/imports.dart';
import 'package:vector_math/vector_math_64.dart';

modeler.StrokeModelerParams get _modelerParams => .new(
  wobbleSmootherParams: .new(
    isEnabled: true,
    timeout: const Duration(milliseconds: 80),
    speedRange: (0.5, 5.0),
  ),
  positionModelerParams: .new(
    springMassConstant: 11.0 / 32400.0,
    dragConstant: 72.0,
    loopContractionMitigation: .new(
      isEnabled: true,
      speedRange: (0.35, 0.7),
      interpolationStrengthAtSpeedRange: (0.7, 0.2),
      minSpeedSamplingWindow: const Duration(milliseconds: 50),
    ),
  ),
  samplingParams: .new(
    minOutputRate: 120,
    endOfStrokeStoppingDistance: 0.001,
    endOfStrokeMaxIterations: 20,
    maxOutputsPerCall: 100000,
    maxEstimatedAngleToTraversePerInput: 0.5,
  ),
  stylusStateModelerParams: .new(
    useStrokeNormalProjection: true,
  ),
  predictionParams: .kalman(
    processNoise: 0.01,
    measurementNoise: 0.1,
    minStableIteration: 4,
    maxTimeSamples: 10,
    minCatchupVelocity: 0.1,
    accelerationWeight: 1.2,
    jerkWeight: 0.5,
    predictionInterval: const Duration(milliseconds: 32),
    confidenceParams: .new(
      desiredNumberOfSamples: 10,
      maxEstimationDistance: 0.5,
      travelSpeedRange: (1, 100),
      maxLinearDeviation: 3,
      baselineLinearityConfidence: 0.4,
    ),
  ),
);

class PencilFreehandDrawActivity extends DragActivity {
  PencilFreehandDrawActivity({required this.controller});

  // static const double _kMinAcceptDistance = 1.0;
  // static const int _kSmoothingWindowSize = 3;
  // static const double _kSmoothingSpeedThreshold = 10.0;

  // static const double _vwEpsilon = 1.75;
  // static const double _schneiderErrorThreshold = 1.75;
  // static const double _cornerWindowArcLength = 10.0;
  // static const double _cornerStrictAngle = 1.2;
  // static const double _cornerRelaxedAngle = 0.7;
  // static const double _cornerSpeedRadius = 15.0;
  // static const double _cornerSuppressionRadius = 18.0;

  static const double _kLoopDistanceThreshold = 8.0;

  // static const double _weightAlpha = 0.3;
  // static const double _weightGamma = 2.0;

  final VectorController controller;
  late TransientStroke stroke;

  final _modeler = modeler.StreamingInkStrokeModeler(params: _modelerParams);

  Offset _toLocal(Offset position) => controller.globalToArtworkLocal(position);

  late final Vertex _startVertex;

  double _getPressure() {
    // return 1.0;
    if (pointerEvent == null) return 1.0;
    if (pointerEvent!.kind == .stylus) {
      return pointerEvent!.pressure.clamp(0.1, double.infinity);
    } else {
      return 1.0;
    }
  }

  double _getOrientation() {
    if (pointerEvent == null) return 0.0;
    if (pointerEvent!.kind == .stylus) {
      return pointerEvent!.orientation;
    } else {
      return 0.0;
    }
  }

  double _getTilt() {
    if (pointerEvent == null) return 0.0;
    if (pointerEvent!.kind == .stylus) {
      return pointerEvent!.tilt;
    } else {
      return 0.0;
    }
  }

  Duration? _baseTimestamp;
  DateTime? _baseDateTime;
  DateTime? _lastEventTime;
  DateTime _getEventTime(Duration? sourceTimestamp) {
    DateTime calculatedTime;

    if (sourceTimestamp == null) {
      calculatedTime = .now();
    } else {
      if (_baseTimestamp == null) {
        _baseTimestamp = sourceTimestamp;
        _baseDateTime = .now();
      }
      calculatedTime = _baseDateTime!.add(sourceTimestamp - _baseTimestamp!);
    }

    if (_lastEventTime != null && calculatedTime.isBefore(_lastEventTime!)) {
      calculatedTime = _lastEventTime!.add(const Duration(milliseconds: 1));
    }

    _lastEventTime = calculatedTime;
    return calculatedTime;
  }

  void _update(modeler.InkEventType eventType, PositionedGestureDetails details, {Duration? sourceTimestamp}) {
    final results = _modeler.update((
      eventType: eventType,
      position: details.globalPosition.asVector2(),
      time: _getEventTime(sourceTimestamp),
      pressure: _getPressure(),
      orientation: _getOrientation(),
      tilt: _getTilt(),
    ));

    for (final result in results) {
      _appendToStroke(result);
    }

    if (eventType == .move) {
      final predictions = _modeler.predict();
      final points = predictions.map((p) => _toLocal(p.position.asOffset())).toList();
      final weights = predictions.map((p) => p.pressure).toList();
      stroke.setPredictions(points, weights);
    }
  }

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    final topological = controller.strokeProperties.topological;

    if (topological) {
      final hitTest = controller.hitTestCell(details.globalPosition);
      _startVertex = hitTest != null
          ? controller.complex.createVertexAtHitTest(hitTest)
          : controller.complex.createVertex(_toLocal(details.globalPosition).asVector2());
    } else {
      _startVertex = controller.complex.createVertex(_toLocal(details.globalPosition).asVector2());
    }

    final vertexLocalPosition = _startVertex.position.asOffset();
    final vertexGlobalPosition = controller.artworkLocalToGlobal(vertexLocalPosition);

    stroke = controller.transientStrokes.create(
      point: vertexLocalPosition,
      rawGlobalPoint: vertexGlobalPosition,
      timestamp: details is DragStartDetails ? details.sourceTimeStamp : null,
      weight: _getPressure(),
    );

    _modeler.reset();
    if (details is DragStartDetails) {
      _update(.down, details, sourceTimestamp: details.sourceTimeStamp);
    } else {
      _update(.down, details);
    }
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);
    _update(.move, details, sourceTimestamp: details.sourceTimeStamp);
  }

  void _appendToStroke(modeler.Result result) {
    final globalPosition = result.position.asOffset();
    final localPosition = _toLocal(globalPosition);

    stroke.addPoint(
      localPosition,
      rawGlobalPoint: globalPosition,
      timestamp: Duration(milliseconds: result.time.millisecondsSinceEpoch),
      weight: result.pressure,
    );
  }

  // void _appendToStroke(DragUpdateDetails details, Offset position) {
  //   final length = stroke.length;
  //   const w = _kSmoothingWindowSize;
  //   const half = w ~/ 2;

  //   final rawPressure = _getPressure();

  //   if (length == 1) {
  //     _lastPressure = rawPressure;
  //     final initialWeight = math.pow(_lastPressure, _weightGamma).toDouble();
  //     stroke.setWeight(0, initialWeight);
  //   } else {
  //     _lastPressure = (_weightAlpha * rawPressure) + ((1 - _weightAlpha) * _lastPressure);
  //   }

  //   final weight = math.pow(_lastPressure, _weightGamma).toDouble();

  //   stroke.addPoint(
  //     position,
  //     rawGlobalPoint: details.globalPosition,
  //     timestamp: details.sourceTimeStamp,
  //     weight: weight,
  //   );

  //   if (length <= w) return;

  //   // Smooth out the point with a speed factor. Fast movements will be less smoothed to maintain accuracy.
  //   final targetIndex = length - half - 1;
  //   var sumX = 0.0, sumY = 0.0;

  //   for (var i = targetIndex - half; i <= targetIndex + half; i++) {
  //     final point = stroke.getPoint(i);
  //     sumX += point.dx;
  //     sumY += point.dy;
  //   }

  //   final rawPoint = stroke.getPoint(targetIndex);
  //   final smoothedPoint = Offset(sumX / w, sumY / w);
  //   final speedFactor = (details.delta.distance / _kSmoothingSpeedThreshold).clamp(0.0, 1.0);
  //   final outputPoint = Offset.lerp(smoothedPoint, rawPoint, speedFactor)!;

  //   stroke.setPoint(targetIndex, outputPoint);
  // }

  @override
  void onEnd(DragEndDetails? details) {
    super.onEnd(details);

    if (details != null) _update(.up, details);
    controller.transientStrokes.remove(stroke);

    final viewportScale = controller.computeScale();
    final invScale = 1.0 / viewportScale;

    // Convert the stroke into a spline and commit the results into the complex
    final points = List.generate(stroke.length, (i) => stroke.getPoint(i).asVector2(), growable: false);
    final timestamps = List.generate(stroke.length, (i) => stroke.timestamps[i], growable: false);
    final weights = List.generate(stroke.length, (i) => stroke.getWeight(i), growable: false);

    var min = points[0].clone(), max = points[0].clone();
    for (final p in points) {
      Vector2.min(min, p, min);
      Vector2.max(max, p, max);
    }

    final bbox = Aabb2.minMax(min, max);

    final spatialTolerance = math.max(
      1.5 * invScale,
      (bbox.max - bbox.min).length * 0.0025,
    );

    final strokePoints = List.generate(
      stroke.length,
      (i) => StrokePoint(
        position: points[i],
        pressure: weights[i],
        timestamp: Duration(microseconds: (timestamps[i] * 1000).round()),
      ),
      growable: false,
    );

    final spline = fitPointsToSplineFfi(
      strokePoints,
      spatialTolerance: spatialTolerance,
      velocityThreshold: 2.0 * invScale,
    );

    final width = controller.strokeProperties.width;
    final weightFidelity = 1.0;
    final weightPerceptualPx = 1.0;
    final weightPerceptual = weightPerceptualPx * invScale / width;
    final weightTolerance = math.min(math.max(weightFidelity, weightPerceptual), 0.3);

    final strokeWeights = StrokeWeightArcLengthProfile.fitFromFreehand(
      strokePoints,
      spatialTolerance: spatialTolerance,
      weightTolerance: weightTolerance,
    );

    final strokeWeightsParameterProfile = strokeWeights.toParameterProfile(spline.tAtDistance);

    if (spline.isEmpty) return;
    if (spline.length == 1) {
      return;
    } else {
      late final Vertex endVertex;
      final topological = controller.strokeProperties.topological;

      final startPosition = controller.artworkLocalToGlobal(_startVertex.position.asOffset());
      final finalPosition = controller.artworkLocalToGlobal(spline.knots.last.p.asOffset());
      final distance = (startPosition - finalPosition).distance;
      if (distance <= _kLoopDistanceThreshold * invScale) {
        endVertex = _startVertex;
      } else if (topological) {
        final hitTest = controller.hitTestCell(finalPosition);
        endVertex = hitTest != null
            ? controller.complex.createVertexAtHitTest(hitTest)
            : controller.complex.createVertex(_toLocal(finalPosition).asVector2());
      } else {
        endVertex = controller.complex.createVertex(_toLocal(finalPosition).asVector2());
      }

      spline.knots.first.p = _startVertex.position;
      spline.knots.last.p = endVertex.position;
      controller.complex.commitSpline(
        spline,
        startVertex: _startVertex,
        endVertex: endVertex,
        strokeWeight: strokeWeightsParameterProfile,
        strokeWidth: controller.strokeProperties.width,
        color: controller.strokeProperties.color,
        topological: controller.strokeProperties.topological,
      );
    }
  }
}
