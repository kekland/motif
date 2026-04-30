part of '../cubic.dart';

double _cubicArcLength(Cubic2 cubic, {double? tolerance}) {
  final (points, _) = cubic.flatten(tolerance: tolerance);
  var length = 0.0;
  for (var i = 1; i < points.length; i++) length += points[i].distanceTo(points[i - 1]);
  return length;
}

double _splineArcLength(CubicSpline2 spline, {double? tolerance}) {
  var length = 0.0;
  for (final segment in spline.segments) length += _cubicArcLength(segment, tolerance: tolerance);
  return length;
}
