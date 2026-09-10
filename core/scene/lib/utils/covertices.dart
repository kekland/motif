part of '../scene.dart';

Set<CovertexRef> resolveDisplayCovertices(Bundle bundle, Iterable<Ref> refs) {
  final result = <CovertexRef>{};

  for (final r in refs) {
    if (r is CovertexRef) {
      result.add(r);
    } else if (r is CellRef) {
      if (r.kind == .vertex) {
        final handle = bundle.vertex(r.asVertex)!;
        final covertices = bundle.vertexUses(handle);
        for (final cv in covertices) result.add(cv.ref(bundle));
      } else if (r.kind == .edge) {
        final handle = bundle.edge(r.asEdge)!;
        final covertices = bundle.edgeCovertices(handle);
        for (final cv in covertices) result.add(cv.ref(bundle));
      }
    }
  }

  return result;
}
