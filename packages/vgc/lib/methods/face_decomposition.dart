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
    if (!face.outerPolyline.contains(point)) continue;

    var inHole = false;
    for (final hp in face.holePolylines) {
      if (hp.contains(point)) {
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

  final Polyline2 outerPolyline;
  final List<Polyline2> holePolylines;

  final double outerAreaAbsolute;
  final Aabb2 outerBbox;
}

class _FaceDecomposition {
  _FaceDecomposition(this.faces);
  final List<_DecomposedFace> faces;
}

enum _CycleKind { outer, hole, degenerate }

_FaceDecomposition _computeDecomposition(VectorComplex complex) {
  const kCubicTolerance = 0.5;

  final cycles = _enumerateAllCycles(complex);
  final cyclePolylines = <RegularCycle, Polyline2>{};
  final cycleSignedAreas = <RegularCycle, double>{};

  final outers = <RegularCycle>[];
  final holes = <RegularCycle>[];

  for (final cycle in cycles) {
    final polyline = cycle.flatten(tolerance: kCubicTolerance);
    final signedArea = polyline.signedArea;

    cyclePolylines[cycle] = polyline;
    cycleSignedAreas[cycle] = signedArea;

    switch (_classifyCycle(cycle, signedArea)) {
      case .outer:
        outers.add(cycle);
      case .hole:
        holes.add(cycle);
      case .degenerate:
        break;
    }
  }

  final outerPolylines = {for (final c in outers) c: cyclePolylines[c]!};
  final outerAreas = {for (final e in outerPolylines.entries) e.key: cycleSignedAreas[e.key]!};
  final holePolylines = {for (final c in holes) c: cyclePolylines[c]!};

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
        outerAreaAbsolute: outerArea.abs(),
        outerBbox: outerPoly.bbox,
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
  final halfedges = v.outgoingHalfEdges.toList();

  halfedges.sort((a, b) {
    final ta = a.outwardTangent;
    final tb = b.outwardTangent;
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

_CycleKind _classifyCycle(RegularCycle cycle, double signedArea) {
  return _classifyByArea(signedArea);

  final first = cycle.halfEdges.first;
  if (cycle.halfEdges.length == 1 && first.edge is ClosedEdge) return _classifyByArea(signedArea);

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

  if (occurrences > 1) return _classifyByArea(signedArea);

  final n = cycle.halfEdges.length;
  final leaving = cycle.halfEdges[minIndex];
  final entering = cycle.halfEdges[(minIndex - 1 + n) % n];

  final tOut = leaving.outwardTangent;
  final tIn = -entering.reversed().outwardTangent;

  final cross = tIn.x * tOut.y - tIn.y * tOut.x;
  if (cross.abs() < 1e-12) return _classifyByArea(signedArea);

  return cross > 0 ? .outer : .hole;
}

_CycleKind _classifyByArea(double area) {
  if (area.abs() < 1e-9) return .degenerate;
  return area > 0 ? .outer : .hole;
}

RegularCycle? _findContainingOuterCycle(
  RegularCycle hole,
  Polyline2 holePoly,
  List<RegularCycle> outers,
  Map<RegularCycle, Polyline2> outerPolylines,
  Map<RegularCycle, double> outerAreas,
) {
  if (holePoly.isEmpty) return null;

  final leftmost = holePoly.leftmostPoint;
  final bbox = holePoly.bbox;
  final scale = (bbox.max - bbox.min).length;
  final probe = leftmost + Vector2(-1e-6 * scale, 0);

  RegularCycle? best;
  var bestArea = double.infinity;

  for (final outer in outers) {
    final outerPoly = outerPolylines[outer]!;
    if (!outerPoly.contains(probe)) continue;

    final area = outerAreas[outer]!;
    if (area < bestArea) {
      bestArea = area;
      best = outer;
    }
  }

  return best;
}
