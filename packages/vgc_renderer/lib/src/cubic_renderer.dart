import 'dart:ffi' as ffi;

import 'package:vector_math/vector_math_64.dart';
import 'package:vgc/vector_complex.dart';
import 'package:vgc_renderer/vgc_renderer.dart';

import 'package:wgpu/wgpu.dart' as wgpu;
import 'package:wgpu/wgpu_native.dart';
import 'package:wgpu/wgsl.dart' as wgsl;

import 'shaders/flatten.g.dart' as flatten;
import 'shaders/render.g.dart' as render;

class CubicRenderer {
  CubicRenderer() {
    _instance = wgpu.Instance.create();
    _adapter = _instance.requestAdapterSync();
    _device = _adapter.requestDeviceSync(
      .new(
        requiredLimits: .new(
          maxComputeInvocationsPerWorkgroup: 1024,
          maxComputeWorkgroupSizeX: 1024,
          maxStorageBuffersPerShaderStage: 8,
        ),
        requiredFeatures: [.subgroups, .timestampQuery],
      ),
    );

    ReassembleProvider.register(_setup);
    _setup();
  }

  void dispose() {
    ReassembleProvider.unregister(_setup);
  }

  static const int _maxEdges = 1024 * 16;
  static const int _maxCubics = 1024 * 64;
  static const int _maxGeometry = 1024 * 256;
  static const int _maxWeightSamples = _maxCubics * 16;

  late final wgpu.Instance _instance;
  late final wgpu.Adapter _adapter;
  late final wgpu.Device _device;

  late wgpu.ComputePipeline _flattenPipeline;
  late wgpu.RenderPipeline _renderPipeline;

  late wgpu.BindGroup _flattenBindGroup;
  late wgpu.BindGroup _renderBindGroup;

  late flatten.UniformsUniformBuffer _ubo;
  late flatten.EdgeDataArrayStorageBuffer _edgeBuffer;
  late flatten.CubicDataArrayStorageBuffer _cubicBuffer;
  late flatten.Vec3fArrayStorageBuffer _edgeWeightSamplesBuffer;
  late flatten.RenderGeometryArrayStorageBuffer _geometryBuffer;
  late flatten.DrawIndirectArgsStorageBuffer _drawIndirectArgsBuffer;

  void _setup() {
    _flattenPipeline = flatten.createComputePipeline(_device);
    _renderPipeline = render.createRenderPipeline(
      _device,
      [
        .new(
          format: .BGRA8Unorm,
          blend: .new(
            color: .new(
              srcFactor: .srcAlpha,
              dstFactor: .oneMinusSrcAlpha,
              operation: .add,
            ),
            alpha: .new(
              srcFactor: .one,
              dstFactor: .oneMinusSrcAlpha,
              operation: .add,
            ),
          ),
        ),
      ],
      primitive: .new(
        topology: .triangleList,
        cullMode: .none,
        frontFace: .CW,
      ),
      multisample: .new(
        count: 4,
        mask: 0xFFFFFFFF,
        alphaToCoverageEnabled: false,
      ),
    );

    _ubo = flatten.UniformsUniformBuffer(_device);
    _edgeBuffer = flatten.EdgeDataArrayStorageBuffer(_device, length: _maxEdges);
    _cubicBuffer = flatten.CubicDataArrayStorageBuffer(_device, length: _maxCubics);
    _edgeWeightSamplesBuffer = flatten.Vec3fArrayStorageBuffer(_device, length: _maxWeightSamples);
    _geometryBuffer = flatten.RenderGeometryArrayStorageBuffer(_device, length: _maxGeometry);
    _drawIndirectArgsBuffer = flatten.DrawIndirectArgsStorageBuffer(
      _device,
      usage: .of([.storage, .indirect, .copyDst]),
    );

    _flattenBindGroup = flatten.createBindGroup0(
      _device,
      u: _ubo,
      inEdgeData: _edgeBuffer,
      inCubicData: _cubicBuffer,
      inEdgeWeightSamples: _edgeWeightSamplesBuffer,
      outRenderGeometry: _geometryBuffer,
      outDrawArgs: _drawIndirectArgsBuffer,
    );

    _renderBindGroup = render.createBindGroup0(
      _device,
      u: _ubo,
      inRenderGeometry: _geometryBuffer,
    );

    // const queryCount = 4;

    // _querySet = _device.createQuerySet(
    //   .new(
    //     type: .timestamp,
    //     count: queryCount,
    //   ),
    // );

    // _resolveBuffer = _device.createBuffer(
    //   .new(
    //     size: queryCount * 8,
    //     usage: .of([.queryResolve, .copySrc]),
    //   ),
    // );

    // _readbackBuffer = _device.createBuffer(
    //   .new(
    //     size: queryCount * 8,
    //     usage: .of([.copyDst, .mapRead]),
    //   ),
    // );
  }

  wgpu.Texture? _texture;
  wgpu.TextureView? _textureView;
  wgpu.Texture? _msaaTexture;
  wgpu.TextureView? _msaaTextureView;

  ffi.Pointer<ffi.Void> renderToTexture(
    List<Edge> edges, {
    required int width,
    required int height,
    required double tolerance,
    required Matrix4 transform,
    List<TransientStroke>? transientStrokes,
  }) {
    final stopwatch = Stopwatch()..start();
    final queue = _device.queue;

    if (_texture?.width != width || _texture?.height != height) {
      _texture?.dispose();
      _msaaTexture?.dispose();

      _texture = _device.createTexture(
        .new(
          label: 'render texture',
          size: .new(width: width, height: height, depthOrArrayLayers: 1),
          dimension: .twoD,
          format: .BGRA8Unorm,
          usage: .of([.renderAttachment, .textureBinding]),
          sampleCount: 1,
        ),
      );

      _msaaTexture = _device.createTexture(
        .new(
          label: 'msaa texture',
          size: .new(width: width, height: height, depthOrArrayLayers: 1),
          dimension: .twoD,
          format: .BGRA8Unorm,
          usage: .renderAttachment,
          sampleCount: 4,
        ),
      );

      _textureView = _texture!.createView();
      _msaaTextureView = _msaaTexture!.createView();
    }

    // Write cubics
    var edgeIdx = 0;
    var cubicIdx = 0;
    var weightIdx = 0;

    for (final edge in edges) {
      final color = edge.color.cssColor.convertTo(.srgb).storage;
      final spline = edge.spline;
      final weights = edge.strokeWeight.toArcLengthProfile(spline.distanceAtT, spline.arcLength).samples;

      _edgeBuffer.set(
        edgeIdx,
        color: wgsl.Vec4f(color.$1, color.$2, color.$3, color.$4),
        width: edge.strokeWidth,
        weightSpan: .new(weightIdx, weights.length),
        arcLength: spline.arcLength,
      );

      for (final sample in weights) {
        _edgeWeightSamplesBuffer[weightIdx] = .new(sample.x, sample.v, sample.dv);
        weightIdx++;
      }

      final cubics = spline.segments.toList();
      var arcLength = 0.0;
      for (var i = 0; i < cubics.length; i++) {
        final c = cubics[i];

        _cubicBuffer.set(
          cubicIdx,
          cubic: (
            .new(c.p0.x, c.p0.y),
            .new(c.p1.x, c.p1.y),
            .new(c.p2.x, c.p2.y),
            .new(c.p3.x, c.p3.y),
          ),
          edgeIdx: edgeIdx,
          edgeSegmentIdx: i,
          edgeSegmentCount: cubics.length,
          edgeStartArcLength: arcLength,
          opacity: 1.0,
        );

        cubicIdx++;
        arcLength += c.arcLength;
      }

      edgeIdx++;
    }

    // Transient strokes: write as cubics for now
    if (transientStrokes != null) {
      for (final stroke in transientStrokes) {
        final length = stroke.length;
        final totalLength = stroke.lengthWithPredictions;

        final color = stroke.color.cssColor.convertTo(.srgb).storage;
        final weightSpanStartIdx = weightIdx;

        var _arcLength = 0.0;

        final w0 = stroke.getWeight(0);
        _edgeWeightSamplesBuffer[weightIdx] = .new(0.0, w0, 0.0);
        weightIdx++;

        for (var i = 0; i < totalLength - 1; i++) {
          final p0 = stroke.getPoint(i);
          final p3 = stroke.getPoint(i + 1);
          final dist = (p0 - p3).distance;
          if (dist < 1.0e-4) continue;

          final w1 = stroke.getWeight(i + 1);

          final p1 = p0 + (p3 - p0) * (1.0 / 3.0);
          final p2 = p0 + (p3 - p0) * (2.0 / 3.0);

          final opacity = i < length - 1 ? 1.0 : 0.75;

          _cubicBuffer.set(
            cubicIdx,
            cubic: (
              .new(p0.dx, p0.dy),
              .new(p1.dx, p1.dy),
              .new(p2.dx, p2.dy),
              .new(p3.dx, p3.dy),
            ),
            edgeIdx: edgeIdx,
            edgeSegmentIdx: i,
            edgeSegmentCount: totalLength - 1,
            edgeStartArcLength: _arcLength,
            opacity: opacity,
          );

          _arcLength += (p3 - p0).distance;

          _edgeWeightSamplesBuffer[weightIdx] = .new(_arcLength, w1, 0.0);

          cubicIdx++;
          weightIdx++;
        }

        _edgeBuffer.set(
          edgeIdx,
          color: wgsl.Vec4f(color.$1, color.$2, color.$3, color.$4),
          width: stroke.width,
          weightSpan: .new(weightSpanStartIdx, weightIdx - weightSpanStartIdx),
          arcLength: _arcLength,
        );

        edgeIdx++;
      }
    }

    _edgeBuffer.writeToQueue(queue, count: edgeIdx);
    _cubicBuffer.writeToQueue(queue, count: cubicIdx);
    _edgeWeightSamplesBuffer.writeToQueue(queue, count: weightIdx);

    _ubo.set(
      tolerance: tolerance,
      screenSize: .new(width.toDouble(), height.toDouble()),
      transform: .fromMatrix64(transform),
      cubicCount: cubicIdx,
      weightAnchorCount: weightIdx,
    );

    _ubo.writeToQueue(queue);

    _drawIndirectArgsBuffer.set(vertexCount: 6, instanceCount: 0, firstVertex: 0, firstInstance: 0);
    _drawIndirectArgsBuffer.writeToQueue(queue);

    final encoder = _device.createCommandEncoder();

    // Flatten
    {
      // encoder.writeTimestamp(_querySet, 0);
      final pass = encoder.beginComputePass();
      pass.setPipeline(_flattenPipeline);
      flatten.bindPipeline(pass, group0: _flattenBindGroup);
      pass.dispatchWorkgroups(x: (cubicIdx / 64).ceil());
      pass.end();
      // encoder.writeTimestamp(_querySet, 1);
    }

    // Render
    {
      // encoder.writeTimestamp(_querySet, 2);
      final pass = encoder.beginRenderPass(
        .new(
          colorAttachments: [
            .new(
              view: _msaaTextureView!,
              resolveTarget: _textureView!,
              loadOp: .clear,
              storeOp: .discard,
              clearValue: .new(r: 0.0, g: 0.0, b: 0.0, a: 0.0),
            ),
          ],
        ),
      );

      pass.setPipeline(_renderPipeline);
      pass.setBindGroup(0, _renderBindGroup);
      pass.drawIndirect(_drawIndirectArgsBuffer.buffer, 0);
      pass.end();
      // encoder.writeTimestamp(_querySet, 3);
    }

    final submitTime = stopwatch.elapsedMicroseconds;

    _device.queue.submit([encoder.finish()]);
    // _device.queue.onSubmittedWorkDoneSync();

    stopwatch.stop();
    // print('gpu: ${stopwatch.elapsedMilliseconds} ms (prepare: ${submitTime} µs)');

    return _texture!.nativeMetalTexture;
  }
}
