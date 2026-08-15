import 'package:ui/ui.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import 'interactive_viewer_gesture_recognizer.dart';

class InteractiveViewer2 extends StatefulWidget {
  const InteractiveViewer2({
    super.key,
    this.controller,
    required this.minScale,
    required this.maxScale,
    required this.builder,
  });

  final TransformationController? controller;
  final double minScale;
  final double maxScale;
  final Widget Function(BuildContext context, Quad quad) builder;

  @override
  State<InteractiveViewer2> createState() => _InteractiveViewer2State();
}

class _InteractiveViewer2State extends State<InteractiveViewer2> with TickerProviderStateMixin {
  late final _translationFlingAnimationController = AnimationController(vsync: this);
  late final _scaleFlingAnimationController = AnimationController(vsync: this);

  Animation<Offset>? _translationFlingAnimation;
  Offset? _scaleFocalPoint;
  Animation<double>? _scaleFlingAnimation;

  Matrix4 get _totalTransform => _activeTransform * _transform;

  var _transform = Matrix4.identity();
  set transform(Matrix4 v) {
    _transform = v;
    widget.controller?.value = _totalTransform;
    setState(() {});
  }

  var _activeTransform = Matrix4.identity();
  set activeTransform(Matrix4 v) {
    _activeTransform = v;
    widget.controller?.value = _totalTransform;
    setState(() {});
  }

  Offset get _translation => _totalTransform.getTranslation().xy.offset;
  // double get _scale => _totalTransform.getMaxScaleOnAxis();

  void _onGestureStart(TransformStartDetails details) {
    _translationFlingAnimationController.stop();
    _scaleFlingAnimationController.stop();

    setState(() {});
  }

  void _onGestureUpdate(TransformUpdateDetails details) {
    activeTransform = details.transform;
    setState(() {});
  }

  void _onGestureEnd(TransformEndDetails details) {
    transform = _totalTransform;
    activeTransform = Matrix4.identity();
    setState(() {});

    _translationFlingAnimation?.removeListener(_onTranslationFlingUpdate);
    _translationFlingAnimationController.reset();
    _scaleFlingAnimation?.removeListener(_onScaleFlingUpdate);
    _scaleFlingAnimationController.reset();

    if (details.translationVelocity != null) {
      final velocity = details.translationVelocity!.pixelsPerSecond;
      if (velocity.distance < 50.0) {
        return;
      }

      final (tween, duration) = Fling.twoD(_translation, details.translationVelocity!);

      _translationFlingAnimation = tween.animate(_translationFlingAnimationController);
      _translationFlingAnimation!.addListener(_onTranslationFlingUpdate);
      _translationFlingAnimationController.duration = duration;
      _translationFlingAnimationController.forward(from: 0.0);
    }

    // if (details.scaleVelocity != null && details.scaleFocalPoint != null) {
    //   final focalPoint = details.scaleFocalPoint!;
    //   final velocity = details.scaleVelocity!;
    //   print('scale fling: $velocity, $focalPoint');
    //   // if (velocity.abs() < 0.1) return;

    //   final (tween, duration) = Fling.oneD(_scale, velocity);
    //   _scaleFocalPoint = focalPoint;

    //   _scaleFlingAnimation = tween.animate(_scaleFlingAnimationController);
    //   _scaleFlingAnimationController.duration = duration;
    //   _scaleFlingAnimationController.forward(from: 0.0);
    //   _scaleFlingAnimation!.addListener(_onScaleFlingUpdate);
    // }
  }

  void _onTranslationFlingUpdate() {
    final translation = _translationFlingAnimation!.value;
    transform = _transform.clone()..setTranslationRaw(translation.dx, translation.dy, 0.0);
    setState(() {});
  }

  void _onScaleFlingUpdate() {
    final scale = _scaleFlingAnimation!.value;
    final focalPoint = _scaleFocalPoint!;

    final transform = Matrix4.identity()
      ..translateByDouble(focalPoint.dx, focalPoint.dy, 0.0, 1.0)
      ..scaledByDouble(scale, scale, 1.0, 1.0)
      ..translateByDouble(-focalPoint.dx, -focalPoint.dy, 0.0, 1.0);

    this.transform = transform * _transform;
    setState(() {});
  }

  @override
  void dispose() {
    _translationFlingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      behavior: .opaque,
      gestures: {
        InteractiveViewerGestureRecognizer: GestureRecognizerFactoryWithHandlers<InteractiveViewerGestureRecognizer>(
          () => InteractiveViewerGestureRecognizer(
            minAllowedPointerCount: 1,
            supportedDevices: {.trackpad, .touch},
          ),
          (instance) {
            instance
              ..onStart = _onGestureStart
              ..onUpdate = _onGestureUpdate
              ..onEnd = _onGestureEnd;
          },
        ),
      },
      child: widget.builder(
        context,
        Quad.points(.zero(), .zero(), .zero(), .zero()),
      ),
    );
  }
}
