import 'package:renderer2/renderer.dart';
import 'package:renderer2/src/shaders/structs.g.dart' as gen;

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

final class FaceBoundaryStorage extends SpanStorage<gen.FaceBoundaryEntry> {
  @override int get elementSizeInBytes => gen.FaceBoundaryEntry.unpaddedSizeInBytes;
  @override gen.FaceBoundaryEntry get(int offset) => .read(data, offset);
  @override void set(int offset, gen.FaceBoundaryEntry value) => value.write(data, offset);
}

final class DrawStorage extends UnitStorage<gen.DrawEntry> {
  @override int get elementSizeInBytes => gen.DrawEntry.unpaddedSizeInBytes;
  @override gen.DrawEntry get(int offset) => .read(data, offset);
  @override void set(int offset, gen.DrawEntry value) => value.write(data, offset);
}
// dart format on

final class TopologyStorage extends CompositeStorage {
  new()
    : super([
        VertexTopologyStorage(),
        EdgeTopologyStorage(),
        FaceTopologyStorage(),
        CovertexTopologyStorage(),
        FaceBoundaryStorage(),
        DrawStorage(),
      ]);

  late final vertex = storages[0] as VertexTopologyStorage;
  late final edge = storages[1] as EdgeTopologyStorage;
  late final face = storages[2] as FaceTopologyStorage;
  late final covertex = storages[3] as CovertexTopologyStorage;
  late final faceBoundary = storages[4] as FaceBoundaryStorage;
  late final draw = storages[5] as DrawStorage;

  int get vertexOffset => offsetFor(0);
  int get edgeOffset => offsetFor(1);
  int get faceOffset => offsetFor(2);
  int get covertexOffset => offsetFor(3);
  int get faceBoundaryOffset => offsetFor(4);
  int get drawOffset => offsetFor(5);
}
