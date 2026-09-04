part of '../program.dart';

typedef Corner = ({VertexRef v, EdgeRef a, EdgeRef b});

final class CornersSelector(final FaceSelector face) extends Selector<List<Corner>> {
  @override
  List<Corner> _resolve(EvalContext context) {
    final bundle = context.bundle;
    final result = <Corner>[];

    final handle = context.handle(context.resolve(face));
    for (final cycle in bundle.faceBoundary(handle)) {
      final edges = <(EdgeRef, VertexRef)>[];

      for (final ce in cycle) {
        edges.add((ce.edge.ref(bundle), bundle.coedgeEnd(ce).ref(bundle)));
      }

      for (var i = 0; i < edges.length; i++) {
        final (a, v) = edges[i];
        final (b, _) = edges[(i + 1) % edges.length];
        result.add((v: v, a: a, b: b));
      }
    }

    return result;
  }

  @override
  Iterable<CellRef> get refs => face.refs;

  @override
  Iterable<CellRef> resolved(EvalContext context) {
    final results = <CellRef>[];

    for (final k in context.resolve(this)) {
      results.add(k.v);
      results.add(k.a);
      results.add(k.b);
    }

    return results;
  }
}
