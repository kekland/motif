part of '../src.dart';
// ignore_for_file: unused_element

class BindGroupLayout extends _BindGroupLayout {
  BindGroupLayout._(super.ptr) : super._();
  BindGroupLayout._borrowed(super.ptr) : super._borrowed();

  void setLabel(String label) => _bindGroupLayoutSetLabel(this, label);
}
