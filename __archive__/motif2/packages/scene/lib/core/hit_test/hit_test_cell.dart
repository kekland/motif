part of '../core.dart';

const _vertexHitTestTolerance = 8.0;
const _edgeHitTestTolerance = 8.0;
const _knotHitTestTolerance = 8.0;
const _knotControlPointHitTestTolerance = 8.0;

double _computeScaledTolerance(Matrix4? globalToScene, double tolerance) {
  final scale = 1.0 / (globalToScene?.getMaxScaleOnAxis() ?? 1.0);
  return tolerance * scale;
}

List<SceneHitTestEntry> _hitTestCells(
  SceneNode parent,
  List<Cell> cells,
  Vector2 localPosition, {
  Matrix4? globalToScene,
  List<SceneNode> ignore = const [],
}) {
  final indexed = <(SceneHitTestEntry, int)>[];
  var depth = 0;

  for (final c in cells.reversed) {
    if (ignore.contains(c)) continue;
    final entries = switch (c) {
      Vertex v => _hitTestVertex(v, localPosition, globalToScene: globalToScene),
      Edge e => _hitTestEdge(e, localPosition, globalToScene: globalToScene),
      Face f => [],
    };

    for (final entry in entries) indexed.add((entry, depth));
    depth++;
  }

  int _priority(SceneHitTestEntry r) => switch (r) {
    VertexHitTestEntry _ => 0,
    EdgeKnotControlPointHitTestEntry _ => 1,
    EdgeKnotHitTestEntry _ => 2,
    EdgeHitTestEntry _ => 3,
    // FaceHitTestEntry _ => 2,
    _ => 5,
  };

  indexed.sort((a, b) {
    final typeComparison = _priority(a.$1).compareTo(_priority(b.$1));
    if (typeComparison != 0) return typeComparison;

    final distanceComparison = a.$1._distance.compareTo(b.$1._distance);
    if (distanceComparison != 0) return distanceComparison;

    return a.$2.compareTo(b.$2);
  });

  return indexed.map((e) => e.$1).toList();
}

List<SceneHitTestEntry> _hitTestVertex(Vertex vertex, Vector2 localPosition, {Matrix4? globalToScene}) {
  final entry = _hitTestVertexRaw(vertex, localPosition, globalToScene: globalToScene);
  if (entry != null) return [entry];
  return const [];
}

List<SceneHitTestEntry> _hitTestEdge(Edge edge, Vector2 localPosition, {Matrix4? globalToScene}) {
  final entries = <SceneHitTestEntry>[];

  final edgeEntry = _hitTestEdgeRaw(edge, localPosition, globalToScene: globalToScene);
  if (edgeEntry != null) entries.add(edgeEntry);

  final knotEntry = _hitTestEdgeKnotsRaw(edge, localPosition, globalToScene: globalToScene);
  if (knotEntry != null) entries.add(knotEntry);

  final controlPointEntry = _hitTestEdgeKnotsControlPointsRaw(edge, localPosition, globalToScene: globalToScene);
  if (controlPointEntry != null) entries.add(controlPointEntry);

  return entries;
}

// ---------------------------
// Raw hit test methods
// --------------------------

double? _hitTestPoint(Vector2 target, Vector2 point, double tolerance) {
  final d = target - point;
  final distance = d.length;
  if (distance > tolerance) return null;
  return distance;
}

VertexHitTestEntry? _hitTestVertexRaw(Vertex vertex, Vector2 localPosition, {Matrix4? globalToScene}) {
  final tolerance = _computeScaledTolerance(globalToScene, _vertexHitTestTolerance);
  final distance = _hitTestPoint(vertex.position, localPosition, tolerance);

  if (distance != null) return VertexHitTestEntry(vertex, localPosition, distance: distance);
  return null;
}

EdgeHitTestEntry? _hitTestEdgeRaw(Edge edge, Vector2 localPosition, {Matrix4? globalToScene}) {
  final tolerance = _computeScaledTolerance(globalToScene, _edgeHitTestTolerance);

  const double flatnessTolerance = 0.5;

  final spline = edge.path;
  final n = spline.segmentCount;
  if (n == 0) return null;

  var bestDistance = double.infinity;
  var bestLocal = 0.0;

  // final weightSamples = e.weights.profile.splitIntoSegments(n);
  // final strokeWidth = e.decoration.width;

  for (var i = 0; i < n; i++) {
    final cubic = spline.segment(i);
    // final weights = weightSamples[i];
    // final maxWeight = weights.isNotEmpty ? weights.max : 1.0;

    // final bbox = cubic.bbox.inflate((strokeWidth * maxWeight) / 2);
    final bbox = cubic.bbox;
    final bboxDistance = bbox.distanceTo(localPosition);
    if (bboxDistance > tolerance || bboxDistance >= bestDistance) continue;

    final result = cubic.closestTo(localPosition);
    if (result.distance < bestDistance) {
      bestDistance = result.distance;
      bestLocal = i + result.t;
    }
  }

  if (bestDistance > tolerance) return null;
  return .new(edge, localPosition, distance: bestDistance, t: bestLocal / n);
}

EdgeKnotHitTestEntry? _hitTestEdgeKnotsRaw(Edge edge, Vector2 localPosition, {Matrix4? globalToScene}) {
  final tolerance = _computeScaledTolerance(globalToScene, _knotHitTestTolerance);
  final spline = edge.path;

  final n = spline.length;
  if (n == 0) return null;

  int? knotIndex;
  var bestKnotDistance = double.infinity;

  // Check for knots
  for (var i = 1; i < n - 1; i++) {
    final knot = spline.knot(i);
    final distance = _hitTestPoint(knot.p, localPosition, tolerance);
    if (distance != null && distance < bestKnotDistance) {
      bestKnotDistance = distance;
      knotIndex = i;
    }
  }

  if (knotIndex == null) return null;
  return .new(
    spline.knot(knotIndex),
    localPosition,
    edge: edge,
    index: knotIndex,
    distance: bestKnotDistance,
  );
}

EdgeKnotControlPointHitTestEntry? _hitTestEdgeKnotsControlPointsRaw(
  Edge edge,
  Vector2 localPosition, {
  Matrix4? globalToScene,
}) {
  final tolerance = _computeScaledTolerance(globalToScene, _knotControlPointHitTestTolerance);
  final spline = edge.path;

  final n = spline.length;
  if (n == 0) return null;

  (int, bool)? bestKnot;
  var bestDistance = double.infinity;

  for (var i = 0; i < n; i++) {
    final knot = spline.knot(i);

    final cIn = knot.cIn;
    if (cIn != knot.p) {
      final distance = _hitTestPoint(cIn, localPosition, tolerance);
      if (distance != null && distance < bestDistance) {
        bestDistance = distance;
        bestKnot = (i, true);
      }
    }

    final cOut = knot.cOut;
    if (cOut != knot.p) {
      final distance = _hitTestPoint(cOut, localPosition, tolerance);
      if (distance != null && distance < bestDistance) {
        bestDistance = distance;
        bestKnot = (i, false);
      }
    }
  }

  if (bestKnot == null) return null;
  final knot = spline.knot(bestKnot.$1);
  final controlPoint = bestKnot.$2 ? knot.cIn : knot.cOut;

  return .new(
    controlPoint,
    localPosition,
    edge: edge,
    index: bestKnot.$1,
    knot: knot,
    distance: bestDistance,
  );
}
