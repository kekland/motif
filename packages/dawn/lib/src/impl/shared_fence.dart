part of '../src.dart';
// ignore_for_file: unused_element

class SharedFence extends _SharedFence {
  SharedFence._(super.ptr) : super._();
  SharedFence._borrowed(super.ptr) : super._borrowed();

  SharedFenceExportInfo get exportInfo => _sharedFenceExportInfo(this);
  void setLabel(String label) => _sharedFenceSetLabel(this, label);
}
