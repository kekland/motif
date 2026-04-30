part of '../vector_complex.dart';

extension EdgeGeometry on Edge {
  Polyline2 flatten({double? tolerance}) => spline.flatten(tolerance: tolerance).$1;

  void forEachSample(FlattenCallback callback, {double? tolerance}) {
    spline.forEachSample(callback, tolerance: tolerance);
  }

  void forEachSegment(FlattenSegmentsCallback callback, {double? tolerance}) {
    spline.forEachSegment(callback, tolerance: tolerance);
  }
}
