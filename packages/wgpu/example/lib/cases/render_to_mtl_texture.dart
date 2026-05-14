import 'dart:math';
import 'dart:typed_data';

import 'package:wgpu/wgpu_native.dart' as wgpu;
import 'package:wgpu/darwin.dart' as darwin;

import 'package:flutter/material.dart';

class RenderToMtlTextureCase extends StatefulWidget {
  const RenderToMtlTextureCase({super.key});

  @override
  State<RenderToMtlTextureCase> createState() => _RenderToMtlTextureCaseState();
}

class _RenderToMtlTextureCaseState extends State<RenderToMtlTextureCase> with SingleTickerProviderStateMixin {
  late final wgpu.Instance _instance;
  late final wgpu.Adapter _adapter;
  late final wgpu.Device _device;
  bool wgpuReady = false;
  late final darwin.MTLFlutterTexture _texture;

  late final AnimationController _controller = AnimationController(vsync: this, duration: Duration(seconds: 10))
    ..repeat();
  late final Animation<double> _animation = _controller.drive(Tween(begin: 0.0, end: 1.0));

  double get t => _animation.value;

  @override
  void initState() {
    super.initState();

    _texture = darwin.MTLFlutterTexture.create();
    _texture.register();

    _controller.addListener(() => setState(() {}));
    _prepareWgpu();
  }

  Future<void> _prepareWgpu() async {
    // ignore: avoid_print
    wgpu.WGPUNative.setLogCallback((l, s) => print('wgpu (${l.name}): $s'));
    _instance = wgpu.Instance.create();
    _adapter = await _instance.requestAdapter();
    _device = await _adapter.requestDevice(
      .new(label: 'main'),
    );

    setState(() => wgpuReady = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _texture.dispose();
    super.dispose();
  }

  void _render() {
    if (!wgpuReady) return;
    _renderTriangle(_device, _texture, t);
  }

  @override
  Widget build(BuildContext context) {
    _render();

    return Scaffold(
      appBar: AppBar(title: Text('Render to MTLTexture')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: _render, child: Text('Render')),
            SizedBox(height: 16),
            Container(
              width: 512,
              height: 512,
              color: Colors.black,
              child: Texture(textureId: _texture.textureId!),
            ),
            Slider(
              value: t,
              onChanged: null,
            ),
            ElevatedButton(
              onPressed: () {
                _controller.isAnimating ? _controller.stop() : _controller.repeat();
              },
              child: Text('toggle animation'),
            ),
          ],
        ),
      ),
    );
  }
}

void _renderTriangle(
  wgpu.Device device,
  darwin.MTLFlutterTexture texture,
  double t,
) {
  const _crt = r'''
struct Uniforms {
  t: f32
};

@group(0) @binding(0) var<uniform> u: Uniforms;

struct VertexOutput {
    @builtin(position) position: vec4f,
    @location(0) uv: vec2f,
};

@vertex
fn vs_main(@builtin(vertex_index) idx: u32) -> VertexOutput {
    let pos = array<vec2f, 3>(
        vec2f(-1.0, -1.0),
        vec2f( 3.0, -1.0),
        vec2f(-1.0,  3.0)
    );
    var out: VertexOutput;
    out.position = vec4f(pos[idx], 0.0, 1.0);
    out.uv = pos[idx] * 0.5 + 0.5;
    return out;
}

// 1. Simulates the curvature of a heavy glass tube
fn curve(uv: vec2f) -> vec2f {
    var coords = uv * 2.0 - 1.0;
    let offset = abs(coords.yx) / vec2f(2.0, 4.0); // Adjust curvature strength here
    coords = coords + coords * offset * offset;
    return coords * 0.5 + 0.5;
}

fn palette(t: f32) -> vec3f {
    let a = vec3f(0.5, 0.5, 0.5);
    let b = vec3f(0.5, 0.5, 0.5);
    let c = vec3f(1.0, 1.0, 1.0);
    let d = vec3f(0.263, 0.416, 0.557);
    return a + b * cos(6.2831853 * (c * t + d));
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4f {
    // Apply curvature to UVs first
    let uv_curved = curve(in.uv);
    
    // Check if we are outside the "glass" bounds (creates the black border)
    if (uv_curved.x < 0.0 || uv_curved.x > 1.0 || uv_curved.y < 0.0 || uv_curved.y > 1.0) {
        return vec4f(0.0, 0.0, 0.0, 1.0);
    }

    // --- Start Procedural Fractal (Our "Input Signal") ---
    var uv = uv_curved * 2.0 - 1.0;
    let uv0 = uv;
    var signalColor = vec3f(0.0);
    let time = u.t;

    for (var i = 0.0; i < 3.0; i += 1.0) {
        uv = fract(uv * 1.5) - 0.5;
        var d = length(uv) * exp(-length(uv0));
        let col = palette(length(uv0) + i * 0.4 + time / 6.28);
        d = sin(d * 8.0 + time) / 8.0;
        d = abs(d);
        d = pow(0.01 / d, 1.2);
        signalColor += col * d;
    }
    // --- End Procedural Fractal ---

    // 2. Scanlines
    // We use the screen-space position (builtin position) for pixel-perfect lines
    let scanline = sin(uv_curved.y * 800.0) * 0.08;
    var finalColor = signalColor - scanline;

    // 3. RGB Shadow Mask (Sub-pixel simulation)
    // This creates that grainy "grid" look
    let grid_size = 300.0;
    let mask = vec3f(
        sin(uv_curved.x * grid_size * 3.0 + 0.0) * 0.5 + 0.5,
        sin(uv_curved.x * grid_size * 3.0 + 2.0) * 0.5 + 0.5,
        sin(uv_curved.x * grid_size * 3.0 + 4.0) * 0.5 + 0.5
    );
    finalColor *= (mask * 0.5 + 0.7);

    // 4. Vignette (Darkens the corners)
    var vignette = uv_curved.x * uv_curved.y * (1.0 - uv_curved.x) * (1.0 - uv_curved.y);
    vignette = pow(vignette * 15.0, 0.25);
    finalColor *= vignette;

    // 5. Brightness Boost (CRT phosphor glow)
    finalColor *= 1.4;

    return vec4f(finalColor, 1.0);
}
''';

  // ignore: unused_local_variable
  const _shader = r'''
struct Uniforms {
  t: f32
};

@group(0) @binding(0) var<uniform> u: Uniforms;

struct VertexOutput {
    @builtin(position) position: vec4f,
    @location(0) uv: vec2f,
};

@vertex
fn vs_main(@builtin(vertex_index) idx: u32) -> VertexOutput {
  // A single triangle that covers the entire NDC space (-1 to 1)
  let pos = array<vec2f, 3>(
    vec2f(-1.0, -1.0),
    vec2f( 3.0, -1.0),
    vec2f(-1.0,  3.0)
  );

  var out: VertexOutput;
  out.position = vec4f(pos[idx], 0.0, 1.0);
  
  // Map standard coordinates to UV (0.0 to 1.0)
  out.uv = pos[idx] * 0.5 + 0.5;
  return out;
}

// Cosine based palette generation (Inigo Quilez)
fn palette(t: f32) -> vec3f {
    let a = vec3f(0.5, 0.5, 0.5);
    let b = vec3f(0.5, 0.5, 0.5);
    let c = vec3f(1.0, 1.0, 1.0);
    let d = vec3f(0.263, 0.416, 0.557);
    return a + b * cos(6.2831853 * (c * t + d));
}
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4f {
    // Center UVs so (0,0) is in the middle, ranging from -1.0 to 1.0
    var uv = in.uv * 2.0 - 1.0;
    
    // Save original UVs for the global distance field
    let uv0 = uv;
    var finalColor = vec3f(0.0);

    // u.t is coming in as (t * 2 * pi), so it ranges from 0 to ~6.28
    let time = u.t;

    // Fractal iteration loop
    for (var i = 0.0; i < 4.0; i += 1.0) {
        // Space repetition
        uv = fract(uv * 1.5) - 0.5;

        // Exponential distance field
        var d = length(uv) * exp(-length(uv0));

        // Generate glowing neon colors based on distance, iteration, and time
        // We divide time by 2PI to map it to a 0..1 phase for the palette
        let col = palette(length(uv0) + i * 0.4 + time / 6.2831853);

        // Sine wave displacement (time is added directly for seamless loops)
        d = sin(d * 8.0 + time) / 8.0;
        d = abs(d);
        
        // Add extreme contrast/glow
        d = pow(0.01 / d, 1.2);

        finalColor += col * d;
    }

    return vec4f(finalColor, 1.0);
}
''';

  const width = 512;
  const height = 512;

  final queue = device.queue;

  final renderTarget = device.createTexture(
    .new(
      label: 'render target',
      size: .new(width: width, height: height, depthOrArrayLayers: 1),
      format: .BGRA8Unorm,
      usage: .of([.renderAttachment, .textureBinding]),
      mipLevelCount: 1,
      sampleCount: 1,
      dimension: .twoD,
    ),
  );

  final renderTargetView = renderTarget.createView(null);

  final shader = device.createShaderModule(
    .new(
      label: 'triangle shader',
      next: wgpu.ShaderSourceWGSL(code: _crt),
    ),
  );

  final uniformBuffer = device.createBuffer(
    .new(
      label: 'uniforms',
      size: 16,
      usage: .of([.uniform, .copyDst]),
    ),
  );

  final tBytes = Float32List.fromList([t * 2 * pi]).buffer.asUint8List();
  queue.writeBuffer(uniformBuffer, 0, tBytes);

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

  final bindGroupLayout = pipeline.getBindGroupLayout(0);

  final bindGroup = device.createBindGroup(
    .new(
      label: 'uniforms bind group',
      layout: bindGroupLayout,
      entries: [
        .new(
          binding: 0,
          buffer: uniformBuffer,
          offset: 0,
          size: 16,
        ),
      ],
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
  renderPass.setBindGroup(0, bindGroup, dynamicOffsets: []);
  renderPass.draw(3, 1, 0, 0);
  renderPass.end();

  queue.submit([encoder.finish()]);
  queue.onSubmittedWorkDoneSync();

  final nativeTexture = renderTarget.nativeMetalTexture;
  texture.updateBuffer(nativeTexture);
}
