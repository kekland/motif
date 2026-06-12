import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';

import 'interactive_viewer_gesture_recognizer.dart';

class InteractiveViewer2 extends StatefulWidget {
  const InteractiveViewer2({
    super.key,
    required this.minScale,
    required this.maxScale,
    required this.builder,
  });

  final double minScale;
  final double maxScale;
  final Widget Function(BuildContext context, Quad quad) builder;

  @override
  State<InteractiveViewer2> createState() => _InteractiveViewer2State();
}

class _InteractiveViewer2State extends State<InteractiveViewer2> {
  var _transform = Matrix4.identity();
  var _activeTransform = Matrix4.identity();

  void _onGestureStart(TransformStartDetails details) {
    setState(() {});
  }

  void _onGestureUpdate(TransformUpdateDetails details) {
    _activeTransform = details.transform;
    setState(() {});
  }

  void _onGestureEnd(TransformEndDetails details) {
    _transform = _activeTransform * _transform;
    _activeTransform = Matrix4.identity();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final transform = _activeTransform * _transform;

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
      child: Transform(
        transform: transform,
        child: widget.builder(
          context,
          Quad.points(.zero(), .zero(), .zero(), .zero()),
        ),
      ),
    );
  }
}
