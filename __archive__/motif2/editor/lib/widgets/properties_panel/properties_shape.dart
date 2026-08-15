part of 'properties_panel.dart';

class PropertiesShapeSection extends HookWidget {
  const PropertiesShapeSection({
    super.key,
    required this.nodes,
  });

  final Set<SceneNode> nodes;

  @override
  Widget build(BuildContext context) {
    final nodes = useNodeList(this.nodes, aspect: .shape);
    final node = nodes.first;

    final shape = node is SceneObjectWithShape ? node.shape as RectangleObjectShape : null;

    if (shape == null) {
      return SizedBox();
    }

    final container = node as SceneObjectWithShape;
    final radius = shape.topLeftRadius.x;

    return PropertiesSection(
      title: Text('Shape'),
      children: [
        DoubleExpressionInputField(
          value: radius,
          onChanged: (v) => container.shape = RectangleObjectShape.circular(v),
        ),
      ],
    );
  }
}
