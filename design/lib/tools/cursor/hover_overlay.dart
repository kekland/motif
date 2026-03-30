import 'package:design/imports.dart';

class HoverOverlayBuilder extends StatelessWidget {
  const HoverOverlayBuilder({
    super.key,
    required this.hoveringNode,
    required this.child,
  });

  final RenderNode? hoveringNode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PersistentOverlayBuilder(
      builder: (context, info) {
        return HoverOverlay(
          node: hoveringNode,
          childPaintTransform: info.childPaintTransform,
          isFilled: true,
        );
      },
      child: child,
    );
  }
}

class HoverOverlay extends StatelessWidget {
  const HoverOverlay({
    super.key,
    required this.node,
    required this.childPaintTransform,
    this.isFilled = false,
  });

  final RenderNode? node;
  final Matrix4 childPaintTransform;
  final bool isFilled;

  Widget _buildHoverOverlay(BuildContext context) {
    // final node = this.node!.node;
    if (!node!.attached) return const SizedBox.shrink();

    final rootNode = node!.rootNode;
    final Matrix4 totalTransform = childPaintTransform * node!.getTransformTo(rootNode);
    final (sx, sy) = (totalTransform.scaleX, totalTransform.scaleY);
    final size = Size(node!.size.width * sx, node!.size.height * sy);

    final transform = totalTransform.getWithNormalizedScale();

    return UnconstrainedOverflowBox(
      alignment: Alignment.topLeft,
      child: IgnorePointer(
        child: Transform(
          transform: transform,
          child: Container(
            width: size.width,
            height: size.height,
            decoration: ShapeDecoration(
              // shape: node.shape.copyWithBorderSide(
              //   BorderSide(
              //     color: context.colors.accent.primary,
              //     width: 2.0,
              //     strokeAlign: BorderSide.strokeAlignCenter,
              //   ),
              // ),
              shape: RoundedRectangleBorder(),
              color: isFilled ? context.colors.accent.primary.withScaledAlpha(0.1) : null,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (node == null) return const SizedBox.shrink();

    return DeferredLayoutBuilder(
      targets: [node!],
      builder: (context, _) => _buildHoverOverlay(context),
    );
  }
}
