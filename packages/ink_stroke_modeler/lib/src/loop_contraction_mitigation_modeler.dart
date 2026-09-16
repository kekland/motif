// ignore_for_file: library_private_types_in_public_api

import 'dart:collection';

import 'package:geometry/geometry.dart';
import 'package:ink_stroke_modeler/src/params.dart';
import 'package:ink_stroke_modeler/src/types.dart';
import 'package:ink_stroke_modeler/src/utils.dart';

final class _SpeedSample({
  final double speed = 0.0,
  final Time time = .zero,
});

final class _State({
  required final ListQueue<_SpeedSample> speedSamples,
});

final class LoopContractionMitigationModeler {
  LoopContractionMitigationModeler()
    : params = null,
      state = .new(
        speedSamples: .new(),
      );

  _State state;
  LoopContractionMitigationParams? params;
  _State? _savedState;

  double get interpolationValue {
    final p = params;
    if (p == null || state.speedSamples.isEmpty) return 1.0;

    var sum = 0.0;
    for (final s in state.speedSamples) sum += s.speed;
    final averageSpeed = sum / state.speedSamples.length;

    final sourceRatio = clamp01(inverseLerp(p.speedBound.min, p.speedBound.max, averageSpeed));
    return interp(p.interpolationStrengthAtSpeedLowerBound, p.interpolationStrengthAtSpeedUpperBound, sourceRatio);
  }

  double update(Vec2 velocity, Time time) {
    final p = params;
    if (p == null) return 1.0;

    final samples = state.speedSamples;
    samples.add(.new(speed: velocity.length, time: time));
    while (samples.isNotEmpty && samples.last.time - samples.first.time > p.minSpeedSamplingWindow) {
      samples.removeFirst();
    }

    return interpolationValue;
  }

  void save() {
    _savedState = _State(
      speedSamples: .of(state.speedSamples),
    );
  }

  void restore() {
    if (_savedState != null) {
      state = .new(speedSamples: .of(_savedState!.speedSamples));
    }
  }

  LoopContractionMitigationModeler clone() {
    final clone = LoopContractionMitigationModeler();
    clone.params = params;
    clone.state = .new(speedSamples: .of(state.speedSamples));
    return clone;
  }

  void reset(LoopContractionMitigationParams? params) {
    this.params = params;
    state = _State(speedSamples: .new());
    _savedState = null;
  }
}
