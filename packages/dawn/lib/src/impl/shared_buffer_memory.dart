part of '../src.dart';
// ignore_for_file: unused_element

class SharedBufferMemory extends _SharedBufferMemory {
  SharedBufferMemory._(super.ptr) : super._();
  SharedBufferMemory._borrowed(super.ptr) : super._borrowed();

  Status beginAccess(Buffer buffer, SharedBufferMemoryBeginAccessDescriptor descriptor) => _sharedBufferMemoryBeginAccess(this, buffer, descriptor);
  Buffer createBuffer(BufferDescriptor? descriptor) => _sharedBufferMemoryCreateBuffer(this, descriptor);
  // endAccess
  SharedBufferMemoryProperties get properties => _sharedBufferMemoryGetProperties(this);
  bool get isDeviceLost => _sharedBufferMemoryIsDeviceLost(this);
  void setLabel(String label) => _sharedBufferMemorySetLabel(this, label);
}
