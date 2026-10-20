part of 'types.dart';

abstract class Queue {
  set label(String label);

  void submit(covariant List<CommandBuffer> commandBuffers);
  Future<void> onSubmittedWorkDone();

  void writeBuffer(covariant Buffer buffer, int bufferOffset, TypedData data);
  void writeTexture(TexelCopyTextureInfo destination, TypedData data, TexelCopyBufferLayout layout, Extent3D writeSize);
}
