import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';
import 'package:ink_stroke_modeler/ink_stroke_modeler.dart' as modeler;

modeler.StrokeModelParams get _modelerParams => .new(
  wobbleSmootherParams: .new(
    timeout: .new(0.08),
    speedRange: .new(0.5, 5.0),
  ),
  positionModelerParams: .new(
    springMassConstant: 11.0 / 32400.0,
    dragConstant: 72.0,
    loopContractionMitigationParams: .new(
      speedBound: .new(0.35, 0.7),
      interpolationStrengthAtSpeedLowerBound: 0.7,
      interpolationStrengthAtSpeedUpperBound: 0.2,
      minSpeedSamplingWindow: .new(0.05),
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
  predictionParams: modeler.KalmanPredictorParams(
    processNoise: 0.01,
    measurementNoise: 0.1,
    minStableIteration: 4,
    maxTimeSamples: 10,
    minCatchupVelocity: 0.1,
    accelerationWeight: 1.2,
    jerkWeight: 0.5,
    predictionInterval: .new(0.032),
    confidenceParams: .new(
      desiredNumberOfSamples: 10,
      maxEstimationDistance: 0.5,
      travelSpeedRange: .new(1, 100),
      maxLinearDeviation: 3,
      baselineLinearityConfidence: 0.4,
    ),
  ),
);

final class PencilFreehandStrokeActivity extends DragActivity {
  new(
    this.editor, {
    super.onStart,
    super.onUpdate,
    super.onEnd,
  });

  final Editor editor;
  late final bundle = editor.bundle;

  TransientStroke? stroke;
  late final VertexRef startVertex;

  final _modeler = modeler.StrokeModeler();

  Duration? _baseTimestamp;
  DateTime? _baseDateTime;
  DateTime? _lastEventTime;
  double _getEventTime(Duration? sourceTimestamp) {
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
    return calculatedTime.microsecondsSinceEpoch / Duration.microsecondsPerSecond;
  }

  double? _pressure() {
    if (pointerEvent!.kind == .stylus) return pointerEvent!.pressure;
    return null;
  }

  double? orientation() {
    if (pointerEvent!.kind == .stylus) return pointerEvent!.orientation;
    return null;
  }

  double? tilt() {
    if (pointerEvent!.kind == .stylus) return pointerEvent!.tilt;
    return null;
  }

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    final hitTest = editor.hitTest(details.globalPosition);
    startVertex = editor.edit((txn) => txn.embedVertex(hitTest));
    final vertexPosition = bundle.vertexPosition(bundle.vertex(startVertex)!, space: .root);

    stroke = editor.transientStrokes.create();
    _modeler.reset(_modelerParams);
    _updateModeler(
      .down,
      details,
      position: vertexPosition,
      sourceTimestamp: (details is DragStartDetails) ? details.sourceTimeStamp : null,
    );
  }

  void _addModelerResults(StrokeData data, Iterable<modeler.Result> results) {
    for (final result in results) {
      data.add(
        point: result.position,
        timestamp: result.time,
        pressure: result.pressure,
        orientation: result.orientation,
        tilt: result.tilt,
      );
    }
  }

  void _updateModeler(
    modeler.EventType type,
    PositionedGestureDetails details, {
    Vec2? position,
    Duration? sourceTimestamp,
  }) {
    final scenePosition = editor.globalToScene(details.globalPosition);

    final results = _modeler.update(
      .new(
        eventType: type,
        position: position ?? scenePosition,
        time: .new(_getEventTime(sourceTimestamp)),
        pressure: _pressure(),
        orientation: orientation(),
        tilt: tilt(),
      ),
    );

    _addModelerResults(stroke!.data, results);

    if (type == .move) {
      final predictions = _modeler.predict();
      stroke!.predictions.clear();
      _addModelerResults(stroke!.predictions, predictions);
    }

    stroke!.onChanged();
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);
    _updateModeler(.move, details, sourceTimestamp: details.sourceTimeStamp);
  }

  @override
  void onEnd(DragEndDetails? details) {
    super.onEnd(details);

    if (details != null) _updateModeler(.up, details);
    editor.transientStrokes.remove(stroke!);

    // TODO: Commit stroke properly

    var prevVertex = startVertex;
    editor.edit((txn) {
      final data = stroke!.data;
      for (var i = 0; i < data.length - 1; i++) {
        final p1 = data.point(i + 1);

        final nextVertex = txn.insert(VertexStatement(p1)).ref;
        txn.insert(EdgeStatement(prevVertex.selector(), nextVertex.selector()));
        prevVertex = nextVertex;
      }
    });
  }

  @override
  void onCancel() {
    if (stroke != null) editor.transientStrokes.remove(stroke!);
    super.onCancel();
  }
}
