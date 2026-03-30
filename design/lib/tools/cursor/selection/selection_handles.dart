part of '../selection_overlay.dart';

class SelectionMoveHandle extends HookWidget {
  const SelectionMoveHandle({super.key, this.onMove});

  final DragActivityFactory? onMove;

  @override
  Widget build(BuildContext context) {
    if (onMove == null) return const SizedBox.expand();
    final recognizer = useManagedResource(
      create: () => onMove != null ? DragActivityGestureRecognizer(activityFactory: onMove!) : null,
      dispose: (v) => v?.dispose(),
      keys: [onMove != null],
    );

    if (onMove != null) recognizer!.activityFactory = onMove!;

    return Listener(
      onPointerDown: (d) => recognizer?.addPointer(d),
      behavior: .translucent,
      child: SizedBox.expand(),
    );
  }
}

class SelectionCornerResizeHandle extends StatelessWidget {
  const SelectionCornerResizeHandle({
    super.key,
    required this.corner,
    this.onResize,
  });

  final Corner corner;
  final DragActivityFactory? onResize;

  @override
  Widget build(BuildContext context) {
    if (onResize == null) return const SizedBox.expand();

    final child = RotatingMouseRegion(
      cursor: Cursors.resize,
      hitTestBehavior: .opaque,
      corner: corner,
      child: RawGestureDetector(
        gestures: {DragActivityGestureRecognizer: DragActivityGestureRecognizerFactory(activityFactory: onResize!)},
        behavior: .opaque,
        child: SizedBox.square(dimension: SelectionCornerResizeHandleIcon.size),
      ),
    );

    if (kSelectionShowPaddingArea) {
      return ColoredBox(color: Colors.orange.withScaledAlpha(0.25), child: child);
    }

    return child;
  }
}

class SelectionCornerRotateHandle extends StatelessWidget {
  const SelectionCornerRotateHandle({
    super.key,
    required this.corner,
    this.onRotate,
  });

  final Corner corner;
  final DragActivityFactory? onRotate;

  @override
  Widget build(BuildContext context) {
    if (onRotate == null) return const SizedBox.expand();

    final child = RotatingMouseRegion(
      cursor: Cursors.rotate,
      hitTestBehavior: .opaque,
      corner: corner,
      child: RawGestureDetector(
        gestures: {DragActivityGestureRecognizer: DragActivityGestureRecognizerFactory(activityFactory: onRotate!)},
        behavior: .opaque,
        child: SizedBox.expand(),
      ),
    );

    if (kSelectionShowPaddingArea) {
      return ColoredBox(color: Colors.purple.withScaledAlpha(0.25), child: child);
    }

    return child;
  }
}

class SelectionEdgeResizeHandle extends StatelessWidget {
  const SelectionEdgeResizeHandle({
    super.key,
    required this.edge,
    this.onResize,
  });

  final Edge edge;
  final DragActivityFactory? onResize;

  @override
  Widget build(BuildContext context) {
    if (onResize == null) return const SizedBox.expand();

    final child = RotatingMouseRegion(
      cursor: Cursors.resize,
      hitTestBehavior: .opaque,
      edge: edge,
      child: RawGestureDetector(
        gestures: {DragActivityGestureRecognizer: DragActivityGestureRecognizerFactory(activityFactory: onResize!)},
        behavior: .opaque,
        child: SizedBox.expand(),
      ),
    );

    if (kSelectionShowPaddingArea) {
      return ColoredBox(color: Colors.red.withScaledAlpha(0.25), child: child);
    }

    return child;
  }
}

class SelectionCornerResizeHandleIcon extends StatelessWidget {
  const SelectionCornerResizeHandleIcon({super.key});
  static const size = 8.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1.0,
          strokeAlign: BorderSide.strokeAlignCenter,
          color: context.colors.accent.primary,
        ),
      ),
    );
  }
}
