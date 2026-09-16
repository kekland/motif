// ignore_for_file: library_private_types_in_public_api

import 'dart:collection';

import 'package:geometry/geometry.dart';
import 'package:ink_stroke_modeler/src/params.dart';
import 'package:ink_stroke_modeler/src/types.dart';
import 'package:ink_stroke_modeler/src/utils.dart';

final class _Sample({
  required final Vec2 position,
  required final Vec2 weightedPosition,
  required final double distance,
  required final TimeSpan duration,
  required final Time time,
});

final class _State({
  required var Queue<_Sample> samples,
  required var Vec2 weighedPositionSum,
  required var double distanceSum,
  required var TimeSpan durationSum,
});

final class WobbleSmoother {
  WobbleSmoother()
    : state = _State(
        samples: .new(),
        weighedPositionSum: .zero(),
        distanceSum: 0.0,
        durationSum: .zero,
      );

  final _State state;
  WobbleSmootherParams? params;
  _State? savedState;

  void reset(WobbleSmootherParams? params, Vec2 position, Time time) {
    state.samples.clear();
    state.weighedPositionSum = .zero();
    state.distanceSum = 0.0;
    state.durationSum = .zero;
    state.samples.add(
      .new(
        position: position,
        time: time,
        distance: 0.0,
        duration: .zero,
        weightedPosition: .zero(),
      ),
    );

    savedState = null;
    this.params = params;
  }

  Vec2 update(Vec2 position, Time time) {
    if (params == null) return position;

    final deltaTime = time - state.samples.last.time;
    final sample = _Sample(
      position: position,
      weightedPosition: position * deltaTime,
      distance: (position - state.samples.last.position).length,
      duration: deltaTime,
      time: time,
    );

    state.samples.add(sample);
    state.weighedPositionSum += sample.weightedPosition;
    state.distanceSum += sample.distance;
    state.durationSum += sample.duration;

    while (state.samples.first.time < time.subtract(params!.timeout)) {
      final front = state.samples.removeFirst();
      state.weighedPositionSum -= front.weightedPosition;
      state.distanceSum -= front.distance;
      state.durationSum -= front.duration;
    }

    if (state.durationSum.isZero) return position;

    final avgPosition = state.weighedPositionSum / state.durationSum;
    final avgSpeed = state.distanceSum / state.durationSum;

    return interpVec2(
      avgPosition,
      position,
      normalize01(params!.speedRange.min, params!.speedRange.max, avgSpeed),
    );
  }

  void save() {
    savedState = _State(
      samples: Queue.of(state.samples),
      weighedPositionSum: state.weighedPositionSum,
      distanceSum: state.distanceSum,
      durationSum: state.durationSum,
    );
  }

  void restore() {
    if (savedState != null) {
      state.samples.clear();
      state.samples.addAll(savedState!.samples);
      state.weighedPositionSum = savedState!.weighedPositionSum;
      state.distanceSum = savedState!.distanceSum;
      state.durationSum = savedState!.durationSum;
    }
  }
}
