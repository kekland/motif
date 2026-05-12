part of '../src.dart';
// ignore_for_file: unused_element

class ExternalTexture extends _ExternalTexture {
  ExternalTexture._(super.ptr) : super._();
  ExternalTexture._borrowed(super.ptr) : super._borrowed();

  void destroy() => _externalTextureDestroy(this);
  void expire() => _externalTextureExpire(this);
  void refresh() => _externalTextureRefresh(this);
  void setLabel(String label) => _externalTextureSetLabel(this, label);
}
