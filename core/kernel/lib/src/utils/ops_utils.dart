part of '../kernel.dart';

extension type const CellPlacement._((CellId? parent, SiblingKeyAnchor anchor) p) {
  CellPlacement.of(TopologyBundle bundle, CellHandle h)
    : this._((
        bundle.parentOf(h)?.asId(bundle),
        switch (bundle.siblingPrevOf(h)) {
          null => .prepend(),
          final prev => .after(prev.asKey(bundle)),
        },
      ));

  static const prepend = CellPlacement._((null, .prepend()));
  static const append = CellPlacement._((null, .append()));

  CellId? get parent => p.$1;
  SiblingKeyAnchor get anchor => p.$2;

  FrameHandle? resolveParent(TopologyBundle bundle) {
    if (parent == null) return null;
    final handle = bundle.frame(parent!);
    if (handle == null) throw StateError('referenced unknown frame $parent');
    return handle;
  }

  SiblingHandleAnchor resolveAnchor(TopologyBundle bundle) {
    return anchor.map((h) {
      final handle = bundle.handle(h);
      if (handle == null) throw StateError('referenced unknown cell $h');
      return handle;
    });
  }
}

extension OpsUtils on TopologyTransaction {
  CellHandle cellFor(CellKey key) => bundle.handle(key) ?? (throw StateError('referenced unknown cell $key'));
  FrameHandle frameFor(CellId id) => bundle.frame(id) ?? (throw StateError('referenced unknown frame $id'));
  VertexHandle vertexFor(CellId id) => bundle.vertex(id) ?? (throw StateError('referenced unknown vertex $id'));
  EdgeHandle edgeFor(CellId id) => bundle.edge(id) ?? (throw StateError('referenced unknown edge $id'));
  FaceHandle faceFor(CellId id) => bundle.face(id) ?? (throw StateError('referenced unknown face $id'));

  Cycle cycleFor(CycleRef ref) => ref.resolve(bundle) ?? (throw StateError('referenced unknown edge in $ref'));
  Coedge coedgeFor(CoedgeRef ref) => ref.resolve(bundle) ?? (throw StateError('referenced unknown edge in $ref'));
  Covertex covertexFor(CovertexRef ref) => ref.resolve(bundle) ?? (throw StateError('referenced unknown vertex $ref'));

  void markFrameMoved(FrameHandle f) {
    delta.markMoved(bundle.frameKey(f));
  }

  void markVertexMoved(VertexHandle v) {
    delta.markMoved(bundle.vertexKey(v));
    for (final e in bundle.vertexEdges(v)) {
      markEdgeMoved(e);
    }
  }

  void markEdgeMoved(EdgeHandle e) {
    delta.markMoved(bundle.edgeKey(e));
    for (final f in bundle.edgeFaces(e)) {
      markFaceMoved(f);
    }
  }

  void markFaceMoved(FaceHandle f) {
    delta.markMoved(bundle.faceKey(f));
  }

  R _compositeOp<R>(CompositeOp Function(List<TopologyOp> children) fold, R Function() body) {
    final mark = ops.length;
    final result = body();

    if (ops.length > mark) {
      final children = ops.sublist(mark);
      ops.removeRange(mark, ops.length);
      ops.add(fold(children));
    }

    return result;
  }

  // void _remapFaceBoundary(FaceHandle f, Cycle? Function(Cycle) transform) {
  //   var changed = false;
  //   final newBoundary = <Cycle>[];
  //   for (final c in bundle.faceBoundary(f)) {
  //     final t = transform(c);
  //     newBoundary.add(t ?? c);
  //     if (t != null) changed = true;
  //   }

  //   if (changed) _setFaceBoundary(f, newBoundary);
  // }

  // void _absorbEdge(EdgeHandle from, {required EdgeHandle into, bool flip = false}) {
  //   final affectedFaces = bundle.edgeUses(from).map((e) => e.$1).toSet();
  //   for (final f in affectedFaces) {
  //     _remapFaceBoundary(f, (c) {
  //       if (!c.hasEdge(from)) return null;
  //       return c.map((u) => u.edge == from ? u.withEdge(into, flip: flip) : u);
  //     });
  //   }
  //   deleteEdge(from);
  // }

  // void _absorbFace(FaceHandle from, {required FaceHandle into}) {
  //   final moveBoundary = bundle.faceBoundary(from).toList();
  //   final intoBoundary = bundle.faceBoundary(into).toList();
  //   _setFaceBoundary(into, [...intoBoundary, ...moveBoundary]);
  //   deleteFace(from);
  // }

  void _eraseEdgeUses(EdgeHandle e) {
    final affectedFaces = bundle.edgeUses(e).map((e) => e.$1).toSet();

    for (final f in affectedFaces) {
      final boundary = bundle.faceBoundary(f).toList();
      final kept = <Cycle>[];
      for (final c in boundary) {
        if (c.coedges.any((u) => u.edge != e)) {
          kept.add(c.where((u) => u.edge != e));
        }
      }

      if (kept.isEmpty) {
        deleteFace(f);
      } else {
        _setFaceBoundary(f, kept);
      }
    }
  }
}
