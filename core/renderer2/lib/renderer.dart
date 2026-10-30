import 'package:geometry/vm/vm_utils.dart';
import 'package:kernel/kernel.dart';
import 'package:program/program.dart';
import 'package:renderer2/src/cache/decoration_cache.dart';
import 'package:renderer2/src/shader.dart';
import 'package:renderer2/src/storage.dart';
import 'package:scene/scene.dart';
import 'package:ui/ui.dart';
import 'package:webgpu/webgpu.dart' as webgpu;
import 'package:webgpu/flutter.dart';

import 'src/shaders/count.g.dart' as count;
import 'src/shaders/scan.g.dart' as scan;
import 'src/shaders/generate.g.dart' as generate;
import 'src/shaders/render.g.dart' as render;

export 'src/storage_base/gpu_storage.dart';
export 'src/storage_base/storage.dart';

export 'widget.dart';

webgpu.Device? _globalDevice;
Future<void> _initializeDevice() async {
  if (_globalDevice != null) return;
  final instance = webgpu.Instance.defaultInstance;
  final adapter = await instance.requestAdapter();
  _globalDevice = await adapter.requestDefaultDevice(
    .new(
      uncapturedErrorCallback: (device, error, message) => debugPrint('Uncaptured error: ${error.name}, $message'),
    ),
  );
}

final class SceneRenderer with ChangeNotifier, ChangeNotifierDisposable, Renderable {
  SceneRenderer(this.scene, this.transformationController) {
    initialize();
    scene.addUpdateListener(_onSceneUpdate);
    transformationController.addListener(_onTransformChanged);
  }

  final Scene scene;
  final TransformationController transformationController;

  @override
  webgpu.Device? get device => _device;
  webgpu.Device get _device => _globalDevice!;

  Bundle get bundle => scene.bundle;

  late final RendererStorage storage;
  late final DecorationCache decorationCache;
  late final ShaderManager shaderManager;

  late final count.WorldUniformBuffer _worldUbo;

  late final webgpu.ComputePipeline _countPipeline;
  late final webgpu.ComputePipeline _scanPipeline;
  late final webgpu.ComputePipeline _generatePipeline;

  late webgpu.RenderPipeline _directPipeline;
  late webgpu.RenderPipeline _stencilPipeline;
  late webgpu.RenderPipeline _coverPipeline;
  late List<webgpu.RenderPipeline> _renderPipelines;

  webgpu.Texture? _stencilTexture;
  webgpu.TextureView? _stencilView;

  late List<webgpu.BindGroup?> _countBindGroups;
  late List<webgpu.BindGroup?> _scanBindGroups;
  late List<webgpu.BindGroup?> _generateBindGroups;
  late List<webgpu.BindGroup?> _renderBindGroups;

  Future<void> initialize() async {
    await _initializeDevice();

    _worldUbo = .new(_device);
    storage = .new(this);
    decorationCache = .new(storage, scene.shaderValidator, _onShaderCodeUpdated);
    shaderManager = .new(this, _onShaderModuleUpdated);

    _countPipeline = count.createComputePipeline(_device);
    _scanPipeline = scan.createComputePipeline(_device);
    _generatePipeline = generate.createComputePipeline(_device);

    storage.initialUpload();

    _createBindGroups();
    _createRenderPipelines();
    notifyListeners();
  }

  void _onSceneUpdate(EvalPass pass) {
    notifyListeners();
  }

  void _onTransformChanged() {
    notifyListeners();
  }

  void _createBindGroups() {
    _countBindGroups = [
      count.createBindGroup0Raw(
        _device,
        world: _worldUbo.bufferView,
        storageOffsets: storage.storageOffsetsUbo.bufferView,
      ),
      count.createBindGroup1Raw(
        _device,
        geometry: .new(storage.geometry.buffer),
        topology: .new(storage.topology.buffer),
        style: .new(storage.style.buffer),
      ),
      count.createBindGroup2Raw(
        _device,
        count: storage.countBuffer.bufferView,
      ),
    ];

    _scanBindGroups = [
      scan.createBindGroup0Raw(_device, storageOffsets: storage.storageOffsetsUbo.bufferView),
      null,
      scan.createBindGroup2Raw(
        _device,
        count: storage.countBuffer.bufferView,
        indirectArgs: storage.indirectArgsBuffer.bufferView,
      ),
    ];

    _generateBindGroups = [
      generate.createBindGroup0Raw(
        _device,
        world: _worldUbo.bufferView,
        storageOffsets: storage.storageOffsetsUbo.bufferView,
      ),
      generate.createBindGroup1Raw(
        _device,
        geometry: .new(storage.geometry.buffer),
        topology: .new(storage.topology.buffer),
        style: .new(storage.style.buffer),
      ),
      generate.createBindGroup2Raw(
        _device,
        count: storage.countBuffer.bufferView,
        renderGeometry: storage.renderGeometryBuffer.bufferView,
      ),
    ];

    _renderBindGroups = [
      render.createBindGroup0Raw(
        _device,
        world: _worldUbo.bufferView,
        storageOffsets: storage.storageOffsetsUbo.bufferView,
      ),
      render.createBindGroup1Raw(
        _device,
        geometry: .new(storage.geometry.buffer),
      ),
      render.createBindGroup2Raw(
        _device,
        renderGeometry: storage.renderGeometryBuffer.bufferView,
      ),
      render.createBindGroup3Raw(
        _device,
        decorations: .new(storage.decorations.buffer),
      ),
    ];
  }

  void _createRenderPipelines() {
    final colorTargets = <webgpu.ColorTargetState>[
      .new(
        format: .bgra8unorm,
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
    ];

    final module = shaderManager.shaderModule;

    _directPipeline = render.createRenderPipeline(
      _device,
      colorTargets,
      module: module,
      depthStencil: .new(
        format: .stencil8,
        depthWriteEnabled: .false_,
        depthCompare: .undefined,
        stencilWriteMask: 0,
      ),
    );

    _stencilPipeline = render.createRenderPipeline(
      _device,
      [
        .new(format: .bgra8unorm, writeMask: .none),
      ],
      module: module,
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

    _coverPipeline = render.createRenderPipeline(
      _device,
      colorTargets,
      module: module,
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

    _renderPipelines = [
      _directPipeline,
      _stencilPipeline,
      _coverPipeline,
    ];
  }

  void _onShaderCodeUpdated() {
    shaderManager.update();
    notifyListeners();
  }

  void _onShaderModuleUpdated() {
    _createRenderPipelines();
    notifyListeners();
  }

  @override
  void performRender(RenderContext context) {
    final queue = _device.queue;

    if (_stencilTexture?.width != context.textureWidth || _stencilTexture?.height != context.textureHeight) {
      _stencilTexture?.destroy();
      _stencilTexture?.dispose();
      _stencilView?.dispose();

      _stencilTexture = _device.createTexture(
        .new(
          format: .stencil8,
          size: .new(width: context.textureWidth, height: context.textureHeight),
          usage: .renderAttachment,
        ),
      );
      _stencilView = _stencilTexture!.createView();
    }

    // Data upload: for now, send everything each frame. later - utilize change tracker
    final drawCount = storage.upload(queue, _createBindGroups);

    final devicePixelRatio = context.devicePixelRatio;

    final viewportTransform = Matrix4.identity()..scaleByDouble(devicePixelRatio, devicePixelRatio, 1.0, 1.0);
    final canvasTransform = transformationController.value;
    final viewportPostTransform = Matrix4.identity()
      ..translateByDouble(context.size.width / 2.0, context.size.height / 2.0, 0.0, 1.0);

    final Matrix4 worldTransform = viewportTransform * canvasTransform * viewportPostTransform;

    _worldUbo.set(
      worldToScreen: .read(Float32List.fromList(worldTransform.storage).buffer.asByteData(), 0),
      viewport: .new(context.textureWidth.toDouble(), context.textureHeight.toDouble()),
      tolerance: 1.0 / canvasTransform.getMaxScaleOnAxis2D(),
    );

    _worldUbo.writeToQueue(queue);

    final encoder = _device.createCommandEncoder();

    // Count
    {
      final pass = encoder.beginComputePass();
      pass.setPipeline(_countPipeline);
      count.bindPipeline(
        pass,
        group0: _countBindGroups[0]!,
        group1: _countBindGroups[1]!,
        group2: _countBindGroups[2]!,
      );
      pass.dispatchWorkgroups((drawCount / 64).ceil());
      pass.end();
    }

    // Scan
    {
      final pass = encoder.beginComputePass();
      pass.setPipeline(_scanPipeline);
      scan.bindPipeline(pass, group0: _scanBindGroups[0]!, group2: _scanBindGroups[2]!);
      pass.dispatchWorkgroups(1);
      pass.end();
    }

    // Generate
    {
      final pass = encoder.beginComputePass();
      pass.setPipeline(_generatePipeline);
      generate.bindPipeline(
        pass,
        group0: _generateBindGroups[0]!,
        group1: _generateBindGroups[1]!,
        group2: _generateBindGroups[2]!,
      );
      pass.dispatchWorkgroups((drawCount / 64).ceil());
      pass.end();
    }

    // Render
    {
      final pass = encoder.beginRenderPass(
        .new(
          colorAttachments: [
            .new(
              view: context.textureView,
              loadOp: .clear,
              storeOp: .store,
              clearValue: .new(r: 0.0, g: 0.0, b: 0.0, a: 0.0),
            ),
          ],
          depthStencilAttachment: .new(
            view: _stencilView!,
            stencilClearValue: 0,
            stencilLoadOp: .clear,
            stencilStoreOp: .discard,
          ),
        ),
      );
      render.bindPipeline(
        pass,
        group0: _renderBindGroups[0]!,
        group1: _renderBindGroups[1]!,
        group2: _renderBindGroups[2]!,
        group3: _renderBindGroups[3]!,
      );

      var currentPipeline = -1;
      final drawEntries = storage.topology.storage.draw;
      print('draw count: $drawCount');
      for (var i = 0; i < drawCount; i++) {
        final drawKind = drawEntries[i]!.kind;
        final pipelineKind = switch (drawKind) {
          0 => 0,
          1 => 0,
          2 => 1,
          3 => 2,
          _ => throw Exception('Unknown draw kind: $drawKind'),
        };

        if (pipelineKind != currentPipeline) {
          pass.setPipeline(_renderPipelines[pipelineKind]);
          currentPipeline = pipelineKind;
        }

        pass.drawIndirect(storage.indirectArgsBuffer.buffer, offset: i * 16);
      }

      pass.end();
    }

    queue.submit([encoder.finish()]);
    queue.onSubmittedWorkDone().then((_) {
      // final readback = _storage.indirectArgsBuffer.readSync(_device);
      // print(readback.take(drawCount).toList());
    });
  }

  @override
  void dispose() {
    scene.removeUpdateListener(_onSceneUpdate);
    transformationController.removeListener(_onTransformChanged);

    _stencilView?.dispose();
    _stencilTexture?.destroy();
    _stencilTexture?.dispose();

    _worldUbo.destroy();
    storage.dispose();

    super.dispose();
  }
}
