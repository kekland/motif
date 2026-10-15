part of '../kernel.dart';

extension RefsQuery on TopologyQuery {
  Iterable<FrameRef> get allFrames => bundle.frames.map((f) => f.ref(bundle));
  Iterable<VertexRef> get allVertices => bundle.vertices.map((v) => v.ref(bundle));
  Iterable<EdgeRef> get allEdges => bundle.edges.map((e) => e.ref(bundle));
  Iterable<FaceRef> get allFaces => bundle.faces.map((f) => f.ref(bundle));

  Iterable<CellRef> get allCells sync* {
    yield* allFrames;
    yield* allVertices;
    yield* allEdges;
    yield* allFaces;
  }
}
