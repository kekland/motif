// ignore_for_file: library_private_types_in_public_api

import 'dart:collection';

import 'package:geometry/geometry.dart';
import 'package:ink_stroke_modeler/src/params.dart';
import 'package:ink_stroke_modeler/src/types.dart';
import 'package:ink_stroke_modeler/src/utils.dart';

final class RawInputProjection({
  final int segmentIndex = 0,
  final double ratioAlongSegment = 0,
});

final class _State({
  var bool receivedUnknownPressure = false,
  var bool receivedUnknownTilt = false,
  var bool receivedUnknownOrientation = false,
  required var ListQueue<Result> rawInputAndStylusStates,
  required var RawInputProjection projection,
});

final class StylusStateModeler {
  StylusStateModeler()
    : params = .new(),
      state = _State(
        rawInputAndStylusStates: .new(),
        projection: .new(),
      );

  _State state;
  StylusStateModelerParams params;
  _State? savedState;

  void update(Vec2 position, Time time, StylusState stylus) {
    if (stylus.pressure == null || stylus.pressure!.isNaN) state.receivedUnknownPressure = true;
    if (stylus.tilt == null || stylus.tilt!.isNaN) state.receivedUnknownTilt = true;
    if (stylus.orientation == null || stylus.orientation!.isNaN) state.receivedUnknownOrientation = true;

    if (!params.useStrokeNormalProjection &&
        state.receivedUnknownPressure &&
        state.receivedUnknownTilt &&
        state.receivedUnknownOrientation) {
      state.rawInputAndStylusStates.clear();
      return;
    }

    Vec2 velocity = .zero(), acceleration = .zero();

    if (state.rawInputAndStylusStates.isNotEmpty && time != state.rawInputAndStylusStates.last.time) {
      final back = state.rawInputAndStylusStates.last;
      velocity = (position - back.position) / (time - back.time);
      acceleration = (velocity - back.velocity) / (time - back.time);
    }

    state.rawInputAndStylusStates.add(
      .new(
        position: position,
        time: time,
        velocity: velocity,
        acceleration: acceleration,
        pressure: stylus.pressure,
        tilt: stylus.tilt,
        orientation: stylus.orientation,
      ),
    );
  }

  Result? project(TipState tip, Vec2? strokeNormal) {
    final states = state.rawInputAndStylusStates;
    if (states.isEmpty) return null;

    if (params.useStrokeNormalProjection && strokeNormal != null) {
      state.projection = _projectAlongStrokeNormal(
        tip.position,
        tip.acceleration,
        tip.time,
        strokeNormal,
        states,
        state.projection,
      );
    } else {
      state.projection = _projectToClosestPoint(tip.position, states, state.projection);
    }

    var projection = state.projection;
    while (projection.segmentIndex > 0) {
      projection = .new(segmentIndex: projection.segmentIndex - 1, ratioAlongSegment: projection.ratioAlongSegment);
      states.removeFirst();
    }

    state.projection = projection;

    var projectedResult = states.length > 1
        ? interpResult(states.elementAt(0), states.elementAt(1), state.projection.ratioAlongSegment)
        : states.first;

    projectedResult = projectedResult.copyWith(
      time: tip.time,
      unknownPressure: state.receivedUnknownPressure,
      unknownTilt: state.receivedUnknownTilt,
      unknownOrientation: state.receivedUnknownOrientation,
    );

    return projectedResult;
  }

  void reset(StylusStateModelerParams params) {
    this.params = params;
    state.receivedUnknownPressure = false;
    state.receivedUnknownTilt = false;
    state.receivedUnknownOrientation = false;
    state.rawInputAndStylusStates.clear();
    state.projection = .new();
  }

  void save() {
    savedState = _State(
      receivedUnknownPressure: state.receivedUnknownPressure,
      receivedUnknownTilt: state.receivedUnknownTilt,
      receivedUnknownOrientation: state.receivedUnknownOrientation,
      rawInputAndStylusStates: .of(state.rawInputAndStylusStates),
      projection: state.projection,
    );
  }

  void restore() {
    if (savedState != null) {
      state.receivedUnknownPressure = savedState!.receivedUnknownPressure;
      state.receivedUnknownTilt = savedState!.receivedUnknownTilt;
      state.receivedUnknownOrientation = savedState!.receivedUnknownOrientation;
      state.rawInputAndStylusStates.clear();
      state.rawInputAndStylusStates.addAll(savedState!.rawInputAndStylusStates);
      state.projection = savedState!.projection;
    }
  }

  StylusStateModeler clone() {
    final clone = StylusStateModeler();
    clone.params = params;
    clone.state = _State(
      receivedUnknownPressure: state.receivedUnknownPressure,
      receivedUnknownTilt: state.receivedUnknownTilt,
      receivedUnknownOrientation: state.receivedUnknownOrientation,
      rawInputAndStylusStates: .of(state.rawInputAndStylusStates),
      projection: state.projection,
    );
    return clone;
  }
}

RawInputProjection _projectToClosestPoint(
  Vec2 position,
  ListQueue<Result> rawInputPolyline,
  RawInputProjection previousProjection,
) {
  RawInputProjection? bestProjection;
  double minDistance = .infinity;

  for (var i = 0; i < rawInputPolyline.length - 1; i++) {
    final segmentStart = rawInputPolyline.elementAt(i).position;
    final segmentEnd = rawInputPolyline.elementAt(i + 1).position;
    final segmentRatio = nearestPointOnSegment(segmentStart, segmentEnd, position);

    if (i == previousProjection.segmentIndex && segmentRatio < previousProjection.ratioAlongSegment) continue;

    final distance = interpVec2(segmentStart, segmentEnd, segmentRatio).distanceTo(position);
    if (distance <= minDistance) {
      minDistance = distance;
      bestProjection = .new(
        segmentIndex: i,
        ratioAlongSegment: segmentRatio,
      );
    }
  }

  return bestProjection ?? previousProjection;
}

RawInputProjection _projectAlongStrokeNormal(
  Vec2 position,
  Vec2 acceleration,
  Time time,
  Vec2 strokeNormal,
  ListQueue<Result> rawInputPolyline,
  RawInputProjection previousProjection,
) {
  RawInputProjection? bestLeftProjection, bestRightProjection;
  double bestDistanceLeft = .infinity, bestDistanceRight = .infinity;

  void maybeUpdateProjection(
    RawInputProjection candidate,
    double distance,
    bool isLeft,
  ) {
    if (isLeft) {
      if (distance < bestDistanceLeft) {
        bestDistanceLeft = distance;
        bestLeftProjection = candidate;
      }
    } else {
      if (distance < bestDistanceRight) {
        bestDistanceRight = distance;
        bestRightProjection = candidate;
      }
    }
  }

  for (var i = previousProjection.segmentIndex; i < rawInputPolyline.length - 1; i++) {
    final segmentStart = rawInputPolyline.elementAt(i).position;
    final segmentEnd = rawInputPolyline.elementAt(i + 1).position;

    final segmentRatio = projectToSegmentAlongNormal(segmentStart, segmentEnd, position, strokeNormal);
    if (segmentRatio == null) continue;

    if (i == previousProjection.segmentIndex && segmentRatio <= previousProjection.ratioAlongSegment) continue;

    final projection = interpVec2(segmentStart, segmentEnd, segmentRatio);
    final distance = (projection - position).length;

    final candidate = RawInputProjection(
      segmentIndex: i,
      ratioAlongSegment: segmentRatio,
    );

    final dot = (projection - position).dot(strokeNormal);
    if (dot == 0.0) {
      return candidate;
    } else if (dot < 0.0) {
      maybeUpdateProjection(candidate, distance, false);
    } else {
      maybeUpdateProjection(candidate, distance, true);
    }
  }

  if (bestLeftProjection != null && bestRightProjection != null) {
    final dot = strokeNormal.dot(acceleration);
    return dot > 0 ? bestRightProjection! : bestLeftProjection!;
  }

  return bestRightProjection ?? bestLeftProjection ?? previousProjection;
}
