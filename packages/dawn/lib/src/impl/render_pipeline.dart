part of '../src.dart';
// ignore_for_file: unused_element

class RenderPipeline extends _RenderPipeline {
  RenderPipeline._(super.ptr) : super._();
  RenderPipeline._borrowed(super.ptr) : super._borrowed();

  BindGroupLayout getBindGroupLayout(int groupIndex) => _renderPipelineGetBindGroupLayout(this, groupIndex);
  void setLabel(String label) => _renderPipelineSetLabel(this, label);
}
