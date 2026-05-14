// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:wgpu/wgpu_native.dart' as wgpu;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class RenderToBytesCase extends StatefulWidget {
  const RenderToBytesCase({super.key});

  @override
  State<RenderToBytesCase> createState() => _RenderToBytesCaseState();
}

class _RenderToBytesCaseState extends State<RenderToBytesCase> {
  Uint8List? _pngBytes;

  Future<void> _render() async {
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
            if (_pngBytes != null) ...[
              SizedBox(height: 16),
              Image.memory(_pngBytes!),
            ],
          ],
        ),
      ),
    );
  }
}

Future<Uint8List> _renderTriangle() async {
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

  wgpu.WGPUNative.logLevel = .debug;
  wgpu.WGPUNative.setLogCallback((level, str) => print('wgpu [${level.name}]: $str'));

  final instance = wgpu.Instance.create();
  print('instance created');
  final adapter = await instance.requestAdapter();
  print('adapter created');
  final device = await adapter.requestDevice(.new(label: 'main'));
  print('device created');

  final queue = device.queue;

  final renderTarget = device.createTexture(
    .new(
      label: 'render target',
      size: .new(width: width, height: height, depthOrArrayLayers: 1),
      format: .BGRA8Unorm,
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
      next: wgpu.ShaderSourceWGSL(code: _shader),
    ),
  );

  final pipeline = device.createRenderPipeline(
    .new(
      label: 'triangle pipeline',
      vertex: wgpu.VertexState(
        module: shader,
        entryPoint: 'vs_main',
      ),
      fragment: wgpu.FragmentState(
        module: shader,
        entryPoint: 'fs_main',
        targets: [
          .new(format: .BGRA8Unorm, writeMask: .all),
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
  );

  encoder.copyTextureToBuffer(
    .new(texture: renderTarget),
    .new(
      buffer: readback,
      layout: .new(bytesPerRow: paddedBytesPerRow, rowsPerImage: height),
    ),
    .new(width: width, height: height),
  );

  queue.submit([encoder.finish()]);
  queue.onSubmittedWorkDone();
  

  await readback.mapAsync(mode: .read);
  print('readback mapped');

  final padded = readback.getMappedRange(0, bufferSize, readOnly: true);
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
