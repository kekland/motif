part of '../webgpu.g.dart';
// ignore_for_file: unused_element

mixin _SurfaceImpl on _SurfaceBase {
  void configure(SurfaceConfiguration configuration) => _configureImpl(configuration);
  void unconfigure() => _unconfigureImpl();

  SurfaceCapabilities getCapabilities(Adapter adapter) => _getCapabilitiesImpl(adapter);
  SurfaceTexture get currentTexture => _getCurrentTextureImpl();
  Status present() => _presentImpl();
  
  set label(String label) => _setLabelImpl(label);
}
