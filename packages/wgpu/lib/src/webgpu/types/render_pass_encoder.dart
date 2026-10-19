part of '../webgpu.g.dart';
// ignore_for_file: unused_element

mixin _RenderPassEncoderImpl on _RenderPassEncoderBase {
  void beginOcclusionQuery(int queryIndex) => _beginOcclusionQueryImpl(queryIndex);
  void endOcclusionQuery() => _endOcclusionQueryImpl();

  void draw(int vertexCount, int instanceCount, int firstVertex, int firstInstance) => _drawImpl(vertexCount, instanceCount, firstVertex, firstInstance);
  void drawIndexed(int indexCount, int instanceCount, int firstIndex, int baseVertex, int firstInstance) => _drawIndexedImpl(indexCount, instanceCount, firstIndex, baseVertex, firstInstance);
  void drawIndexedIndirect(Buffer indirectBuffer, int indirectOffset) => _drawIndexedIndirectImpl(indirectBuffer, indirectOffset);
  void drawIndirect(Buffer indirectBuffer, int indirectOffset) => _drawIndirectImpl(indirectBuffer, indirectOffset);

  void end() => _endImpl();

  void executeBundles(List<RenderBundle> bundles) => _executeBundlesImpl(bundles);
  
  void pushDebugGroup(String groupLabel) => _pushDebugGroupImpl(groupLabel);
  void popDebugGroup() => _popDebugGroupImpl();
  void insertDebugMarker(String markerLabel) => _insertDebugMarkerImpl(markerLabel);
  set label(String label) => _setLabelImpl(label);

  void setBindGroup(int groupIndex, BindGroup? bindGroup, {List<int> dynamicOffsets = const []}) => _setBindGroupImpl(groupIndex, bindGroup, dynamicOffsets);
  void setBlendConstant(Color color) => _setBlendConstantImpl(color);
  void setIndexBuffer(Buffer buffer, IndexFormat format, int offset, int size) => _setIndexBufferImpl(buffer, format, offset, size);
  void setPipeline(RenderPipeline pipeline) => _setPipelineImpl( pipeline);
  void setScissorRect(int x, int y, int width, int height) => _setScissorRectImpl(x, y, width, height);
  void setStencilReference(int reference) => _setStencilReferenceImpl(reference);
  void setVertexBuffer(int slot, Buffer buffer, int offset, int size) => _setVertexBufferImpl(slot, buffer, offset, size);
  void setViewport(double x, double y, double width, double height, double minDepth, double maxDepth) => _setViewportImpl(x, y, width, height, minDepth, maxDepth);
}
