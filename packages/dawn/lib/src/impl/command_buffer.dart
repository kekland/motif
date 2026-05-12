part of '../src.dart';
// ignore_for_file: unused_element

class CommandBuffer extends _CommandBuffer {
  CommandBuffer._(super.ptr) : super._();
  CommandBuffer._borrowed(super.ptr) : super._borrowed();

  void setLabel(String label) => _commandBufferSetLabel(this, label);
}
