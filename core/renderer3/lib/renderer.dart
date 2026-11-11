import 'dart:collection';

import 'package:css/css.dart' as css;
import 'package:geometry/geometry.dart';
import 'package:geometry/geometry_32.dart' as geom32;

import 'package:kernel/kernel.dart';
import 'package:program/program.dart';
import 'package:scene/scene.dart';
import 'package:ui/ui.dart';
import 'package:webgpu/flutter.dart';
import 'package:skia/skia.dart' as skia;

import 'src/storage/storage.dart';
import 'src/storage/gpu_storage.dart';
import 'src/utils/async_cache.dart';
import 'src/shaders/_storage.g.dart' as gen;
import 'src/shaders/_bindings.g.dart' as gen_bindings;

import 'src/shaders/flatten.g.dart' as flatten;
import 'src/shaders/geometry.g.dart' as geometry;
import 'src/shaders/glyph_geometry.g.dart' as glyph_geometry;
import 'src/shaders/indirect.g.dart' as indirect;
import 'src/shaders/render.g.dart' as render;
import 'src/shaders/debug_render.g.dart' as debug_render;

import 'package:webgpu/webgpu.dart' as webgpu;

export 'widget.dart';

part 'src/geometry.dart';
part 'src/uniforms.dart';
part 'src/text.dart';

part 'src/decoration/image.dart';
part 'src/decoration/shader.dart';
part 'src/decoration.dart';

part 'src/topology.dart';
part 'src/shader.dart';
part 'src/style.dart';
part 'src/draw.dart';
part 'src/updater.dart';
part 'src/bindings.dart';
part 'src/render_buffers.dart';

part 'src/stages/flatten.dart';
part 'src/stages/geometry.dart';
part 'src/stages/indirect.dart';
part 'src/stages/render.dart';

final class Renderer with ChangeNotifier, ChangeNotifierDisposable, Renderable {
  new(this.scene, this.transformationController) {
    initialize();
  }

  final Scene scene;
  final TransformationController transformationController;
  Bundle get bundle => scene.bundle;

  @override
  webgpu.Device? device;

  webgpu.Queue get queue => device!.queue;

  late final topology = TopologyManager(this);
  late final geometry = GeometryManager(this);
  late final decoration = DecorationManager(this);
  late final style = StyleManager(this);
  late final draw = DrawManager(this);
  late final uniforms = UniformsManager(this);
  late final renderBuffers = RenderBuffersManager(this);
  late final text = TextManager(this);

  late final bindings = BindingsManager(this);
  late final updater = RendererUpdater(this);
  late final renderShader = RenderShaderManager(this);

  late final flattenStage = FlattenStage(this);
  late final geometryStage = GeometryStage(this);
  late final indirectStage = IndirectStage(this);
  late final renderStage = RenderStage(this);

  Future<void> initialize() async {
    final instance = webgpu.Instance.defaultInstance;
    final adapter = await instance.requestAdapter();
    device = await adapter.requestDefaultDevice(
      .new(
        label: 'main (${shortHash(this)})',
        uncapturedErrorCallback: (device, error, message) => debugPrint('Uncaptured error: ${error.name}, $message'),
      ),
    );

    updater.initialUpdate();

    bindings.setup();
    renderShader.setup();

    flattenStage.setup();
    geometryStage.setup();
    indirectStage.setup();
    renderStage.setup();

    transformationController.addListener(notifyListeners);
    updater.addListener(notifyListeners);
    notifyListeners();
  }

  bool upload() {
    var rebind = false;
    rebind |= topology.upload();
    rebind |= geometry.upload();
    rebind |= decoration.upload();
    rebind |= style.upload();
    rebind |= draw.upload();
    rebind |= text.upload();

    if (rebind) bindings.setup();
    return rebind;
  }

  @override
  void performRender(RenderContext context) {
    updater.update();
    upload();

    final devicePixelRatio = context.devicePixelRatio;
    final viewportTransform = Matrix4.identity()..scaleByDouble(devicePixelRatio, devicePixelRatio, 1.0, 1.0);
    final canvasTransform = transformationController.value;
    final viewportPostTransform = Matrix4.identity()
      ..translateByDouble(context.size.width / 2.0, context.size.height / 2.0, 0.0, 1.0);

    uniforms.update(
      worldToScreen: viewportTransform * canvasTransform * viewportPostTransform,
      viewport: .new(context.textureWidth.toDouble(), context.textureHeight.toDouble()),
      tolerance: 0.1 / canvasTransform.getMaxScaleOnAxis2D(),
    );

    final encoder = device!.createCommandEncoder();
    renderBuffers.clear(encoder);
    flattenStage.dispatch(encoder);
    geometryStage.dispatch(encoder);
    indirectStage.dispatch(encoder);
    renderStage.dispatch(context, encoder);

    final commandBuffer = encoder.finish();
    queue.submit([commandBuffer]);
    queue.onSubmittedWorkDone().then((_) {
      if (isDisposed) return;
      // final args = renderBuffers.segments.readSync(device!);
      // print(args.take(100));
    });
  }

  @override
  void dispose() {
    updater.removeListener(notifyListeners);
    updater.dispose();
    transformationController.removeListener(notifyListeners);
    super.dispose();
  }
}
