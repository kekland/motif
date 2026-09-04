part of '../kernel.dart';

final class SetEdgeTangentsOp extends TopologyOp {
  SetEdgeTangentsOp(this.id, this.start, this.end);

  final CellId id;
  final ({Vec2 from, Vec2 to})? start;
  final ({Vec2 from, Vec2 to})? end;

  @override
  void reapply(TopologyTransaction txn) => txn.setEdgeTangents(
    txn.edgeFor(id),
    start: start?.to,
    end: end?.to,
  );

  @override
  void unapply(TopologyTransaction txn) => txn.setEdgeTangents(
    txn.edgeFor(id),
    start: start?.from,
    end: end?.from,
  );
}

extension SetEdgeTangentsTransaction on TopologyTransaction {
  void setEdgeTangents(EdgeHandle e, {Vec2? start, Vec2? end}) {
    _checkOpen();
    final oldStart = bundle.edgeStartTangent(e);
    final oldEnd = bundle.edgeEndTangent(e);
    if (start != null && start.exactEquals(oldStart)) start = null;
    if (end != null && end.exactEquals(oldEnd)) end = null;
    if (start == null && end == null) return;

    bundle._setEdgeTangents(e, start: start, end: end);
    ops.add(
      SetEdgeTangentsOp(
        bundle.edgeId(e),
        start != null ? (from: oldStart, to: start) : null,
        end != null ? (from: oldEnd, to: end) : null,
      ),
    );

    markEdgeMoved(e);
  }

  void setEdgeCubic(EdgeHandle e, Cubic2 c, {required FrameHandle space}) {
    Vec2 into(VertexHandle at, Vec2 delta) {
      final m = bundle.getTransformBetween(space, at);
      return m.transformDelta2(delta);
    }

    setEdgeTangents(
      e,
      start: into(bundle.edgeStart(e), c.p1 - c.p0),
      end: into(bundle.edgeEnd(e), c.p2 - c.p3),
    );
  }
}
