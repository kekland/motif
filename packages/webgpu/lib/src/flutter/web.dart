import 'package:web/web.dart' as web;
import 'package:webgpu/src/web/webgpu.g.dart' as web;

import 'package:flutter/widgets.dart';
import 'package:webgpu/src/flutter/widget.dart';
import 'package:webgpu/webgpu.dart' as webgpu;
import 'package:webgpu/web.dart' as webgpu_web;

WebGpuWidgetState createWebGpuWidgetState() => WebWebGpuWidgetState();

final class WebWebGpuWidgetState extends WebGpuWidgetState {
  var _isReady = false;
  var _isConfigured = false;
  late web.HTMLCanvasElement _canvas;
  late web.GPUCanvasContext _canvasContext;
  late webgpu.TextureFormat _preferredFormat;

  @override
  bool get isReady => _isReady;

  @override
  void dispose() {
    _isReady = false;
    super.dispose();
  }

  @override
  void configure(webgpu.Device device) {
    if (_isConfigured) throw Exception('Canvas is already configured.');

    _canvasContext.configure(
      .new(
        device: device.toJS,
        format: _preferredFormat.name!,
        usage: webgpu.TextureUsage.renderAttachment.value,
        alphaMode: 'premultiplied',
      ),
    );
    _isConfigured = true;
  }

  @override
  webgpu.TextureFormat get preferredFormat => _preferredFormat;

  @override
  void render(webgpu.Texture? Function(webgpu.TextureView? renderView) callback) {
    if (!_isReady) return;

    final texture = webgpu_web.Texture.from(_canvasContext.getCurrentTexture());
    final view = texture.createView();
    callback(view);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return HtmlElementView.fromTagName(
          tagName: 'canvas',
          onElementCreated: (element) {
            _canvas = element as web.HTMLCanvasElement;
            _canvas.style.width = '100%';
            _canvas.style.height = '100%';
            _canvas.style.display = 'block';
            _canvas.style.pointerEvents = 'none';

            final double dpr = web.window.devicePixelRatio;
            _canvas.width = (constraints.maxWidth * dpr).toInt();
            _canvas.height = (constraints.maxHeight * dpr).toInt();

            _canvasContext = _canvas.getContext('webgpu') as web.GPUCanvasContext;
            _preferredFormat = .fromName(webgpu_web.Instance.instance.toJS.getPreferredCanvasFormat())!;
            _isReady = true;
          },
        );
      },
    );
  }
}
