part of '../webgpu.g.dart';
// ignore_for_file: unused_element

mixin _CommandEncoderImpl on _CommandEncoderBase {
  ComputePassEncoder beginComputePass([ComputePassDescriptor? descriptor]) => _beginComputePassImpl(descriptor);
  RenderPassEncoder beginRenderPass(RenderPassDescriptor descriptor) => _beginRenderPassImpl(descriptor);
  CommandBuffer finish([CommandBufferDescriptor? descriptor]) => _finishImpl(descriptor);

  void clearBuffer(Buffer buffer, int offset, int size) => _clearBufferImpl(buffer, offset, size);
  void copyBufferToBuffer(Buffer source, int sourceOffset, Buffer destination, int destinationOffset, int size) => _copyBufferToBufferImpl(source, sourceOffset, destination, destinationOffset, size);
  void copyBufferToTexture(TexelCopyBufferInfo source, TexelCopyTextureInfo destination, Extent3D copySize) => _copyBufferToTextureImpl(source, destination, copySize);
  void copyTextureToBuffer(TexelCopyTextureInfo source, TexelCopyBufferInfo destination, Extent3D copySize) => _copyTextureToBufferImpl(source, destination, copySize);
  void copyTextureToTexture(TexelCopyTextureInfo source, TexelCopyTextureInfo destination, Extent3D copySize) => _copyTextureToTextureImpl(source, destination, copySize);
  
  void pushDebugGroup(String groupLabel) => _pushDebugGroupImpl(groupLabel);
  void popDebugGroup() => _popDebugGroupImpl();
  void insertDebugMarker(String markerLabel) => _insertDebugMarkerImpl(markerLabel);

  void resolveQuerySet(QuerySet querySet, int firstQuery, int queryCount, Buffer destination, int destinationOffset) => _resolveQuerySetImpl(querySet, firstQuery, queryCount, destination, destinationOffset);
  void writeTimestamp(QuerySet querySet, int queryIndex) => _writeTimestampImpl(querySet, queryIndex);
  set label(String label) => _setLabelImpl(label);
}
