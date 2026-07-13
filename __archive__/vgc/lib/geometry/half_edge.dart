part of '../vector_complex.dart';

extension HalfEdgeGeometry on HalfEdge {
  Vector2 get startPosition {
    final spline = edge.spline;
    return direction ? spline.knots.first.p : spline.knots.last.p;
  }

  Vector2 get endPosition {
    final spline = edge.spline;
    return direction ? spline.knots.last.p : spline.knots.first.p;
  }

  Vector2 get outwardTangent {
    final e = edge;
    return direction ? e.spline.tangentAtStart : -e.spline.tangentAtEnd;
  }

  CubicSpline2 get spline {
    final e = edge.spline;
    return direction ? e : e.reversed();
  }

  Polyline2 flatten({double? tolerance}) => spline.flatten(tolerance: tolerance).$1;

  void forEachSample(FlattenCallback callback, {double? tolerance}) {
    spline.forEachSample(callback, tolerance: tolerance);
  }

  void forEachSegment(FlattenSegmentsCallback callback, {double? tolerance}) {
    spline.forEachSegment(callback, tolerance: tolerance);
  }
}
