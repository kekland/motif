import 'package:flutter/widgets.dart';
import 'package:webgpu/webgpu.dart' as webgpu;

import 'darwin.dart' if (dart.library.js_interop) 'web.dart' show createWebGpuWidgetState;

final class const WebGpuWidget({
  required GlobalKey<WebGpuWidgetState> super.key,
}) extends StatefulWidget {
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => createWebGpuWidgetState();
}

abstract class WebGpuWidgetState extends State<WebGpuWidget> {
  bool get isReady;
  webgpu.TextureFormat get preferredFormat;

  void configure(webgpu.Device device);
  void render(webgpu.Texture? Function(webgpu.TextureView? renderView) callback);
}
