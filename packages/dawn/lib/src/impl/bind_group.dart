part of '../src.dart';
// ignore_for_file: unused_element

class BindGroup extends _BindGroup {
  BindGroup._(super.ptr) : super._();
  BindGroup._borrowed(super.ptr) : super._borrowed();

  void setLabel(String label) => _bindGroupSetLabel(this, label);
}
