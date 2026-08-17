import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

/// The minimum distance travelled by a pointer for the gesture to be
/// considered a transform gesture.
const _kTransformSlop = 6.0;

/// Minimum angle (in radians) that must be traversed for a rotation to be recognized.
const _kTransformRotateSlop = math.pi / 180.0 * 15.0;

const _kPanZoomScaleFactor = 1.6;

enum _TransformState { ready, possible, started }

extension type _PointersState(List<Offset> pointers) {
  Offset difference(_PointersState other) {
    final a = pointers[0];
    final b = other.pointers[0];
    return b - a;
  }

  Offset get focalPoint {
    final sum = pointers.reduce((a, b) => a + b);
    return sum / pointers.length.toDouble();
  }
}

class InteractiveViewerGestureRecognizer extends OneSequenceGestureRecognizer {
  InteractiveViewerGestureRecognizer({
    required this.minAllowedPointerCount,
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
    this.onStart,
    this.onUpdate,
    this.onEnd,
  });

  final int minAllowedPointerCount;
  GestureTransformStartCallback? onStart;
  GestureTransformUpdateCallback? onUpdate;
  GestureTransformEndCallback? onEnd;

  @override
  String get debugDescription => 'InteractiveViewerGestureRecognizer';

  var _state = _TransformState.ready;
  var _transform = Matrix4.identity();

  _PointersState? _initialPointersState;
  _PointersState? _currentPointersState;

  final _pointerQueue = <int>[];
  final _pointerLocalPositions = <int, Offset>{};
  final _velocityTrackers = <int, VelocityTracker>{};

  bool _isPanZoomEvent = false;
  PointerPanZoomUpdateEvent? _panZoomUpdateEvent;

  VelocityTracker? _scaleVelocityTracker;

  Offset? _scaleFocalPoint;
  Velocity? _finalTranslationVelocity;
  double? _finalScaleVelocity;

  int get _pointerCount => _pointerQueue.length;
  bool get _hasMinPointerCount => _pointerCount >= minAllowedPointerCount;
  Iterable<Offset> get _queuedLocalPositions => _pointerQueue.map((i) => _pointerLocalPositions[i]!);

  Velocity get _currentVelocity {
    final velocities = _velocityTrackers.values.map((t) => t.getVelocity());

    if (velocities.length == 1) {
      return velocities.first;
    } else if (velocities.length > 1) {
      final sum = velocities.map((v) => v.pixelsPerSecond).reduce((a, b) => a + b);
      return Velocity(pixelsPerSecond: sum / velocities.length.toDouble());
    } else {
      return Velocity.zero;
    }
  }

  @override
  void addAllowedPointerPanZoom(PointerPanZoomStartEvent event) {
    startTrackingPointer(event.pointer, event.transform);
  }

  @override
  void handleEvent(PointerEvent event) {
    final pointerId = event.pointer;
    var didChangeConfiguration = false;

    if (event is PointerDownEvent || event is PointerPanZoomStartEvent) {
      _pointerQueue.add(pointerId);
      _pointerLocalPositions[pointerId] = event.localPosition;
      _velocityTrackers[pointerId] = VelocityTracker.withKind(event.kind);
      _scaleVelocityTracker = VelocityTracker.withKind(event.kind);

      didChangeConfiguration = true;
      _isPanZoomEvent = true;
    } else if (event is PointerMoveEvent) {
      _pointerLocalPositions[pointerId] = event.localPosition;
      _velocityTrackers[pointerId]?.addPosition(event.timeStamp, event.position);
    } else if (event is PointerPanZoomUpdateEvent) {
      _pointerLocalPositions[pointerId] = event.localPosition + event.localPan;
      _velocityTrackers[pointerId]?.addPosition(event.timeStamp, event.position + event.pan);
      _panZoomUpdateEvent = event;
    } else if (event is PointerUpEvent || event is PointerCancelEvent || event is PointerPanZoomEndEvent) {
      _finalTranslationVelocity = _currentVelocity;
      _finalScaleVelocity = _scaleVelocityTracker?.getVelocity().pixelsPerSecond.dx;
      _pointerQueue.remove(pointerId);
      _pointerLocalPositions.remove(pointerId);
      _velocityTrackers.remove(pointerId);
      _scaleVelocityTracker = null;
      didChangeConfiguration = true;
      _panZoomUpdateEvent = null;
      _isPanZoomEvent = false;
    }

    if (didChangeConfiguration) _reconfigure();

    _update(event.timeStamp);
    _advanceStateMachine();

    stopTrackingIfPointerNoLongerDown(event);
  }

  _PointersState? _createPointersState() {
    if (_pointerCount == 0) return null;
    return _PointersState(_queuedLocalPositions.toList(growable: false));
  }

  void _reconfigure() {
    _initialPointersState = _createPointersState();
    if (_state == .started) {
      _onEnd();
      _state = .ready;
      _currentPointersState = null;
      _transform = .identity();
      _rotationBaseAngle = null;
    }
  }

  void _update(Duration timestamp) {
    if (_initialPointersState == null) return;
    _currentPointersState = _createPointersState();

    if (_state != .started) return;
    if (_currentPointersState == null) return;

    if (_panZoomUpdateEvent != null) {
      _updateWithPanZoom();
    } else {
      _updateWithPointersState();
    }

    final scale = _transform.getMaxScaleOnAxis();
    _scaleVelocityTracker!.addPosition(timestamp, Offset(scale, 0.0));
  }

  void _updateWithPointersState() {
    final startPointers = _initialPointersState!.pointers;
    final currentPointers = _currentPointersState!.pointers;

    if (startPointers.length >= 2 && currentPointers.length >= 2) {
      final a1 = startPointers[0];
      final a2 = startPointers[1];
      final a = a2 - a1;

      final b1 = currentPointers[0];
      final b2 = currentPointers[1];
      final b = b2 - b1;

      final scale = b.distance / a.distance;
      var angle = math.atan2(
        b.dx * a.dy - b.dy * a.dx,
        b.dx * a.dx + b.dy * a.dy,
      );

      angle = _applyRotationSnap(angle);

      _transform = Matrix4.identity()
        ..translateByDouble(b1.dx, b1.dy, 0.0, 1.0)
        ..rotateZ(-angle)
        ..scaleByDouble(scale, scale, 1.0, 1.0)
        ..translateByDouble(-a1.dx, -a1.dy, 0.0, 1.0);
    } else {
      final a = startPointers[0];
      final b = currentPointers[0];
      _transform = Matrix4.identity()..translateByDouble(b.dx - a.dx, b.dy - a.dy, 0.0, 1.0);
    }
  }

  void _updateWithPanZoom() {
    final event = _panZoomUpdateEvent!;
    final pan = event.pan; // TODO: update to localPan once fixed.
    final origin = event.localPosition;

    var angle = event.rotation;
    angle = _applyRotationSnap(angle);

    final scale = math.pow(event.scale, _kPanZoomScaleFactor).toDouble();

    _scaleFocalPoint = origin;
    _transform = Matrix4.identity()
      ..translateByDouble(pan.dx, pan.dy, 0.0, 1.0)
      ..translateByDouble(origin.dx, origin.dy, 0.0, 1.0)
      ..rotateZ(angle)
      ..scaleByDouble(scale, scale, scale, 1.0)
      ..translateByDouble(-origin.dx, -origin.dy, 0.0, 1.0);
  }

  double? _rotationBaseAngle;
  double _applyRotationSnap(double rawAngle) {
    if (_rotationBaseAngle == null && rawAngle.abs() > _kTransformRotateSlop) {
      _rotationBaseAngle = rawAngle;
    }

    if (_rotationBaseAngle != null) {
      return (rawAngle - _rotationBaseAngle!);
    }

    return 0.0;
  }

  void _advanceStateMachine() {
    if (_state == .ready && _initialPointersState != null) {
      _state = .possible;
    }

    if (_state == .possible) {
      if (_isPanZoomEvent) {
        _state = .started;
        _onStart();
        resolve(.accepted);
        return;
      }

      if (_initialPointersState == null) return;

      final offset = _initialPointersState!.difference(_currentPointersState!);
      final delta = offset.distance;

      if (delta > _kTransformSlop && _hasMinPointerCount) {
        _state = .started;
        _onStart();
        resolve(.accepted);
      }
    } else if (_state.index >= _TransformState.possible.index) {
      resolve(.accepted);
    }

    if (_state == .started) _onUpdate();
  }

  void _onStart() {
    if (onStart != null) {
      invokeCallback<void>(
        'onStart',
        () => onStart!(.new(pointerCount: _pointerCount, transform: _transform)),
      );
    }
  }

  void _onUpdate() {
    if (onUpdate != null) {
      invokeCallback<void>(
        'onUpdate',
        () => onUpdate!(.new(pointerCount: _pointerCount, transform: _transform)),
      );
    }
  }

  void _onEnd() {
    if (onEnd != null) {
      invokeCallback<void>(
        'onEnd',
        () => onEnd!(
          .new(
            transform: _transform,
            translationVelocity: _finalTranslationVelocity,
            scaleFocalPoint: _scaleFocalPoint,
            scaleVelocity: _finalScaleVelocity,
          ),
        ),
      );
    }
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    if (_state == .ready) resolve(.rejected);
    _state = .ready;
  }

  void onPointerSignal(PointerSignalEvent event) {
    if (_state == .started) return;

    var handled = false;
    var newTransform = Matrix4.identity();
    Offset? scaleFocalPoint;

    if (event is PointerScaleEvent) {
      final focalPoint = event.localPosition;
      scaleFocalPoint = focalPoint;
      final scale = event.scale;

      newTransform
        ..translateByDouble(focalPoint.dx, focalPoint.dy, 0.0, 1.0)
        ..scaleByDouble(scale, scale, 1.0, 1.0)
        ..translateByDouble(-focalPoint.dx, -focalPoint.dy, 0.0, 1.0);

      handled = true;
    } else if (event is PointerScrollEvent) {
      final keyboard = HardwareKeyboard.instance;
      final isZoom = keyboard.isMetaPressed || keyboard.isControlPressed;

      final delta = event.scrollDelta;

      if (!isZoom) {
        newTransform.translateByDouble(-delta.dx, -delta.dy, 0.0, 1.0);
      } else {
        final focalPoint = event.localPosition;
        scaleFocalPoint = focalPoint;

        final scale = 1.0 + delta.dy * 0.01;

        newTransform
          ..translateByDouble(focalPoint.dx, focalPoint.dy, 0.0, 1.0)
          ..scaleByDouble(scale, scale, 1.0, 1.0)
          ..translateByDouble(-focalPoint.dx, -focalPoint.dy, 0.0, 1.0);
      }
      handled = true;
    }

    if (handled) {
      _transform = newTransform;

      onStart?.call(.new(pointerCount: 0, transform: .identity()));
      onUpdate?.call(.new(pointerCount: 0, transform: _transform));
      onEnd?.call(
        .new(
          transform: _transform,
          translationVelocity: .zero,
          scaleVelocity: 0.0,
          scaleFocalPoint: scaleFocalPoint,
        ),
      );

      _transform = Matrix4.identity();
    }
  }
}

typedef GestureTransformStartCallback = void Function(TransformStartDetails details);
typedef GestureTransformUpdateCallback = void Function(TransformUpdateDetails details);
typedef GestureTransformEndCallback = void Function(TransformEndDetails details);

class TransformStartDetails {
  const TransformStartDetails({required this.pointerCount, required this.transform});

  final int pointerCount;
  final Matrix4 transform;
}

class TransformUpdateDetails {
  const TransformUpdateDetails({required this.pointerCount, required this.transform});

  final int pointerCount;
  final Matrix4 transform;
}

class TransformEndDetails {
  const TransformEndDetails({
    required this.transform,
    this.translationVelocity,
    this.scaleFocalPoint,
    this.scaleVelocity,
  });

  final Matrix4 transform;
  final Velocity? translationVelocity;
  final Offset? scaleFocalPoint;
  final double? scaleVelocity;
}
