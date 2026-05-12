part of '../webgpu.g.dart';
// ignore_for_file: unused_element

mixin _RenderBundleEncoderImpl on _RenderBundleEncoderBase {
  void draw(int vertexCount, int instanceCount, int firstVertex, int firstInstance) => _drawImpl(vertexCount, instanceCount, firstVertex, firstInstance);
  void drawIndexed(int indexCount, int instanceCount, int firstIndex, int baseVertex, int firstInstance) => _drawIndexedImpl(indexCount, instanceCount, firstIndex, baseVertex, firstInstance);
  void drawIndexedIndirect(Buffer indirectBuffer, int indirectOffset) => _drawIndexedIndirectImpl(indirectBuffer, indirectOffset);
  void drawIndirect(Buffer indirectBuffer, int indirectOffset) => _drawIndirectImpl(indirectBuffer, indirectOffset);
  RenderBundle finish(RenderBundleDescriptor? descriptor) => _finishImpl(descriptor);
  
  set label(String label) => _setLabelImpl(label);
  void pushDebugGroup(String groupLabel) => _pushDebugGroupImpl(groupLabel);
  void popDebugGroup() => _popDebugGroupImpl();
  void insertDebugMarker(String markerLabel) => _insertDebugMarkerImpl(markerLabel);

  void setBindGroup(int groupIndex, BindGroup? bindGroup, List<int> dynamicOffsets) => _setBindGroupImpl(groupIndex, bindGroup, dynamicOffsets);
  void setIndexBuffer(Buffer buffer, IndexFormat format, int offset, int size) => _setIndexBufferImpl(buffer, format, offset, size);
  void setPipeline(RenderPipeline pipeline) => _setPipelineImpl(pipeline);
  void setVertexBuffer(int slot, Buffer buffer, int offset, int size) => _setVertexBufferImpl(slot, buffer, offset, size);
}
