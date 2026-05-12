part of '../src.dart';
// ignore_for_file: unused_element

class Surface extends _Surface {
  Surface._(super.ptr) : super._();
  Surface._borrowed(super.ptr) : super._borrowed();

  void configure(SurfaceConfiguration configuration) => _surfaceConfigure(this, configuration);
  SurfaceCapabilities getCapabilities(Adapter adapter) => _surfaceGetCapabilities(this, adapter);
  SurfaceTexture get currentTexture => _surfaceGetCurrentTexture(this);
  Status present() => _surfacePresent(this);
  void setLabel(String label) => _surfaceSetLabel(this, label);
}
