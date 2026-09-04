part of '../kernel.dart';

final class Region {
  Region(this.outer, this.holes, this.area);

  final Cycle outer;
  final List<Cycle> holes;

  final double area;
}

final class Arrangement {
  Arrangement._(this._bundle, this._version, this.regions);

  factory Arrangement.of(TopologyBundle bundle) {
    return _computeArrangement(bundle);
  }

  final TopologyBundle _bundle;
  final int _version;
  final List<Region> regions;

  Region? regionAt(Vec2 p) => _arrangementRegionAt(this, p);
}

Vec2 _outwardTangent(TopologyBundle b, Coedge u) {
  var c = b.edgeCubicWorld(u.edge);
  if (!u.forward) c = c.reversed();

  var d = c.p1 - c.p0;
  if (d.length2 < 1e-9) d = c.p2 - c.p0;
  if (d.length2 < 1e-9) d = c.p3 - c.p0;

  return d;
}

Arrangement _computeArrangement(TopologyBundle bundle) {
  final rotation = <VertexHandle, List<Coedge>>{};
  for (final v in bundle.vertices) {
    final out = bundle
        .vertexUses(v)
        .map((cv) => Coedge(cv.edge, forward: cv.isStart))
        .where((c) => !bundle.edgeCollapsed(c.edge))
        .toList();

    final angles = <Coedge, double>{};
    for (final u in out) {
      final t = _outwardTangent(bundle, u);
      angles[u] = math.atan2(t.y, t.x);
    }

    out.sort((a, b) => angles[a]!.compareTo(angles[b]!));
    rotation[v] = out;
  }

  final visited = <Coedge>{};
  final bounded = <(Cycle, double)>[];
  final contours = <Cycle>[];
  final maxSteps = bundle.edgeCount * 4 + 100;

  for (final entry in rotation.values) {
    for (final start in entry) {
      if (visited.contains(start)) continue;
      final walk = <Coedge>[];
      var h = start;
      var ok = false;

      for (var s = 0; s < maxSteps; s++) {
        walk.add(h);
        final v = bundle.coedgeEnd(h);
        final r = h.reversed;
        final rot = rotation[v]!;
        final i = rot.indexOf(r);
        if (i == -1) break;

        h = rot[(i - 1 + rot.length) % rot.length];
        if (h == start) {
          ok = true;
          break;
        }
      }

      if (!ok) continue;
      visited.addAll(walk);
      final cycle = Cycle(walk);
      final area = bundle.cycleSignedArea(cycle);
      if (area.abs() < 1e-9) continue;
      if (area > 0) {
        bounded.add((cycle, area));
      } else {
        contours.add(cycle);
      }
    }
  }

  bounded.sort((a, b) => a.$2.compareTo(b.$2));

  final holesOf = <int, List<Cycle>>{};
  for (final contour in contours) {
    final first = contour.first;
    final probe = bundle.edgeCubicWorld(first.edge).point(0.5);

    final contourEdges = {for (final u in contour) u.edge};
    for (var i = 0; i < bounded.length; i++) {
      if (bounded[i].$1.any((u) => contourEdges.contains(u.edge))) continue;
      if (bundle._cycleWinding(bounded[i].$1, probe) != 0) {
        holesOf.putIfAbsent(i, () => []).add(contour);
        break;
      }
    }
  }

  final regions = <Region>[];
  for (var i = 0; i < bounded.length; i++) {
    regions.add(Region(bounded[i].$1, holesOf[i] ?? [], bounded[i].$2));
  }

  return Arrangement._(bundle, bundle._version, regions);
}

Region? _arrangementRegionAt(Arrangement arrangement, Vec2 p) {
  final bundle = arrangement._bundle;
  if (bundle.version != arrangement._version) throw StateError('arrangement is stale');

  for (final region in arrangement.regions) {
    if (bundle._cycleWinding(region.outer, p) == 0) continue;

    var inHole = false;
    for (final hole in region.holes) {
      if (bundle._cycleWinding(hole, p) != 0) {
        inHole = true;
        break;
      }
    }

    if (!inHole) return region;
  }

  return null;
}
