part of '../kernel.dart';

sealed class HitEntry<R extends Ref> {
  const HitEntry(this.ref, {required this.distance});

  // dart format off
  static FrameHitEntry frame(FrameRef ref, double distance, Vec2 point) => .new(ref, distance: distance, point: point);
  static VertexHitEntry vertex(VertexRef ref, double distance) => .new(ref, distance: distance);
  static EdgeHitEntry edge(EdgeRef ref, double distance, double t) => .new(ref, distance: distance, t: t);
  static FaceHitEntry face(FaceRef ref, double distance, Vec2 point) => .new(ref, distance: distance, point: point);
  // dart format on

  final R ref;
  final double distance;
}

final class FrameHitEntry extends HitEntry<FrameRef> {
  const FrameHitEntry(
    super.ref, {
    required super.distance,
    required this.point,
  });

  final Vec2 point;
}

final class CovertexHitEntry extends HitEntry<CovertexRef> {
  const CovertexHitEntry(super.ref, {required super.distance});
}

final class VertexHitEntry extends HitEntry<VertexRef> {
  const VertexHitEntry(super.ref, {required super.distance});
}

final class EdgeHitEntry extends HitEntry<EdgeRef> {
  const EdgeHitEntry(
    super.ref, {
    required super.distance,
    required this.t,
  });

  final double t;
}

final class FaceHitEntry extends HitEntry<FaceRef> {
  const FaceHitEntry(
    super.ref, {
    required super.distance,
    required this.point,
  });

  final Vec2 point;
}

class HitResult {
  HitResult({
    required this.vertices,
    required this.covertices,
    required this.edges,
    required this.faces,
    required this.frames,
  });

  final List<VertexHitEntry> vertices;
  final List<CovertexHitEntry> covertices;
  final List<EdgeHitEntry> edges;
  final List<FaceHitEntry> faces;
  final List<FrameHitEntry> frames;

  late final List<HitEntry> entries = [...vertices, ...covertices, ...edges, ...faces, ...frames];
  bool get isEmpty => entries.isEmpty;
}

final class HitTestCovertexMode {
  const HitTestCovertexMode._(this.all, this.covertices, this.allowCollapsed);

  const HitTestCovertexMode.all({this.allowCollapsed = false}) : all = true, covertices = null;
  const HitTestCovertexMode.some(this.covertices, {this.allowCollapsed = false}) : all = false;
  static const HitTestCovertexMode none = ._(false, null, false);

  final bool all;
  final Set<CovertexRef>? covertices;
  final bool allowCollapsed;
}

extension HitTestQuery on TopologyQuery {
  HitResult hitTest(
    Vec2 p, {
    double tolerance = 0.0,
    HitTestCovertexMode covertexMode = .none,
  }) {
    final vertices = <VertexHitEntry>[];
    final covertices = <CovertexHitEntry>[];
    final edges = <EdgeHitEntry>[];
    final faces = <FaceHitEntry>[];
    final frames = <FrameHitEntry>[];

    void walk(FrameHandle f) {
      final clip = bundle.frameClip(f);
      if (f != .root && clip != null && !_faceContains(clip, p, tolerance)) return;

      final children = bundle.frameChildren(f).toList();
      for (final child in children.reversed) {
        final kind = child.kind;

        if (kind == .vertex) {
          final e = _hitTestVertex(child.asVertex, p, tolerance);
          if (e != null) vertices.add(e);
        } else if (kind == .edge) {
          final e = _hitTestEdge(child.asEdge, p, tolerance);
          if (e != null) edges.add(e);
        } else if (kind == .face) {
          final e = _hitTestFace(child.asFace, p, tolerance);
          if (e != null) faces.add(e);
        } else if (kind == .frame) {
          walk(child.asFrame);
        }
      }

      final bounds = frameBounds(f);
      if (f.index != .root && bounds != null) {
        final worldToLocal = bundle.transformBetween(bundle.root, f);
        final local = worldToLocal.transform2(p);
        final scale = worldToLocal.maxScaleOnAxis;

        if (bounds.inflated(tolerance * scale).contains(local)) {
          frames.add(.new(f.ref(bundle), distance: 0.0, point: local));
        }
      }
    }

    walk(bundle.root);

    final Iterable<Covertex?> cvs;
    if (covertexMode.all) {
      cvs = bundle.covertices;
    } else if (covertexMode.covertices != null) {
      cvs = covertexMode.covertices!.map((r) => r.resolve(bundle));
    } else {
      cvs = const [];
    }

    for (final cv in cvs) {
      if (cv == null) continue;
      final e = _hitTestCovertex(cv, p, tolerance, allowCollapsed: covertexMode.allowCollapsed);
      if (e != null) covertices.add(e);
    }

    _sortByDistance(vertices);
    _sortByDistance(covertices);
    _sortByDistance(edges);

    return HitResult(
      vertices: vertices,
      covertices: covertices,
      edges: edges,
      faces: faces,
      frames: frames,
    );
  }

  VertexHitEntry? _hitTestVertex(VertexHandle v, Vec2 p, double tolerance) {
    final d = p.distanceTo(bundle.vertexPosition(v, space: .root));
    if (d > tolerance) return null;
    return .new(v.ref(bundle), distance: d);
  }

  CovertexHitEntry? _hitTestCovertex(
    Covertex c,
    Vec2 p,
    double tolerance, {
    CovertexRef? ref,
    bool allowCollapsed = false,
  }) {
    if (!allowCollapsed && bundle.covertexTangentCollapsed(c)) return null;
    final d = p.distanceTo(bundle.covertexPosition(c, space: .root));
    if (d > tolerance) return null;
    return .new(ref ?? c.ref(bundle), distance: d);
  }

  EdgeHitEntry? _hitTestEdge(EdgeHandle e, Vec2 p, double tolerance) {
    final bbox = bundle.edgeBbox(e, space: .root);
    if (bbox.distance2To(p) > tolerance * tolerance) return null;

    final c = bundle.edgeCubic(e, space: .root);
    final r = c.closestPoint(p);
    if (r.distance > tolerance) return null;
    return .new(e.ref(bundle), distance: r.distance, t: r.t);
  }

  FaceHitEntry? _hitTestFace(FaceHandle f, Vec2 p, double tolerance) {
    if (!_faceContains(f, p, tolerance)) return null;
    return .new(f.ref(bundle), distance: 0.0, point: p);
  }

  bool _faceContains(FaceHandle f, Vec2 p, double tolerance) {
    // if (bundle.query.cellBboxWorld(f).distance2To(p) > tolerance * tolerance) return false;
    if (bundle.faceWinding(f, p, space: .root) != 0) return true;
    if (tolerance <= 0.0) return false;

    final tolerance2 = tolerance * tolerance;

    for (final cycle in bundle.faceBoundary(f)) {
      for (final u in cycle) {
        final c = bundle.edgeCubic(u.edge, space: .root);
        if (c.bbox.distance2To(p) > tolerance2) continue;
        if (c.closestPoint(p).distance <= tolerance) return true;
      }
    }

    return false;
  }

  void _sortByDistance<T extends HitEntry>(List<T> list) {
    if (list.length < 2) return;
    mergeSort(list, compare: (a, b) => a.distance.compareTo(b.distance));
  }
}
