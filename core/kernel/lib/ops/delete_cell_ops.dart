part of '../kernel.dart';

final class DeleteFrameOp extends Op<void> {
  DeleteFrameOp(this.target);
  final FrameRef target;

  @override
  void _execute(Transaction t, bool produceResult) {
    final f = t.bundle.frame(target);
    if (f == null || !t.bundle.isFrameLive(f)) return;
    t._deleteFrame(f, cascade: true);
  }

  @override
  bool topologyEquals(Op other) => other is DeleteFrameOp && other.target == target;
}

final class DeleteVertexOp extends Op<void> {
  DeleteVertexOp(this.target);
  final VertexRef target;

  @override
  void _execute(Transaction t, bool produceResult) {
    final v = t.bundle.vertex(target);
    if (v == null || !t.bundle.isVertexLive(v)) return;
    t._deleteVertex(v, cascade: true);
  }

  @override
  bool topologyEquals(Op other) => other is DeleteVertexOp && other.target == target;
}

final class DeleteEdgeOp extends Op<void> {
  DeleteEdgeOp(this.target, {this.prune = true});
  final EdgeRef target;
  final bool prune;

  @override
  void _execute(Transaction t, bool produceResult) {
    final b = t.bundle;
    final e = b.edge(target);
    if (e == null || !b.isEdgeLive(e)) return;

    final v0 = b.edgeStart(e), v1 = b.edgeEnd(e);
    t._deleteEdge(e, cascade: true);
    if (!prune) return;
    if (!b.vertexHasUses(v0)) t._deleteVertex(v0);
    if (v0 != v1 && !b.vertexHasUses(v1)) t._deleteVertex(v1);
  }

  @override
  bool topologyEquals(Op other) => other is DeleteEdgeOp && other.target == target && other.prune == prune;
}

final class DeleteFaceOp extends Op<void> {
  DeleteFaceOp(this.target);
  final FaceRef target;

  @override
  void _execute(Transaction t, bool produceResult) {
    final f = t.bundle.face(target);
    if (f == null || !t.bundle.isFaceLive(f)) return;
    t._deleteFace(f);
  }

  @override
  bool topologyEquals(Op other) => other is DeleteFaceOp && other.target == target;
}
