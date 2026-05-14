import 'dart:ffi' as ffi;

import 'package:geometry/geometry.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:wgpu/wgpu.dart' as wgpu;
import 'package:wgpu/wgpu_native.dart' as wgpu_native;
import 'cubic_renderer.g.dart' as bindings;

class CubicRenderer {
  CubicRenderer() {
    _instance = wgpu.Instance.create();
    _adapter = _instance.requestAdapterSync();
    _device = _adapter.requestDeviceSync();
    _setup();
  }

  static const int _maxCubics = 1024 * 16;
  static const int _maxQuadratics = 1024 * 64;
  static const int _maxQuadsPerTile = 64;
  static const double _tileSize = 64.0;

  late final wgpu.Instance _instance;
  late final wgpu.Adapter _adapter;
  late final wgpu.Device _device;

  late wgpu.ShaderModule _module;

  late wgpu.ComputePipeline _cubicToQuadsPipeline;
  late wgpu.ComputePipeline _quadBinningPipeline;
  late wgpu.RenderPipeline _quadRendererPipeline;

  late wgpu.BindGroup _cubicToQuadsBindGroup;
  late wgpu.BindGroup _quadBinningBindGroup;
  late wgpu.BindGroup _quadRendererBindGroup;

  late bindings.Cubic2ArrayBuffer _cubicsBuffer;
  late bindings.Quadratic2ArrayBuffer _quadsBuffer;
  late bindings.U32Buffer _quadCountBuffer;
  late bindings.U32ArrayBuffer _tileCountsBuffer;
  late bindings.U32ArrayBuffer _tileIndicesBuffer;

  late bindings.CubicToQuadsUniformsBuffer _cubicToQuadsUbo;
  late bindings.QuadBinningUniformsBuffer _quadBinningUbo;
  late bindings.QuadRendererUniformsBuffer _quadRendererUbo;

  wgpu.Texture? _texture;
  wgpu.TextureView? _textureView;

  void _setup() {
    // Shader module
    _module = bindings.createShaderModule(_device);

    // Pipelines
    _cubicToQuadsPipeline = bindings.createCsCubicToQuadsPipeline(_device, _module);

    _quadBinningPipeline = bindings.createCsQuadBinningPipeline(_device, _module);
    _quadRendererPipeline = bindings.createVsQuadRendererFsQuadRendererRenderPipeline(
      _device,
      _module,
      [.new(format: .BGRA8Unorm)],
    );

    // UBOs and buffers
    _cubicToQuadsUbo = .new(_device);
    _quadBinningUbo = .new(_device);
    _quadRendererUbo = .new(_device);

    _cubicsBuffer = .new(_device, _maxCubics);
    _quadsBuffer = .new(_device, _maxQuadratics);
    _quadCountBuffer = .new(_device);
    _tileCountsBuffer = .new(_device, 1000);
    _tileIndicesBuffer = .new(_device, 1000 * _maxQuadsPerTile);

    // Bind groups
    _cubicToQuadsBindGroup = bindings.createBindGroup0(
      _device,
      _cubicToQuadsPipeline.getBindGroupLayout(0),
      uCubicToQuads: _cubicToQuadsUbo,
      inCubics: _cubicsBuffer,
      outCounter: _quadCountBuffer,
      outQuadratics: _quadsBuffer,
    );

    _quadBinningBindGroup = bindings.createBindGroup1(
      _device,
      _quadBinningPipeline.getBindGroupLayout(1),
      uQuadBinning: _quadBinningUbo,
      inQuadratics: _quadsBuffer,
      inQuadCounts: _quadCountBuffer,
      outTileCounts: _tileCountsBuffer,
      outTileIndices: _tileIndicesBuffer,
    );

    _quadRendererBindGroup = bindings.createBindGroup2(
      _device,
      _quadRendererPipeline.getBindGroupLayout(2),
      uQuadRenderer: _quadRendererUbo,
      inRendererQuadratics: _quadsBuffer,
      inTileCounts: _tileCountsBuffer,
      inTileIndices: _tileIndicesBuffer,
    );
  }

  ffi.Pointer<ffi.Void> render(
    List<CubicSpline2> splines, {
    required int width,
    required int height,
    required double tolerance,
    required Matrix4 transform,
  }) {
    final queue = _device.queue;

    final tilesWidth = (width / _tileSize).ceil();
    final tilesHeight = (height / _tileSize).ceil();

    if (_texture?.width != width || _texture?.height != height) {
      _texture?.dispose();
      _texture = _device.createTexture(
        .new(
          label: 'render texture',
          size: .new(width: width, height: height, depthOrArrayLayers: 1),
          dimension: .twoD,
          format: .BGRA8Unorm,
          usage: .of([.renderAttachment, .textureBinding]),
        ),
      );

      _textureView = _texture!.createView();
    }

    _cubicToQuadsUbo.write(
      .new(
        tolerance: tolerance,
        transform: .fromMatrix64(transform),
        maxQuadratics: _maxQuadratics,
      ),
    );
    _cubicToQuadsUbo.writeToQueue(queue);

    _quadBinningUbo.write(
      .new(
        screenSize: .new(width.toDouble(), height.toDouble()),
        tilesWidth: tilesWidth,
        tilesHeight: tilesHeight,
        maxPerTile: _maxQuadsPerTile,
        tileSize: _tileSize,
        strokeWidth: 4.0,
      ),
    );
    _quadBinningUbo.writeToQueue(queue);

    _quadRendererUbo.write(
      .new(
        screenSize: .new(width.toDouble(), height.toDouble()),
        maxPerTile: _maxQuadsPerTile,
        tileSize: _tileSize,
        tilesWidth: tilesWidth,
      ),
    );
    _quadRendererUbo.writeToQueue(queue);

    _quadCountBuffer.clear();
    _quadCountBuffer.writeToQueue(queue);

    _tileCountsBuffer.clear();
    _tileCountsBuffer.writeToQueue(queue);

    final cubics = splines.expand((s) => s.segments).toList();
    for (var i = 0; i < cubics.length; i++) {
      final c = cubics[i];
      _cubicsBuffer[i] = .new(
        p0: .fromVector64(c.p0),
        p1: .fromVector64(c.p1),
        p2: .fromVector64(c.p2),
        p3: .fromVector64(c.p3),
      );
    }

    _cubicsBuffer.writeToQueue(queue);

    final encoder = _device.createCommandEncoder();
    final pass1 = encoder.beginComputePass();
    pass1.setPipeline(_cubicToQuadsPipeline);
    pass1.setBindGroup(0, _cubicToQuadsBindGroup);

    pass1.dispatchWorkgroups(x: (cubics.length + 63) ~/ 64);
    pass1.end();

    final pass2 = encoder.beginComputePass();
    pass2.setPipeline(_quadBinningPipeline);
    pass2.setBindGroup(1, _quadBinningBindGroup);

    pass2.dispatchWorkgroups(x: _maxQuadratics ~/ 64);
    pass2.end();

    final renderPass = encoder.beginRenderPass(
      .new(
        colorAttachments: [
          .new(
            view: _textureView!,
            loadOp: .clear,
            storeOp: .store,
            clearValue: .new(r: 0.0, g: 0.0, b: 0.0, a: 0.0),
          ),
        ],
      ),
    );

    renderPass.setPipeline(_quadRendererPipeline);
    renderPass.setBindGroup(2, _quadRendererBindGroup);

    renderPass.draw(3, 1, 0, 0);
    renderPass.end();

    _device.queue.submit([encoder.finish()]);
    _device.queue.onSubmittedWorkDoneSync();

    return _texture!.nativeMetalTexture;
  }
}
