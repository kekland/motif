part of '../kernel.dart';

final class CutEdgeOp extends Op<MultiCutEdgeResult> {
  CutEdgeOp(
    this.target,
    this.ts,
  );

  final EdgeRef target;
  final List<double> ts;

  @override
  MultiCutEdgeResult? _execute(Transaction t, bool produceResult) {
    if (ts.length == 1) return _executeOne(t);

    final b = t.bundle;
    final target = t.edgeFor(this.target.id);
    final v0 = b.edgeStart(target), v1 = b.edgeEnd(target);
    final frame = b.parentOf(target)!;
    final cubic = b.edgeCubic(target);
    final pieces = cubic.splitMultiple(ts);

    final vs = <VertexHandle>[];
    for (var i = 0; i < ts.length; i++) {
      final v = t._addVertex(pieces[i].p3, parent: frame);
      vs.add(v);
    }

    final es = <EdgeHandle>[];
    for (var i = 0; i <= ts.length; i++) {
      final p = pieces[i];
      final e = t._addEdge(
        i == 0 ? v0 : vs[i - 1],
        i == ts.length ? v1 : vs[i],
        startTangent: p.p1 - p.p0,
        endTangent: p.p2 - p.p3,
        parent: frame,
      );

      es.add(e);
    }

    if (t.mode == .topology) {
      final (walk1, walk2) = Coedge.walks(es);
      for (final (face, ce) in b.edgeUses(target).toList()) {
        t._spliceFaceBoundary(face, [ce], ce.forward ? walk1 : walk2);
      }
    }

    t._deleteEdge(target);
    t._recordLineage(.edge(target.ref(b), same: es.map((e) => e.ref(b)).toList()));

    if (produceResult) return .new(vs, es, cubic);
    return null;
  }

  MultiCutEdgeResult _executeOne(Transaction t) {
    assert(ts.length == 1);
    final b = t.bundle;

    final target = t.edgeFor(this.target.id);
    final v0 = b.edgeStart(target), v1 = b.edgeEnd(target);
    final frame = b.parentOf(target)!;
    final cubic = b.edgeCubic(target);
    final (c0, c1) = cubic.split(ts.single);

    final v = t._addVertex(c0.p3, parent: frame);
    final e1 = t._addEdge(
      v0,
      v,
      startTangent: c0.p1 - c0.p0,
      endTangent: c0.p2 - c0.p3,
      parent: frame,
    );

    final e2 = t._addEdge(
      v,
      v1,
      startTangent: c1.p1 - c1.p0,
      endTangent: c1.p2 - c1.p3,
      parent: frame,
    );

    if (t.mode == .topology) {
      final (walk1, walk2) = Coedge.walks([e1, e2]);
      for (final (face, ce) in b.edgeUses(target).toList()) {
        t._spliceFaceBoundary(face, [ce], ce.forward ? walk1 : walk2);
      }
    }

    t._deleteEdge(target);
    t._recordLineage(.edge(target.ref(b), same: [e1.ref(b), e2.ref(b)]));
    return .new([v], [e1, e2], cubic);
  }

  @override
  bool topologyEquals(Op other) => other is CutEdgeOp && target == other.target && ts.length == other.ts.length;
}

final class CutEdgeResult(
  final VertexHandle vertex,
  final EdgeHandle edge0,
  final EdgeHandle edge1,
  final Cubic2 original,
);

final class MultiCutEdgeResult(
  final List<VertexHandle> vertices,
  final List<EdgeHandle> edges,
  final Cubic2 original,
) {
  CutEdgeResult get single {
    assert(vertices.length == 1 && edges.length == 2);
    return .new(vertices.single, edges[0], edges[1], original);
  }
}

extension CutEdgeMutationTransaction on Transaction {
  CutEdgeResult cutEdge(EdgeHandle e, double t) => multiCutEdge(e, [t]).single;
  MultiCutEdgeResult multiCutEdge(EdgeHandle e, List<double> ts) => _applyWithResult(
    CutEdgeOp(e.ref(bundle), ts),
  );
}
