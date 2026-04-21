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
        final fill = useComputedValue(() => node.fill);
        final color = fill.color;

        return DecoratedBox(
          decoration: ShapeDecoration(
            shape: shape,
            color: _colorDataToColor(color),
          ),
          child: child,
        );
      },
    );
  }
}

ShapeBorder _nodeShapeToShape(BuildContext context, NodeShapeData shape) {
  final side = BorderSide(
    color: context.colors.divider,
    width: 1.0,
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

Color _colorDataToColor(ColorData colorData) =>
    colorData.cssColor.convertTo(.srgb).reinterpretAs(.displayP3).toUiColor(colorSpace: .displayP3);
