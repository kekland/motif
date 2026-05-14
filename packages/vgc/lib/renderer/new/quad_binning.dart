import 'dart:typed_data';

import 'package:geometry/geometry.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:wgpu/wgpu.dart' as wgpu;

const _shader = '''
struct Quadratic2 {
  p0: vec2f,
  p1: vec2f,
  p2: vec2f,
};

struct Uniforms {
  screen_size: vec2f,
  tile_size: f32,
  max_per_tile: u32,
  tiles_width: u32,
  tiles_height: u32,
  stroke_width: f32,
};

@group(0) @binding(0) var<uniform> u: Uniforms;
@group(0) @binding(1) var<storage, read> in_quadratics: array<Quadratic2>;
@group(0) @binding(2) var<storage, read> in_quad_counts: u32;
@group(0) @binding(3) var<storage, read_write> out_tile_counts: array<atomic<u32>>;
@group(0) @binding(4) var<storage, read_write> out_tile_indices: array<u32>;

@compute @workgroup_size(64)
fn main(@builtin(global_invocation_id) id: vec3u) {
  let quad_id = id.x;
  if (quad_id >= in_quad_counts) { return; }

  let quad = in_quadratics[quad_id];

  var min_p = min(quad.p0, min(quad.p1, quad.p2));
  var max_p = max(quad.p0, max(quad.p1, quad.p2));
  
  min_p = min_p - vec2f(u.stroke_width);
  max_p = max_p + vec2f(u.stroke_width);

  let min_tile_x = u32(clamp(floor(min_p.x / u.tile_size), 0.0, f32(u.tiles_width - 1)));
  let max_tile_x = u32(clamp(floor(max_p.x / u.tile_size), 0.0, f32(u.tiles_width - 1)));
  let min_tile_y = u32(clamp(floor(min_p.y / u.tile_size), 0.0, f32(u.tiles_height - 1)));
  let max_tile_y = u32(clamp(floor(max_p.y / u.tile_size), 0.0, f32(u.tiles_height - 1)));

  for (var y = min_tile_y; y <= max_tile_y; y++) {
    for (var x = min_tile_x; x <= max_tile_x; x++) {
      let tile_index = y * u.tiles_width + x;
      let slot = atomicAdd(&out_tile_counts[tile_index], 1u);
      if (slot < u.max_per_tile) {
        let address = tile_index * u.max_per_tile + slot;
        out_tile_indices[address] = quad_id;
      }
    }
  }
}
''';

class QuadBinning {
  QuadBinning(this._device) {
    _shaderModule = _device.createShaderModule(
      .new(
        label: 'quad binning shader',
        next: wgpu.ShaderSourceWGSL(code: _shader),
      ),
    );

    _pipeline = _device.createComputePipeline(
      .new(
        label: 'quad binning pipeline',
        layout: null,
        compute: .new(module: _shaderModule, entryPoint: 'main'),
      ),
    );

    _bindGroupLayout = _pipeline.getBindGroupLayout(0);

    _uniformBuffer = _device.createBuffer(
      .new(
        label: 'quad binning uniform buffer',
        size: 32,
        usage: .of([.uniform, .copyDst]),
      ),
    );
  }

  final wgpu.Device _device;

  late final wgpu.Buffer _uniformBuffer;
  late final wgpu.ShaderModule _shaderModule;
  late final wgpu.ComputePipeline _pipeline;
  late final wgpu.BindGroupLayout _bindGroupLayout;

  void setUniformBuffer({
    required Vector2 screenSize,
    required double tileSize,
    required int maxPerTile,
    required int tilesWidth,
    required int tilesHeight,
    required double strokeWidth,
  }) {
    final data = ByteData(_uniformBuffer.size);
    data.setFloat32(0, screenSize.x, .little);
    data.setFloat32(4, screenSize.y, .little);
    data.setFloat32(8, tileSize, .little);
    data.setUint32(12, maxPerTile, Endian.little);
    data.setUint32(16, tilesWidth, Endian.little);
    data.setUint32(20, tilesHeight, Endian.little);
    data.setFloat32(24, strokeWidth, .little);
    _device.queue.writeBuffer(_uniformBuffer, 0, data);
  }

  wgpu.BindGroup createBindGroup({
    required wgpu.Buffer quadraticsBuffer,
    required wgpu.Buffer quadCountsBuffer,
    required wgpu.Buffer tileCountsBuffer,
    required wgpu.Buffer tileIndicesBuffer,
  }) {
    return _device.createBindGroup(
      .new(
        label: 'quad binning bind group',
        layout: _bindGroupLayout,
        entries: [
          .new(binding: 0, offset: 0, buffer: _uniformBuffer),
          .new(binding: 1, offset: 0, buffer: quadraticsBuffer),
          .new(binding: 2, offset: 0, buffer: quadCountsBuffer),
          .new(binding: 3, offset: 0, buffer: tileCountsBuffer),
          .new(binding: 4, offset: 0, buffer: tileIndicesBuffer),
        ],
      ),
    );
  }

  void encode(wgpu.ComputePassEncoder pass, wgpu.BindGroup bindGroup, int quadCount) {
    pass.setPipeline(_pipeline);
    pass.setBindGroup(0, bindGroup);
    pass.dispatchWorkgroups(x: (quadCount + 63) ~/ 64);
  }
}
