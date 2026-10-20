part of 'types.dart';

abstract class Surface {
  set label(String value);

  SurfaceCapabilities getCapabilities(covariant Adapter adapter);
  SurfaceTexture get currentTexture;
  void configure(SurfaceConfiguration configuration);
  void unconfigure();

  Status present();

  void dispose();
}
