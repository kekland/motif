part of 'selection.dart';

const kSelectionShowPaddingArea = false;

class SelectionControls extends StatelessWidget {
  const SelectionControls({
    super.key,
    required this.layoutSize,
    this.onMove,
    this.onEdgeResize,
    this.onCornerResize,
    this.onRotate,
    this.childSize,
    this.padding = 0.0,
    this.transform,
    this.trailing,
  });

  final Matrix4? transform;
  final Size layoutSize;
  final DragActivity Function()? onMove;
  final DragActivity Function(Edge)? onEdgeResize;
  final DragActivity Function(Corner)? onCornerResize;
  final DragActivity Function(Corner)? onRotate;
  final Size? childSize;
  final double padding;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    // Compute the quad
    final transform = Matrix4.copy(this.transform ?? Matrix4.identity());
    final paddedSize = EdgeInsets.all(padding).inflateSize(layoutSize);

    final bbox = Aabb2.minMax(.zero(), .new(layoutSize.width, layoutSize.height));
    final quad = bbox.transformToQuad(transform);

    // Find the "lowest" edge of the quad.
    var lowestEdgeIndex = -1;
    var lowestEdgeCenterDy = 0.0;
    var lowestEdgeDirX = double.negativeInfinity;
    for (var i = 0; i < 4; i++) {
      final (p1, p2) = (quad[i], quad[(i + 1) % 4]);
      final center = (p1 + p2) / 2.0;
      final dirX = p1.x - p2.x;

      final isFirst = lowestEdgeIndex == -1;
      final isLower = !isFirst && (center.y - lowestEdgeCenterDy) > 1e-6;
      final isTie = !isFirst && (center.y - lowestEdgeCenterDy).abs() <= 1e-6;

      if (isFirst || isLower || (isTie && dirX > lowestEdgeDirX)) {
        lowestEdgeIndex = i;
        lowestEdgeCenterDy = center.y;
        lowestEdgeDirX = dirX;
      }
    }

    final minQuadEdge = quad.edges.elementAt(lowestEdgeIndex);
    final minQuadEdgeVector = minQuadEdge.$1 - minQuadEdge.$2;
    final minQuadEdgeCenter = (minQuadEdge.$1 + minQuadEdge.$2) / 2.0;
    final minQuadEdgeAngle = math.atan2(minQuadEdgeVector.y, minQuadEdgeVector.x);

    // Transform should apply the padding
    transform.translateByDouble(-padding, -padding, 0.0, 1.0);

    Positioned _buildCornerPositioned({
      required Corner corner,
      required Widget child,
      required double extent,
      required double indent,
    }) {
      final top = corner.isTop ? indent : null;
      final left = corner.isLeft ? indent : null;
      final right = corner.isRight ? indent : null;
      final bottom = corner.isBottom ? indent : null;

      final width = extent;
      final height = extent;
      return Positioned(left: left, top: top, right: right, bottom: bottom, width: width, height: height, child: child);
    }

    Positioned _buildEdgePositioned({
      required Edge edge,
      required Widget child,
      required double extent,
      required double indent,
    }) {
      final top = edge == Edge.top || edge.isVertical ? indent : null;
      final left = edge == Edge.left || edge.isHorizontal ? indent : null;
      final right = edge == Edge.right || edge.isHorizontal ? indent : null;
      final bottom = edge == Edge.bottom || edge.isVertical ? indent : null;

      final width = edge.isVertical ? extent : null;
      final height = edge.isHorizontal ? extent : null;
      return Positioned(left: left, top: top, right: right, bottom: bottom, width: width, height: height, child: child);
    }

    Widget _buildCornerRotateHandle(Corner corner) => _buildCornerPositioned(
      corner: corner,
      indent: 0.0,
      extent: padding * 1.5,
      child: SelectionCornerRotateHandle(
        corner: corner,
        onRotate: onRotate != null ? (_) => onRotate!(corner) : null,
      ),
    );

    Widget _buildCornerResizeHandle(Corner corner) => _buildCornerPositioned(
      corner: corner,
      indent: padding / 2.0,
      extent: padding,
      child: SelectionCornerResizeHandle(
        corner: corner,
        onResize: onCornerResize != null ? (_) => onCornerResize!(corner) : null,
      ),
    );

    Widget _buildEdgeResizeHandle(Edge edge) => _buildEdgePositioned(
      edge: edge,
      indent: padding / 2.0,
      extent: padding,
      child: SelectionEdgeResizeHandle(
        edge: edge,
        onResize: onEdgeResize != null ? (_) => onEdgeResize!(edge) : null,
      ),
    );

    Widget _buildMoveHandle() => Positioned(
      left: padding,
      right: padding,
      top: padding,
      bottom: padding,
      child: SelectionMoveHandle(
        onMove: onMove != null ? (_) => onMove!() : null,
      ),
    );

    final transformedChildren = Stack(
      clipBehavior: Clip.none,
      children: [
        if (onMove != null) _buildMoveHandle(),
        Positioned(
          left: padding,
          right: padding,
          top: padding,
          bottom: padding,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.colors.accent.primary,
                  width: 1.0,
                  strokeAlign: BorderSide.strokeAlignCenter,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: padding,
          right: padding,
          top: padding,
          bottom: padding,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.colors.accent.primary,
                  width: 1.0,
                  strokeAlign: BorderSide.strokeAlignCenter,
                ),
              ),
            ),
          ),
        ),
        if (onMove != null) _buildMoveHandle(),
        if (onEdgeResize != null) ...Edge.values.map(_buildEdgeResizeHandle),
        if (onRotate != null) ...Corner.values.map(_buildCornerRotateHandle),
        if (onCornerResize != null) ...Corner.values.map(_buildCornerResizeHandle),
      ],
    );

    final child = OverflowHitTestableStack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Transform(
            transform: transform,
            child: UnconstrainedOverflowBox(
              alignment: Alignment.topLeft,
              child: SizedBox.fromSize(
                size: paddedSize,
                child: transformedChildren,
              ),
            ),
          ),
        ),

        for (final p in quad.points)
          Positioned(
            left: p.x - 4.0,
            top: p.y - 4.0,
            child: IgnorePointer(child: SelectionCornerResizeHandleIcon()),
          ),

        if (trailing != null || childSize != null)
          Positioned(
            left: minQuadEdgeCenter.x,
            top: minQuadEdgeCenter.y,
            child: Transform.rotate(
              angle: minQuadEdgeAngle,
              child: Transform.translate(
                offset: .new(0.0, 8.0),
                child: OverflowHitTestableSizedOverflowBox(
                  size: .zero,
                  alignment: .topCenter,
                  child: trailing ?? SelectionSizeInfoBox(size: childSize!),
                ),
              ),
            ),
          ),
      ],
    );

    if (kSelectionShowPaddingArea) {
      return ColoredBox(
        color: Colors.green.withScaledAlpha(0.25),
        child: child,
      );
    }

    return child;
  }
}
