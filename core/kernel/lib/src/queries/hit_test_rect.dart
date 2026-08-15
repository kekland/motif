part of '../kernel.dart';

enum HitTestRectMode {
  intersect,
  contain,
  normal,
}

extension HitTestRectQuery on TopologyQuery {
  HitResult hitTestRect(Aabb2 rect, {HitTestRectMode mode = .normal}) {
    final vertices = <VertexHitEntry>[];
    final edges = <EdgeHitEntry>[];
    final faces = <FaceHitEntry>[];
    final frames = <FrameHitEntry>[];

    final containLeaves = mode == .contain;
    final containFrames = mode != .intersect;

    void walk(FrameHandle f) {
      final clip = bundle.frameClip(f);
      if (clip != null && !_faceIntersectsRect(clip, rect)) return;

      final children = bundle.frameChildren(f).toList();
      for (final child in children) {
        final kind = child.kind;
        if (kind == .vertex) {
          final p = bundle.vertexPositionWorld(child.asVertex);
          if (rect.contains(p)) vertices.add(.new(handle: child.asVertex, distance: 0.0));
        } else if (kind == .edge) {
          final c = bundle.edgeCubicWorld(child.asEdge);
          final hit = containLeaves ? c.containedInAabb(rect) : c.intersectsAabb(rect);
          if (hit) edges.add(.new(handle: child.asEdge, distance: 0.0, t: 0.0));
        } else if (kind == .face) {
          final hit = containLeaves ? _faceContainedRect(child.asFace, rect) : _faceIntersectsRect(child.asFace, rect);
          if (hit) faces.add(.new(handle: child.asFace, distance: 0.0, point: rect.center));
        } else if (kind == .frame) {
          walk(child.asFrame);
        }
      }

      if (f != bundle.root) {
        final bounds = frameBounds(f);
        if (bounds != null) {
          final hit = containFrames ? bounds.containsAabb(rect) : bounds.intersectsAabb(rect);
          if (hit) frames.add(.new(handle: f, distance: 0.0, point: rect.center));
        }
      }
    }

    walk(bundle.root);
    return HitResult(vertices: vertices, edges: edges, faces: faces, frames: frames);
  }

  bool _faceIntersectsRect(FaceHandle f, Aabb2 rect) {
    for (final cycle in bundle.faceBoundary(f)) {
      for (final u in cycle) {
        final cubic = bundle.edgeCubicWorld(u.edge);
        if (cubic.intersectsAabb(rect)) return true;
      }
    }

    return false;
  }

  bool _faceContainedRect(FaceHandle f, Aabb2 rect) {
    for (final cycle in bundle.faceBoundary(f)) {
      for (final u in cycle) {
        final cubic = bundle.edgeCubicWorld(u.edge);
        if (!cubic.containedInAabb(rect)) return false;
      }
    }

    return true;
  }
}
