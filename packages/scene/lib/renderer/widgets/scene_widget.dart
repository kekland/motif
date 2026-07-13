part of 'widgets.dart';

class SceneWidget extends StatefulWidget {
  const SceneWidget({super.key, required this.scene});

  final Scene scene;

  @override
  State<SceneWidget> createState() => _SceneWidgetState();
}

class _SceneWidgetState extends State<SceneWidget> {
  var _frameScheduled = false;

  @override
  void initState() {
    super.initState();
    widget.scene.addListener(_onSceneChanged);
    widget.scene.layout();
  }

  @override
  void dispose() {
    widget.scene.removeListener(_onSceneChanged);
    super.dispose();
  }

  void _onSceneChanged() {
    if (_frameScheduled) return;

    _frameScheduled = true;

    SchedulerBinding.instance.scheduleFrameCallback((_) {
      if (!mounted) return;

      widget.scene.layout();
      setState(() => _frameScheduled = false);
    }, scheduleNewFrame: true);
  }

  @override
  Widget build(BuildContext context) {
    final children = [
      for (final c in widget.scene.root.children) SceneNodeWidget.from(c),
    ];

    return RenderSceneWidget(
      scene: widget.scene,
      child: Stack(
        clipBehavior: .none,
        children: children,
      ),
    );
  }
}
