part of '../vector_complex.dart';

extension CommitSplineExt on VectorComplex {
  List<OpenEdge> commitSpline(
    CubicSpline2 spline, {
    Vertex? startVertex,
    Vertex? endVertex,
    StrokeWeightParameterProfile? strokeWeight,
    double? strokeWidth,
    ColorData? color,
    double? vertexHitTestTolerance,
    bool topological = true,
  }) {
    if (startVertex != null && endVertex != null) {
      return _commitSpline(
        this,
        spline,
        startVertex: startVertex,
        endVertex: endVertex,
        strokeWeight: strokeWeight,
        strokeWidth: strokeWidth,
        color: color,
        vertexHitTestTolerance: vertexHitTestTolerance,
        topological: topological,
      );
    } else {
      return _commitSpline(
        this,
        spline,
        strokeWeight: strokeWeight,
        strokeWidth: strokeWidth,
        color: color,
        vertexHitTestTolerance: vertexHitTestTolerance,
        topological: topological,
      );
    }
  }
}

List<OpenEdge> _commitSpline(
  VectorComplex complex,
  CubicSpline2 spline, {
  Vertex? startVertex,
  Vertex? endVertex,
  StrokeWeightParameterProfile? strokeWeight,
  double? strokeWidth,
  ColorData? color,
  double? vertexHitTestTolerance,
  bool topological = true,
}) {
  late final Vertex _startVertex;
  late final Vertex _endVertex;

  if (startVertex == null && endVertex == null) {
    final start = spline.knots.first.p;
    final end = spline.knots.last.p;
    final isLoop = start.distanceTo(end) < (vertexHitTestTolerance ?? 12.0);

    final canonical = isLoop ? _withSnappedEnd(spline, start) : spline;

    _startVertex = complex.createVertex(canonical.knots.first.p);
    _endVertex = isLoop ? _startVertex : complex.createVertex(canonical.knots.last.p);
  } else {
    _startVertex = startVertex ?? complex.createVertex(spline.knots.first.p);
    _endVertex = endVertex ?? complex.createVertex(spline.knots.last.p);
  }

  if (!topological) {
    return [
      complex.createOpenEdgeFromSpline(
        _startVertex,
        _endVertex,
        spline,
        strokeWeight: strokeWeight,
        color: color,
        strokeWidth: strokeWidth,
      ),
    ];
  }

  return _commitSplineSegments(
    complex,
    spline,
    _startVertex,
    _endVertex,
    strokeWeight: strokeWeight,
    strokeWidth: strokeWidth,
    color: color,
  );
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
  Vertex endVertex, {
  StrokeWeightParameterProfile? strokeWeight,
  double? strokeWidth,
  ColorData? color,
}) {
  var selfIntersections = spline.selfIntersect();
  late final List<(Vertex, Vertex, CubicSpline2, StrokeWeightParameterProfile?)> segments = [];

  final eps = 1e-9;
  selfIntersections = selfIntersections
      .where((i) => i.tA > eps && i.tA < 1 - eps && i.tB > eps && i.tB < 1 - eps)
      .toList();

  if (selfIntersections.isEmpty) {
    segments.addAll(_commitSubSpline(complex, spline, startVertex, endVertex, strokeWeight));
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
    final weights = strokeWeight?.splitMultiple(ts);

    for (var i = 0; i < pieces.length; i++) {
      final s = i == 0 ? startVertex : breakpoints[i - 1].$2;
      final e = i == pieces.length - 1 ? endVertex : breakpoints[i].$2;

      final w = weights != null ? weights[i] : null;
      segments.addAll(_commitSubSpline(complex, pieces[i], s, e, w));
    }
  }

  return segments
      .map(
        (s) => complex.createOpenEdgeFromSpline(
          s.$1,
          s.$2,
          s.$3,
          strokeWeight: s.$4,
          color: color,
          strokeWidth: strokeWidth,
        ),
      )
      .toList();
}

List<(Vertex, Vertex, CubicSpline2, StrokeWeightParameterProfile?)> _commitSubSpline(
  VectorComplex complex,
  CubicSpline2 spline,
  Vertex start,
  Vertex end,
  StrokeWeightParameterProfile? strokeWeight,
) {
  const eps = 1e-9;

  // TODO: check for tA/tB close to 0 and 1 and snap to start/end vertex?
  final intersections = complex
      .intersectWithSpline(spline)
      .where((i) => i.tA > eps && i.tA < 1 - eps && i.tB > eps && i.tB < 1 - eps)
      .toList();

  intersections.sort((a, b) => a.tArg.compareTo(b.tArg));

  // Split our own spline at each intersection point, and then find the corresponding edges.
  final ts = intersections.map((i) => i.tArg).toList();
  final pieces = spline.splitMultiple(ts);
  final weights = strokeWeight?.splitMultiple(ts);

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

  final out = <(Vertex, Vertex, CubicSpline2, StrokeWeightParameterProfile?)>[];
  for (var i = 0; i < pieces.length; i++) {
    final s = i == 0 ? start : indexToVertex[i - 1]!;
    final e = i == pieces.length - 1 ? end : indexToVertex[i]!;
    final w = weights != null ? weights[i] : null;
    out.add((s, e, pieces[i], w));
  }

  return out;
}
