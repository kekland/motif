part of '../kernel.dart';

final class CutEdgeOp(final CellId edge, final List<double> ts, super.children) extends CompositeOp;

final class CutEdgeResult(
  final VertexHandle vertex,
  final EdgeHandle edge0,
  final EdgeHandle edge1,
  final Cubic2 original,
);

final class MultiCutEdgeResult(final List<VertexHandle> vertices, final List<EdgeHandle> edges, final Cubic2 original);

extension CutEdgeTransaction on TopologyTransaction {
  VertexHandle edgeMidpoint(EdgeHandle e) => cutEdge(e, 0.5).vertex;

  CutEdgeResult cutEdge(EdgeHandle target, double t) {
    final r = multiCutEdge(target, [t]);
    return CutEdgeResult(r.vertices.single, r.edges[0], r.edges[1], r.original);
  }

  MultiCutEdgeResult multiCutEdge(EdgeHandle target, List<double> ts) {
    if (ts.isEmpty) throw ArgumentError.value(ts, 'ts', 'must not be empty');
    _checkOpen();

    final targetId = bundle.edgeId(target);
    final targetKey = bundle.edgeKey(target);
    final parent = bundle.parentOf(target)!;
    final original = bundle.edgeCubic(target);

    return _compositeOp(
      (children) => CutEdgeOp(targetId, ts, children),
      () {
        final v0 = bundle.edgeStart(target), v1 = bundle.edgeEnd(target);

        final startSpace = bundle.parentOf(v0)!;
        final endSpace = bundle.parentOf(v1)!;
        final intoStart = startSpace == parent ? null : bundle.getTransformBetween(parent, startSpace);
        final intoEnd = endSpace == parent ? null : bundle.getTransformBetween(parent, endSpace);

        final cubic = original;
        final pieces = cubic.splitMultiple(ts);
        assert(pieces.length == ts.length + 1, 'expected ${ts.length + 1} pieces, got ${pieces.length}');

        final tag = createTag('cut');

        var anchor = SiblingHandleAnchor.after(target);

        // Create vertices
        final vHandles = <VertexHandle>[];
        for (var i = 0; i < ts.length; i++) {
          final id = tag.derive('v$i');
          final handle = addVertex(id, pieces[i].p3, parent: parent, anchor: anchor);
          vHandles.add(handle);
          anchor = .after(handle);
        }

        // Create edges
        final eHandles = <EdgeHandle>[];
        for (var i = 0; i < pieces.length; i++) {
          final s = i == 0 ? v0 : vHandles[i - 1];
          final e = i == pieces.length - 1 ? v1 : vHandles[i];
          final eId = tag.derive('e$i');

          final c = pieces[i];
          var t0 = c.p1 - c.p0;
          var t1 = c.p2 - c.p3;
          if (i == 0 && intoStart != null) t0 = intoStart.transformDelta2(t0);
          if (i == pieces.length - 1 && intoEnd != null) t1 = intoEnd.transformDelta2(t1);

          final handle = addEdge(eId, s, e, startTangent: t0, endTangent: t1, parent: parent, anchor: anchor);
          eHandles.add(handle);
          anchor = .after(handle);
        }

        // Splice face cycles
        final (walk1, walk2) = Coedge.walks(eHandles);
        final targetUses = bundle.edgeUses(target).toList();
        for (final (face, ce) in targetUses) {
          final remove = [ce];
          final insert = ce.forward ? walk1 : walk2;
          _spliceCycle(face, remove, insert);
        }

        // Remove original edge
        deleteEdge(target);

        return (
          MultiCutEdgeResult(vHandles, eHandles, original),
          [
            .edge(targetKey, same: [for (final e in eHandles) bundle.edgeKey(e)]),
          ],
        );
      },
    );
  }
}
