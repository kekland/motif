part of '../src.dart';
// ignore_for_file: unused_element

class TexelBufferView extends _TexelBufferView {
  TexelBufferView._(super.ptr) : super._();
  TexelBufferView._borrowed(super.ptr) : super._borrowed();

  void setLabel(String label) => _texelBufferViewSetLabel(this, label);
}
