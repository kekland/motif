part of 'selection.dart';

class SelectionMoveHandle extends HookWidget {
  const SelectionMoveHandle({
    super.key,
    this.onMove,
  });

  final DragActivityFactory? onMove;

  @override
  Widget build(BuildContext context) {
    if (onMove == null) return const SizedBox.expand();

    return DragActivityDetector(
      behavior: .translucent,
      activityFactory: onMove!,
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
      child: DragActivityDetector(
        behavior: .opaque,
        activityFactory: onResize!,
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
      child: DragActivityDetector(
        behavior: .opaque,
        activityFactory: onRotate!,
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
      child: DragActivityDetector(
        behavior: .opaque,
        activityFactory: onResize!,
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
