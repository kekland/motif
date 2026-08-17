part of '../kernel.dart';

sealed class HitEntry<T extends CellHandle> {
  const HitEntry({required this.handle, required this.distance});

  // dart format off
  static FrameHitEntry frame(FrameHandle cell, double distance, Vec2 point) => .new(handle: cell, distance: distance, point: point);
  static VertexHitEntry vertex(VertexHandle cell, double distance) => .new(handle: cell, distance: distance);
  static EdgeHitEntry edge(EdgeHandle cell, double distance, double t) => .new(handle: cell, distance: distance, t: t);
  static FaceHitEntry face(FaceHandle cell, double distance, Vec2 point) => .new(handle: cell, distance: distance, point: point);
  // dart format on

  final T handle;
  final double distance;
}

final class FrameHitEntry extends HitEntry<FrameHandle> {
  const FrameHitEntry({
    required super.handle,
    required super.distance,
    required this.point,
  });

  final Vec2 point;
}

final class VertexHitEntry extends HitEntry<VertexHandle> {
  const VertexHitEntry({required super.handle, required super.distance});
}

final class EdgeHitEntry extends HitEntry<EdgeHandle> {
  const EdgeHitEntry({
    required super.handle,
    required super.distance,
    required this.t,
  });

  final double t;
}

final class FaceHitEntry extends HitEntry<FaceHandle> {
  const FaceHitEntry({
    required super.handle,
    required super.distance,
    required this.point,
  });

  final Vec2 point;
}

class HitResult {
  HitResult({
    required this.vertices,
    required this.edges,
    required this.faces,
    required this.frames,
  });

  final List<VertexHitEntry> vertices;
  final List<EdgeHitEntry> edges;
  final List<FaceHitEntry> faces;
  final List<FrameHitEntry> frames;

  late final List<HitEntry> entries = [...vertices, ...edges, ...faces, ...frames];
  bool get isEmpty => entries.isEmpty;
}

extension HitTestQuery on TopologyQuery {
  HitResult hitTest(Vec2 p, {double tolerance = 0.0}) {
    final vertices = <VertexHitEntry>[];
    final edges = <EdgeHitEntry>[];
    final faces = <FaceHitEntry>[];
    final frames = <FrameHitEntry>[];

    void walk(FrameHandle f) {
      final clip = bundle.frameClip(f);
      if (clip != null && !_faceContains(clip, p, tolerance)) return;

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
        final transform = bundle.frameTransformWorld(f);
        final world = bounds.transformed(transform).inflated(tolerance);
        if (world.contains(p)) {
          final localPosition = transform.inverted().transform2(p);
          frames.add(.new(handle: f, distance: 0.0, point: localPosition));
        }
      }
    }

    walk(bundle.root);

    _sortByDistance(vertices);
    _sortByDistance(edges);

    return HitResult(vertices: vertices, edges: edges, faces: faces, frames: frames);
  }

  VertexHitEntry? _hitTestVertex(VertexHandle v, Vec2 p, double tolerance) {
    final d = p.distanceTo(bundle.vertexPositionWorld(v));
    if (d <= tolerance) return .new(handle: v, distance: d);
    return null;
  }

  EdgeHitEntry? _hitTestEdge(EdgeHandle e, Vec2 p, double tolerance) {
    final c = bundle.edgeCubicWorld(e);
    if (c.bbox.distance2To(p) > tolerance * tolerance) return null;

    final r = c.closestPoint(p);
    if (r.distance <= tolerance) return .new(handle: e, distance: r.distance, t: r.t);

    return null;
  }

  FaceHitEntry? _hitTestFace(FaceHandle f, Vec2 p, double tolerance) {
    if (!_faceContains(f, p, tolerance)) return null;
    return .new(handle: f, distance: 0.0, point: p);
  }

  bool _faceContains(FaceHandle f, Vec2 p, double tolerance) {
    if (bundle._faceWinding(f, p) != 0) return true;
    if (tolerance <= 0.0) return false;

    final tolerance2 = tolerance * tolerance;

    for (final cycle in bundle.faceBoundary(f)) {
      for (final u in cycle) {
        final c = bundle.edgeCubicWorld(u.edge);
        if (c.bbox.distance2To(p) > tolerance2) continue;
        if (c.closestPoint(p).distance <= tolerance) return true;
      }
    }

    return false;
  }

  void _sortByDistance<T extends HitEntry>(List<T> list) {
    if (list.length < 2) return;
    final order = <T, int>{for (var i = 0; i < list.length; i++) list[i]: i};
    list.sort((a, b) {
      final c = a.distance.compareTo(b.distance);
      return c != 0 ? c : order[a]!.compareTo(order[b]!);
    });
  }
}
