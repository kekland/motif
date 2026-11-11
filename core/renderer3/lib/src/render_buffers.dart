part of '../renderer.dart';

final class RenderBuffersManager {
  new(this.renderer);
  final Renderer renderer;

  late final segmentOffset = gen.U32ArrayStorageBuffer(
    renderer.device!,
    length: 30000,
    usage: .of([.storage, .copySrc, .copyDst]),
  );

  late final segments = gen.Vec4fArrayStorageBuffer(
    renderer.device!,
    length: 30000,
    usage: .of([.storage, .copySrc, .copyDst]),
  );

  late final renderGeometryOffset = gen.U32ArrayStorageBuffer(
    renderer.device!,
    length: 30000,
    usage: .of([.storage, .copySrc, .copyDst]),
  );

  late final renderGeometry = gen.RenderGeometryArrayStorageBuffer(
    renderer.device!,
    length: 30000,
    usage: .of([.storage, .copySrc, .copyDst]),
  );

  late final indirectArgs = gen.DrawIndirectArgsArrayStorageBuffer(
    renderer.device!,
    length: 30000,
    usage: .of([.storage, .indirect, .copySrc, .copyDst]),
  );

  bool clear(CommandEncoder encoder) {
    encoder.clearBuffer(renderGeometry.buffer);
    encoder.clearBuffer(segmentOffset.buffer);
    encoder.clearBuffer(segments.buffer);
    encoder.clearBuffer(renderGeometryOffset.buffer);
    encoder.clearBuffer(indirectArgs.buffer);
    return false;
  }
}
