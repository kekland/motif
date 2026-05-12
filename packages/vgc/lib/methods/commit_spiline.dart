part of '../vector_complex.dart';

extension CommitSplineExt on VectorComplex {
  List<OpenEdge> commitSpline(CubicSpline2 spline, {Vertex? startVertex, Vertex? endVertex}) {
    if (startVertex != null && endVertex != null) {
      return _commitSpline(this, spline, startVertex: startVertex, endVertex: endVertex);
    } else {
      return _commitSpline(this, spline);
    }
  }
}

const double _kLoopCloseThreshold = 12.0;

List<OpenEdge> _commitSpline(VectorComplex complex, CubicSpline2 spline, {Vertex? startVertex, Vertex? endVertex}) {
  late final Vertex _startVertex;
  late final Vertex _endVertex;

  if (startVertex == null && endVertex == null) {
    final start = spline.knots.first.p;
    final end = spline.knots.last.p;
    final isLoop = start.distanceTo(end) < _kLoopCloseThreshold;

    final canonical = isLoop ? _withSnappedEnd(spline, start) : spline;

    _startVertex = complex.createVertex(canonical.knots.first.p);
    _endVertex = isLoop ? _startVertex : complex.createVertex(canonical.knots.last.p);
  } else {
    _startVertex = startVertex ?? complex.createVertex(spline.knots.first.p);
    _endVertex = endVertex ?? complex.createVertex(spline.knots.last.p);
  }

  return _commitSplineSegments(complex, spline, _startVertex, _endVertex);
}

CubicSpline2 _withSnappedEnd(CubicSpline2 spline, Vector2 snappedEnd) {
  final knots = spline.knots.map((k) => k.copy()).toList();
  knots.last.p = snappedEnd.clone();
  return CubicSpline2(knots);
}

List<OpenEdge> _commitSplineSegments(
  VectorComplex complex,
  CubicSpline2 spline,
  Vertex startVertex,
  Vertex endVertex,
) {
  var selfIntersections = spline.selfIntersect();
  late final List<(Vertex, Vertex, CubicSpline2)> segments = [];

  // If the spline is a closed loop, ignore self-intersections near start/end point.
  if (startVertex == endVertex) {
    final eps = 1e-9;
    selfIntersections = selfIntersections
        .where((i) => i.tA > eps && i.tA < 1 - eps && i.tB > eps && i.tB < 1 - eps)
        .toList();
  }

  if (selfIntersections.isEmpty) {
    segments.addAll(_commitSubSpline(complex, spline, startVertex, endVertex));
  } else {
    // Create vertices at self-intersection points.
    final breakpoints = <(double, Vertex)>[];
    for (final inter in selfIntersections) {
      final v = complex.createVertex(inter.point);
      breakpoints.add((inter.tA, v));
      breakpoints.add((inter.tB, v));
    }
    breakpoints.sort((a, b) => a.$1.compareTo(b.$1));

    final ts = breakpoints.map((b) => b.$1).toList();
    final pieces = spline.splitMultiple(ts);

    for (var i = 0; i < pieces.length; i++) {
      final s = i == 0 ? startVertex : breakpoints[i - 1].$2;
      final e = i == pieces.length - 1 ? endVertex : breakpoints[i].$2;
      segments.addAll(_commitSubSpline(complex, pieces[i], s, e));
    }
  }

  return segments.map((s) => complex.createOpenEdgeFromSpline(s.$1, s.$2, s.$3)).toList();
}

List<(Vertex, Vertex, CubicSpline2)> _commitSubSpline(
  VectorComplex complex,
  CubicSpline2 spline,
  Vertex start,
  Vertex end,
) {
  const eps = 1e-9;

  // TODO: check for tA/tB close to 0 and 1 and snap to start/end vertex?
  final intersections = complex
      .intersectWithSpline(spline)
      .where((i) => i.tA > eps && i.tA < 1 - eps && i.tB > eps && i.tB < 1 - eps)
      .toList();

  intersections.sort((a, b) => a.tArg.compareTo(b.tArg));

  // Split our own spline at each intersection point, and then find the corresponding edges.
  final pieces = spline.splitMultiple(intersections.map((i) => i.tArg).toList());
  final intersectionsByEdge = <Edge, List<(int, VectorComplexIntersection)>>{};
  for (final (i, inter) in intersections.indexed) {
    intersectionsByEdge[inter.edge] ??= [];
    intersectionsByEdge[inter.edge]!.add((i, inter));
  }

  // For each edge, cut it at the intersection points to create new vertices, and then make sure that vertices are
  // correctly associated to the pieces of the spline.
  final indexToVertex = <int, Vertex>{};
  for (final entry in intersectionsByEdge.entries) {
    final group = entry.value..sort((a, b) => a.$2.tEdge.compareTo(b.$2.tEdge));
    final ts = group.map((e) => e.$2.tEdge).toList();
    final result = complex.cutEdgeMultiple(entry.key, ts);
    for (var i = 0; i < result.vertices.length; i++) {
      indexToVertex[group[i].$1] = result.vertices[i];
    }
  }

  final out = <(Vertex, Vertex, CubicSpline2)>[];
  for (var i = 0; i < pieces.length; i++) {
    final s = i == 0 ? start : indexToVertex[i - 1]!;
    final e = i == pieces.length - 1 ? end : indexToVertex[i]!;
    out.add((s, e, pieces[i]));
  }

  return out;
}
