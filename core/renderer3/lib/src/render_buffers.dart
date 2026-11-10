part of '../renderer.dart';

final class RenderBuffersManager {
  new(this.renderer);
  final Renderer renderer;

  late final segmentOffset = gen.U32ArrayStorageBuffer(
    renderer.device!,
    length: 30000,
    usage: .of([.storage, .copySrc]),
  );

  late final segments = gen.Vec4fArrayStorageBuffer(
    renderer.device!,
    length: 30000,
    usage: .of([.storage, .copySrc]),
  );

  late final renderGeometryOffset = gen.U32ArrayStorageBuffer(
    renderer.device!,
    length: 30000,
    usage: .of([.storage, .copySrc]),
  );

  late final renderGeometry = gen.RenderGeometryArrayStorageBuffer(
    renderer.device!,
    length: 30000,
    usage: .of([.storage, .copySrc]),
  );

  late final indirectArgs = gen.DrawIndirectArgsArrayStorageBuffer(
    renderer.device!,
    length: 30000,
    usage: .of([.storage, .indirect, .copySrc]),
  );

  bool clear() {
    return false;
  }
}
