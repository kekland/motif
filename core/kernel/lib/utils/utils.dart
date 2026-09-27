part of '../kernel.dart';

extension CellIterableExtension on Iterable<CellRef> {
  Iterable<CellRef<H>> whereKind<H extends CellHandle>(CellKind kind) => where((c) => c.kind == kind).cast<CellRef<H>>();

  Iterable<FrameRef> whereFrame() => whereKind<FrameHandle>(.frame);
  Iterable<VertexRef> whereVertex() => whereKind<VertexHandle>(.vertex);
  Iterable<EdgeRef> whereEdge() => whereKind<EdgeHandle>(.edge);
  Iterable<FaceRef> whereFace() => whereKind<FaceHandle>(.face);
}
