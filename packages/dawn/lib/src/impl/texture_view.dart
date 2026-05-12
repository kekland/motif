part of '../src.dart';
// ignore_for_file: unused_element

class TextureView extends _TextureView {
  TextureView._(super.ptr) : super._();
  TextureView._borrowed(super.ptr) : super._borrowed();

  void setLabel(String label) => _textureViewSetLabel(this, label);
}
