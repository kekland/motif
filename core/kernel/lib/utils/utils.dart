part of '../kernel.dart';

extension CellIterableExtension on Iterable<CellRef> {
  Iterable<CellRef> whereKind(CellKind kind) => where((c) => c.kind == kind);

  Iterable<FrameRef> whereFrame() => whereType<FrameRef>();
  Iterable<VertexRef> whereVertex() => whereType<VertexRef>();
  Iterable<EdgeRef> whereEdge() => whereType<EdgeRef>();
  Iterable<FaceRef> whereFace() => whereType<FaceRef>();
}
