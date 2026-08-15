part of 'drag_activity.dart';

typedef DragActivityFactory<T extends DragActivity> = T? Function(PointerEvent event);

class DragActivityRecognizer<T extends DragActivity> extends PanGestureRecognizer {
  DragActivityRecognizer({
    required this.factory,
    super.allowedButtonsFilter,
    super.supportedDevices,
    super.debugOwner,
  }) {
    dragStartBehavior = .down;
    onlyAcceptDragOnThreshold = false;

    onStart = (details) {
      _onActivityCreated();
      _currentActivity!.onStart(details);
    };

    onUpdate = (details) {
      _currentActivity?.onUpdate(details);
    };

    onEnd = (details) {
      if (_currentActivity == null) return;
      _releaseActivity(details);
    };

    onCancel = () {
      if (_currentActivity == null) return;
      _releaseActivity(null, cancel: true);
    };
  }

  DragActivityFactory<T> factory;

  T? _currentActivity;
  T? get currentActivity => _currentActivity;

  PointerEvent? _lastPointerEvent;

  void _onActivityCreated() {
    currentActivity?._pointerEvent = _lastPointerEvent;
  }

  void _releaseActivity(DragEndDetails? details, {bool cancel = false}) {
    if (!cancel) {
      _currentActivity?.onEnd(details);
    } else {
      _currentActivity?.onCancel();
    }

    _currentActivity = null;
  }

  final Set<int> _trackedPointers = <int>{};

  @override
  void addAllowedPointerPanZoom(PointerPanZoomStartEvent event) {
    assert(_currentActivity == null);
    _currentActivity = factory(event);
    if (_currentActivity == null) {
      resolvePointer(event.pointer, .rejected);
      return;
    }

    final activity = _currentActivity!;

    if (!activity.shouldAcceptPanZoom(event)) {
      resolvePointer(event.pointer, .rejected);
      _releaseActivity(null, cancel: true);
      return;
    }

    super.addAllowedPointerPanZoom(event);
  }

  @override
  void addAllowedPointer(PointerDownEvent event) {
    assert(_currentActivity == null);
    _currentActivity = factory(event);
    if (_currentActivity == null) {
      resolvePointer(event.pointer, .rejected);
      return;
    }

    final activity = _currentActivity!;

    if (!activity.shouldAccept(event)) {
      resolvePointer(event.pointer, .rejected);
      _releaseActivity(null, cancel: true);
      return;
    }

    // Add supported devices from the activity to the recognizer's supported devices.
    if (activity.supportedDevices != null) {
      supportedDevices ??= activity.supportedDevices!.toSet();
      supportedDevices!.union(activity.supportedDevices!);
    }

    super.addAllowedPointer(event);
    _trackedPointers.add(event.pointer);

    // If we're tracking more pointers than the activity allows, reject all of them.
    if (_trackedPointers.length > activity.maxPointers) {
      for (final int pointer in _trackedPointers.toList()) {
        resolvePointer(pointer, .rejected);
        stopTrackingPointer(pointer);
      }

      _trackedPointers.clear();
      _releaseActivity(null, cancel: true);
      return;
    }

    // Instant accept if the device is in the list of devices to accept immediately (e.g. a stylus).
    final devicesToAcceptImmediately = activity.devicesToAcceptImmediately;
    if (devicesToAcceptImmediately?.contains(event.kind) == true) {
      resolvePointer(event.pointer, .accepted);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerUpEvent || event is PointerCancelEvent) {
      _trackedPointers.remove(event.pointer);
    }

    _lastPointerEvent = event;
    currentActivity?._pointerEvent = event;
    super.handleEvent(event);
  }

  @override
  void rejectGesture(int pointer) {
    _trackedPointers.remove(pointer);
    super.rejectGesture(pointer);
  }
}

class DragActivityRecognizerFactory<T extends DragActivity>
    extends GestureRecognizerFactory<DragActivityRecognizer<T>> {
  DragActivityRecognizerFactory({required this.activityFactory});

  final DragActivityFactory<T> activityFactory;

  @override
  DragActivityRecognizer<T> constructor() {
    return DragActivityRecognizer<T>(factory: activityFactory);
  }

  @override
  void initializer(DragActivityRecognizer<T> instance) {
    instance.factory = activityFactory;
  }
}

class DragActivityDetector<T extends DragActivity> extends RawGestureDetector {
  DragActivityDetector({
    super.key,
    required this.activityFactory,
    this.onStart,
    this.onEnd,
    this.supportedDevices,
    super.behavior,
    super.child,
  }) : super(
         gestures: {
           DragActivityRecognizer<T>: DragActivityRecognizerFactory<T>(
             activityFactory: activityFactory,
           ),
         },
       );

  final DragActivityFactory<T> activityFactory;
  final VoidCallback? onStart;
  final VoidCallback? onEnd;
  final Set<PointerDeviceKind>? supportedDevices;
}
