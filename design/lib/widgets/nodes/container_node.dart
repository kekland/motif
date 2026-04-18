part of '_nodes.dart';

class ContainerNodeWidget extends HookWidget {
  const ContainerNodeWidget({
    super.key,
    required this.node,
  });

  final ContainerNode node;

  @override
  Widget build(BuildContext context) {
    final shapeData = useComputedValue(() => node.shape);
    final shape = _nodeShapeToShape(context, shapeData);

    return NodeBuilder(
      node: node,
      shape: shape,
      builder: (context, child) {
        return DecoratedBox(
          decoration: ShapeDecoration(shape: shape),
          child: child,
        );
      },
    );
  }
}

ShapeBorder _nodeShapeToShape(BuildContext context, NodeShapeData shape) {
  final side = BorderSide(
    color: context.colors.divider,
    strokeAlign: BorderSide.strokeAlignInside,
  );

  return switch (shape) {
    RectangleNodeShapeData v => RoundedRectangleBorder(
      borderRadius: v.borderRadius,
      side: side,
    ),
    EllipseNodeShapeData v => CircleBorder(
      eccentricity: v.eccentricity,
      side: side,
    ),
  };
}
