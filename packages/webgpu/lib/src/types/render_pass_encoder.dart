part of 'types.dart';

abstract class RenderPassEncoder {
  set label(String value);

  void setPipeline(covariant RenderPipeline pipeline);
  void setBindGroup(int index, covariant BindGroup? bindGroup, {List<int>? dynamicOffsets});
  void setImmediates(int offset, TypedData data);

  void draw(int vertexCount, {int instanceCount = 1, int firstVertex = 0, int firstInstance = 0});
  void drawIndexed(
    int indexCount, {
    int instanceCount = 1,
    int firstIndex = 0,
    int baseVertex = 0,
    int firstInstance = 0,
  });

  void drawIndirect(covariant Buffer indirectBuffer, {int offset = 0});
  void drawIndexedIndirect(covariant Buffer indirectBuffer, {int offset = 0});

  void executeBundles(List<RenderBundle> bundles);

  void insertDebugMarker(String markerLabel);
  void pushDebugGroup(String groupLabel);
  void popDebugGroup();

  void setStencilReference(int reference);
  void setBlendConstant(Color color);

  void setViewport({
    double x = 0,
    double y = 0,
    double width = 0,
    double height = 0,
    double minDepth = 0,
    double maxDepth = 1,
  });

  void setScissorRect({
    int x = 0,
    int y = 0,
    int width = 0,
    int height = 0,
  });

  void setVertexBuffer(int slot, covariant Buffer? buffer, {int offset = 0, int? size});
  void setIndexBuffer(covariant Buffer buffer, IndexFormat format, {int offset = 0, int? size});

  void beginOcclusionQuery(int queryIndex);
  void endOcclusionQuery();
  void end();
}
