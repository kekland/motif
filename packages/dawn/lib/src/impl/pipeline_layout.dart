part of '../src.dart';
// ignore_for_file: unused_element

class PipelineLayout extends _PipelineLayout {
  PipelineLayout._(super.ptr) : super._();
  PipelineLayout._borrowed(super.ptr) : super._borrowed();

  void setLabel(String label) => _pipelineLayoutSetLabel(this, label);
}
