part of '../webgpu.g.dart';
// ignore_for_file: unused_element

mixin _ComputePassEncoderImpl on _ComputePassEncoderBase {
  void dispatchWorkgroups({int x = 1, int y = 1, int z = 1}) => _dispatchWorkgroupsImpl(x, y, z);
  void dispatchWorkgroupsIndirect(Buffer indirectBuffer, int indirectOffset) => _dispatchWorkgroupsIndirectImpl(indirectBuffer, indirectOffset);
  void end() => _endImpl();
  
  void insertDebugMarker(String markerLabel) => _insertDebugMarkerImpl(markerLabel);
  void pushDebugGroup(String groupLabel) => _pushDebugGroupImpl(groupLabel);
  void popDebugGroup() => _popDebugGroupImpl();

  set label(String label) => _setLabelImpl(label);
  void setBindGroup(int groupIndex, BindGroup? bindGroup, {List<int> dynamicOffsets = const []}) => _setBindGroupImpl(groupIndex, bindGroup, dynamicOffsets);
  void setPipeline(ComputePipeline pipeline) => _setPipelineImpl(pipeline);
}
