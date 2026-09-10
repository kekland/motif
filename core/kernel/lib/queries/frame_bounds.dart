part of '../kernel.dart';

extension FrameBoundsQuery on TopologyQuery {
  Aabb2 hull(Iterable<Ref> refs, {FrameRef? space}) {
    final hull = Aabb2.invertedInfinity();

    for (final r in refs) {
      final b = bbox(r, space: space);
      if (b != null) hull.hull(b);
    }

    return hull;
  }

  Aabb2? bbox(Ref ref, {FrameRef? space}) {
    final spaceHandle = space != null ? bundle.frame(space)! : null;
    return switch (ref) {
      CellRef c => _cellBbox(bundle.handle(c)!, space: spaceHandle),
      CovertexRef cv => _covertexBbox(cv.resolve(bundle)!, space: spaceHandle),
    };
  }

  Aabb2? _cellBbox(CellHandle handle, {FrameHandle? space}) {
    return switch (handle.kind) {
      .vertex => .point(bundle.vertexPosition(handle.asVertex, space: space)),
      .edge => bundle.edgeCubic(handle.asEdge, space: space).bboxTight,
      .frame => _frameBbox(handle.asFrame, space: space),
      .face => _faceBbox(handle.asFace, space: space),
    };
  }

  Aabb2? _covertexBbox(Covertex cv, {FrameHandle? space}) {
    return .point(bundle.covertexPosition(cv, space: space));
  }

  Aabb2 _frameBbox(FrameHandle h, {FrameHandle? space}) {
    final transform = bundle.frameTransform(h, space: space);
    final bounds = frameBounds(h);
    return bounds != null ? bounds.transformed(transform) : .point(transform.translation2);
  }

  Aabb2 _faceBbox(FaceHandle h, {FrameHandle? space}) {
    final _space = space ?? bundle.parentOf(h);
    final hull = Aabb2.invertedInfinity();
    for (final cycle in bundle.faceBoundary(h)) {
      for (final coedge in cycle) {
        final edgeBbox = bundle.edgeCubic(coedge.edge, space: _space).bboxTight;
        hull.hull(edgeBbox);
      }
    }
    return hull;
  }

  Aabb2? frameBounds(FrameHandle h) {
    final size = bundle.frameSize(h);
    if (size != null) return size.toAabb();
    return contentBounds(h);
  }

  Aabb2? contentBounds(FrameHandle h) {
    Aabb2? out;

    void hull(Aabb2 b) {
      if (out == null) {
        out = Aabb2.copy(b);
      } else {
        out!.hull(b);
      }
    }

    for (final child in bundle.frameChildren(h)) {
      if (child.kind == .vertex) {
        hull(.point(bundle.vertexPosition(child.asVertex)));
      } else if (child.kind == .edge) {
        final v1 = bundle.edgeStart(child.asEdge);
        final v2 = bundle.edgeEnd(child.asEdge);
        if (bundle.isAncestorOf(v1, ancestor: h) && bundle.isAncestorOf(v2, ancestor: h)) {
          hull(bundle.edgeCubic(child.asEdge).bboxTight);
        }
      } else if (child.kind == .frame) {
        final f = child.asFrame;
        final inner = frameBounds(f);
        if (inner != null) {
          hull(inner.transformed(bundle.frameTransform(f)));
        }
      }
    }

    return out;
  }
}
