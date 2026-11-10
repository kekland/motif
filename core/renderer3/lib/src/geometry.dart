part of '../renderer.dart';

final class GeometryManager {
  new(this.renderer);

  final Renderer renderer;
  Bundle get bundle => renderer.bundle;

  late final buffer = GpuStorageBuffer(renderer.device!, storage, label: 'geometry');
  late final storage = GeometryStorage();

  void updateFrame(FrameIndex i) {
    storage.frame[i.i] = bundle.frameWorldTransformRaw(i);
    storage.frameInverse[i.i] = bundle.frameInverseWorldTransformRaw(i);
  }

  void updateVertex(VertexIndex i) {
    storage.vertex[i.i] = bundle.vertexPositionRaw(i);
  }

  void updateCovertex(CovertexIndex i) {
    storage.covertex[i.i] = bundle.covertexTangentRaw(i);
  }

  void updateEdge(EdgeIndex i) {
    storage.edge[i.i] = bundle.edgeCubicRaw(i);
  }

  bool upload() => buffer.upload(renderer.queue);
}

final class GeometryStorage extends CompositeStorage {
  new() : super([Mat4UnitStorage(), Mat4UnitStorage(), Vec2UnitStorage(), Vec2UnitStorage(), Cubic2UnitStorage()]);

  late final frame = storages[0] as Mat4UnitStorage;
  late final frameInverse = storages[1] as Mat4UnitStorage;
  late final vertex = storages[2] as Vec2UnitStorage;
  late final covertex = storages[3] as Vec2UnitStorage;
  late final edge = storages[4] as Cubic2UnitStorage;

  int get frameOffsetInBytes => offsetFor(0);
  int get frameInverseOffsetInBytes => offsetFor(1);
  int get vertexOffsetInBytes => offsetFor(2);
  int get covertexOffsetInBytes => offsetFor(3);
  int get edgeOffsetInBytes => offsetFor(4);
}
