part of '../renderer.dart';

final class UniformsManager {
  new(this.renderer);
  final Renderer renderer;

  late final world = gen.WorldUniformBuffer(renderer.device!);
  late final storageCounts = gen.StorageCountsUniformBuffer(renderer.device!);
  late final storageOffsets = gen.StorageOffsetsUniformBuffer(renderer.device!);
  late final storageCapacity = gen.StorageCapacityUniformBuffer(renderer.device!);

  void update({
    required Matrix4 worldToScreen,
    required Vec2 viewport,
    required double tolerance,
  }) {
    world.set(
      worldToScreen: .read(Float32List.fromList(worldToScreen.storage).buffer.asByteData(), 0),
      viewport: .new(viewport.x, viewport.y),
      tolerance: tolerance,
    );

    storageCounts.set(
      draw: renderer.draw.order.count,
      drawEdge: renderer.draw.order.edgeCount,
    );

    storageOffsets.set(
      topologyVertex: renderer.topology.storage.vertexOffsetInBytes ~/ 4,
      topologyCovertex: renderer.topology.storage.covertexOffsetInBytes ~/ 4,
      topologyEdge: renderer.topology.storage.edgeOffsetInBytes ~/ 4,
      topologyFace: renderer.topology.storage.faceOffsetInBytes ~/ 4,
      topologyFaceBoundary: renderer.topology.storage.faceBoundaryOffsetInBytes ~/ 4,

      geometryFrame: renderer.geometry.storage.frameOffsetInBytes ~/ 4,
      geometryFrameInverse: renderer.geometry.storage.frameInverseOffsetInBytes ~/ 4,
      geometryVertex: renderer.geometry.storage.vertexOffsetInBytes ~/ 4,
      geometryCovertex: renderer.geometry.storage.covertexOffsetInBytes ~/ 4,
      geometryEdge: renderer.geometry.storage.edgeOffsetInBytes ~/ 4,

      styleVertex: renderer.style.storage.vertexOffsetInBytes ~/ 4,
      styleEdge: renderer.style.storage.edgeOffsetInBytes ~/ 4,
      styleFace: renderer.style.storage.faceOffsetInBytes ~/ 4,

      glyphData: renderer.text.glyph.storage.dataOffsetInBytes ~/ 4,
      glyphBoundary: renderer.text.glyph.storage.boundaryOffsetInBytes ~/ 4,
      glyphGeometry: renderer.text.glyph.storage.geometryOffsetInBytes ~/ 4,

      drawEntry: renderer.draw.storage.entryOffsetInBytes ~/ 4,
      drawEdge: renderer.draw.storage.edgeOffsetInBytes ~/ 4,
      drawOrder: renderer.draw.storage.orderOffsetInBytes ~/ 4,
    );

    world.writeToQueue(renderer.queue);
    storageCounts.writeToQueue(renderer.queue);
    storageOffsets.writeToQueue(renderer.queue);
    storageCapacity.writeToQueue(renderer.queue);
  }
}
