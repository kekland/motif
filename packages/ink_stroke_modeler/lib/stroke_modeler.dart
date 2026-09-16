// stroke_modeler.dart
import 'package:geometry/geometry.dart';
import 'package:ink_stroke_modeler/src/loop_contraction_mitigation_modeler.dart';
import 'package:ink_stroke_modeler/src/params.dart';
import 'package:ink_stroke_modeler/src/position_modeler.dart';
import 'package:ink_stroke_modeler/src/prediction/input_predictor.dart';
import 'package:ink_stroke_modeler/src/prediction/kalman_predictor.dart';
import 'package:ink_stroke_modeler/src/prediction/stroke_end_predictor.dart';
import 'package:ink_stroke_modeler/src/stylus_state_modeler.dart';
import 'package:ink_stroke_modeler/src/types.dart';
import 'package:ink_stroke_modeler/src/utils.dart';
import 'package:ink_stroke_modeler/src/wobble_smoother.dart';

final class _LastInput({required final Input input, required final Vec2 correctedPosition});

final class StrokeModeler {
  StrokeModelParams? _params;
  InputPredictor? _predictor;

  final _wobbleSmoother = WobbleSmoother();
  final _positionModeler = PositionModeler();
  final _stylusStateModeler = StylusStateModeler();
  final _loopContractionMitigationModeler = LoopContractionMitigationModeler();
  final _tipStateBuffer = <TipState>[];
  _LastInput? _lastInput;

  InputPredictor? _savedPredictor;
  _LastInput? _savedLastInput;
  var _saveActive = false;

  void reset([StrokeModelParams? params]) {
    if (params != null) {
      params.validate();
      _params = params;
    }
    final p = _params;
    if (p == null) throw StateError('Initial call to reset must pass StrokeModelParams.');

    _lastInput = null;
    _saveActive = false;
    _predictor = switch (p.predictionParams) {
      final KalmanPredictorParams k => KalmanPredictor(k, p.samplingParams),
      StrokeEndPredictorParams() => StrokeEndPredictor(p.positionModelerParams, p.samplingParams),
      DisabledPredictorParams() => null,
    };
    _loopContractionMitigationModeler.reset(p.positionModelerParams.loopContractionMitigationParams);
  }

  List<Result> update(Input input) {
    if (_params == null) throw StateError('Stroke model has not yet been initialized');
    _validateInput(input);

    if (_lastInput case final last?) {
      if (last.input == input) throw ArgumentError('Received duplicate input');
      if (input.time < last.input.time) throw ArgumentError('Inputs travel backwards in time');
    }

    final results = <Result>[];
    switch (input.eventType) {
      case .down:
        _processDown(input, results);
      case .move:
        _processMove(input, results);
      case .up:
        _processUp(input, results);
    }
    return results;
  }

  List<Result> predict() {
    if (_params == null) throw StateError('Stroke model has not yet been initialized');
    final predictor = _predictor;
    if (predictor == null) throw StateError('Prediction has been disabled by StrokeModelParams.');
    final last = _lastInput;
    if (last == null) throw StateError('Cannot construct prediction when no stroke is in-progress');

    predictor.constructPrediction(_positionModeler.state, _tipStateBuffer);
    final results = <Result>[];
    _modelStylus(
      _tipStateBuffer,
      _stylusStateModeler.clone(),
      _loopContractionMitigationModeler.clone(),
      results,
      last.input.time,
    );
    return results;
  }

  void save() {
    _wobbleSmoother.save();
    _positionModeler.save();
    _stylusStateModeler.save();
    _loopContractionMitigationModeler.save();
    _savedLastInput = _lastInput;
    _savedPredictor = _predictor?.clone();
    _saveActive = true;
  }

  void restore() {
    if (!_saveActive) return;
    _wobbleSmoother.restore();
    _positionModeler.restore();
    _stylusStateModeler.restore();
    _loopContractionMitigationModeler.restore();
    _lastInput = _savedLastInput;
    if (_savedPredictor case final saved?) _predictor = saved.clone();
  }

  void _validateInput(Input input) {
    if (!input.position.isFinite) throw ArgumentError.value(input.position, 'Input.position', 'must be finite');
    if (!input.time.isFinite) throw ArgumentError.value(input.time, 'Input.time', 'must be finite');
    // Pressure, tilt and orientation are deliberately unchecked: some producers send NaN for unknown.
  }

  void _processDown(Input input, List<Result> results) {
    if (_lastInput != null) throw StateError('Received down event while stroke is in-progress');
    final p = _params!;

    _wobbleSmoother.reset(p.wobbleSmootherParams, input.position, input.time);
    _positionModeler.reset(
      TipState(position: input.position, velocity: .zero(), acceleration: .zero(), time: input.time),
      p.positionModelerParams,
    );
    _stylusStateModeler.reset(p.stylusStateModelerParams);
    _loopContractionMitigationModeler.reset(p.positionModelerParams.loopContractionMitigationParams);
    _stylusStateModeler.update(input.position, input.time, _stylusOf(input));

    _predictor
      ?..reset()
      ..update(input.position, input.time);
    _lastInput = .new(input: input, correctedPosition: input.position);

    final tip = _positionModeler.state;
    results.add(
      Result(
        position: tip.position,
        velocity: tip.velocity,
        acceleration: tip.acceleration,
        time: tip.time,
        pressure: input.pressure,
        tilt: input.tilt,
        orientation: input.orientation,
      ),
    );
  }

  void _processMove(Input input, List<Result> results) {
    final last = _lastInput;
    if (last == null) throw StateError('Received move event while no stroke is in-progress');
    final p = _params!;

    final correctedPosition = _wobbleSmoother.update(input.position, input.time);
    _stylusStateModeler.update(correctedPosition, input.time, _stylusOf(input));

    final nSteps = numberOfStepsBetweenInputs(
      _positionModeler.state,
      last.input,
      input,
      p.samplingParams,
      p.positionModelerParams,
    );
    _tipStateBuffer.clear();
    _positionModeler.updateAlongLinearPath(
      last.correctedPosition,
      last.input.time,
      correctedPosition,
      input.time,
      nSteps,
      _tipStateBuffer,
    );

    _predictor?.update(correctedPosition, input.time);
    _lastInput = .new(input: input, correctedPosition: correctedPosition);
    _modelStylus(_tipStateBuffer, _stylusStateModeler, _loopContractionMitigationModeler, results, input.time);
  }

  void _processUp(Input input, List<Result> results) {
    final last = _lastInput;
    if (last == null) throw StateError('Received up event while no stroke is in-progress');
    final p = _params!;

    final nSteps = numberOfStepsBetweenInputs(
      _positionModeler.state,
      last.input,
      input,
      p.samplingParams,
      p.positionModelerParams,
    );
    _tipStateBuffer.clear();
    _positionModeler.updateAlongLinearPath(
      last.correctedPosition,
      last.input.time,
      input.position,
      input.time,
      nSteps,
      _tipStateBuffer,
    );
    _positionModeler.modelEndOfStroke(
      input.position,
      TimeSpan(1.0 / p.samplingParams.minOutputRate),
      p.samplingParams.endOfStrokeMaxIterations,
      p.samplingParams.endOfStrokeStoppingDistance,
      _tipStateBuffer,
    );
    if (_tipStateBuffer.isEmpty) _tipStateBuffer.add(_positionModeler.state);

    _stylusStateModeler.update(input.position, input.time, _stylusOf(input));
    _modelStylus(_tipStateBuffer, _stylusStateModeler, _loopContractionMitigationModeler, results, last.input.time);
    _lastInput = null;
  }

  static StylusState _stylusOf(Input i) => .new(pressure: i.pressure, tilt: i.tilt, orientation: i.orientation);

  static void _modelStylus(
    List<TipState> tipStates,
    StylusStateModeler stylus,
    LoopContractionMitigationModeler loop,
    List<Result> out,
    Time prevTime,
  ) {
    var interpValue = loop.interpolationValue;
    for (final tip in tipStates) {
      final projected = stylus.project(tip, getStrokeNormal(tip, prevTime));
      final modeled = Result(
        position: tip.position,
        velocity: tip.velocity,
        acceleration: tip.acceleration,
        time: tip.time,
        pressure: projected?.pressure,
        tilt: projected?.tilt,
        orientation: projected?.orientation,
      );
      out.add(projected == null ? modeled : interpResult(projected, modeled, interpValue));
      interpValue = loop.update(out.last.velocity, tip.time);
      prevTime = tip.time;
    }
  }
}
