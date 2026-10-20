part of 'types.dart';

abstract class RenderBundleEncoder {
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

  void insertDebugMarker(String markerLabel);
  void pushDebugGroup(String groupLabel);
  void popDebugGroup();

  void setVertexBuffer(int slot, covariant Buffer? buffer, {int offset = 0, int? size});
  void setIndexBuffer(covariant Buffer buffer, IndexFormat format, {int offset = 0, int? size});

  RenderBundle finish([RenderBundleDescriptor? descriptor]);
}
