import 'dart:collection';
import 'dart:math';

import 'package:geometry/geometry.dart';
import 'package:ink_stroke_modeler/src/params.dart';
import 'package:ink_stroke_modeler/src/prediction/input_predictor.dart';
import 'package:ink_stroke_modeler/src/prediction/kalman_filter/kalman_filter.dart';
import 'package:ink_stroke_modeler/src/types.dart';
import 'package:ink_stroke_modeler/src/utils.dart';

final class KalmanState({
  required final Vec2 position,
  required final Vec2 velocity,
  required final Vec2 acceleration,
  required final Vec2 jerk,
}) {
  KalmanState evaluateCubic(double dt) {
    final dt2 = dt * dt, dt3 = dt2 * dt;
    return .new(
      position: position + velocity * dt + acceleration * (dt2 / 2) + jerk * (dt3 / 6),
      velocity: velocity + acceleration * dt + jerk * (dt2 / 2),
      acceleration: acceleration + jerk * dt,
      jerk: jerk,
    );
  }
}

final class KalmanPredictor implements InputPredictor {
  KalmanPredictor(this._params, this._samplingParams)
    : _x = AxisPredictor(_params.processNoise, _params.measurementNoise, _params.minStableIteration),
      _y = AxisPredictor(_params.processNoise, _params.measurementNoise, _params.minStableIteration);
  KalmanPredictor._(this._params, this._samplingParams, this._x, this._y);

  final KalmanPredictorParams _params;
  final SamplingParams _samplingParams;
  final AxisPredictor _x, _y;
  Vec2? _lastPositionReceived;
  ListQueue<Time> _sampleTimes = .new();

  @override
  void reset() {
    _x.reset();
    _y.reset();
    _sampleTimes.clear();
    _lastPositionReceived = null;
  }

  @override
  void update(Vec2 position, Time time) {
    _lastPositionReceived = position;
    _sampleTimes.add(time);
    if (_sampleTimes.length > _params.maxTimeSamples) _sampleTimes.removeFirst();
    _x.update(position.x);
    _y.update(position.y);
  }

  KalmanState? get estimatedState {
    if (!_x.isStable || !_y.isStable || _sampleTimes.isEmpty) return null;

    final dt = (_sampleTimes.last - _sampleTimes.first).seconds / _sampleTimes.length;
    final dt2 = dt * dt, dt3 = dt2 * dt;
    return .new(
      position: Vec2(_x.position, _y.position),
      velocity: Vec2(_x.velocity, _y.velocity) / dt,
      acceleration: Vec2(_x.acceleration, _y.acceleration) / dt2 * _params.accelerationWeight,
      jerk: Vec2(_x.jerk, _y.jerk) / dt3 * _params.jerkWeight,
    );
  }

  @override
  void constructPrediction(TipState lastState, List<TipState> prediction) {
    prediction.clear();
    final estimated = estimatedState;
    if (estimated == null || _lastPositionReceived == null) return;

    final sampleDt = 1.0 / _samplingParams.minOutputRate;
    _cubicConnector(lastState, estimated, sampleDt, prediction);
    final startTime = prediction.isEmpty ? lastState.time : prediction.last.time;
    _cubicPrediction(estimated, startTime, sampleDt, _numberOfPointsToPredict(estimated), prediction);
  }

  void _cubicConnector(TipState last, KalmanState estimated, double sampleDt, List<TipState> out) {
    final distance = last.position.distanceTo(estimated.position);
    final maxVelocityAtEnds = max(last.velocity.length, estimated.velocity.length);
    final targetDuration = distance / max(maxVelocityAtEnds, _params.minCatchupVelocity);
    final nPoints = max((targetDuration / sampleDt).ceil(), 1);
    final duration = nPoints * sampleDt;

    final a = last.position * 2 - estimated.position * 2 + (last.velocity + estimated.velocity) * duration;
    final b = last.position * -3 + estimated.position * 3 - (last.velocity * 2 + estimated.velocity) * duration;
    final c = last.velocity * duration;
    final d = last.position;

    for (var i = 1; i <= nPoints; i++) {
      final t = i / nPoints, t2 = t * t, t3 = t2 * t;
      out.add(
        TipState(
          position: a * t3 + b * t2 + c * t + d,
          velocity: (a * (3 * t2) + b * (2 * t) + c) / duration,
          acceleration: (a * (6 * t) + b * 2) / (duration * duration),
          time: last.time.add(TimeSpan(duration * t)),
        ),
      );
    }
  }

  void _cubicPrediction(KalmanState estimated, Time startTime, double sampleDt, int nSamples, List<TipState> out) {
    var state = estimated;
    var time = startTime;
    for (var i = 0; i < nSamples; i++) {
      state = state.evaluateCubic(sampleDt);
      time = time.add(TimeSpan(sampleDt));
      out.add(
        TipState(position: state.position, velocity: state.velocity, acceleration: state.acceleration, time: time),
      );
    }
  }

  int _numberOfPointsToPredict(KalmanState estimated) {
    final c = _params.confidenceParams;
    final interval = _params.predictionInterval.seconds;
    final targetNumber = interval * _samplingParams.minOutputRate;

    final sampleRatio = min(1.0, _x.iterations / c.desiredNumberOfSamples);

    final estimatedError = _lastPositionReceived!.distanceTo(estimated.position);
    final normalizedError = 1 - normalize01(0, c.maxEstimationDistance, estimatedError);

    final end = estimated.evaluateCubic(interval);
    final travelSpeed = estimated.position.distanceTo(end.position) / interval;
    final normalizedDistance = normalize01(c.travelSpeedRange.min, c.travelSpeedRange.max, travelSpeed);

    final deviationFromLinear = end.position.distanceTo(estimated.position + estimated.velocity * interval);
    final linearity = interp(
      c.baselineLinearityConfidence,
      1,
      1 - normalize01(0, c.maxLinearDeviation, deviationFromLinear),
    );

    final confidence = sampleRatio * normalizedError * normalizedDistance * linearity;
    return max(0, (targetNumber * confidence).ceil());
  }

  @override
  InputPredictor clone() => KalmanPredictor._(_params, _samplingParams, _x.clone(), _y.clone())
    .._lastPositionReceived = _lastPositionReceived
    .._sampleTimes = ListQueue.of(_sampleTimes);
}
