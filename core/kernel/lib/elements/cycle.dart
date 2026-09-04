part of '../kernel.dart';

extension type const Cycle(List<Coedge> coedges) implements Iterable<Coedge> {
  Cycle.walk(Iterable<EdgeHandle> edges, {bool forward = true})
    : this([for (final e in edges) Coedge(e, forward: forward)]);

  Coedge operator [](int i) => coedges[i];
  Cycle get reversed => Cycle(coedges.reversedWalk);

  CycleRef asRef(Bundle bundle) => .new([for (final u in coedges) u.asRef(bundle)]);

  // Cycle where(bool Function(Coedge) f) => Cycle([
  //   for (final c in coedges)
  //     if (f(c)) c,
  // ]);
  // Cycle map(Coedge Function(Coedge) f) => Cycle([for (final c in coedges) f(c)]);
}

extension type const CycleRef(List<CoedgeRef> coedges) implements Iterable<CoedgeRef> {
  CoedgeRef operator [](int i) => coedges[i];
  CycleRef get reversed => CycleRef([for (final c in coedges.reversed) c.reversed]);

  Cycle? resolve(Bundle bundle) {
    final out = <Coedge>[];
    for (final r in coedges) {
      final c = r.resolve(bundle);
      if (c == null) return null;
      out.add(c);
    }
    return Cycle(out);
  }
}

final class _EdgeChain {
  _EdgeChain(this.vertices, this.edges, this.forward)
    : assert(vertices.length == edges.length + 1),
      assert(forward.length == edges.length);

  final List<VertexHandle> vertices;
  final List<EdgeHandle> edges;
  final List<bool> forward;

  bool get isClosed => vertices.first == vertices.last;

  Cycle get cycle => Cycle(
    [for (var k = 0; k < edges.length; k++) Coedge(edges[k], forward: forward[k])],
  );
}
