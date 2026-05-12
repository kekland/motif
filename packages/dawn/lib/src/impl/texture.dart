part of '../src.dart';
// ignore_for_file: unused_element

class Texture extends _Texture {
  Texture._(super.ptr) : super._();
  Texture._borrowed(super.ptr) : super._borrowed();

  TextureView createErrorView(TextureViewDescriptor? descriptor) => _textureCreateErrorView(this, descriptor);
  TextureView createView(TextureViewDescriptor? descriptor) => _textureCreateView(this, descriptor);
  void destroy() => _textureDestroy(this);
  int get depthOrArrayLayers => _textureGetDepthOrArrayLayers(this);
  TextureDimension get dimension => _textureGetDimension(this);
  TextureFormat get format => _textureGetFormat(this);
  int get height => _textureGetHeight(this);
  int get mipLevelCount => _textureGetMipLevelCount(this);
  int get sampleCount => _textureGetSampleCount(this);
  TextureViewDimension get textureBindingViewDimension => _textureGetTextureBindingViewDimension(this);
  TextureUsage get usage => _textureGetUsage(this);
  int get width => _textureGetWidth(this);
  void pin(TextureUsage usage) => _texturePin(this, usage);
  void setLabel(String label) => _textureSetLabel(this, label);
  void setOwnershipForMemoryDump(int ownerGuid) => _textureSetOwnershipForMemoryDump(this, ownerGuid);
  void unpin() => _textureUnpin(this);
}
