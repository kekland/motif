part of '../program.dart';

typedef ResolvedCorner = ({VertexRef v, EdgeRef a, EdgeRef b});

final class CornersSelector(final FaceSelector face) extends Selector<List<ResolvedCorner>> {
  @override
  List<ResolvedCorner> _resolve(EvalContext context) {
    final bundle = context.bundle;
    final result = <ResolvedCorner>[];

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

  @override
  CornersSelector clone() => .new(face.clone());

  @override
  RemapResult _remap(Remap remap) => face._remap(remap);

  @override
  int get hashCode => Object.hash(runtimeType, face.hashCode);

  @override
  bool operator ==(Object other) => other.runtimeType == runtimeType && (other as CornersSelector).face == face;
}
