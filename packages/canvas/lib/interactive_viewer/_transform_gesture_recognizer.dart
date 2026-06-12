// import 'dart:math';

// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:watchcrunch_flutter_stories/src/components/transformable_widget/transformable_widget.dart';
// import 'package:vector_math/vector_math_64.dart';
// import 'package:watchcrunch_flutter_stories/src/components/utils/first_where_or_null.dart';

// /// The minimum distance travelled by a pointer for the gesture to be
// /// considered a transform gesture.
// const kTransformSlop = 6.0;

// /// Threshold of the velocity of the gesture, after which the gesture will
// /// not snap to guides or angles.
// const kSnapVelocityThreshold = 30.0;

// /// The minimum distance between a [TransformableGeometry] and a [Guide] for
// /// the [TransformableGeometry] to snap to the [Guide].
// ///
// /// Expressed in logical pixels in the global coordinate system.
// const kTranslationSnapDistance = 10.0;

// /// The minimum distance between a [TransformableGeometry] and a [Guide] for
// /// the [TransformableGeometry] to break the snap to the [Guide].
// ///
// /// Expressed in logical pixels in the global coordinate system.
// const kTranslationSnapBreakDistance = 16.0;

// /// The increment of the rotation angle by which the [TransformableGeometry]
// /// will snap to the nearest angle.
// ///
// /// Expressed in radians.
// const kRotationSnapAngleIncrement = pi / 2;

// /// The minimum difference between the rotation angle of the
// /// [TransformableGeometry] and the nearest angle for the geometry to snap
// /// to the nearest angle.
// ///
// /// Expressed in radians.
// const kRotationSnapAngleDifference = pi / 12;

// /// The minimum difference between the rotation angle of the
// /// [TransformableGeometry] and the nearest angle for the geometry to break
// /// the snap to the nearest angle.
// ///
// /// Expressed in radians.
// const kRotationSnapBreakAngleDifference = pi / 10;

// class _PointersState {
//   _PointersState({
//     required this.positions,
//   });

//   final List<Offset> positions;

//   Offset difference(_PointersState other) {
//     final a = positions.first;
//     final b = other.positions.first;

//     return b - a;
//   }

//   Offset get focalPoint {
//     final sum = positions.reduce((a, b) => a + b);
//     return sum / positions.length.toDouble();
//   }
// }

// /// State of a [TransformGestureRecognizer].
// enum _TransformState {
//   /// The recognizer is ready to accept new pointers.
//   ready,

//   /// The recognizer has accepted pointers, but hasn't started the gesture yet.
//   possible,

//   /// The recognizer has started the gesture.
//   started,
// }

// /// TODO: Document this.
// class TransformGestureRecognizer extends OneSequenceGestureRecognizer {
//   TransformGestureRecognizer({
//     required this.minAllowedPointerCount,
//     Matrix4? initialTransform,
//     this.shape = BoxShape.rectangle,
//     this.context,
//     this.transformedContext,
//     this.onStart,
//     this.onUpdate,
//     this.onEnd,
//     this.canvasState,
//     this.canSnapTranslation = true,
//     this.canSnapRotation = true,
//   }) : _transform = initialTransform ?? Matrix4.identity();

//   BuildContext? context;
//   BuildContext? transformedContext;

//   bool canSnapTranslation;
//   bool canSnapRotation;

//   TransformationCanvasState? canvasState;
//   final BoxShape shape;
//   final int minAllowedPointerCount;
//   GestureTransformStartCallback? onStart;
//   GestureTransformUpdateCallback? onUpdate;
//   GestureTransformEndCallback? onEnd;

//   final _pointerQueue = <int>[];
//   final _pointerLocalPositions = <int, Offset>{};
//   final _pointerGlobalPositions = <int, Offset>{};
//   final _velocityTrackers = <int, VelocityTracker>{};

//   var _state = _TransformState.ready;

//   Matrix4 _transform;
//   var _currentTransform = Matrix4.identity();
//   var _translationSnapTransform = Matrix4.identity();
//   var _rotationSnapTransform = Matrix4.identity();

//   Matrix4 get _totalTransform =>
//       _translationSnapTransform *
//       _rotationSnapTransform *
//       _totalTransformWithoutSnap;

//   Matrix4 get _totalTransformWithoutTranslationSnap =>
//       _rotationSnapTransform * _totalTransformWithoutSnap;

//   Matrix4 get _totalTransformWithoutSnap =>
//       _transform * _currentTransform * _pointerSignalTransform;

//   int get _pointerCount => _pointerQueue.length;
//   bool get _hasMinPointerCount => _pointerCount >= minAllowedPointerCount;

//   Iterable<Offset> get _queuedLocalPositions =>
//       _pointerQueue.map((v) => _pointerLocalPositions[v]!);

//   Iterable<Offset> get _queuedGlobalPositions =>
//       _pointerQueue.map((v) => _pointerGlobalPositions[v]!);

//   @override
//   void addAllowedPointer(PointerDownEvent event) {
//     super.addAllowedPointer(event);
//   }

//   @override
//   void acceptGesture(int pointer) {}

//   @override
//   void rejectGesture(int pointer) {}

//   @override
//   void handleEvent(PointerEvent event) {
//     // Whether the configuration of the pointers have changed.
//     var didChangeConfiguration = false;

//     final pointerId = event.pointer;

//     if (event is PointerDownEvent) {
//       // Initialize the information about this pointer
//       _pointerQueue.add(pointerId);
//       _pointerLocalPositions[pointerId] = event.localPosition;
//       _pointerGlobalPositions[pointerId] = event.position;
//       _velocityTrackers[pointerId] = VelocityTracker.withKind(event.kind);

//       didChangeConfiguration = true;
//     } else if (event is PointerMoveEvent) {
//       // Update the information about this pointer
//       _pointerLocalPositions[pointerId] = event.localPosition;
//       _pointerGlobalPositions[pointerId] = event.position;
//       _velocityTrackers[pointerId]!
//           .addPosition(event.timeStamp, event.position);
//     } else if (event is PointerUpEvent || event is PointerCancelEvent) {
//       // Remove this pointer's information
//       _pointerQueue.remove(pointerId);
//       _pointerLocalPositions.remove(pointerId);
//       _pointerGlobalPositions.remove(pointerId);
//       _velocityTrackers.remove(pointerId);

//       didChangeConfiguration = true;
//     }

//     if (_lastGlobalToLocalTransform == null) {
//       _updateLastGlobalToLocalTransform();
//     }

//     if (didChangeConfiguration) {
//       _reconfigure();
//     }

//     _update();
//     _advanceStateMachine();

//     stopTrackingIfPointerNoLongerDown(event);
//   }

//   var _pointerSignalTransform = Matrix4.identity();

//   final _rotationKeys = {
//     LogicalKeyboardKey.controlLeft,
//     LogicalKeyboardKey.meta,
//   };

//   void handlePointerSignalEvent(PointerSignalEvent event) {
//     if (_state != _TransformState.started) return;

//     if (event is PointerScrollEvent) {
//       final isRotation = RawKeyboard.instance.keysPressed.any(
//         (v) => _rotationKeys.contains(v),
//       );

//       final origin = _renderBox!.globalToLocal(_queuedGlobalPositions.first);

//       if (isRotation) {
//         final delta = event.scrollDelta.dy.sign * (pi / 90.0);

//         final rotation = Matrix4.identity()
//           ..translate(origin.dx, origin.dy)
//           ..rotateZ(delta)
//           ..translate(-origin.dx, -origin.dy);

//         _pointerSignalTransform = _pointerSignalTransform * rotation;
//       } else {
//         final delta = -event.scrollDelta.dy / 500.0;

//         final scale = Matrix4.identity()
//           ..translate(origin.dx, origin.dy)
//           ..scale(1.0 + delta)
//           ..translate(-origin.dx, -origin.dy);

//         _pointerSignalTransform = _pointerSignalTransform * scale;
//       }

//       _update();
//       _advanceStateMachine();
//     }
//   }

//   _PointersState? _createPointersState() {
//     if (_pointerCount == 0) return null;

//     return _PointersState(
//       positions: _queuedGlobalPositions.toList(growable: false),
//     );
//   }

//   _PointersState? _initialPointersState;
//   _PointersState? _currentPointersState;

//   void _reconfigure() {
//     _initialPointersState = _createPointersState();

//     if (_state == _TransformState.started) {
//       _state = _TransformState.ready;

//       _currentPointersState = null;
//       _transform = _totalTransform;

//       _currentTransform = Matrix4.identity();
//       _pointerSignalTransform = Matrix4.identity();
//       _translationSnapTransform = Matrix4.identity();
//       _rotationSnapTransform = Matrix4.identity();

//       _snappedHorizontalGuide = null;
//       _snappedVerticalGuide = null;
//       _onSnappedGuidesUpdated();

//       canvasState?.setActiveGeometry(null);
//       canvasState?.setActiveRotationSnapAngle(null);

//       _lastGlobalToLocalTransform = null;

//       _onEnd();
//     }
//   }

//   Matrix4? _lastGlobalToLocalTransform;

//   RenderBox? _cachedRenderBox;
//   RenderBox? get _renderBox {
//     return _cachedRenderBox ??=
//         transformedContext?.findRenderObject() as RenderBox?;
//   }

//   Size get _size => _renderBox?.size ?? Size.zero;

//   void _updateLastGlobalToLocalTransform() {
//     if (_renderBox == null) return;

//     _setLastGlobalToLocalTransform(
//       Matrix4.inverted(
//         _renderBox!.getTransformTo(null),
//       ),
//     );
//   }

//   void _setLastGlobalToLocalTransform(Matrix4? t) {
//     if (_lastGlobalToLocalTransform != t) {
//       _lastGlobalToLocalTransform = t;
//     }
//   }

//   Offset _transformGlobalToLocalPosition(Offset position) {
//     return PointerEvent.transformPosition(
//       _lastGlobalToLocalTransform,
//       position,
//     );
//   }

//   void _update() {
//     if (_initialPointersState == null) return;
//     _currentPointersState = _createPointersState();

//     if (_currentPointersState == null) return;
//     if (_state != _TransformState.started) return;

//     final startPointers = _initialPointersState!.positions;
//     final currentPointers = _currentPointersState!.positions;

//     if (startPointers.length >= 2 && currentPointers.length >= 2) {
//       // Two-finger gesture
//       final a1 = _transformGlobalToLocalPosition(startPointers[0]);
//       final a2 = _transformGlobalToLocalPosition(startPointers[1]);
//       final a = a2 - a1;

//       final b1 = _transformGlobalToLocalPosition(currentPointers[0]);
//       final b2 = _transformGlobalToLocalPosition(currentPointers[1]);
//       final b = b2 - b1;

//       final scaleFactor = b.distance / a.distance;
//       final rotationAngle = atan2(
//         b.dx * a.dy - b.dy * a.dx,
//         b.dx * a.dx + b.dy * a.dy,
//       );

//       _currentTransform = Matrix4.identity()
//         ..translate(b1.dx, b1.dy)
//         ..rotateZ(-rotationAngle)
//         ..scale(scaleFactor)
//         ..translate(-a1.dx, -a1.dy);

//       _applyRotationSnap();
//       _applyTranslationSnap(false);
//     } else {
//       // One-finger gesture
//       final a = _transformGlobalToLocalPosition(startPointers[0]);
//       final b = _transformGlobalToLocalPosition(currentPointers[0]);

//       _currentTransform = Matrix4.identity()
//         ..translate(b.dx - a.dx, b.dy - a.dy);

//       _applyTranslationSnap();
//     }
//   }

//   Velocity get _averageVelocity {
//     final velocities = _velocityTrackers.values.map((v) => v.getVelocity());
//     final velocitySum = velocities.reduce((a, b) => a + b);

//     return Velocity(
//       pixelsPerSecond: velocitySum.pixelsPerSecond / _pointerCount.toDouble(),
//     );
//   }

//   double get _averageVelocityMagnitude {
//     return _averageVelocity.pixelsPerSecond.distance;
//   }

//   bool get _isMovingSlowly =>
//       _averageVelocityMagnitude < kSnapVelocityThreshold;

//   TransformableGeometry get _originalGeometry {
//     final quad = Quad.points(
//       Vector3(0, 0, 0),
//       Vector3(_size.width, 0, 0),
//       Vector3(_size.width, _size.height, 0),
//       Vector3(0, _size.height, 0),
//     );

//     if (shape == BoxShape.rectangle) {
//       return TransformableQuadGeometry(quad: quad);
//     } else {
//       return TransformableCircleGeometry(quad: quad);
//     }
//   }

//   TransformableGeometry get _transformedGeometry =>
//       _originalGeometry.transform(_totalTransform);

//   TransformableGeometry get _transformedWithoutSnapGeometry =>
//       _originalGeometry.transform(_totalTransformWithoutSnap);

//   TransformableGeometry get _transformedWithRotationSnapGeometry =>
//       _originalGeometry.transform(_totalTransformWithoutTranslationSnap);

//   Matrix4? get _canvasTransform => canvasState != null
//       ? context
//           ?.findRenderObject()
//           ?.getTransformTo(canvasState!.context.findRenderObject())
//       : null;

//   TransformableGeometry _transformGeometryToCanvas(
//     TransformableGeometry geometry,
//   ) {
//     return geometry.transform(_canvasTransform!);
//   }

//   bool _isRotationSnapped = false;

//   void _applyRotationSnap([bool forceCanSnap = true]) {
//     if (!forceCanSnap || !canSnapRotation) {
//       if (!_rotationSnapTransform.isIdentity()) {
//         _rotationSnapTransform = Matrix4.identity();
//       }

//       return;
//     }

//     final rotation = _transformedWithoutSnapGeometry.rotation;

//     final snapRotation = (rotation / kRotationSnapAngleIncrement).round() *
//         kRotationSnapAngleIncrement;

//     final rotationDifference = (rotation - snapRotation).abs();

//     final isInSnapRange = rotationDifference < pi / 40;
//     final isInSnapBreakRange = rotationDifference < pi / 32;

//     final canSnap = _isMovingSlowly && isInSnapRange;
//     final canBreakSnap = !isInSnapBreakRange;

//     if (_isRotationSnapped && canBreakSnap) {
//       if (_isRotationSnapped) {
//         _isRotationSnapped = false;
//         HapticFeedback.selectionClick();

//         canvasState?.setActiveRotationSnapAngle(null);
//       }

//       _rotationSnapTransform = Matrix4.identity();
//     } else if (_isRotationSnapped || canSnap) {
//       if (!_isRotationSnapped) {
//         _isRotationSnapped = true;
//         HapticFeedback.selectionClick();

//         canvasState?.setActiveRotationSnapAngle(snapRotation);
//       }

//       _rotationSnapTransform = Matrix4.identity()
//         ..rotateZ(-rotation + snapRotation);
//     }
//   }

//   HorizontalGuide? _snappedHorizontalGuide;
//   VerticalGuide? _snappedVerticalGuide;

//   void _unsnapToGuide(Guide guide) {
//     if (canvasState == null) return;

//     if (_snappedHorizontalGuide == guide) {
//       _snappedHorizontalGuide = null;
//     } else if (_snappedVerticalGuide == guide) {
//       _snappedVerticalGuide = null;
//     }
//   }

//   List<Guide> get _snappedGuides => [
//         if (_snappedHorizontalGuide != null) _snappedHorizontalGuide!,
//         if (_snappedVerticalGuide != null) _snappedVerticalGuide!,
//       ];

//   void _onSnappedGuidesUpdated() {
//     canvasState?.setActiveGuides(_snappedGuides);
//   }

//   void _applyTranslationSnap([bool forceCanSnap = true]) {
//     if ((!forceCanSnap || !canSnapTranslation) || canvasState == null) {
//       if (_snappedGuides.isNotEmpty) {
//         _translationSnapTransform = Matrix4.identity();
//         _snappedHorizontalGuide = null;
//         _snappedVerticalGuide = null;
//         _onSnappedGuidesUpdated();
//       }

//       return;
//     }

//     final canvasGeometry =
//         _transformGeometryToCanvas(_transformedWithRotationSnapGeometry);

//     if (_isMovingSlowly) {
//       final guides = sortGuidesByDistanceForGeometry(
//         canvasState!.guides,
//         canvasGeometry,
//       );

//       final closestHorizontalGuide = guides.firstWhereOrNull(
//         (v) => v.$1 is HorizontalGuide && v.$2 < kTranslationSnapDistance,
//       );

//       final closestVerticalGuide = guides.firstWhereOrNull(
//         (v) => v.$1 is VerticalGuide && v.$2 < kTranslationSnapDistance,
//       );

//       var changedState = false;

//       if (closestHorizontalGuide?.$1 != _snappedHorizontalGuide) {
//         _snappedHorizontalGuide =
//             closestHorizontalGuide?.$1 as HorizontalGuide?;
//         changedState = true;
//       }

//       if (closestVerticalGuide?.$1 != _snappedVerticalGuide) {
//         _snappedVerticalGuide = closestVerticalGuide?.$1 as VerticalGuide?;
//         changedState = true;
//       }

//       if (changedState) {
//         HapticFeedback.selectionClick();
//         _onSnappedGuidesUpdated();
//       }
//     }

//     for (final guide in _snappedGuides) {
//       final distance = guide.distanceToGeometry(canvasGeometry);

//       if (distance > kTranslationSnapBreakDistance) {
//         _unsnapToGuide(guide);
//         _onSnappedGuidesUpdated();
//         HapticFeedback.selectionClick();
//       }
//     }

//     final offset = getOffsetToSnapGeometry(
//       canvasGeometry,
//       horizontalGuide: _snappedHorizontalGuide,
//       verticalGuide: _snappedVerticalGuide,
//     );

//     final invertedCanvasScale =
//         Matrix4.inverted(_canvasTransform!).getMaxScaleOnAxis();

//     _translationSnapTransform = Matrix4.identity()
//       ..translate(
//         offset.dx * invertedCanvasScale,
//         offset.dy * invertedCanvasScale,
//       );
//   }

//   void _advanceStateMachine() {
//     if (_state == _TransformState.ready && _initialPointersState != null) {
//       _state = _TransformState.possible;
//     }

//     if (_state == _TransformState.possible) {
//       if (_initialPointersState == null) {
//         return;
//       }

//       final offset = _initialPointersState!.difference(_currentPointersState!);
//       final delta = offset.distance;

//       if (delta > kTransformSlop && _hasMinPointerCount) {
//         _state = _TransformState.started;
//         _onStart();
//         resolve(GestureDisposition.accepted);
//       }
//     } else if (_state.index >= _TransformState.possible.index) {
//       resolve(GestureDisposition.accepted);
//     }

//     if (_state == _TransformState.started) {
//       _onUpdate();
//     }
//   }

//   void _onStart() {
//     if (onStart != null) {
//       final canvasGeometry = _transformGeometryToCanvas(_transformedGeometry);
//       canvasState?.setActiveGeometry(canvasGeometry);

//       invokeCallback<void>(
//         'onStart',
//         () {
//           onStart!(
//             TransformStartDetails(
//               pointerCount: _pointerCount,
//               transform: _totalTransform,
//               geometry: canvasGeometry,
//             ),
//           );
//         },
//       );
//     }
//   }

//   void _onUpdate() {
//     if (onUpdate != null) {
//       final canvasGeometry = _transformGeometryToCanvas(_transformedGeometry);
//       canvasState?.setActiveGeometry(canvasGeometry);

//       final focalPoint = _currentPointersState!.focalPoint;
//       final localFocalPoint = _renderBox!.globalToLocal(focalPoint);

//       invokeCallback<void>(
//         'onUpdate',
//         () {
//           onUpdate!(
//             TransformUpdateDetails(
//               pointerCount: _pointerCount,
//               transform: _totalTransform,
//               geometry: canvasGeometry,
//               focalPoint: focalPoint,
//               localFocalPoint: localFocalPoint,
//               localRect: Offset.zero & _size,
//             ),
//           );
//         },
//       );
//     }
//   }

//   void _onEnd() {
//     if (onEnd != null) {
//       invokeCallback<void>(
//         'onEnd',
//         () {
//           onEnd!(
//             TransformEndDetails(
//               transform: _totalTransform,
//             ),
//           );
//         },
//       );
//     }
//   }

//   @override
//   String get debugDescription => throw UnimplementedError();

//   @override
//   void didStopTrackingLastPointer(int pointer) {
//     if (_state == _TransformState.ready) {
//       resolve(GestureDisposition.rejected);
//     }

//     _state = _TransformState.ready;
//   }
// }

// typedef GestureTransformStartCallback = void Function(
//   TransformStartDetails details,
// );

// typedef GestureTransformUpdateCallback = void Function(
//   TransformUpdateDetails details,
// );

// typedef GestureTransformEndCallback = void Function(
//   TransformEndDetails details,
// );

// class TransformStartDetails {
//   TransformStartDetails({
//     required this.pointerCount,
//     required this.transform,
//     required this.geometry,
//   });

//   final int pointerCount;
//   final Matrix4 transform;
//   final TransformableGeometry geometry;
// }

// class TransformUpdateDetails {
//   TransformUpdateDetails({
//     required this.pointerCount,
//     required this.transform,
//     required this.geometry,
//     required this.focalPoint,
//     required this.localFocalPoint,
//     required this.localRect,
//   });

//   final int pointerCount;
//   final Matrix4 transform;
//   final TransformableGeometry geometry;

//   final Offset focalPoint;
//   final Offset localFocalPoint;

//   final Rect localRect;

//   Alignment get localFocalPointAlignment {
//     return Alignment(
//       (localFocalPoint.dx / localRect.width) * 2 - 1,
//       (localFocalPoint.dy / localRect.height) * 2 - 1,
//     );
//   }
// }

// class TransformEndDetails {
//   TransformEndDetails({
//     required this.transform,
//   });

//   final Matrix4 transform;
// }
