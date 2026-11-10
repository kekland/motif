part of '../renderer.dart';

final class TopologyManager {
  new(this.renderer);

  final Renderer renderer;
  Bundle get bundle => renderer.bundle;

  late final buffer = GpuStorageBuffer(renderer.device!, storage, label: 'topology');
  late final storage = TopologyStorage();

  void updateVertex(VertexIndex i) {
    storage.vertex[i.i] = .new(
      diskStart: bundle.vertexStorage.diskStart[i].i,
      parent: bundle.vertexStorage.parent[i].i,
    );
  }

  void updateCovertex(CovertexIndex i) {
    storage.covertex[i.i] = .new(
      edge: bundle.covertexStorage.edge[i].i,
      isStart: bundle.covertexStorage.isStart[i] ? 1 : 0,
      next: bundle.covertexStorage.diskNext[i].i,
    );
  }

  void updateEdge(EdgeIndex i) {
    storage.edge[i.i] = .new(
      vertexStart: bundle.edgeStorage.vStart[i].i,
      vertexEnd: bundle.edgeStorage.vEnd[i].i,
      parent: bundle.edgeStorage.parent[i].i,
    );
  }

  void updateFace(FaceIndex i) {
    final coedges = bundle.faceBoundaryRaw(i);
    final boundary = <gen.FaceBoundaryEntry>[];

    for (final ce in coedges) {
      boundary.add(
        .new(
          edge: bundle.coedgeStorage.edge[ce].i,
          isForward: bundle.coedgeStorage.direction[ce] ? 1 : 0,
        ),
      );
    }

    final previousSpan = storage.face[i.i]?.boundarySpan;
    final span = storage.faceBoundary.put(boundary, span: .maybeFrom(previousSpan));
    storage.face[i.i] = .new(parent: bundle.faceStorage.parent[i].i, boundarySpan: span);
  }

  void releaseVertex(VertexIndex i) {}
  void releaseCovertex(CovertexIndex i) {}
  void releaseEdge(EdgeIndex i) {}
  void releaseFace(FaceIndex i) {
    final previousSpan = storage.face[i.i]?.boundarySpan;
    if (previousSpan != null) storage.faceBoundary.release(.from(previousSpan));
  }

  bool upload() => buffer.upload(renderer.queue);
}

final class TopologyStorage extends CompositeStorage {
  new()
    : super([
        VertexTopologyStorage(),
        CovertexTopologyStorage(),
        EdgeTopologyStorage(),
        FaceTopologyStorage(),
        FaceBoundaryStorage(),
      ]);

  late final vertex = storages[0] as VertexTopologyStorage;
  late final covertex = storages[1] as CovertexTopologyStorage;
  late final edge = storages[2] as EdgeTopologyStorage;
  late final face = storages[3] as FaceTopologyStorage;
  late final faceBoundary = storages[4] as FaceBoundaryStorage;

  int get vertexOffsetInBytes => offsetFor(0);
  int get covertexOffsetInBytes => offsetFor(1);
  int get edgeOffsetInBytes => offsetFor(2);
  int get faceOffsetInBytes => offsetFor(3);
  int get faceBoundaryOffsetInBytes => offsetFor(4);
}

// dart format off
final class VertexTopologyStorage extends UnitStorage<gen.VertexTopology> {
  @override int get elementSizeInBytes => gen.VertexTopology.unpaddedSizeInBytes;
  @override gen.VertexTopology get(int offset) => .read(data, offset);
  @override void set(int offset, gen.VertexTopology value) => value.write(data, offset);
}

final class EdgeTopologyStorage extends UnitStorage<gen.EdgeTopology> {
  @override int get elementSizeInBytes => gen.EdgeTopology.unpaddedSizeInBytes;
  @override gen.EdgeTopology get(int offset) => .read(data, offset);
  @override void set(int offset, gen.EdgeTopology value) => value.write(data, offset);
}

final class FaceTopologyStorage extends UnitStorage<gen.FaceTopology> {
  @override int get elementSizeInBytes => gen.FaceTopology.unpaddedSizeInBytes;
  @override gen.FaceTopology get(int offset) => .read(data, offset);
  @override void set(int offset, gen.FaceTopology value) => value.write(data, offset);
}

final class CovertexTopologyStorage extends UnitStorage<gen.CovertexTopology> {
  @override int get elementSizeInBytes => gen.CovertexTopology.unpaddedSizeInBytes;
  @override gen.CovertexTopology get(int offset) => .read(data, offset);
  @override void set(int offset, gen.CovertexTopology value) => value.write(data, offset);
}

final class FaceBoundaryStorage extends UnitStorage<gen.FaceBoundaryEntry> with SpanStorage<gen.FaceBoundaryEntry> {
  @override int get elementSizeInBytes => gen.FaceBoundaryEntry.unpaddedSizeInBytes;
  @override gen.FaceBoundaryEntry get(int offset) => .read(data, offset);
  @override void set(int offset, gen.FaceBoundaryEntry value) => value.write(data, offset);
}
// dart format on
