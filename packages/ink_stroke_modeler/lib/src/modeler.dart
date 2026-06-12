import 'dart:ffi';

import 'package:ffi/ffi.dart' as ffi;
import 'package:vector_math/vector_math_64.dart';

import 'bindings.g.dart' as bindings;
import 'params.dart';

enum InkEventType { down, move, up }

typedef Input = ({
  InkEventType eventType,
  Vector2 position,
  DateTime time,
  double pressure,
  double tilt,
  double orientation,
});

typedef Result = ({
  Vector2 position,
  Vector2 velocity,
  DateTime time,
  double pressure,
  double tilt,
  double orientation,
});

double _secondsFromDuration(Duration duration) => duration.inMilliseconds / 1000.0;

void _inputToCInput(Input input, Pointer<bindings.InkInput> cInput) {
  cInput.ref.event_typeAsInt = input.eventType.index;
  cInput.ref.x = input.position.x;
  cInput.ref.y = input.position.y;
  cInput.ref.time_seconds = input.time.millisecondsSinceEpoch / 1000.0;
  cInput.ref.pressure = input.pressure;
  cInput.ref.tilt = input.tilt;
  cInput.ref.orientation = input.orientation;
}

Result _resultFromCResult(bindings.InkResult cResult) {
  return (
    position: .new(cResult.x, cResult.y),
    velocity: .new(cResult.velocity_x, cResult.velocity_y),
    time: .fromMillisecondsSinceEpoch((cResult.time_seconds * 1000).round()),
    pressure: cResult.pressure,
    tilt: cResult.tilt,
    orientation: cResult.orientation,
  );
}

void _paramsToCParams(StrokeModelerParams params, Pointer<bindings.StrokeModelerParams> cParams) {
  final wobble = params.wobbleSmootherParams;
  final cWobble = cParams.ref.wobble_smoother_params;
  cWobble.is_enabled = wobble.isEnabled;
  cWobble.speed_floor = wobble.speedRange.$1;
  cWobble.timeout_seconds = _secondsFromDuration(wobble.timeout);
  cWobble.speed_ceiling = wobble.speedRange.$2;

  final positionModeler = params.positionModelerParams;
  final cPositionModeler = cParams.ref.position_modeler_params;

  cPositionModeler.spring_mass_constant = positionModeler.springMassConstant;
  cPositionModeler.drag_constant = positionModeler.dragConstant;

  final loopContraction = positionModeler.loopContractionMitigation;
  final cLoopContraction = cPositionModeler.loop_contraction_mitigation_params;

  cLoopContraction.is_enabled = loopContraction.isEnabled;
  cLoopContraction.speed_lower_bound = loopContraction.speedRange.$1;
  cLoopContraction.speed_upper_bound = loopContraction.speedRange.$2;
  cLoopContraction.interpolation_strength_at_speed_lower_bound = loopContraction.interpolationStrengthAtSpeedRange.$1;
  cLoopContraction.interpolation_strength_at_speed_upper_bound = loopContraction.interpolationStrengthAtSpeedRange.$2;
  cLoopContraction.min_speed_sampling_window_seconds = _secondsFromDuration(loopContraction.minSpeedSamplingWindow);

  final sampling = params.samplingParams;
  final cSampling = cParams.ref.sampling_params;

  cSampling.min_output_rate = sampling.minOutputRate;
  cSampling.end_of_stroke_stopping_distance = sampling.endOfStrokeStoppingDistance;
  cSampling.end_of_stroke_max_iterations = sampling.endOfStrokeMaxIterations;
  cSampling.max_outputs_per_call = sampling.maxOutputsPerCall;
  cSampling.max_estimated_angle_to_traverse_per_input = sampling.maxEstimatedAngleToTraversePerInput;

  final stylusState = params.stylusStateModelerParams;
  final cStylusState = cParams.ref.stylus_state_modeler_params;

  cStylusState.use_stroke_normal_projection = stylusState.useStrokeNormalProjection;

  final cPredictor = cParams.ref.prediction_params;
  if (params.predictionParams is DisabledPredictorParams) {
    cPredictor.typeAsInt = bindings.PredictorType.PREDICTOR_TYPE_DISABLED.value;
  } else if (params.predictionParams is StrokeEndPredictorParams) {
    cPredictor.typeAsInt = bindings.PredictorType.PREDICTOR_TYPE_STROKE_END.value;
  } else if (params.predictionParams is KalmanPredictorParams) {
    cPredictor.typeAsInt = bindings.PredictorType.PREDICTOR_TYPE_KALMAN.value;

    final kalman = params.predictionParams as KalmanPredictorParams;
    final cKalman = cPredictor.unnamed.kalman;

    cKalman.process_noise = kalman.processNoise;
    cKalman.measurement_noise = kalman.measurementNoise;
    cKalman.min_stable_iteration = kalman.minStableIteration;
    cKalman.max_time_samples = kalman.maxTimeSamples;
    cKalman.min_catchup_velocity = kalman.minCatchupVelocity;
    cKalman.acceleration_weight = kalman.accelerationWeight;
    cKalman.jerk_weight = kalman.jerkWeight;
    cKalman.prediction_interval_seconds = _secondsFromDuration(kalman.predictionInterval);

    final confidence = kalman.confidenceParams;
    final cConfidence = cKalman.confidence_params;

    cConfidence.desired_number_of_samples = confidence.desiredNumberOfSamples;
    cConfidence.max_estimation_distance = confidence.maxEstimationDistance;
    cConfidence.min_travel_speed = confidence.travelSpeedRange.$1;
    cConfidence.max_travel_speed = confidence.travelSpeedRange.$2;
    cConfidence.max_linear_deviation = confidence.maxLinearDeviation;
    cConfidence.baseline_linearity_confidence = confidence.baselineLinearityConfidence;
  }
}

final _inputScratch = ffi.malloc<bindings.InkInput>();
final _resultScratch = ffi.malloc<Pointer<bindings.InkResult>>();
final _paramsScratch = ffi.malloc<bindings.StrokeModelerParams>();

abstract class _InkStrokeModelerBase implements Finalizable {
  _InkStrokeModelerBase(this._ptr, this.params) {
    _finalizer.attach(this, _ptr.cast(), detach: this);
    reset(params: params);
  }

  final Pointer<bindings.InkStrokeModeler> _ptr;
  static final _finalizer = NativeFinalizer(bindings.addresses.ink_stroke_modeler_destroy.cast());

  late StrokeModelerParams params;

  int get length;

  List<Result> predict() {
    final size = bindings.ink_stroke_modeler_predict(_ptr, _resultScratch);
    if (size == 0) return const [];
    if (_resultScratch.value == nullptr) throw StateError('InkStrokeModeler predict failed');

    return List.generate(
      size,
      (i) => _resultFromCResult(_resultScratch.value[i]),
      growable: false,
    );
  }

  void reset({StrokeModelerParams? params}) {
    if (params != null) this.params = params;
    _paramsToCParams(this.params, _paramsScratch);

    if (!bindings.ink_stroke_modeler_reset(_ptr, _paramsScratch.ref)) {
      throw StateError('InkStrokeModeler reset failed');
    }
  }
}

class InkStrokeModeler extends _InkStrokeModelerBase {
  InkStrokeModeler({required StrokeModelerParams params}) : super(bindings.ink_stroke_modeler_create(), params);

  final _results = <Result>[];
  Iterable<Result> get results => _results;

  @override
  int get length => _results.length;

  Iterable<Result> update(Input input) {
    _inputToCInput(input, _inputScratch);

    final size = bindings.ink_stroke_modeler_update(_ptr, _inputScratch.ref, _resultScratch);
    if (_resultScratch.value == nullptr) throw StateError('InkStrokeModeler update failed');
    if (size == 0) {
      _results.clear();
      return const [];
    }

    final currentSize = _results.length;
    for (var i = currentSize; i < size; i++) {
      final cResult = _resultScratch.value[i];
      _results.add(_resultFromCResult(cResult));
    }

    return _results;
  }

  @override
  void reset({StrokeModelerParams? params}) {
    _results.clear();
    super.reset(params: params);
  }
}

class StreamingInkStrokeModeler extends _InkStrokeModelerBase {
  StreamingInkStrokeModeler({required StrokeModelerParams params})
    : super(bindings.ink_stroke_modeler_create(), params);

  var _lastSize = 0;

  @override
  int get length => _lastSize;

  Iterable<Result> update(Input input) sync* {
    _inputToCInput(input, _inputScratch);

    final size = bindings.ink_stroke_modeler_update(_ptr, _inputScratch.ref, _resultScratch);
    if (_resultScratch.value == nullptr) throw StateError('InkStrokeModeler update failed');
    if (size == 0) return;

    for (var i = _lastSize; i < size; i++) {
      final cResult = _resultScratch.value[i];
      yield _resultFromCResult(cResult);
    }

    _lastSize = size;
  }

  @override
  void reset({StrokeModelerParams? params}) {
    _lastSize = 0;
    super.reset(params: params);
  }
}
