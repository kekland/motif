part of '../src.dart';
// ignore_for_file: unused_element

class ComputePassEncoder extends _ComputePassEncoder {
  ComputePassEncoder._(super.ptr) : super._();
  ComputePassEncoder._borrowed(super.ptr) : super._borrowed();

  void dispatchWorkgroups({int x = 1, int y = 1, int z = 1}) => _computePassEncoderDispatchWorkgroups(this, x, y, z);
  void dispatchWorkgroupsIndirect(Buffer indirectBuffer, int indirectOffset) => _computePassEncoderDispatchWorkgroupsIndirect(this, indirectBuffer, indirectOffset);
  void end() => _computePassEncoderEnd(this);
  void insertDebugMarker(String markerLabel) => _computePassEncoderInsertDebugMarker(this, markerLabel);
  void popDebugGroup() => _computePassEncoderPopDebugGroup(this);
  void pushDebugGroup(String groupLabel) => _computePassEncoderPushDebugGroup(this, groupLabel);
  void setBindGroup(int groupIndex, BindGroup? bindGroup, List<int> dynamicOffsets) => _computePassEncoderSetBindGroup(this, groupIndex, bindGroup, dynamicOffsets);
  void setImmediates(int offset, Pointer<Void> data, int size) => _computePassEncoderSetImmediates(this, offset, data, size);
  void setLabel(String label) => _computePassEncoderSetLabel(this, label);
  void setPipeline(ComputePipeline pipeline) => _computePassEncoderSetPipeline(this, pipeline);
  void setResourceTable(ResourceTable? resourceTable) => _computePassEncoderSetResourceTable(this, resourceTable);
  void writeTimestamp(QuerySet querySet, int queryIndex) => _computePassEncoderWriteTimestamp(this, querySet, queryIndex);
}
