import 'dart:math';

import 'package:geometry/geometry.dart';
import 'package:ink_stroke_modeler/src/types.dart';

double clamp01(double value) => value.clamp(0.0, 1.0);

double normalize01(double start, double end, double value) {
  if (start == end) return value > start ? 1.0 : 0.0;
  return clamp01((value - start) / (end - start));
}

double inverseLerp(double a, double b, double value) {
  if (b - a == 0.0) return 0.0;
  return (value - a) / (b - a);
}

double interp(double start, double end, double t) {
  return start + (end - start) * clamp01(t);
}

Vec2 interpVec2(Vec2 start, Vec2 end, double t) {
  return start + (end - start) * clamp01(t);
}

double normalizeAngle(double angle) {
  while (angle < 0) angle += 2 * pi;
  while (angle > 2 * pi) angle -= 2 * pi;
  return angle;
}

double interpAngle(double start, double end, double t) {
  start = normalizeAngle(start);
  end = normalizeAngle(end);
  final delta = end - start;
  if (delta < -pi) {
    end += 2 * pi;
  } else if (delta > pi) {
    end -= 2 * pi;
  }

  return normalizeAngle(interp(start, end, t));
}

double? projectToSegmentAlongNormal(Vec2 segmentStart, Vec2 segmentEnd, Vec2 position, Vec2 strokeNormal) {
  final v = segmentEnd - segmentStart;
  final det = strokeNormal.cross(v);
  if (det == 0.0) return null;

  final w = segmentStart - position;
  final param = w.cross(strokeNormal) / det;
  if (param < 0 || param > 1) return null;
  return param;
}

double nearestPointOnSegment(Vec2 segmentStart, Vec2 segmentEnd, Vec2 point) {
  if (segmentStart.equals(segmentEnd)) return 0.0;

  final segmentVector = segmentEnd - segmentStart;
  final projectionVector = point - segmentStart;
  return clamp01(projectionVector.dot(segmentVector) / segmentVector.dot(segmentVector));
}

Result interpResult(Result start, Result end, double t) {
  return .new(
    position: interpVec2(start.position, end.position, t),
    velocity: interpVec2(start.velocity, end.velocity, t),
    acceleration: interpVec2(start.acceleration, end.acceleration, t),
    time: .new(interp(start.time, end.time, t)),
    pressure: start.pressure == null || end.pressure == null ? null : interp(start.pressure!, end.pressure!, t),
    tilt: start.tilt == null || end.tilt == null ? null : interp(start.tilt!, end.tilt!, t),
    orientation: start.orientation == null || end.orientation == null
        ? null
        : interpAngle(start.orientation!, end.orientation!, t),
  );
}

double absoluteAngleTo(Vec2 a, Vec2 b) {
  if (!a.isFinite || !b.isFinite) throw ArgumentError('a/b must be finite');
  final magnitude = a.length;
  final otherMagnitude = b.length;
  if (magnitude == 0.0 || otherMagnitude == 0.0) return 0.0;

  final unitVec = a / magnitude;
  final otherUnitVec = b / otherMagnitude;

  final dotProduct = unitVec.dot(otherUnitVec);
  return acos(dotProduct.clamp(-1.0, 1.0));
}

Vec2 _orthogonal(Vec2 v) => Vec2(-v.y, v.x);

Vec2? getStrokeNormal(TipState tip, Time prevTime) {
  const cosineHalfDegree = 0.99996192;
  final v = tip.velocity, a = tip.acceleration;
  final vMagnitude = v.length, aMagnitude = a.length;
  if (vMagnitude == 0 && aMagnitude == 0) return null;
  if (vMagnitude == 0) return _orthogonal(a);
  if (aMagnitude == 0) return _orthogonal(v);
  if (v.dot(a).abs() > cosineHalfDegree * vMagnitude * aMagnitude) return _orthogonal(v);

  final dt = (tip.time - prevTime).seconds;
  final strokeDir = v / vMagnitude + (v + a * dt).normalized();
  return _orthogonal(strokeDir);
}
