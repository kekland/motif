part of '../src.dart';
// ignore_for_file: unused_element

class SharedTextureMemory extends _SharedTextureMemory {
  SharedTextureMemory._(super.ptr) : super._();
  SharedTextureMemory._borrowed(super.ptr) : super._borrowed();

  Status beginAccess(Texture texture, SharedTextureMemoryBeginAccessDescriptor descriptor) => _sharedTextureMemoryBeginAccess(this, texture, descriptor);
  Texture createTexture(TextureDescriptor? descriptor) => _sharedTextureMemoryCreateTexture(this, descriptor);
  // endAccess
  SharedTextureMemoryProperties get properties => _sharedTextureMemoryGetProperties(this);
  bool get isDeviceLost => _sharedTextureMemoryIsDeviceLost(this);
  void setLabel(String label) => _sharedTextureMemorySetLabel(this, label);
}
