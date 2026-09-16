import 'dart:math';
import 'dart:typed_data';

import 'package:geometry/geometry.dart';
import 'package:ink_stroke_modeler/src/params.dart';
import 'package:ink_stroke_modeler/src/types.dart';
import 'package:ink_stroke_modeler/src/utils.dart';

final class PositionModeler {
  PositionModeler()
    : params = .new(),
      state = .new(
        position: .zero(),
        acceleration: .zero(),
        velocity: .zero(),
        time: .zero,
      );

  PositionModelerParams params;
  TipState state;
  TipState? savedState;

  TipState update(Vec2 anchorPosition, Time time) {
    final dt = (time - state.time).seconds;
    final acceleration = _springAcceleration(state, anchorPosition, params);
    final velocity = state.velocity + acceleration * dt;
    return state = TipState(
      position: state.position + velocity * dt,
      velocity: velocity,
      acceleration: acceleration,
      time: time,
    );
  }

  void save() {
    savedState = state;
  }

  void restore() {
    if (savedState != null) {
      state = savedState!;
    }
  }

  void reset(TipState state, PositionModelerParams params) {
    this.state = state;
    this.params = params;
    savedState = null;
  }

  void updateAlongLinearPath(
    Vec2 startAnchorPosition,
    Time startTime,
    Vec2 endAnchorPosition,
    Time endTime,
    int nSamples,
    List<TipState> output,
  ) {
    for (var i = 1; i <= nSamples; i++) {
      final interpValue = i / nSamples;
      final position = interpVec2(startAnchorPosition, endAnchorPosition, interpValue);
      final time = Time(interp(startTime, endTime, interpValue));
      final result = update(position, time);
      output.add(result);
    }
  }

  void modelEndOfStroke(
    Vec2 anchorPosition,
    TimeSpan deltaTime,
    int maxIterations,
    double stopDistance,
    List<TipState> output,
  ) {
    var dt = deltaTime;
    for (var i = 0; i < maxIterations; i++) {
      final previousState = state;
      final candidate = update(anchorPosition, state.time.add(dt));
      if (previousState.position.distanceTo(candidate.position) < stopDistance) {
        return;
      }

      final closestT = nearestPointOnSegment(previousState.position, candidate.position, anchorPosition);
      if (closestT < 1) {
        dt = .new(dt * 0.5);
        state = previousState;
        continue;
      }

      output.add(candidate);
      if (candidate.position.distanceTo(anchorPosition) < stopDistance) {
        return;
      }
    }
  }
}

Float32List _scratch = .new(1);

/// The C++ computes the step count from a `float` delta; the rounding decides ceil() at
/// near-integers, so the reference outputs depend on it.
double _asFloat32(double x) => (_scratch..[0] = x)[0];

int numberOfStepsBetweenInputs(
  TipState tipState,
  Input start,
  Input end,
  SamplingParams samplingParams,
  PositionModelerParams positionModelerParams,
) {
  final deltaT = end.time - start.time;
  final floatDelta = _asFloat32(deltaT.seconds);

  var nSteps = min((floatDelta * samplingParams.minOutputRate).ceil(), 1 << 30);
  final estimatedDeltaV = _springAcceleration(tipState, end.position, positionModelerParams) * floatDelta;
  final estimatedEndV = tipState.velocity + estimatedDeltaV;
  final estimatedAngle = absoluteAngleTo(tipState.velocity, estimatedEndV);

  if (samplingParams.maxEstimatedAngleToTraversePerInput != null) {
    final stepsForAngle = min(
      (estimatedAngle / samplingParams.maxEstimatedAngleToTraversePerInput!).ceil(),
      1 << 30,
    );

    if (stepsForAngle > nSteps) nSteps = stepsForAngle;
  }

  if (nSteps > samplingParams.maxOutputsPerCall) {
    throw ArgumentError(
      'Input events are too far apart; requested $nSteps > ${samplingParams.maxOutputsPerCall} samples.',
    );
  }

  return nSteps;
}

Vec2 _springAcceleration(TipState tipState, Vec2 anchorPosition, PositionModelerParams positionModelerParams) {
  return (anchorPosition - tipState.position) / positionModelerParams.springMassConstant -
      tipState.velocity * positionModelerParams.dragConstant;
}
