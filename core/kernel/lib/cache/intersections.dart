part of '../kernel.dart';

class EdgeIntersection {
  EdgeIntersection(this.a, this.b, this.ta, this.tb, this.point);
  EdgeIntersection.from(EdgeHandle a, EdgeHandle b, Intersection i) : this(a, b, i.ta, i.tb, i.point);

  final EdgeHandle a, b;
  final double ta, tb;
  final Vec2 point;

  double tOn(EdgeHandle e) {
    assert(e == a || e == b);
    return e == a ? ta : tb;
  }

  EdgeHandle other(EdgeHandle e) {
    assert(e == a || e == b);
    return e == a ? b : a;
  }
}

final class EdgeOverlap {
  EdgeOverlap(this.a, this.b, this.ta0, this.ta1, this.tb0, this.tb1);
  EdgeOverlap.from(EdgeHandle a, EdgeHandle b, Overlap o) : this(a, b, o.ta0, o.ta1, o.tb0, o.tb1);

  final EdgeHandle a, b;
  final double ta0, ta1, tb0, tb1;

  EdgeHandle other(EdgeHandle e) {
    assert(e == a || e == b);
    return e == a ? b : a;
  }
}

final class EdgeSelfIntersection extends EdgeIntersection {
  EdgeSelfIntersection(EdgeHandle e, double t0, double t1, Vec2 point) : super(e, e, t0, t1, point);
  EdgeSelfIntersection.from(EdgeHandle e, Intersection i) : this(e, i.ta, i.tb, i.point);
}

final class EdgePairIntersections {
  EdgePairIntersections(this.a, this.b, this.intersections, this.overlaps);

  final EdgeHandle a, b;
  final List<EdgeIntersection> intersections;
  final List<EdgeOverlap> overlaps;

  bool get isEmpty => intersections.isEmpty && overlaps.isEmpty;
}

final class IntersectionCache {
  IntersectionCache(this.bundle) {
    bundle._edge.observe(_edgeObserver);
    bundle._frame.observe(_frameObserver);
    _edgeObserver._touched.addAll(bundle._edge.liveIndices);
  }

  final Bundle bundle;

  final _map = <EdgeIndex, Map<EdgeIndex, EdgePairIntersections>>{};
  final _selfIntersections = <EdgeIndex, EdgeSelfIntersection>{};

  Iterable<EdgePairIntersections>? _pairsOf(EdgeHandle e) {
    _flush();
    return _map[e.index]?.values;
  }

  Iterable<EdgeIntersection> of(EdgeHandle e) {
    return _pairsOf(e)?.expand((p) => p.intersections) ?? const [];
  }

  Iterable<EdgeOverlap> overlaps(EdgeHandle e) {
    return _pairsOf(e)?.expand((p) => p.overlaps) ?? const [];
  }

  EdgeSelfIntersection? self(EdgeHandle e) {
    _flush();
    return _selfIntersections[e.index];
  }

  Map<EdgeHandle, Intersections> withCubic(Cubic2 cubic, {VertexHandle? start, VertexHandle? end}) {
    _flush();

    final result = <EdgeHandle, Intersections>{};
    for (final o in _candidates(cubic.bboxTight)) {
      final r = _intersect(cubic, o, start: start?.index, end: end?.index);
      if (r != null) result[bundle._edge.handleFor(o)] = r;
    }

    return result;
  }

  late final _edgeObserver = CacheArenaObserver<EdgeIndex>();
  late final _frameObserver = CacheArenaObserver<FrameIndex>();
  bool get isDirty => _edgeObserver.isNotEmpty || _frameObserver.isNotEmpty;

  void _flush() {
    if (!isDirty) return;
    for (final e in _edgeObserver._retired) _detach(e);
    for (final f in _frameObserver.touched) {
      _edgeObserver._touched.addAll(bundle._frameDependentCells(f, kind: .edge).map((e) => e.asEdge));
    }

    final dirty = _edgeObserver._touched.where((e) => bundle._edge.isLive(e));
    for (final e in dirty) _detach(e);

    final done = HashSet<EdgeIndex>();
    for (final e in dirty) {
      final cubic = bundle._edgeCubic(e, space: .root);
      final bbox = bundle._edgeBbox(e, space: .root);

      final self = cubic.selfIntersect();
      if (self != null) _selfIntersections[e] = .from(bundle._edge.handleFor(e), self);

      for (final o in _candidates(bbox)) {
        if (e == o || done.contains(o)) continue;
        _compute(e, o, cubic);
      }

      done.add(e);
    }

    _edgeObserver.clear();
    _frameObserver.clear();
  }

  void _compute(EdgeIndex a, EdgeIndex b, Cubic2 ca) {
    final result = _intersect(ca, b, start: bundle._edge.vStart[a], end: bundle._edge.vEnd[a]);
    if (result == null) return;

    final ha = bundle._edge.handleFor(a), hb = bundle._edge.handleFor(b);
    final pair = EdgePairIntersections(
      ha,
      hb,
      result.intersections.map((i) => EdgeIntersection.from(ha, hb, i)).toList(),
      result.overlaps.map((o) => EdgeOverlap.from(ha, hb, o)).toList(),
    );

    _store(a, b, pair);
  }

  Iterable<EdgeIndex> _candidates(Aabb2 bbox) {
    final candidates = <EdgeIndex>[];

    for (final e in bundle._edge.liveIndices) {
      final b = bundle._edgeBbox(e, space: .root);
      if (b.intersectsAabb(bbox)) candidates.add(e);
    }

    return candidates;
  }

  Intersections? _intersect(Cubic2 cubic, EdgeIndex edge, {VertexIndex? start, VertexIndex? end}) {
    final result = cubic.intersect(bundle._edgeCubic(edge, space: .root));
    if (result.isEmpty) return null;

    final keptIntersections = result.intersections.toList();
    keptIntersections.removeWhere((i) => _isIntersectionAtVertex(i, edge, start: start, end: end));

    if (keptIntersections.isEmpty && result.overlaps.isEmpty) return null;
    return .new(keptIntersections, result.overlaps);
  }

  bool _isIntersectionAtVertex(Intersection i, EdgeIndex e, {VertexIndex? start, VertexIndex? end}) {
    final a = i.resolveEndpointsA(() => start, () => end);
    final b = i.resolveEndpointsB(() => bundle._edge.vStart[e], () => bundle._edge.vEnd[e]);
    return a != null && a == b;
  }

  void _store(EdgeIndex a, EdgeIndex b, EdgePairIntersections pair) {
    _map.putIfAbsent(a, () => {})[b] = pair;
    _map.putIfAbsent(b, () => {})[a] = pair;
  }

  void _detach(EdgeIndex e) {
    _selfIntersections.remove(e);
    final pairs = _map.remove(e);
    if (pairs == null) return;
    for (final other in pairs.keys) _map[other]?.remove(e);
  }
}
