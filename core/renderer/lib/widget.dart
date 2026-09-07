import 'package:flutter/widgets.dart';
import 'package:renderer/dbg_renderer.dart';
import 'package:renderer/renderer.dart';
import 'package:scene/scene.dart';

class SceneWidget extends StatefulWidget {
  const SceneWidget({super.key, required this.scene});

  final Scene scene;

  @override
  State<SceneWidget> createState() => _SceneWidgetState();
}

class _SceneWidgetState extends State<SceneWidget> {
  Scene get scene => widget.scene;
  ProgramRenderer? renderer;

  @override
  void initState() {
    super.initState();
    scene.addListener(_onSceneChanged);
    renderer = .new(scene.evaluation);
  }

  @override
  void didUpdateWidget(SceneWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scene != scene) {
      renderer?.dispose();
      oldWidget.scene.removeListener(_onSceneChanged);
      scene.addListener(_onSceneChanged);
      renderer = .new(scene.evaluation);
    }
  }

  @override
  void dispose() {
    renderer?.dispose();
    scene.removeListener(_onSceneChanged);
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    renderer?.reassemble();
  }

  void _onSceneChanged() {
    // print('scene changed');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // return CustomPaint(painter: BundlePainter(bundle: scene.bundle));
    return CustomPaint(
      painter: _ProgramPainter(renderer: renderer!),
      isComplex: false,
      willChange: true,
    );
  }
}

class _ProgramPainter extends CustomPainter {
  _ProgramPainter({required this.renderer});

  final ProgramRenderer renderer;

  @override
  void paint(Canvas canvas, Size size) {
    renderer.paint(canvas);
  }

  @override
  bool shouldRepaint(covariant _ProgramPainter oldDelegate) => true;
}
