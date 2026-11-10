part of '../../renderer.dart';

const _kDebug = false;

final class RenderStage {
  new(this.renderer);
  final Renderer renderer;
  BindingsManager get bindings => renderer.bindings;

  static const _sampleCount = 4;

  late webgpu.RenderPipeline _directPipeline;
  late webgpu.RenderPipeline _stencilPipeline;
  late webgpu.RenderPipeline _coverKeepPipeline;
  late webgpu.RenderPipeline _coverZeroPipeline;

  late webgpu.RenderPipeline _debugPipeline;

  webgpu.Texture? _stencilTexture;
  webgpu.TextureView? _stencilTextureView;

  webgpu.Texture? _msaaTexture;
  webgpu.TextureView? _msaaTextureView;

  late webgpu.Texture _decorationEmptyTexture;
  late webgpu.TextureView _decorationEmptyTextureView;
  late webgpu.Sampler _decorationSampler;
  late webgpu.BindGroup _emptyGroup3;

  void setup() {
    _decorationEmptyTexture = renderer.device!.createTexture(
      .new(
        size: .new(width: 1, height: 1),
        format: .rgba8unorm,
        usage: .textureBinding,
      ),
    );

    _decorationEmptyTextureView = _decorationEmptyTexture.createView();
    _decorationSampler = renderer.device!.createSampler(.new());
    _emptyGroup3 = render.createBindGroup3(
      renderer.device!,
      decorationImageTexture: _decorationEmptyTextureView,
      decorationImageSampler: _decorationSampler,
    );

    final colorTargets = <webgpu.ColorTargetState>[
      .new(
        format: .bgra8unorm,
        blend: .new(
          color: .new(
            srcFactor: .one,
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
    ];

    final module = renderer.renderShader.module;

    _directPipeline = render.createVsMainFsMainRenderPipeline(
      renderer.device!,
      colorTargets,
      module: module,
      multisample: .new(count: _sampleCount),
      depthStencil: .new(
        format: .stencil8,
        depthWriteEnabled: .false_,
        depthCompare: .undefined,
        stencilWriteMask: 0,
      ),
    );

    _stencilPipeline = render.createVsMainFsStencilMainRenderPipeline(
      renderer.device!,
      [.new(format: .bgra8unorm, writeMask: .none)],
      module: module,
      multisample: .new(count: _sampleCount),
      depthStencil: .new(
        format: .stencil8,
        depthWriteEnabled: .false_,
        depthCompare: .undefined,
        stencilWriteMask: 0xFF,
        stencilReadMask: 0xFF,
        stencilFront: .new(compare: .always, passOp: .incrementWrap),
        stencilBack: .new(compare: .always, passOp: .decrementWrap),
      ),
    );

    _coverKeepPipeline = render.createVsMainFsMainRenderPipeline(
      renderer.device!,
      colorTargets,
      module: module,
      multisample: .new(count: _sampleCount),
      depthStencil: .new(
        format: .stencil8,
        depthWriteEnabled: .false_,
        depthCompare: .undefined,
        stencilWriteMask: 0xFF,
        stencilReadMask: 0xFF,
        stencilFront: .new(compare: .notEqual, passOp: .keep),
        stencilBack: .new(compare: .notEqual, passOp: .keep),
      ),
    );

    _coverZeroPipeline = render.createVsMainFsMainRenderPipeline(
      renderer.device!,
      colorTargets,
      module: module,
      multisample: .new(count: _sampleCount),
      depthStencil: .new(
        format: .stencil8,
        depthWriteEnabled: .false_,
        depthCompare: .undefined,
        stencilWriteMask: 0xFF,
        stencilReadMask: 0xFF,
        stencilFront: .new(compare: .notEqual, passOp: .zero),
        stencilBack: .new(compare: .notEqual, passOp: .zero),
      ),
    );

    _debugPipeline = debug_render.createRenderPipeline(
      renderer.device!,
      colorTargets,
      multisample: .new(count: _sampleCount),
      depthStencil: .new(
        format: .stencil8,
        depthWriteEnabled: .false_,
        depthCompare: .undefined,
        stencilWriteMask: 0,
      ),
    );
  }

  late webgpu.BindGroup _group0;
  late webgpu.BindGroup _group1;
  late webgpu.BindGroup _group2;

  late webgpu.BindGroup _debugGroup0;
  late webgpu.BindGroup _debugGroup1;
  late webgpu.BindGroup _debugGroup2;

  void rebind() {
    _group0 = bindings.createBindGroup0(render.createBindGroup0LayoutDescriptor());
    _group1 = bindings.createBindGroup1(render.createBindGroup1LayoutDescriptor());
    _group2 = bindings.createBindGroup2(render.createBindGroup2LayoutDescriptor());

    _debugGroup0 = bindings.createBindGroup0(debug_render.createBindGroup0LayoutDescriptor());
    _debugGroup1 = bindings.createBindGroup1(debug_render.createBindGroup1LayoutDescriptor());
    _debugGroup2 = bindings.createBindGroup2(debug_render.createBindGroup2LayoutDescriptor());
  }

  void dispatch(RenderContext context, webgpu.CommandEncoder encoder) {
    if (_stencilTexture?.width != context.textureWidth || _stencilTexture?.height != context.textureHeight) {
      _stencilTexture?.destroy();
      _stencilTexture?.dispose();
      _stencilTextureView?.dispose();
      _msaaTextureView?.dispose();
      _msaaTexture?.destroy();
      _msaaTexture?.dispose();

      _stencilTexture = renderer.device!.createTexture(
        .new(
          format: .stencil8,
          size: .new(width: context.textureWidth, height: context.textureHeight),
          sampleCount: _sampleCount,
          usage: .renderAttachment,
        ),
      );

      _msaaTexture = renderer.device!.createTexture(
        .new(
          format: .bgra8unorm,
          size: .new(width: context.textureWidth, height: context.textureHeight),
          sampleCount: _sampleCount,
          usage: .renderAttachment,
        ),
      );

      _msaaTextureView = _msaaTexture!.createView();
      _stencilTextureView = _stencilTexture!.createView();
    }

    final pass = encoder.beginRenderPass(
      .new(
        label: 'render',
        colorAttachments: [
          .new(
            view: _msaaTextureView,
            resolveTarget: context.textureView,
            loadOp: .clear,
            storeOp: .discard,
            clearValue: .new(r: 0.0, g: 0.0, b: 0.0, a: 0.0),
          ),
        ],
        depthStencilAttachment: .new(
          view: _stencilTextureView!,
          stencilClearValue: 0,
          stencilLoadOp: .clear,
          stencilStoreOp: .discard,
        ),
      ),
    );

    // Main pass
    {
      render.bindVsMainFsMainPipeline(pass, group0: _group0, group1: _group1, group2: _group2, group3: _emptyGroup3);

      var _lastState = RenderPipelineState(kind: .direct);
      pass.setPipeline(_directPipeline);

      // print('== render start');

      var offset = 0;
      for (final cell in renderer.draw.order._cache) {
        final (_, drawCounts, pipelines) = renderer.draw.entry._cache[cell]!;
        // print('    render cell: ${cell.index} (${cell.kind.name})');

        for (var i = 0; i < drawCounts.length; i++) {
          final pipelineState = pipelines[i];
          if (!pipelineState.isKindCompatible(_lastState)) {
            final pipeline = switch (pipelineState.kind) {
              .direct => _directPipeline,
              .stencil => _stencilPipeline,
              .coverKeep => _coverKeepPipeline,
              .coverZero => _coverZeroPipeline,
            };

            // print('      switch pipeline to: ${pipelineState.kind.name}');
            pass.setPipeline(pipeline);
          }

          if (!pipelineState.isBindingsCompatible(_lastState)) {
            final texture = renderer.decoration.image.resolve(pipelineState.imageBinding!)!;
            final textureView = texture.createView();
            final bindGroup = render.createBindGroup3(
              renderer.device!,
              decorationImageTexture: textureView,
              decorationImageSampler: _decorationSampler,
            );

            // print('      switch bind group 3');
            pass.setBindGroup(3, bindGroup);
          }

          _lastState = pipelineState;
          final count = drawCounts[i];
          // print('      draw: count = $count (offset = $offset)');

          if (count == 0) {
            pass.drawIndirect(renderer.renderBuffers.indirectArgs.buffer, offset: offset * 16);
            offset++;
          } else {
            for (var j = 0; j < count; j++) {
              pass.drawIndirect(renderer.renderBuffers.indirectArgs.buffer, offset: offset * 16);
              offset++;
            }
          }
        }
      }
    }

    // Debug pass
    if (_kDebug) {
      debug_render.bindPipeline(pass, group0: _debugGroup0, group1: _debugGroup1, group2: _debugGroup2);
      pass.setPipeline(_debugPipeline);

      var offset = 0;
      for (final cell in renderer.draw.order._cache) {
        final (_, drawCounts, _) = renderer.draw.entry._cache[cell]!;
        for (var i = 0; i < drawCounts.length; i++) {
          final count = drawCounts[i];

          if (count == 0) {
            pass.drawIndirect(renderer.renderBuffers.indirectArgs.buffer, offset: offset * 16);
            offset++;
          } else {
            for (var j = 0; j < count; j++) {
              pass.drawIndirect(renderer.renderBuffers.indirectArgs.buffer, offset: offset * 16);
              offset++;
            }
          }
        }
      }
    }

    pass.end();
  }
}
