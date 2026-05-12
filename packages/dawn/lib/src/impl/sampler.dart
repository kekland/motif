part of '../src.dart';
// ignore_for_file: unused_element

class Sampler extends _Sampler {
  Sampler._(super.ptr) : super._();
  Sampler._borrowed(super.ptr) : super._borrowed();

  void setLabel(String label) => _samplerSetLabel(this, label);
}
