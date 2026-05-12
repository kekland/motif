part of '../webgpu.g.dart';
// ignore_for_file: unused_element

mixin _RenderPipelineImpl on _RenderPipelineBase {
  BindGroupLayout getBindGroupLayout(int groupIndex) => _getBindGroupLayoutImpl(groupIndex);
  set label(String label) => _setLabelImpl(label);
}
