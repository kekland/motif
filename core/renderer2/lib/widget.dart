import 'package:flutter/widgets.dart';
import 'package:renderer2/renderer.dart';
import 'package:scene/scene.dart';
import 'package:webgpu/flutter.dart';

class SceneWidget extends StatefulWidget {
  const SceneWidget({
    super.key,
    required this.scene,
    required this.transformationController,
  });

  final Scene scene;
  final TransformationController transformationController;

  @override
  State<SceneWidget> createState() => _SceneWidgetState();
}

class _SceneWidgetState extends State<SceneWidget> {
  Scene get scene => widget.scene;
  late SceneRenderer renderer;

  @override
  void initState() {
    super.initState();
    scene.addListener(_onSceneChanged);
    _createRenderer();
  }

  void _createRenderer() {
    renderer = .new(scene, widget.transformationController);
    renderer.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(SceneWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scene != scene) {
      renderer.dispose();
      oldWidget.scene.removeListener(_onSceneChanged);
      scene.addListener(_onSceneChanged);
      _createRenderer();
    }
  }

  @override
  void dispose() {
    renderer.dispose();
    scene.removeListener(_onSceneChanged);
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    renderer.dispose();
    _createRenderer();
  }

  void _onSceneChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Widget child;

    child = IgnorePointer(
      child: WebGpuWidget(renderable: renderer),
    );

    return child;
  }
}
