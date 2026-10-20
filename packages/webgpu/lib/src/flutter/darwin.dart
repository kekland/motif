import 'package:flutter/widgets.dart';
import 'package:webgpu/src/flutter/widget.dart';
import 'package:webgpu/webgpu.dart' as webgpu;
import 'package:webgpu/native.dart' as native;
import 'package:webgpu/darwin.dart' as darwin;

WebGpuWidgetState createWebGpuWidgetState() => DarwinWebGpuWidgetState();

final class DarwinWebGpuWidgetState extends WebGpuWidgetState {
  late darwin.MTLFlutterTexture _texture;
  var _isReady = false;

  @override
  bool get isReady => _isReady;

  @override
  void initState() {
    super.initState();
    _texture = darwin.MTLFlutterTexture.create();
    _texture.register();
  }

  @override
  void dispose() {
    _texture.unregister();
    _texture.dispose();
    _isReady = false;
    super.dispose();
  }

  @override
  void configure(webgpu.Device device) {
    _isReady = true;
  }

  @override
  webgpu.TextureFormat get preferredFormat => .bgra8Unorm;

  @override
  void render(webgpu.Texture? Function(webgpu.TextureView? renderView) callback) {
    if (!_isReady) return;
    final texture = callback(null);
    final nativeTexture = texture as native.Texture;
    final mtlTexture = nativeTexture.nativeMetalTexture;
    _texture.updateBuffer(mtlTexture);
  }

  @override
  Widget build(BuildContext context) {
    return Texture(textureId: _texture.textureId!);
  }
}
