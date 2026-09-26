import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mouse_cursor/mouse_cursor.dart';

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
    required this.minScale,
    required this.maxScale,
    required this.currentTransform,
    super.debugOwner,
    super.supportedDevices,
    this.onStart,
    this.onUpdate,
    this.onEnd,
  }) {
    HardwareKeyboard.instance.addHandler(_onKeyboardEvent);
  }

  final int minAllowedPointerCount;
  final Matrix4 Function() currentTransform;
  double minScale, maxScale;
  GestureTransformStartCallback? onStart;
  GestureTransformUpdateCallback? onUpdate;
  GestureTransformEndCallback? onEnd;

  @override
  String get debugDescription => 'InteractiveViewerGestureRecognizer';

  var _state = _TransformState.ready;
  var _transform = Matrix4.identity();
  var _startScale = 1.0;

  _PointersState? _initialPointersState;
  _PointersState? _currentPointersState;

  final _pointerQueue = <int>[];
  final _pointerLocalPositions = <int, Offset>{};
  final _velocityTrackers = <int, VelocityTracker>{};

  bool _isPanZoomEvent = false;
  PointerPanZoomUpdateEvent? _panZoomUpdateEvent;

  bool _isGrabEvent = false;
  bool _isGrabCursorActive = false;

  VelocityTracker? _scaleVelocityTracker;

  Offset? _scaleFocalPoint;
  Velocity? _finalTranslationVelocity;
  double? _finalScaleVelocity;

  int get _pointerCount => _pointerQueue.length;
  bool get _hasMinPointerCount => _pointerCount >= minAllowedPointerCount;
  Iterable<Offset> get _queuedLocalPositions => _pointerQueue.map((i) => _pointerLocalPositions[i]!);

  FocusNode? _focusNode;
  set focusNode(FocusNode? node) {
    if (_focusNode == node) return;
    _focusNode?.removeListener(_onFocusChanged);
    _focusNode = node;
    _focusNode?.addListener(_onFocusChanged);
  }

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
  bool isPointerAllowed(PointerDownEvent event) {
    if (event.kind == .mouse) {
      if (event.buttons != kMiddleMouseButton) return false;
    }

    return super.isPointerAllowed(event);
  }

  void _activateGrabCursor() {
    if (_isGrabCursorActive) return;
    ExclusiveMouseCursor.instance.set(SystemMouseCursors.grab);
    _isGrabCursorActive = true;
  }

  void _deactivateGrabCursor() {
    if (!_isGrabCursorActive) return;
    ExclusiveMouseCursor.instance.set(SystemMouseCursors.basic);
    _isGrabCursorActive = false;
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
      _isPanZoomEvent = event is PointerPanZoomStartEvent;
      _isGrabEvent = event.kind == .mouse && event.buttons == kMiddleMouseButton;
      _stopSmoothAnimation();
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
      _isGrabEvent = false;
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
    _startScale = currentTransform().getMaxScaleOnAxis();
    if (_state == .started) {
      _onEnd();
      _state = .ready;
      _currentPointersState = null;
      _transform = .identity();
      _rotationBaseAngle = null;
    }
  }

  double _limitScale(double delta) {
    return (_startScale * delta).clamp(minScale, maxScale) / _startScale;
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

      final scale = _limitScale(b.distance / a.distance);
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

    final scale = _limitScale(math.pow(event.scale, _kPanZoomScaleFactor).toDouble());

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
        if (_isGrabEvent) {
          _activateGrabCursor();
        }
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
    _deactivateGrabCursor();
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKeyboardEvent);
    _focusNode?.removeListener(_onFocusChanged);
    _ticker?.dispose();
    _deactivateGrabCursor();
    super.dispose();
  }

  void onPointerSignal(PointerSignalEvent event) {
    if (_state == .started) return;

    if (event is PointerScaleEvent) {
      _stopSmoothAnimation();

      final focalPoint = event.localPosition;
      final scale = event.scale;

      final transform = Matrix4.identity()
        ..translateByDouble(focalPoint.dx, focalPoint.dy, 0.0, 1.0)
        ..scaleByDouble(scale, scale, 1.0, 1.0)
        ..translateByDouble(-focalPoint.dx, -focalPoint.dy, 0.0, 1.0);

      onStart?.call(.new(pointerCount: 0, transform: .identity()));
      onUpdate?.call(.new(pointerCount: 0, transform: transform));
      onEnd?.call(.new(transform: transform));
    } else if (event is PointerScrollEvent) {
      final keyboard = HardwareKeyboard.instance;
      final isZoom = keyboard.isMetaPressed || keyboard.isControlPressed;
      final delta = event.scrollDelta;

      if (!isZoom) {
        _smoothPanRemaining -= delta;
      } else {
        _smoothFocalPoint = event.localPosition;

        final scaleMultiplier = math.exp(-delta.dy * 0.00175);
        final currentTotalScale = currentTransform().getMaxScaleOnAxis();
        final futureTotalScale = currentTotalScale * _smoothScaleRemaining;
        final newFutureScale = (futureTotalScale * scaleMultiplier).clamp(minScale, maxScale);

        _smoothScaleRemaining = newFutureScale / currentTotalScale;
      }

      _startSmoothAnimationTicker();
    }
  }

  // --
  // Focus handling
  // --

  void _onFocusChanged() {
    if (_focusNode?.hasPrimaryFocus != true) {
      _stopSmoothAnimation();
    }
  }

  // --
  // Smoothed discrete event animator
  // --

  Ticker? _ticker;
  Duration? _lastTick;
  Offset _smoothPanRemaining = Offset.zero;
  double _smoothScaleRemaining = 1.0;
  Offset? _smoothFocalPoint;
  Matrix4 _smoothTotalTransform = .identity();

  void _startSmoothAnimationTicker() {
    if (_ticker?.isTicking == true) return;

    _ticker ??= .new(_onSmoothAnimationTick);
    if (!_ticker!.isTicking) {
      _lastTick = null;
      _ticker!.start();
      onStart?.call(.new(pointerCount: 0, transform: .identity()));
    }
  }

  void _onSmoothAnimationTick(Duration elapsed) {
    if (_lastTick == null) {
      _lastTick = elapsed;
      return;
    }

    final deltaTime = (elapsed - _lastTick!).inMicroseconds / Duration.microsecondsPerSecond;
    _lastTick = elapsed;

    // -- Keyboard panning
    const double panPixelsPerSecond = 1000.0;
    final keys = HardwareKeyboard.instance.logicalKeysPressed;
    var keyDelta = Offset.zero;
    if (keys.contains(LogicalKeyboardKey.arrowLeft)) keyDelta += const Offset(1.0, 0.0);
    if (keys.contains(LogicalKeyboardKey.arrowRight)) keyDelta += const Offset(-1.0, 0.0);
    if (keys.contains(LogicalKeyboardKey.arrowUp)) keyDelta += const Offset(0.0, 1.0);
    if (keys.contains(LogicalKeyboardKey.arrowDown)) keyDelta += const Offset(0.0, -1.0);

    if (keyDelta != .zero) {
      _smoothPanRemaining += keyDelta * panPixelsPerSecond * deltaTime;
    }

    final lerp = 1.0 - math.exp(-deltaTime * 40.0);
    final scaleDiff = _smoothScaleRemaining - 1.0;

    final panDone = _smoothPanRemaining.distanceSquared < 0.1;
    final scaleDone = scaleDiff.abs() < 0.001;

    if (panDone && scaleDone) {
      _emitSmoothAnimationUpdate(scale: _smoothScaleRemaining, pan: _smoothPanRemaining);
      _stopSmoothAnimation();
      return;
    }

    final panStep = _smoothPanRemaining * lerp;
    final scaleStep = 1.0 + scaleDiff * lerp;

    _smoothPanRemaining -= panStep;
    _smoothScaleRemaining /= scaleStep;
    _emitSmoothAnimationUpdate(scale: scaleStep, pan: panStep);
  }

  void _emitSmoothAnimationUpdate({required double scale, required Offset pan}) {
    final focalPoint = _smoothFocalPoint ?? .zero;
    final deltaTransform = Matrix4.identity()
      ..translateByDouble(pan.dx, pan.dy, 0.0, 1.0)
      ..translateByDouble(focalPoint.dx, focalPoint.dy, 0.0, 1.0)
      ..scaleByDouble(scale, scale, 1.0, 1.0)
      ..translateByDouble(-focalPoint.dx, -focalPoint.dy, 0.0, 1.0);

    _smoothTotalTransform = deltaTransform * _smoothTotalTransform;
    onUpdate?.call(.new(pointerCount: 0, transform: _smoothTotalTransform));
  }

  void _stopSmoothAnimation() {
    if (_ticker?.isTicking == true) {
      _ticker!.stop();
      _smoothScaleRemaining = 1.0;
      _smoothPanRemaining = .zero;
      _lastTick = null;
      onEnd?.call(.new(transform: _smoothTotalTransform));
      _smoothTotalTransform = .identity();
    }
  }

  // --
  // Keyboard arrows listener
  // --

  bool _onKeyboardEvent(KeyEvent e) {
    if (_focusNode?.hasPrimaryFocus != true) return false;

    if (e is KeyDownEvent || e is KeyRepeatEvent) {
      if (_arrowKeys.contains(e.logicalKey)) {
        return _onArrowKeyEvent(e);
      }
    }

    return false;
  }

  final _arrowKeys = <LogicalKeyboardKey>{.arrowLeft, .arrowRight, .arrowUp, .arrowDown};
  bool _onArrowKeyEvent(KeyEvent e) {
    if (e is KeyDownEvent) {
      _startSmoothAnimationTicker();
      return true;
    }

    return false;
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
