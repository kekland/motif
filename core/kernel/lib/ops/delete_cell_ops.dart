part of '../kernel.dart';

final class DeleteFrameOp extends Op<void> {
  DeleteFrameOp(this.target);
  final FrameRef target;

  @override
  void _execute(Transaction t, bool produceResult) {
    t._deleteFrame(t.frameFor(target.id), cascade: true);
  }

  @override
  bool topologyEquals(Op other) => other is DeleteFrameOp && other.target == target;
}

final class DeleteVertexOp extends Op<void> {
  DeleteVertexOp(this.target);
  final VertexRef target;

  @override
  void _execute(Transaction t, bool produceResult) {
    t._deleteVertex(t.vertexFor(target.id), cascade: true);
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
    final e = t.edgeFor(target.id);
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
    t._deleteFace(t.faceFor(target.id));
  }

  @override
  bool topologyEquals(Op other) => other is DeleteFaceOp && other.target == target;
}
