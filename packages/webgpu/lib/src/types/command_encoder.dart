part of 'types.dart';

abstract class CommandEncoder {
  set label(String value);

  CommandBuffer finish([CommandBufferDescriptor? descriptor]);
  ComputePassEncoder beginComputePass([ComputePassDescriptor? descriptor]);
  RenderPassEncoder beginRenderPass(RenderPassDescriptor descriptor);

  void copyBufferToBuffer(
    covariant Buffer source,
    covariant Buffer destination, {
    int sourceOffset = 0,
    int destinationOffset = 0,
    required int size,
  });

  void copyBufferToTexture(
    TexelCopyBufferInfo source,
    TexelCopyTextureInfo destination,
    Extent3D copySize,
  );

  void copyTextureToBuffer(
    TexelCopyTextureInfo source,
    TexelCopyBufferInfo destination,
    Extent3D copySize,
  );

  void clearBuffer(covariant Buffer buffer, {int offset = 0, int? size});

  void insertDebugMarker(String markerLabel);
  void pushDebugGroup(String groupLabel);
  void popDebugGroup();

  void resolveQuerySet(
    covariant QuerySet querySet,
    covariant Buffer destination, {
    required int firstQuery,
    required int queryCount,
    required int destinationOffset,
  });
}
