part of 'types.dart';

abstract class Texture {
  set label(String value);

  TextureView createView([TextureViewDescriptor? descriptor]);
  int get width;
  int get height;
  int get depthOrArrayLayers;
  int get mipLevelCount;
  int get sampleCount;
  TextureDimension get dimension;
  TextureViewDimension get textureBindingViewDimension;
  TextureFormat get format;
  TextureUsage get usage;

  void dispose();
}
