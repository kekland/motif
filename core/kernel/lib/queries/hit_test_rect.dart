part of '../kernel.dart';

enum HitTestRectMode {
  intersect,
  contain,
  normal,
}

extension HitTestRectQuery on TopologyQuery {
  HitResult hitTestRect(Aabb2 rect, {HitTestRectMode mode = .normal}) {
    final entries = <HitEntry>[];

    final containLeaves = mode == .contain;
    final containFrames = mode != .intersect;

    void walk(FrameHandle f) {
      final clip = bundle.frameClip(f);
      if (clip != null && !_faceIntersectsRect(clip, rect)) return;

      final children = bundle.frameChildren(f).toList();
      for (final child in children) {
        final kind = child.kind;
        if (kind == .vertex) {
          final p = bundle.vertexPosition(child.asVertex, space: .root);
          if (rect.contains(p)) entries.add(.vertex(child.asVertex.ref(bundle), 0.0));
        } else if (kind == .edge) {
          final c = bundle.edgeCubic(child.asEdge, space: .root);
          final hit = containLeaves ? c.containedInAabb(rect) : c.intersectsAabb(rect);
          if (hit) entries.add(.edge(child.asEdge.ref(bundle), 0.0, 0.0));
        } else if (kind == .face) {
          final hit = containLeaves ? _faceContainedRect(child.asFace, rect) : _faceIntersectsRect(child.asFace, rect);
          if (hit) entries.add(.face(child.asFace.ref(bundle), 0.0, rect.center));
        } else if (kind == .frame) {
          walk(child.asFrame);
        }
      }

      if (f != bundle.root) {
        final bounds = bbox(f.ref(bundle), space: .root);
        if (bounds != null) {
          final hit = containFrames ? rect.containsAabb(bounds) : rect.intersectsAabb(bounds);
          if (hit) entries.add(.frame(f.asFrame.ref(bundle), 0.0, rect.center));
        }
      }
    }

    walk(bundle.root);
    return HitResult(entries);
  }

  bool _faceIntersectsRect(FaceHandle f, Aabb2 rect) {
    if (bundle.faceWinding(f, rect.center, space: .root) != 0) return true;
    for (final cycle in bundle.faceBoundary(f)) {
      for (final u in cycle) {
        final cubic = bundle.edgeCubic(u.edge, space: .root);
        if (cubic.intersectsAabb(rect)) return true;
      }
    }

    return false;
  }

  bool _faceContainedRect(FaceHandle f, Aabb2 rect) {
    for (final cycle in bundle.faceBoundary(f)) {
      for (final u in cycle) {
        final cubic = bundle.edgeCubic(u.edge, space: .root);
        if (!cubic.containedInAabb(rect)) return false;
      }
    }

    return true;
  }
}
