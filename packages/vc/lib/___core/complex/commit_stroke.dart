part of '../core.dart';

extension ComplexCommitStrokeExt on MutableVectorComplex {
  List<MutableEdge> commitStroke(
    EdgePath path, {
    MutableVertex? startVertex,
    MutableVertex? endVertex,
    EdgeDecoration? decoration,
    EdgeWeights? weights,
    List<EdgeModifier>? modifiers,
    double? vertexHitTestTolerance,
    bool topological = true,
  }) {
    return _commitStroke(
      this,
      path,
      startVertex: startVertex,
      endVertex: endVertex,
      decoration: decoration,
      weights: weights,
      modifiers: modifiers,
      vertexHitTestTolerance: vertexHitTestTolerance,
      topological: topological,
    );
  }
}

List<MutableEdge> _commitStroke(
  MutableVectorComplex complex,
  EdgePath path, {
  MutableVertex? startVertex,
  MutableVertex? endVertex,
  EdgeDecoration? decoration,
  EdgeWeights? weights,
  List<EdgeModifier>? modifiers,
  double? vertexHitTestTolerance,
  bool topological = true,
}) {
  late final MutableVertex _startVertex;
  late final MutableVertex _endVertex;

  final spline = path.spline;

  if (startVertex == null && endVertex == null) {
    final start = spline.knots.first.p;
    final end = spline.knots.last.p;
    final isLoop = start.distanceTo(end) < (vertexHitTestTolerance ?? 12.0);

    final canonical = isLoop ? _withSnappedEnd(spline, start) : spline;

    _startVertex = complex.addVertex(canonical.knots.first.p);
    _endVertex = isLoop ? _startVertex : complex.addVertex(canonical.knots.last.p);
  } else {
    _startVertex = startVertex ?? complex.addVertex(spline.knots.first.p);
    _endVertex = endVertex ?? complex.addVertex(spline.knots.last.p);
  }

  if (!topological) {
    return [
      complex.addEdge(
        _startVertex,
        _endVertex,
        path: path,
        weights: weights,
        decoration: decoration,
        modifiers: modifiers,
      ),
    ];
  }

  return _commitSplineSegments(
    complex,
    spline,
    _startVertex,
    _endVertex,
    weights: weights,
    decoration: decoration,
    modifiers: modifiers,
  );
}

CubicSpline2 _withSnappedEnd(CubicSpline2 spline, Vector2 snappedEnd) {
  final knots = spline.knots.map((k) => k.copy()).toList();
  knots.last.p = snappedEnd.clone();
  return CubicSpline2(knots);
}

List<MutableEdge> _commitSplineSegments(
  MutableVectorComplex complex,
  CubicSpline2 spline,
  MutableVertex startVertex,
  MutableVertex endVertex, {
  EdgeWeights? weights,
  EdgeDecoration? decoration,
  List<EdgeModifier>? modifiers,
}) {
  var selfIntersections = spline.selfIntersect();
  late final List<(MutableVertex, MutableVertex, CubicSpline2, EdgeWeights?)> segments = [];

  final eps = 1e-9;
  selfIntersections = selfIntersections
      .where((i) => i.tA > eps && i.tA < 1 - eps && i.tB > eps && i.tB < 1 - eps)
      .toList();

  if (selfIntersections.isEmpty) {
    segments.addAll(_commitSubSpline(complex, spline, startVertex, endVertex, weights));
  } else {
    // Create vertices at self-intersection points.
    final breakpoints = <(double, MutableVertex)>[];
    for (final inter in selfIntersections) {
      final v = complex.addVertex(inter.point);
      breakpoints.add((inter.tA, v));
      breakpoints.add((inter.tB, v));
    }
    breakpoints.sort((a, b) => a.$1.compareTo(b.$1));

    final ts = breakpoints.map((b) => b.$1).toList();
    final pieces = spline.splitMultiple(ts);
    final weightPieces = weights?.splitMultiple(ts);

    for (var i = 0; i < pieces.length; i++) {
      final s = i == 0 ? startVertex : breakpoints[i - 1].$2;
      final e = i == pieces.length - 1 ? endVertex : breakpoints[i].$2;

      final w = weightPieces != null ? weightPieces[i] : null;
      segments.addAll(_commitSubSpline(complex, pieces[i], s, e, w));
    }
  }

  return segments
      .map(
        (s) => complex.addEdge(
          s.$1,
          s.$2,
          path: .immutable(knots: s.$3.knots),
          weights: s.$4,
          decoration: decoration,
          modifiers: modifiers,
        ),
      )
      .toList();
}

List<(MutableVertex, MutableVertex, CubicSpline2, EdgeWeights?)> _commitSubSpline(
  MutableVectorComplex complex,
  CubicSpline2 spline,
  MutableVertex start,
  MutableVertex end,
  EdgeWeights? weights,
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
  final weightPieces = weights?.splitMultiple(ts);

  final intersectionsByEdge = <MutableEdge, List<(int, VectorComplexIntersection<MutableEdge>)>>{};
  for (final (i, inter) in intersections.indexed) {
    intersectionsByEdge[inter.edge] ??= [];
    intersectionsByEdge[inter.edge]!.add((i, inter));
  }

  // For each edge, cut it at the intersection points to create new vertices, and then make sure that vertices are
  // correctly associated to the pieces of the spline.
  final indexToVertex = <int, MutableVertex>{};
  for (final entry in intersectionsByEdge.entries) {
    final group = entry.value..sort((a, b) => a.$2.tEdge.compareTo(b.$2.tEdge));
    final ts = group.map((e) => e.$2.tEdge).toList();
    final result = complex.cutEdgeMultiple(entry.key, ts);
    for (var i = 0; i < result.vertices.length; i++) {
      indexToVertex[group[i].$1] = result.vertices[i];
    }
  }

  final out = <(MutableVertex, MutableVertex, CubicSpline2, EdgeWeights?)>[];
  for (var i = 0; i < pieces.length; i++) {
    final s = i == 0 ? start : indexToVertex[i - 1]!;
    final e = i == pieces.length - 1 ? end : indexToVertex[i]!;
    final w = weightPieces != null ? weightPieces[i] : null;
    out.add((s, e, pieces[i], w));
  }

  return out;
}
