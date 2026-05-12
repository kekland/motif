part of '../src.dart';
// ignore_for_file: unused_element

class CommandEncoder extends _CommandEncoder {
  CommandEncoder._(super.ptr) : super._();
  CommandEncoder._borrowed(super.ptr) : super._borrowed();

  ComputePassEncoder beginComputePass([ComputePassDescriptor? descriptor]) => _commandEncoderBeginComputePass(this, descriptor);
  RenderPassEncoder beginRenderPass(RenderPassDescriptor descriptor) => _commandEncoderBeginRenderPass(this, descriptor);
  CommandBuffer finish([CommandBufferDescriptor? descriptor]) => _commandEncoderFinish(this, descriptor);

  void clearBuffer(Buffer buffer, int offset, int size) => _commandEncoderClearBuffer(this, buffer, offset, size);
  void copyBufferToBuffer(Buffer source, int sourceOffset, Buffer destination, int destinationOffset, int size) => _commandEncoderCopyBufferToBuffer(this, source, sourceOffset, destination, destinationOffset, size);
  void copyBufferToTexture(TexelCopyBufferInfo source, TexelCopyTextureInfo destination, Extent3D copySize) => _commandEncoderCopyBufferToTexture(this, source, destination, copySize);
  void copyTextureToBuffer(TexelCopyTextureInfo source, TexelCopyBufferInfo destination, Extent3D copySize) => _commandEncoderCopyTextureToBuffer(this, source, destination, copySize);
  void copyTextureToTexture(TexelCopyTextureInfo source, TexelCopyTextureInfo destination, Extent3D copySize) => _commandEncoderCopyTextureToTexture(this, source, destination, copySize);
  
  void writeBuffer(Buffer buffer, int bufferOffset, Pointer<Uint8> data, int size) => _commandEncoderWriteBuffer(this, buffer, bufferOffset, data, size);

  void pushDebugGroup(String groupLabel) => _commandEncoderPushDebugGroup(this, groupLabel);
  void popDebugGroup() => _commandEncoderPopDebugGroup(this);
  void injectValidationError(String message) => _commandEncoderInjectValidationError(this, message);
  void insertDebugMarker(String markerLabel) => _commandEncoderInsertDebugMarker(this, markerLabel);
  void resolveQuerySet(QuerySet querySet, int firstQuery, int queryCount, Buffer destination, int destinationOffset) => _commandEncoderResolveQuerySet(this, querySet, firstQuery, queryCount, destination, destinationOffset);
  void writeTimestamp(QuerySet querySet, int queryIndex) => _commandEncoderWriteTimestamp(this, querySet, queryIndex);
  void setLabel(String label) => _commandEncoderSetLabel(this, label);
}
