part of '../core.dart';

List<Edge> _commitStroke(
  SceneNode parent,
  EdgePath path, {
  Vertex? startVertex,
  Vertex? endVertex,
  bool topological = true,
}) {
  final _startVertex = startVertex ?? Vertex(path.first.p);
  final _endVertex = endVertex ?? Vertex(path.last.p);

  if (!topological) {
    final edge = Edge(_startVertex, _endVertex, path: path);
    edge.parent = parent;
    return [edge];
  }

  return _commitSplineSegments(parent, path, _startVertex, _endVertex);
}

List<Edge> _commitSplineSegments(
  SceneNode parent,
  CubicSpline2 spline,
  Vertex startVertex,
  Vertex endVertex,
) {
  var selfIntersections = spline.selfIntersect();
  late final List<(Vertex, Vertex, CubicSpline2)> segments = [];

  final eps = 1e-9;
  selfIntersections = selfIntersections
      .where((i) => i.tA > eps && i.tA < 1 - eps && i.tB > eps && i.tB < 1 - eps)
      .toList();

  var startIndex = parent.children.length;

  if (selfIntersections.isEmpty) {
    segments.addAll(_commitSubSpline(parent, spline, startVertex, endVertex));
  } else {
    // Create vertices at self-intersection points.
    final breakpoints = <(double, Vertex)>[];
    for (final inter in selfIntersections) {
      final v = Vertex(inter.point);
      breakpoints.add((inter.tA, v));
      breakpoints.add((inter.tB, v));
    }
    
    breakpoints.sort((a, b) => a.$1.compareTo(b.$1));
    parent._insertChildren(startIndex, breakpoints.map((b) => b.$2));
    startIndex += breakpoints.length; 

    final ts = breakpoints.map((b) => b.$1).toList();
    final pieces = spline.splitMultiple(ts);

    for (var i = 0; i < pieces.length; i++) {
      final s = i == 0 ? startVertex : breakpoints[i - 1].$2;
      final e = i == pieces.length - 1 ? endVertex : breakpoints[i].$2;
      segments.addAll(_commitSubSpline(parent, pieces[i], s, e));
    }
  }

  final edges = <Edge>[];
  for (final segment in segments) {
    final edge = Edge(segment.$1, segment.$2, path: .from(segment.$3));
    edges.add(edge);
  }

  parent._insertChildren(startIndex, edges);
  return edges;
}

List<(Vertex, Vertex, CubicSpline2)> _commitSubSpline(
  SceneNode parent,
  CubicSpline2 spline,
  Vertex start,
  Vertex end,
) {
  const eps = 1e-9;

  // TODO: check for tA/tB close to 0 and 1 and snap to start/end vertex?
  final intersections = parent.cells
      .intersectionsWithSpline(spline)
      .where((i) => i.tA > eps && i.tA < 1 - eps && i.tB > eps && i.tB < 1 - eps)
      .toList();

  intersections.sort((a, b) => a.tArg.compareTo(b.tArg));

  // Split our own spline at each intersection point, and then find the corresponding edges.
  final ts = intersections.map((i) => i.tArg).toList();
  final pieces = spline.splitMultiple(ts);

  final intersectionsByEdge = <Edge, List<(int, CellIntersection)>>{};
  for (final (i, inter) in intersections.indexed) {
    intersectionsByEdge[inter.edge] ??= [];
    intersectionsByEdge[inter.edge]!.add((i, inter));
  }

  // For each edge, cut it at the intersection points to create new vertices, and then make sure that vertices are
  // correctly associated to the pieces of the spline.
  final indexToVertex = <int, Vertex>{};
  // for (final entry in intersectionsByEdge.entries) {
  //   final group = entry.value..sort((a, b) => a.$2.tEdge.compareTo(b.$2.tEdge));
  //   final ts = group.map((e) => e.$2.tEdge).toList();
  //   final result = entry.key.cutMultiple(ts);
  //   for (var i = 0; i < result.vertices.length; i++) {
  //     indexToVertex[group[i].$1] = result.vertices[i];
  //   }
  // }

  final out = <(Vertex, Vertex, CubicSpline2)>[];
  for (var i = 0; i < pieces.length; i++) {
    final s = i == 0 ? start : indexToVertex[i - 1]!;
    final e = i == pieces.length - 1 ? end : indexToVertex[i]!;
    out.add((s, e, pieces[i]));
  }

  return out;
}
