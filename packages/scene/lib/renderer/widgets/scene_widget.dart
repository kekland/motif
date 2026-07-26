part of 'widgets.dart';

class SceneWidget extends StatefulWidget {
  const SceneWidget({super.key, required this.scene});

  final Scene scene;

  static SceneWidgetState of(BuildContext context) => context.findAncestorStateOfType<SceneWidgetState>()!;

  @override
  State<SceneWidget> createState() => SceneWidgetState();
}

class SceneWidgetState extends State<SceneWidget> {
  // var _frameScheduled = false;
  // VoidCallback? _rootSubscription;
  // StreamSubscription? _layoutSubscription;

  Scene get scene => widget.scene;

  @override
  void initState() {
    super.initState();
    scene.flush();
    scene.scheduler.scheduler = _scheduleFrameCallback;
    scene.root(.children).addListener(_onRootChanged);
  }

  void _scheduleFrameCallback(void Function() callback) {
    SchedulerBinding.instance.scheduleFrameCallback((_) => callback(), scheduleNewFrame: true);
  }

  void _onRootChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    scene.root(.children).removeListener(_onRootChanged);
    // _layoutSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SceneTransientTransformsTickerProvider(
      child: RenderSceneWidget(
        scene: scene,
        child: SceneObjectChildrenWidget(object: scene.root),
      ),
    );
  }
}
