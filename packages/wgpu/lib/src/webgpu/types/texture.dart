part of '../webgpu.g.dart';
// ignore_for_file: unused_element

mixin _TextureImpl on _TextureBase {
  TextureView createView(TextureViewDescriptor? descriptor) => _createViewImpl(descriptor);
  int get depthOrArrayLayers => _getDepthOrArrayLayersImpl();
  TextureDimension get dimension => _getDimensionImpl();
  TextureFormat get format => _getFormatImpl();
  int get height => _getHeightImpl();
  int get mipLevelCount => _getMipLevelCountImpl();
  int get sampleCount => _getSampleCountImpl();
  TextureViewDimension get textureBindingViewDimension => _getTextureBindingViewDimensionImpl();
  TextureUsage get usage => _getUsageImpl();
  int get width => _getWidthImpl();

  set label(String label) => _setLabelImpl(label);
  void destroy() => _destroyImpl();
}
