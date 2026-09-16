// prediction/kalman_filter.dart
import 'dart:typed_data';

import 'package:geometry/geometry.dart';

typedef Vec4 = Float64List; // length 4

extension _Vec4Ops on Vec4 {
  double dot(Vec4 o) => this[0] * o[0] + this[1] * o[1] + this[2] * o[2] + this[3] * o[3];
  Vec4 plus(Vec4 o) => Float64List(4)
    ..[0] = this[0] + o[0]
    ..[1] = this[1] + o[1]
    ..[2] = this[2] + o[2]
    ..[3] = this[3] + o[3];
  Vec4 scaledBy(double k) => Float64List(4)
    ..[0] = this[0] * k
    ..[1] = this[1] * k
    ..[2] = this[2] * k
    ..[3] = this[3] * k;

  Vec4 timesMatrix(Mat4 m) {
    final r = Float64List(4);
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 4; j++) r[i] += this[j] * m[i * 4 + j];
    }
    return r;
  }
}

extension _Mat4Ops on Mat4 {
  static Mat4 outer(Vec4 a, Vec4 b) {
    final m = Mat4.zero();
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 4; j++) m[j * 4 + i] = a[i] * b[j];
    }
    return m;
  }

  Mat4 get transposed {
    final t = Mat4.zero();
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 4; j++) t[j * 4 + i] = this[i * 4 + j];
    }
    return t;
  }

  Mat4 plus(Mat4 o) => _map16((i) => this[i] + o[i]);
  Mat4 minus(Mat4 o) => _map16((i) => this[i] - o[i]);
  Mat4 scaledBy(double k) => _map16((i) => this[i] * k);

  /// Matrix times column vector: (Mv)ᵢ = Σⱼ M(i, j) vⱼ.
  Vec4 timesVector(Vec4 v) {
    final r = Float64List(4);
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 4; j++) r[i] += this[j * 4 + i] * v[j];
    }
    return r;
  }

  Mat4 _map16(double Function(int) f) {
    final m = Mat4.zero();
    for (var i = 0; i < 16; i++) m[i] = f(i);
    return m;
  }
}

final class KalmanFilter {
  KalmanFilter({
    required this.stateTransition,
    required this.processNoiseCovariance,
    required this.measurementVector,
    required this.measurementNoiseVariance,
    required this.minStableIteration,
  });

  final Mat4 stateTransition;
  final Mat4 processNoiseCovariance;
  final Vec4 measurementVector;
  final double measurementNoiseVariance;
  final int minStableIteration;

  Vec4 state = Float64List(4);
  Mat4 _errorCovariance = Mat4.identity();
  int iterations = 0;

  bool get isStable => iterations >= minStableIteration;

  void reset() {
    state = Float64List(4);
    _errorCovariance = Mat4.identity();
    iterations = 0;
  }

  void update(double observation) {
    if (iterations++ == 0) {
      state[0] = observation;
      return;
    }
    _predict();

    final y = observation - measurementVector.dot(state);
    final hp = measurementVector.timesMatrix(_errorCovariance);
    final s = hp.dot(measurementVector) + measurementNoiseVariance;
    final gain = hp.scaledBy(1 / s);

    state = state.plus(gain.scaledBy(y));
    final iKH = Mat4.identity().minus(_Mat4Ops.outer(gain, measurementVector));
    _errorCovariance = (iKH * _errorCovariance * iKH.transposed).plus(
      _Mat4Ops.outer(gain, gain).scaledBy(measurementNoiseVariance),
    );
  }

  void _predict() {
    state = stateTransition.timesVector(state);
    _errorCovariance = (stateTransition * _errorCovariance * stateTransition.transposed).plus(processNoiseCovariance);
  }

  KalmanFilter clone() =>
      KalmanFilter(
          stateTransition: stateTransition,
          processNoiseCovariance: processNoiseCovariance,
          measurementVector: measurementVector,
          measurementNoiseVariance: measurementNoiseVariance,
          minStableIteration: minStableIteration,
        )
        ..state = Float64List.fromList(state)
        .._errorCovariance = _errorCovariance.copy()
        ..iterations = iterations;
}

final class AxisPredictor {
  AxisPredictor(double processNoise, double measurementNoise, int minStableIteration)
    : _filter = _makeFilter(processNoise, measurementNoise, minStableIteration);
  AxisPredictor._(this._filter);

  final KalmanFilter _filter;

  static KalmanFilter _makeFilter(double processNoise, double measurementNoise, int minStableIteration) {
    const dt = 1.0, dt2 = dt * dt, dt3 = dt2 * dt;

    final f = Mat4.zero();
    const rows = [
      [1.0, dt, dt2 / 2, dt3 / 6],
      [0.0, 1.0, dt, dt2 / 2],
      [0.0, 0.0, 1.0, dt],
      [0.0, 0.0, 0.0, 1.0],
    ];
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 4; j++) f[j * 4 + i] = rows[i][j];
    }

    final noise = Float64List(4)
      ..[0] = dt3 / 6
      ..[1] = dt2 / 2
      ..[2] = dt
      ..[3] = 1;
    return KalmanFilter(
      stateTransition: f,
      processNoiseCovariance: _Mat4Ops.outer(noise, noise).scaledBy(processNoise),
      measurementVector: Float64List(4)..[0] = 1,
      measurementNoiseVariance: measurementNoise,
      minStableIteration: minStableIteration,
    );
  }

  bool get isStable => _filter.isStable;
  int get iterations => _filter.iterations;
  double get position => _filter.state[0];
  double get velocity => _filter.state[1];
  double get acceleration => _filter.state[2];
  double get jerk => _filter.state[3];

  void reset() => _filter.reset();
  void update(double observation) => _filter.update(observation);
  AxisPredictor clone() => AxisPredictor._(_filter.clone());
}
