part of '../src.dart';
// ignore_for_file: unused_element

class RenderPassEncoder extends _RenderPassEncoder {
  RenderPassEncoder._(super.ptr) : super._();
  RenderPassEncoder._borrowed(super.ptr) : super._borrowed();

  void beginOcclusionQuery(int queryIndex) => _renderPassEncoderBeginOcclusionQuery(this, queryIndex);
  void draw(int vertexCount, int instanceCount, int firstVertex, int firstInstance) => _renderPassEncoderDraw(this, vertexCount, instanceCount, firstVertex, firstInstance);
  void drawIndexed(int indexCount, int instanceCount, int firstIndex, int baseVertex, int firstInstance) => _renderPassEncoderDrawIndexed(this, indexCount, instanceCount, firstIndex, baseVertex, firstInstance);
  void drawIndexedIndirect(Buffer indirectBuffer, int indirectOffset) => _renderPassEncoderDrawIndexedIndirect(this, indirectBuffer, indirectOffset);
  void drawIndirect(Buffer indirectBuffer, int indirectOffset) => _renderPassEncoderDrawIndirect(this, indirectBuffer, indirectOffset);
  void end() => _renderPassEncoderEnd(this);
  void endOcclusionQuery() => _renderPassEncoderEndOcclusionQuery(this);
  void executeBundles(List<RenderBundle> bundles) => _renderPassEncoderExecuteBundles(this, bundles);
  void insertDebugMarker(String markerLabel) => _renderPassEncoderInsertDebugMarker(this, markerLabel);
  void multiDrawIndexedIndirect(Buffer indirectBuffer, int indirectOffset, int maxDrawCount, Buffer? drawCountBuffer, int drawCountBufferOffset) => _renderPassEncoderMultiDrawIndexedIndirect(this, indirectBuffer, indirectOffset, maxDrawCount, drawCountBuffer, drawCountBufferOffset);
  void multiDrawIndirect(Buffer indirectBuffer, int indirectOffset, int maxDrawCount, Buffer? drawCountBuffer, int drawCountBufferOffset) => _renderPassEncoderMultiDrawIndirect(this, indirectBuffer, indirectOffset, maxDrawCount, drawCountBuffer, drawCountBufferOffset);
  void pixelLocalStorageBarrier() => _renderPassEncoderPixelLocalStorageBarrier(this);
  void popDebugGroup() => _renderPassEncoderPopDebugGroup(this);
  void pushDebugGroup(String groupLabel) => _renderPassEncoderPushDebugGroup(this, groupLabel);
  void setBindGroup(int groupIndex, BindGroup? bindGroup, List<int> dynamicOffsets) => _renderPassEncoderSetBindGroup(this, groupIndex, bindGroup, dynamicOffsets);
  void setBlendConstant(Color color) => _renderPassEncoderSetBlendConstant(this, color);
  // setImmediates
  void setIndexBuffer(Buffer buffer, IndexFormat format, int offset, int size) => _renderPassEncoderSetIndexBuffer(this, buffer, format, offset, size);
  void setLabel(String label) => _renderPassEncoderSetLabel(this, label);
  void setPipeline(RenderPipeline pipeline) => _renderPassEncoderSetPipeline(this, pipeline);
  void setResourceTable(ResourceTable? resourceTable) => _renderPassEncoderSetResourceTable(this, resourceTable);
  void setScissorRect(int x, int y, int width, int height) => _renderPassEncoderSetScissorRect(this, x, y, width, height);
  void setStencilReference(int reference) => _renderPassEncoderSetStencilReference(this, reference);
  void setVertexBuffer(int slot, Buffer buffer, int offset, int size) => _renderPassEncoderSetVertexBuffer(this, slot, buffer, offset, size);
  void setViewport(double x, double y, double width, double height, double minDepth, double maxDepth) => _renderPassEncoderSetViewport(this, x, y, width, height, minDepth, maxDepth);
  void writeTimestamp(QuerySet querySet, int queryIndex) => _renderPassEncoderWriteTimestamp(this, querySet, queryIndex);
}
