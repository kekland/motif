part of '../kernel.dart';

final class EdgeAdd(
  final CellId id,
  final CellId start,
  final CellId end,
  final Vec2? startTangent,
  final Vec2? endTangent,
  final CellPlacement placement,
) extends Mutation {
  @override
  EdgeHandle reapply(Transaction txn) => txn.bundle._edgeAdd(
    id,
    txn.vertexFor(start),
    txn.vertexFor(end),
    startTangent: startTangent,
    endTangent: endTangent,
    parent: placement.resolveParent(txn),
  );

  @override
  void unapply(Transaction txn) => txn.bundle._edgeFree(
    txn.edgeFor(id),
  );
}

final class EdgeDelete(
  final CellId id,
  final CellPlacement placement,
) extends Mutation {
  @override
  void reapply(Transaction txn) => txn.bundle._edgeRemove(
    txn.edgeFor(id),
  );

  @override
  void unapply(Transaction txn) => txn.bundle._edgeRelink(
    txn.edgeFor(id),
    parent: placement.resolveParent(txn),
  );
}

final class EdgeRepoint extends Mutation {
  EdgeRepoint(this.edge, {this.start, this.end});

  final CellId edge;
  final ({CellId from, CellId to})? start;
  final ({CellId from, CellId to})? end;

  @override
  void reapply(Transaction txn) => txn.bundle._edgeRepoint(
    txn.edgeFor(edge),
    start: start != null ? txn.vertexFor(start!.to) : null,
    end: end != null ? txn.vertexFor(end!.to) : null,
  );

  @override
  void unapply(Transaction txn) => txn.bundle._edgeRepoint(
    txn.edgeFor(edge),
    start: start != null ? txn.vertexFor(start!.from) : null,
    end: end != null ? txn.vertexFor(end!.from) : null,
  );
}

extension EdgeMutationTransaction on Transaction {
  EdgeHandle _addEdge(
    VertexHandle start,
    VertexHandle end, {
    Vec2? startTangent,
    Vec2? endTangent,
    FrameHandle? parent,
  }) {
    final handle = _addCell(
      (id) => EdgeAdd(
        id,
        start.id(bundle),
        end.id(bundle),
        startTangent,
        endTangent,
        .from(bundle, parent),
      ),
      (id) => bundle.edge(id)!,
    );

    _setEdgeTangents(handle, start: startTangent, end: endTangent);
    return handle;
  }

  void _deleteEdge(EdgeHandle handle, {bool cascade = false}) {
    _checkOpen();
    if (mode != .topology) return;

    if (bundle.edgeHasUses(handle)) {
      if (!cascade) throw StateError('cannot delete edge $handle with uses');
      for (final face in bundle.edgeFaces(handle).toSet()) _deleteFace(face);
    }

    _deleteCell(handle, EdgeDelete(handle.id(bundle), .of(bundle, handle)));
  }

  void _repointEdge(EdgeHandle e, {VertexHandle? start, VertexHandle? end}) {
    _checkOpen();
    if (mode != .topology) return;

    final oldStart = bundle.edgeStart(e);
    final oldEnd = bundle.edgeEnd(e);
    if (start != null && start == oldStart) start = null;
    if (end != null && end == oldEnd) end = null;
    if (start == null && end == null) return;

    final mutation = _recordMutation(
      EdgeRepoint(
        bundle.edgeId(e),
        start: start != null ? (from: oldStart.id(bundle), to: start.id(bundle)) : null,
        end: end != null ? (from: oldEnd.id(bundle), to: end.id(bundle)) : null,
      ),
    );

    mutation.reapply(this);
    markEdgeMoved(e);
  }

  void _repointEdgeEndpoint(EdgeHandle e, {required bool isStart, required VertexHandle to}) {
    return _repointEdge(
      e,
      start: isStart ? to : null,
      end: isStart ? null : to,
    );
  }

  void _setEdgeTangents(EdgeHandle e, {Vec2? start, Vec2? end}) {
    if (start == null && end == null) return;
    if (start != null && start.exactEquals(bundle.edgeStartTangent(e))) start = null;
    if (end != null && end.exactEquals(bundle.edgeEndTangent(e))) end = null;

    _recordGeometry(e);
    bundle._edgeSetTangents(e, start: start, end: end);
    markEdgeMoved(e);
  }

  void _setEdgeCubic(EdgeHandle e, Cubic2 c, {required FrameHandle space}) {
    Vec2 into(VertexHandle at, Vec2 delta) {
      final m = bundle.transformBetween(space, at);
      return m.transformDelta2(delta);
    }

    _setEdgeTangents(
      e,
      start: into(bundle.edgeStart(e), c.p1 - c.p0),
      end: into(bundle.edgeEnd(e), c.p2 - c.p3),
    );
  }
}
