import 'package:webgpu/native.dart' as webgpu;

void a() {
  final instance = webgpu.Instance.create();
  instance.createSurface(
    .new(
      next: webgpu.SurfaceSourceMetalLayer(
        layer: null,
      ),
    ),
  );
}
