part of '../program.dart';

final class BakeRouter {
  new({required this.statements, required this.remap});

  final List<Statement> statements;
  final Remap remap;
}

extension RouteBake on Evaluation {
  BakeRouter routeBake(
    Iterable<CellRef> cells, {
    bool closed = false,
    bool ghosts = false,
    Set<CellRef> gone = const {},
  }) {
    final bake = <CellRef>{};
    final work = [...cells];
    while (work.isNotEmpty) {
      final r = work.removeLast();
      final exists = ghosts ? bundle.handle(r) != null : bundle.isLive(r);
      if (!exists || !bake.add(r)) continue;
      if (closed) work.addAll(bundle.cellDependencies(r));
    }

    final refMap = <CellRef, List<CellRef>>{};
    CellRef<H> mapped<H extends CellHandle>(CellRef<H> r) => (refMap[r]?.single as CellRef<H>?) ?? r;

    final out = <Statement>[];

    FrameHandle spaceOf(CellHandle h) {
      for (var f = bundle.parentOf(h); f != null && f != bundle.root; f = bundle.parentOf(f)) {
        if (!gone.contains(f.ref(bundle))) return f;
      }
      return bundle.root;
    }

    FrameRef? parentOf(CellHandle h) {
      final f = spaceOf(h);
      if (f == bundle.root) return null;
      return mapped(f.ref(bundle));
    }

    final bakeByKind = <CellKind, List<CellRef>>{.frame: [], .vertex: [], .edge: [], .face: []};
    for (final r in bake) bakeByKind[r.kind]!.add(r);

    for (final f in bakeByKind[CellKind.frame]!) {
      final h = bundle.frame(f.id)!;
      final s = FrameStatement(
        transform: bundle.frameTransform(h, space: spaceOf(h)),
        size: bundle.frameSize(h),
        parent: parentOf(h),
      );

      out.add(s);
      refMap[f] = [s.ref];
    }

    for (final v in bakeByKind[CellKind.vertex]!) {
      final h = bundle.vertex(v.id)!;
      final s = VertexStatement(bundle.vertexPosition(h, space: spaceOf(h)), parent: parentOf(h));
      out.add(s);
      refMap[v] = [s.ref];
    }

    for (final e in bakeByKind[CellKind.edge]!) {
      final h = bundle.edge(e.id)!;
      final c = bundle.edgeCubic(h, space: spaceOf(h));
      final s = EdgeStatement(
        mapped(bundle.edgeStart(h).ref(bundle)).selector(),
        mapped(bundle.edgeEnd(h).ref(bundle)).selector(),
        startTangent: c.p1 - c.p0,
        endTangent: c.p2 - c.p3,
        parent: parentOf(h),
      );

      out.add(s);
      refMap[e] = [s.ref];
    }

    for (final f in bakeByKind[CellKind.face]!) {
      final h = bundle.face(f.id)!;

      final cycles = <ChainSelector>[];
      for (final cycle in bundle.faceBoundary(h)) {
        final chain = cycle.coedges.map((ce) => mapped(ce.edge.ref(bundle))).toList();
        cycles.add(.new(chain));
      }

      final s = FaceStatement(
        cycles.first,
        holes: cycles.skip(1).toList(),
        parent: parentOf(h),
      );

      out.add(s);
      refMap[f] = [s.ref];
    }

    return .new(statements: out, remap: ._(refMap));
  }
}
