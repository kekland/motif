part of '../vector_complex.dart';

extension RegularCycleGeometry on RegularCycle {
  Polyline2 flatten({double? tolerance}) {
    final polyline = <Vector2>[];
    forEachSample((point, _) => polyline.add(point), tolerance: tolerance);
    return .new(polyline);
  }

  void forEachSample(FlattenCallback callback, {double? tolerance}) {
    if (halfEdges.isEmpty) return;
    final n = halfEdges.length;

    for (var i = 0; i < n; i++) {
      final he = halfEdges[i];
      final isFirst = i == 0;
      he.forEachSample((point, localT) {
        if (!isFirst && localT == 0) return;
        final globalT = (i + localT) / n;
        callback(point, globalT);
      }, tolerance: tolerance);
    }
  }

  void forEachSegment(FlattenSegmentsCallback callback, {double? tolerance}) {
    if (halfEdges.isEmpty) return;
    final n = halfEdges.length;

    for (var i = 0; i < n; i++) {
      final he = halfEdges[i];
      he.forEachSegment((segment, localT0, localT1) {
        final globalT0 = (i + localT0) / n;
        final globalT1 = (i + localT1) / n;
        callback(segment, globalT0, globalT1);
      }, tolerance: tolerance);
    }
  }
}
