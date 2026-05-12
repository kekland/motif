import 'dart:ffi';
import 'dart:typed_data';

import 'package:dawn/dawn.dart' as dawn;
import 'package:dawn/darwin.dart' as darwin;

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class RenderToMtlTextureCase extends StatefulWidget {
  const RenderToMtlTextureCase({super.key});

  @override
  State<RenderToMtlTextureCase> createState() => _RenderToMtlTextureCaseState();
}

class _RenderToMtlTextureCaseState extends State<RenderToMtlTextureCase> {
  late final dawn.Instance _instance;
  late final dawn.Adapter _adapter;
  late final dawn.Device _device;
  late final dawn.UncapturedErrorCallbackListener _errorListener;
  bool _dawnReady = false;
  late final darwin.MTLFlutterTexture _texture;

  @override
  void initState() {
    super.initState();

    _texture = darwin.MTLFlutterTexture.create();
    _texture.register();

    _prepareDawn();
  }

  Future<void> _prepareDawn() async {
    _errorListener = .new((device, type, str) {
      print('Error ($device): $type, $str');
    });

    _instance = dawn.Instance.create();
    _adapter = await _instance.requestAdapter();
    _device = _adapter.createDevice(
      .new(
        label: 'main',
        uncapturedErrorCallbackInfo: .new(callback: _errorListener),
      ),
    );

    setState(() => _dawnReady = true);
  }

  @override
  void dispose() {
    _texture.dispose();
    super.dispose();
  }

  Future<void> _render() async {
    if (!_dawnReady) return;

    final bytes = await _renderTriangle();
    setState(() {
      _pngBytes = bytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Render to bytes')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: _render, child: Text('Render')),
            SizedBox(height: 16),
            SizedBox(
              width: 512,
              height: 512,
              child: Texture(textureId: _texture.textureId!),
            ),
          ],
        ),
      ),
    );
  }
}

Pointer<Void> _renderTriangle(
  dawn.Device device,
  darwin.MTLFlutterTexture texture,
) async {
  const _shader = r'''
struct VertexOutput {
    @builtin(position) position: vec4f,
    @location(0) color: vec3f,
};

@vertex
fn vs_main(@builtin(vertex_index) idx: u32) -> VertexOutput {
  let pos = array<vec2f, 3>(
    vec2f(0.0, 0.5),
    vec2f(-0.5, -0.5),
    vec2f(0.5, -0.5),
  );

  let colors = array<vec3f, 3>(
    vec3f(0.0, 1.0, 0.0),
    vec3f(1.0, 0.0, 0.0),
    vec3f(0.0, 0.0, 1.0),
  );

  var out: VertexOutput;
  out.position = vec4f(pos[idx], 0.0, 1.0);
  out.color = colors[idx];
  return out;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4f {
  return vec4f(in.color, 1.0);
}
''';

  const width = 512;
  const height = 512;

  final queue = device.queue;

  final renderTarget = device.createTexture(
    .new(
      label: 'render target',
      size: .new(width: width, height: height, depthOrArrayLayers: 1),
      format: .bGRA8Unorm,
      usage: .of([.renderAttachment, .copySrc]),
      mipLevelCount: 1,
      sampleCount: 1,
      dimension: .twoD,
    ),
  );

  final renderTargetView = renderTarget.createView(null);

  final shader = device.createShaderModule(
    .new(
      label: 'triangle shader',
      next: dawn.ShaderSourceWGSL(code: _shader),
    ),
  );

  final pipeline = device.createRenderPipeline(
    .new(
      label: 'triangle pipeline',
      vertex: dawn.VertexState(
        module: shader,
        entryPoint: 'vs_main',
      ),
      fragment: dawn.FragmentState(
        module: shader,
        entryPoint: 'fs_main',
        targets: [
          .new(format: .bGRA8Unorm, writeMask: .all),
        ],
      ),
      primitive: .new(topology: .triangleList, cullMode: .none),
      multisample: .new(count: 1, mask: 0xFFFFFFFF),
    ),
  );

  final encoder = device.createCommandEncoder();
  final renderPass = encoder.beginRenderPass(
    .new(
      colorAttachments: [
        .new(
          view: renderTargetView,
          loadOp: .clear,
          storeOp: .store,
          clearValue: .new(r: 0.0, g: 0.0, b: 0.0, a: 1.0),
        ),
      ],
    ),
  );

  renderPass.setPipeline(pipeline);
  renderPass.draw(3, 1, 0, 0);
  renderPass.end();

  const bpp = 4;
  const unpaddedBytesPerRow = width * bpp;
  const paddedBytesPerRow = ((unpaddedBytesPerRow + 255) ~/ 256) * 256;
  const bufferSize = paddedBytesPerRow * height;

  final readback = device.createBuffer(
    .new(
      label: 'readback buffer',
      size: bufferSize,
      usage: .of([.copyDst, .mapRead]),
    ),
  )!;

  encoder.copyTextureToBuffer(
    .new(texture: renderTarget),
    .new(
      buffer: readback,
      layout: .new(bytesPerRow: paddedBytesPerRow, rowsPerImage: height),
    ),
    .new(width: width, height: height, depthOrArrayLayers: 1),
  );

  queue.submit([encoder.finish()]);

  await readback.mapAsync(.read, 0, bufferSize);
  final padded = readback.readMappedRange(0, bufferSize);
  readback.unmap();

  final pixels = Uint8List(unpaddedBytesPerRow * height);
  for (var y = 0; y < height; y++) {
    final src = y * paddedBytesPerRow;
    final dst = y * unpaddedBytesPerRow;
    pixels.setRange(dst, dst + unpaddedBytesPerRow, padded, src);
  }

  for (var i = 0; i < pixels.length; i += 4) {
    final b = pixels[i + 0];
    final r = pixels[i + 2];
    pixels[i + 0] = r;
    pixels[i + 2] = b;
  }

  final image = img.Image.fromBytes(width: width, height: height, bytes: pixels.buffer, order: .rgba);
  return Uint8List.fromList(img.encodePng(image));
}
