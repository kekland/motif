part of '../editor.dart';

final class EditorCanvasUtils {
  EditorCanvasUtils(this.editor);
  final Editor editor;

  static const minScale = 1 / 128.0;
  static const maxScale = 256.0;

  AnimationController? _animationController;
  Animation? _animation;
  AppTheme get theme => editor.tickerProviderKey.currentContext!.theme;

  Future<void> showOnScreen(Iterable<StatementId> ids) async {
    const padding = 128.0;

    cancelAnimation();
    if (ids.isEmpty) return;

    final viewportSize = editor.canvasKey.currentContext!.size!;

    final bbox = editor.scene.query.bbox(ids);
    var width = bbox.width;
    var height = bbox.height;

    final currentTransform = editor.canvasTransformationController.value.clone();
    final currentInverse = Matrix4.inverted(currentTransform);

    final currentScale = currentTransform.getMaxScaleOnAxis2D();
    final viewportWidth = max(1.0, viewportSize.width - padding * 2.0);
    final viewportHeight = max(1.0, viewportSize.height - padding * 2.0);

    final scaleX = width > 0 ? viewportWidth / width : currentScale;
    final scaleY = height > 0 ? viewportHeight / height : currentScale;

    var targetScale = min(scaleX, scaleY).clamp(minScale, maxScale);
    if (targetScale > currentScale) targetScale = currentScale;

    final targetCenter = bbox.center.offset + viewportSize.center(.zero);

    final startScale = currentScale;
    final startCenter = MatrixUtils.transformPoint(currentInverse, viewportSize.center(.zero));

    final controller = AnimationController(
      vsync: editor.tickerProvider,
      duration: theme.animations.effectSlow.duration,
    );

    controller.addStatusListener((status) {
      if (status == .completed) cancelAnimation();
    });

    _animationController = controller;
    _animation = CurvedAnimation(parent: _animationController!, curve: theme.animations.effectSlow.curve!);

    _animation!.addListener(() {
      final t = _animation!.value;
      final scale = lerpDouble(startScale, targetScale, t)!;
      final center = Offset.lerp(startCenter, targetCenter, t)!;

      editor.canvasTransformationController.value = Matrix4.identity()
        ..translateByDouble(viewportSize.width / 2.0, viewportSize.height / 2.0, 0.0, 1.0)
        ..scaleByDouble(scale, scale, 1.0, 1.0)
        ..translateByDouble(-center.dx, -center.dy, 0.0, 1.0);
    });

    await _animationController!.forward();
  }

  Future<void> showSelection() async {
    final selection = editor.selection.statements;
    await showOnScreen(selection);
  }

  void cancelAnimation() {
    _animationController?.stop(canceled: true);
    _animationController?.dispose();
    _animationController = null;
    _animation = null;
  }
}
