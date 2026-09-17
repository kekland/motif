import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';
import 'package:ink_stroke_modeler/ink_stroke_modeler.dart' as modeler;

modeler.StrokeModelParams get _modelerParams {
  final double pxPerCm = switch (defaultTargetPlatform) {
    .android => 160.0 / 2.54,
    .iOS => 163.0 / 2.54,
    _ => 96.0 / 2.54,
  };

  double cm(double v) => v * pxPerCm;

  return .new(
    wobbleSmootherParams: .new(
      timeout: .new(0.08),
      speedRange: .new(cm(0.5), cm(5.0)),
    ),
    positionModelerParams: .new(
      springMassConstant: 11.0 / 32400.0,
      dragConstant: 72.0,
      loopContractionMitigationParams: .new(
        speedBound: .new(cm(0.35), cm(0.7)),
        interpolationStrengthAtSpeedLowerBound: 0.7,
        interpolationStrengthAtSpeedUpperBound: 0.2,
        minSpeedSamplingWindow: .new(0.05),
      ),
    ),
    samplingParams: .new(
      minOutputRate: 120,
      endOfStrokeStoppingDistance: cm(0.001),
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
      minCatchupVelocity: cm(0.1),
      accelerationWeight: 1.2,
      jerkWeight: 0.5,
      predictionInterval: .new(0.032),
      confidenceParams: .new(
        desiredNumberOfSamples: 10,
        maxEstimationDistance: 0.5,
        travelSpeedRange: .new(cm(1), cm(100)),
        maxLinearDeviation: cm(3),
        baselineLinearityConfidence: 0.4,
      ),
    ),
  );
}

final class PencilFreehandStrokeActivity extends DragActivity {
  new(
    this.editor, {
    this.topological = true,
    this.destructive = true,
    this.edgeStyle = .default_,
    super.onStart,
    super.onUpdate,
    super.onEnd,
  });

  final Editor editor;
  final bool topological;
  final bool destructive;
  final EdgeStyle edgeStyle;

  late final bundle = editor.bundle;

  TransientStroke? stroke;
  late final VertexRef startVertex;
  late final mergeKey = Object();

  final _modeler = modeler.StrokeModeler();

  double _eventTime() {
    return pointerEvent!.timeStamp.inMicroseconds / Duration.microsecondsPerSecond;
  }

  double? _pressure() {
    if (pointerEvent!.kind == .stylus) return pointerEvent!.pressure;
    return null;
  }

  double? _orientation() {
    if (pointerEvent!.kind == .stylus) return pointerEvent!.orientation;
    return null;
  }

  double? _tilt() {
    if (pointerEvent!.kind == .stylus) return pointerEvent!.tilt;
    return null;
  }

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    final hitTest = editor.hitTest(details.globalPosition);
    startVertex = editor.edit(
      (txn) => txn.embedVertex(hitTest, topological: topological, destructive: destructive),
      mergeKey: mergeKey,
    );

    final vertexPosition = bundle.vertexPosition(bundle.vertex(startVertex)!, space: .root);
    stroke = editor.transientStrokes.create(style: edgeStyle);
    _modeler.reset(_modelerParams);
    _updateModeler(.down, details, position: editor.sceneToGlobal(vertexPosition));
  }

  void _addModelerResults(StrokeData data, Iterable<modeler.Result> results) {
    for (final result in results) {
      data.add(
        point: editor.globalToScene(result.position.offset),
        timestamp: result.time,
        pressure: result.pressure,
        orientation: result.orientation,
        tilt: result.tilt,
      );
    }
  }

  modeler.Input? _lastInput;

  void _updateModeler(
    modeler.EventType type,
    PositionedGestureDetails details, {
    Offset? position,
  }) {
    final input = modeler.Input(
      eventType: type,
      position: (position ?? details.globalPosition).vec2,
      time: .new(_eventTime()),
      pressure: _pressure(),
      orientation: _orientation(),
      tilt: _tilt(),
    );

    if (input == _lastInput) return;
    _lastInput = input;

    final results = _modeler.update(input);
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
    _updateModeler(.move, details);
  }

  @override
  void onEnd(DragEndDetails details) {
    super.onEnd(details);

    _updateModeler(.up, details);
    editor.transientStrokes.remove(stroke!);

    const spacingPx = 2.0;
    final spacing = (editor.globalToScene(.new(spacingPx, 0)) - editor.globalToScene(.zero)).length;

    final resampled = stroke!.data.resampled(spacing);
    final segments = StrokeFitter.fit(resampled, smoothness: 0.5);
    if (segments.isEmpty) return;

    editor.edit((txn) {
      var from = startVertex;
      for (var i = 0; i < segments.length; i++) {
        final s = segments[i];
        final endPoint = s.cubic.p3;
        final to = i == segments.length - 1
            ? txn.embedVertex(
                editor.hitTest(editor.sceneToGlobal(endPoint)),
                topological: topological,
                destructive: destructive,
              )
            : txn.insert(VertexStatement(endPoint)).ref;

        txn.flush();
        txn.embedEdge(
          from,
          to,
          s.cubic,
          topological: topological,
          destructive: destructive,
          style: edgeStyle,
        );
        from = to;
      }
    });
  }

  @override
  void onCancel() {
    if (stroke != null) editor.transientStrokes.remove(stroke!);
    super.onCancel();
  }
}
