part of '../vector_complex.dart';

extension TraceFace on VectorComplex {
  List<RegularCycle>? traceFaceAt(Vector2 p) => _traceFaceAt(this, p);
}

List<RegularCycle>? _traceFaceAt(VectorComplex complex, Vector2 point) {
  final decomposition = _computeDecomposition(complex);
  if (decomposition.faces.isEmpty) return null;

  _DecomposedFace? best;
  for (final face in decomposition.faces) {
    if (!face.outerBbox.containsVector2(point)) continue;
    if (!_pointInPolygon(point, face.outerPolyline)) continue;

    var inHole = false;
    for (final hp in face.holePolylines) {
      if (_pointInPolygon(point, hp)) {
        inHole = true;
        break;
      }
    }

    if (inHole) continue;
    if (best == null || face.outerAreaAbsolute < best.outerAreaAbsolute) {
      best = face;
    }
  }

  if (best == null) return null;
  return [best.outer, ...best.holes];
}

class _DecomposedFace {
  _DecomposedFace({
    required this.outer,
    required this.holes,
    required this.outerPolyline,
    required this.holePolylines,
    required this.outerAreaAbsolute,
    required this.outerBbox,
  });

  final RegularCycle outer;
  final List<RegularCycle> holes;

  final List<Vector2> outerPolyline;
  final List<List<Vector2>> holePolylines;

  final double outerAreaAbsolute;
  final Aabb2 outerBbox;
}

class _FaceDecomposition {
  _FaceDecomposition(this.faces);
  final List<_DecomposedFace> faces;
}

enum _CycleKind { outer, hole, degenerate }

_FaceDecomposition _computeDecomposition(VectorComplex complex) {
  final cycles = _enumerateAllCycles(complex);

  final outers = <RegularCycle>[];
  final holes = <RegularCycle>[];

  for (final cycle in cycles) {
    switch (_classifyCycle(cycle)) {
      case .outer:
        outers.add(cycle);
      case .hole:
        holes.add(cycle);
      case .degenerate:
        break;
    }
  }

  final outerPolylines = {for (final c in outers) c: _flattenCycle(c)};
  final outerAreas = {for (final c in outers) c: _signedArea(c.halfEdges).abs()};
  final holePolylines = {for (final c in holes) c: _flattenCycle(c)};

  final outerHoles = {for (final o in outers) o: <RegularCycle>[]};
  for (final hole in holes) {
    final holePoly = holePolylines[hole]!;
    final container = _findContainingOuterCycle(hole, holePoly, outers, outerPolylines, outerAreas);
    if (container != null) outerHoles[container]!.add(hole);
  }

  final faces = <_DecomposedFace>[];
  for (final outer in outers) {
    final outerPoly = outerPolylines[outer]!;
    final outerArea = outerAreas[outer]!;
    final holes = outerHoles[outer]!;

    faces.add(
      _DecomposedFace(
        outer: outer,
        holes: holes,
        outerPolyline: outerPoly,
        holePolylines: holes.map((h) => holePolylines[h]!).toList(),
        outerAreaAbsolute: outerArea,
        outerBbox: _polylineBbox(outerPoly),
      ),
    );
  }

  return _FaceDecomposition(faces);
}

List<RegularCycle> _enumerateAllCycles(VectorComplex complex) {
  final visited = <(Edge, bool)>{};
  final cycles = <RegularCycle>[];

  for (final cell in complex.cells) {
    if (cell is! Edge) continue;

    for (final dir in const [true, false]) {
      if (visited.contains((cell, dir))) continue;

      final cycle = _walkCycle(complex, HalfEdge(cell, dir));
      if (cycle == null) continue;

      for (final he in cycle) visited.add((he.edge, he.direction));
      cycles.add(RegularCycle(cycle));
    }
  }

  return cycles;
}

List<HalfEdge>? _walkCycle(VectorComplex complex, HalfEdge start) {
  if (start.edge is ClosedEdge) return [start];

  final cycle = <HalfEdge>[];
  var h = start;

  final maxSteps = complex.length * 4 + 100;
  for (var s = 0; s < maxSteps; s++) {
    cycle.add(h);
    h = _nextInCycle(h.end, h);
    if (h.edge == start.edge && h.direction == start.direction) return cycle;
  }

  return null;
}

List<HalfEdge> _vertexRotation(Vertex v) {
  final halfedges = _vertexOutgoingHalfedges(v);

  halfedges.sort((a, b) {
    final ta = _halfedgeOutwardTangent(a);
    final tb = _halfedgeOutwardTangent(b);
    return math.atan2(ta.y, ta.x).compareTo(math.atan2(tb.y, tb.x));
  });

  return halfedges;
}

HalfEdge _nextInCycle(Vertex v, HalfEdge incoming) {
  final reversed = incoming.reversed();
  final rotation = _vertexRotation(v);
  final index = rotation.indexWhere((he) => he.edge == reversed.edge && he.direction == reversed.direction);

  if (index == -1) throw StateError('incoming halfedge not found in vertex rotation');
  return rotation[(index - 1 + rotation.length) % rotation.length];
}

_CycleKind _classifyCycle(RegularCycle cycle) {
  final first = cycle.halfEdges.first;
  if (cycle.halfEdges.length == 1 && first.edge is ClosedEdge) {
    return _classifyByArea(cycle);
  }

  var minIndex = 0;
  var minPos = first.start.position;
  for (var i = 1; i < cycle.halfEdges.length; i++) {
    final p = cycle.halfEdges[i].start.position;
    if (p.x < minPos.x || (p.x == minPos.x && p.y < minPos.y)) {
      minIndex = i;
      minPos = p;
    }
  }

  var occurrences = 0;
  for (final h in cycle.halfEdges) {
    if (h.start.position == minPos) occurrences++;
  }

  if (occurrences > 1) return _classifyByArea(cycle);

  final n = cycle.halfEdges.length;
  final leaving = cycle.halfEdges[minIndex];
  final entering = cycle.halfEdges[(minIndex - 1 + n) % n];

  final tOut = _halfedgeOutwardTangent(leaving);
  final tIn = -_halfedgeOutwardTangent(entering.reversed());

  final cross = tIn.x * tOut.y - tIn.y * tOut.x;
  if (cross.abs() < 1e-12) return _classifyByArea(cycle);

  return cross > 0 ? .outer : .hole;
}

_CycleKind _classifyByArea(RegularCycle cycle) {
  final area = _signedArea(cycle.halfEdges);
  if (area.abs() < 1e-9) return .degenerate;
  return area > 0 ? .outer : .hole;
}

RegularCycle? _findContainingOuterCycle(
  RegularCycle hole,
  List<Vector2> holePoly,
  List<RegularCycle> outers,
  Map<RegularCycle, List<Vector2>> outerPolylines,
  Map<RegularCycle, double> outerAreas,
) {
  if (holePoly.isEmpty) return null;

  var leftmost = holePoly.first;
  for (final p in holePoly) {
    if (p.x < leftmost.x || (p.x == leftmost.x && p.y < leftmost.y)) {
      leftmost = p;
    }
  }

  final bbox = _polylineBbox(holePoly);
  final scale = (bbox.max - bbox.min).length;
  final probe = leftmost + Vector2(-1e-6 * scale, 0);

  RegularCycle? best;
  var bestArea = double.infinity;

  for (final outer in outers) {
    if (!_pointInPolygon(probe, outerPolylines[outer]!)) continue;
    final area = outerAreas[outer]!;
    if (area < bestArea) {
      bestArea = area;
      best = outer;
    }
  }

  return best;
}

List<Vector2> _flattenCycle(RegularCycle cycle) {
  final pts = <Vector2>[cycle.halfEdges.first.startPosition];
  for (final he in cycle.halfEdges) {
    _walkHalfedgePolyline(he, pts.add);
  }
  return pts;
}

double _signedArea(List<HalfEdge> cycle) {
  var area = 0.0;
  var prev = cycle.first.startPosition;

  for (final h in cycle) {
    _walkHalfedgePolyline(h, (point) {
      area += (prev.x * point.y - point.x * prev.y);
      prev = point;
    });
  }

  return area;
}

void _walkHalfedgePolyline(HalfEdge h, void Function(Vector2) callback, {double tolerance = 0.5}) {
  final spline = h.edge.spline;
  for (var i = 0; i < spline.segmentCount; i++) {
    final c = spline.segment(i);
    final points = c.flatten(tolerance: tolerance);
    if (h.direction) {
      for (var j = 1; j < points.length; j++) callback(points[j]);
    } else {
      for (var j = points.length - 2; j >= 0; j--) callback(points[j]);
    }
  }
}

bool _pointInPolygon(Vector2 p, List<Vector2> poly) {
  var inside = false;
  for (var i = 0, j = poly.length - 1; i < poly.length; j = i++) {
    final yi = poly[i].y;
    final yj = poly[j].y;

    if ((yi > p.y) != (yj > p.y)) {
      final xj = poly[j].x;
      final xi = poly[i].x;
      final xCross = xj + (p.y - yj) * (xi - xj) / (yi - yj);
      if (p.x < xCross) inside = !inside;
    }
  }
  return inside;
}

Aabb2 _polylineBbox(List<Vector2> poly) {
  var min = Vector2(double.infinity, double.infinity);
  var max = Vector2(double.negativeInfinity, double.negativeInfinity);

  for (final p in poly) {
    Vector2.min(min, p, min);
    Vector2.max(max, p, max);
  }

  return Aabb2.minMax(min, max);
}

Vector2 _halfedgeOutwardTangent(HalfEdge halfedge) {
  final edge = halfedge.edge;
  final direction = halfedge.direction;

  if (edge is! OpenEdge) throw StateError('only open edges have a well-defined tangent direction');

  final spline = edge.spline;
  const epsilon = 1e-18;
  if (direction) {
    // a -> b
    final c = spline.segment(0);
    final dir = (c.c1 ?? c.b) - c.a;
    return (dir.length2 < epsilon) ? (c.b - c.a) : dir.normalized();
  } else {
    // b -> a
    final c = spline.segment(spline.segmentCount - 1);
    final dir = (c.c2 ?? c.a) - c.b;
    return (dir.length2 < epsilon) ? (c.a - c.b) : dir.normalized();
  }
}

List<HalfEdge> _vertexOutgoingHalfedges(Vertex v) {
  final result = <HalfEdge>[];
  for (final cell in v.directStar) {
    if (cell is OpenEdge) {
      if (cell.start == v) result.add(HalfEdge(cell, true));
      if (cell.end == v) result.add(HalfEdge(cell, false));
    }
  }
  return result;
}
