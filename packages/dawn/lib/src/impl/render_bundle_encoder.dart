part of '../src.dart';
// ignore_for_file: unused_element

class RenderBundleEncoder extends _RenderBundleEncoder {
  RenderBundleEncoder._(super.ptr) : super._();
  RenderBundleEncoder._borrowed(super.ptr) : super._borrowed();

  void draw(int vertexCount, int instanceCount, int firstVertex, int firstInstance) => _renderBundleEncoderDraw(this, vertexCount, instanceCount, firstVertex, firstInstance);
  void drawIndexed(int indexCount, int instanceCount, int firstIndex, int baseVertex, int firstInstance) => _renderBundleEncoderDrawIndexed(this, indexCount, instanceCount, firstIndex, baseVertex, firstInstance);
  void drawIndexedIndirect(Buffer indirectBuffer, int indirectOffset) => _renderBundleEncoderDrawIndexedIndirect(this, indirectBuffer, indirectOffset);
  void drawIndirect(Buffer indirectBuffer, int indirectOffset) => _renderBundleEncoderDrawIndirect(this, indirectBuffer, indirectOffset);
  RenderBundle finish(RenderBundleDescriptor? descriptor) => _renderBundleEncoderFinish(this, descriptor);
  void insertDebugMarker(String markerLabel) => _renderBundleEncoderInsertDebugMarker(this, markerLabel);
  void popDebugGroup() => _renderBundleEncoderPopDebugGroup(this);
  void pushDebugGroup(String groupLabel) => _renderBundleEncoderPushDebugGroup(this, groupLabel);
  void setBindGroup(int groupIndex, BindGroup? bindGroup, List<int> dynamicOffsets) => _renderBundleEncoderSetBindGroup(this, groupIndex, bindGroup, dynamicOffsets);
  // setImmediates
  void setIndexBuffer(Buffer buffer, IndexFormat format, int offset, int size) => _renderBundleEncoderSetIndexBuffer(this, buffer, format, offset, size);
  void setLabel(String label) => _renderBundleEncoderSetLabel(this, label);
  void setPipeline(RenderPipeline pipeline) => _renderBundleEncoderSetPipeline(this, pipeline);
  void setResourceTable(ResourceTable? resourceTable) => _renderBundleEncoderSetResourceTable(this, resourceTable);
  void setVertexBuffer(int slot, Buffer buffer, int offset, int size) => _renderBundleEncoderSetVertexBuffer(this, slot, buffer, offset, size);
}
