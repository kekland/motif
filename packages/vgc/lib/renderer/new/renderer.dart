import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:geometry/geometry.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:vgc/renderer/new/quad_binning.dart';
import 'package:vgc/renderer/new/quad_renderer.dart';
import 'package:wgpu/wgpu.dart' as wgpu;
import 'package:wgpu/wgpu_native.dart' as wgpu_native;

import 'cubic_to_quads.dart';

class Renderer {
  static const _bytesPerCubic = 4 * 2 * 4;
  static const _maxCubics = 1024 * 16;

  static const _bytesPerQuadratic = 4 * 3 * 4;
  static const _maxQuadratics = 1024 * 64;

  static const _tileSize = 16.0;
  static const _maxQuadsPerTile = 64;

  Renderer() {
    _instance = wgpu.Instance.create();
    _adapter = _instance.requestAdapterSync();
    _device = _adapter.requestDeviceSync(.new(label: 'main'));

    _cubicToQuads = CubicToQuads(_device);
    _quadBinning = QuadBinning(_device);
    _quadRenderer = QuadRenderer(_device);

    _cubicsBuffer = _device.createBuffer(
      .new(
        label: 'cubics buffer',
        size: _bytesPerCubic * _maxCubics,
        usage: .of([.storage, .copyDst]),
      ),
    );

    _quadsBuffer = _device.createBuffer(
      .new(
        label: 'quadratics buffer',
        size: _bytesPerQuadratic * _maxQuadratics,
        usage: .of([.storage]),
      ),
    );

    _quadCountBuffer = _device.createBuffer(
      .new(
        label: 'quad count buffer',
        size: 4,
        usage: .of([.storage, .copyDst]),
      ),
    );
  }

  late final wgpu.Instance _instance;
  late final wgpu.Adapter _adapter;
  late final wgpu.Device _device;

  late final CubicToQuads _cubicToQuads;
  late final QuadBinning _quadBinning;
  late final QuadRenderer _quadRenderer;

  wgpu.BindGroup? _cubicToQuadsBindGroup;
  wgpu.BindGroup? _quadBinningBindGroup;
  wgpu.BindGroup? _quadRendererBindGroup;
  void _resetBindGroups() {
    _cubicToQuadsBindGroup?.dispose();
    _quadBinningBindGroup?.dispose();
    _quadRendererBindGroup?.dispose();
    _cubicToQuadsBindGroup = null;
    _quadBinningBindGroup = null;
    _quadRendererBindGroup = null;
  }

  late final wgpu.Buffer _cubicsBuffer;
  late final wgpu.Buffer _quadsBuffer;
  late final wgpu.Buffer _quadCountBuffer;
  wgpu.Buffer? _tileCountsBuffer;
  wgpu.Buffer? _tileIndicesBuffer;

  wgpu.Texture? _texture;
  wgpu.TextureView? _textureView;

  ffi.Pointer<ffi.Void> render(
    List<CubicSpline2> splines, {
    required int screenWidth,
    required int screenHeight,
    required double tolerance,
    required Matrix4 transform,
  }) {
    final queue = _device.queue;

    final tilesWidth = (screenWidth / _tileSize).ceil();
    final tilesHeight = (screenHeight / _tileSize).ceil();

    final tileCountsSize = tilesWidth * tilesHeight * 4;
    if (_tileCountsBuffer == null || _tileCountsBuffer!.size != tileCountsSize) {
      _tileCountsBuffer?.dispose();
      _tileCountsBuffer = _device.createBuffer(
        .new(
          label: 'tile counts buffer',
          size: tileCountsSize,
          usage: .of([.storage, .copyDst]),
        ),
      );
      _resetBindGroups();
    }

    final tileIndicesSize = tilesWidth * tilesHeight * _maxQuadsPerTile * 4;
    if (_tileIndicesBuffer == null || _tileIndicesBuffer!.size != tileIndicesSize) {
      _tileIndicesBuffer?.dispose();
      _tileIndicesBuffer = _device.createBuffer(
        .new(
          label: 'tile indices buffer',
          size: tileIndicesSize,
          usage: .of([.storage, .copyDst]),
        ),
      );
      _resetBindGroups();
    }

    if (_texture == null || _texture!.width != screenWidth || _texture!.height != screenHeight) {
      _texture?.destroy();
      _textureView?.dispose();
      _texture = _device.createTexture(
        .new(
          label: 'render texture',
          size: .new(width: screenWidth, height: screenHeight, depthOrArrayLayers: 1),
          dimension: .twoD,
          format: .BGRA8Unorm,
          usage: .of([.renderAttachment, .textureBinding]),
        ),
      );
      _textureView = _texture!.createView();
    }

    _cubicToQuadsBindGroup ??= _cubicToQuads.createBindGroup(
      cubicsBuffer: _cubicsBuffer,
      quadraticsBuffer: _quadsBuffer,
      counterBuffer: _quadCountBuffer,
    );

    _quadBinningBindGroup ??= _quadBinning.createBindGroup(
      quadraticsBuffer: _quadsBuffer,
      quadCountsBuffer: _quadCountBuffer,
      tileCountsBuffer: _tileCountsBuffer!,
      tileIndicesBuffer: _tileIndicesBuffer!,
    );

    _quadRendererBindGroup ??= _quadRenderer.createBindGroup(
      quadraticsBuffer: _quadsBuffer,
      tileCountsBuffer: _tileCountsBuffer!,
      tileIndicesBuffer: _tileIndicesBuffer!,
    );

    final screenSize = Vector2(screenWidth.toDouble(), screenHeight.toDouble());
    _cubicToQuads.setUniformBuffer(
      tolerance: 0.25,
      maxQuadratics: _maxQuadratics,
      transform: transform,
    );
    _quadBinning.setUniformBuffer(
      screenSize: screenSize,
      tileSize: _tileSize,
      maxPerTile: _maxQuadsPerTile,
      tilesWidth: tilesWidth,
      tilesHeight: tilesHeight,
      strokeWidth: 4.0,
    );
    _quadRenderer.setUniformBuffer(
      screenSize: screenSize,
      tileSize: _tileSize,
      maxPerTile: _maxQuadsPerTile,
      tilesWidth: tilesWidth,
    );

    final zeroData = Uint32List.fromList([0]).buffer.asByteData();
    queue.writeBuffer(_quadCountBuffer, 0, zeroData);
    queue.writeBuffer(_tileCountsBuffer!, 0, Uint8List(tileCountsSize));

    final cubics = splines.expand((s) => s.segments).toList();
    final cubicsData = ByteData(_bytesPerCubic * cubics.length);
    for (var i = 0; i < cubics.length; i++) {
      final c = cubics[i];
      cubicsData.setFloat32(i * _bytesPerCubic + 0, c.p0.x, Endian.little);
      cubicsData.setFloat32(i * _bytesPerCubic + 4, c.p0.y, Endian.little);
      cubicsData.setFloat32(i * _bytesPerCubic + 8, c.p1.x, Endian.little);
      cubicsData.setFloat32(i * _bytesPerCubic + 12, c.p1.y, Endian.little);
      cubicsData.setFloat32(i * _bytesPerCubic + 16, c.p2.x, Endian.little);
      cubicsData.setFloat32(i * _bytesPerCubic + 20, c.p2.y, Endian.little);
      cubicsData.setFloat32(i * _bytesPerCubic + 24, c.p3.x, Endian.little);
      cubicsData.setFloat32(i * _bytesPerCubic + 28, c.p3.y, Endian.little);
    }
    queue.writeBuffer(_cubicsBuffer, 0, cubicsData);

    final encoder = _device.createCommandEncoder(.new(label: 'cubic-to-quads command encoder'));
    final pass1 = encoder.beginComputePass(.new(label: 'cubic-to-quads compute pass'));
    _cubicToQuads.encode(pass1, _cubicToQuadsBindGroup!, cubics.length);
    pass1.end();

    final pass2 = encoder.beginComputePass(.new(label: 'quad binning compute pass'));
    _quadBinning.encode(pass2, _quadBinningBindGroup!, 100);
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

    _quadRenderer.encode(renderPass, _quadRendererBindGroup!);
    renderPass.end();

    _device.queue.submit([encoder.finish()]);
    _device.queue.onSubmittedWorkDoneSync();

    return _texture!.nativeMetalTexture;
  }
}
