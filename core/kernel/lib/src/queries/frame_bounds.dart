part of '../kernel.dart';

extension FrameBoundsQuery on TopologyQuery {
  Aabb2 cellBbox(CellHandle h) {
    if (h.kind == .vertex) {
      return .point(bundle.vertexPosition(h.asVertex));
    } else if (h.kind == .edge) {
      return bundle.edgeCubic(h.asEdge).bbox;
    } else if (h.kind == .frame) {
      final bounds = frameBounds(h.asFrame);
      if (bounds != null) return bounds;
      final transform = bundle.frameTransform(h.asFrame);
      return .point(transform.translation2);
    } else if (h.kind == .face) {
      final hull = Aabb2.invertedInfinity();
      final boundary = bundle.faceBoundary(h.asFace);
      for (final cycle in boundary) {
        for (final coedge in cycle) {
          final edgeBbox = bundle.edgeCubic(coedge.edge, space: bundle.parentOf(h)).bbox;
          hull.hull(edgeBbox);
        }
      }
      return hull;
    }

    throw ArgumentError('Invalid cell kind: ${h.kind}');
  }

  Aabb2 cellBboxWorld(CellHandle h) {
    if (h.kind == .vertex) {
      return .point(bundle.vertexPositionWorld(h.asVertex));
    } else if (h.kind == .edge) {
      return bundle.edgeCubicWorld(h.asEdge).bbox;
    } else if (h.kind == .frame) {
      final bounds = frameBounds(h.asFrame);
      final transform = bundle.frameTransformWorld(h.asFrame);
      if (bounds != null) return bounds.transformed(transform);
      return .point(transform.translation2);
    } else if (h.kind == .face) {
      final hull = Aabb2.invertedInfinity();
      final boundary = bundle.faceBoundary(h.asFace);
      for (final cycle in boundary) {
        for (final coedge in cycle) {
          final edgeBbox = bundle.edgeCubicWorld(coedge.edge).bbox;
          hull.hull(edgeBbox);
        }
      }
      return hull;
    }

    throw ArgumentError('Invalid cell kind: ${h.kind}');
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
        if (bundle._isAncestorOf(v1, ancestor: h) && bundle._isAncestorOf(v2, ancestor: h)) {
          hull(bundle.edgeCubic(child.asEdge).bbox);
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
