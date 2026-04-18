part of '../properties_panel.dart';

class ShapeSection extends HookWidget {
  const ShapeSection({super.key, required this.node});

  final NodeWithShape node;

  @override
  Widget build(BuildContext context) {
    final shape = useComputedValue(() => node.shape);

    void apply(NodeShapeData shape) {
      (node as MutableNodeWithShape).shape = shape;
    }

    return SectionTemplateWidget(
      title: Text('shape'),
      body: [
        ToggleableButtonRow(
          height: 28.0,
          children: [
            ToggleableButton(
              isActive: shape is RectangleNodeShapeData,
              onChanged: (v) => apply(RectangleNodeShapeData()),
              iconSize: 16.0,
              child: Icons.square(),
            ),
            ToggleableButton(
              isActive: shape is EllipseNodeShapeData,
              onChanged: (v) => apply(EllipseNodeShapeData()),
              iconSize: 16.0,
              child: Icons.circle(),
            ),
            ToggleableButton(
              isActive: false,
              onChanged: (v) {},
              iconSize: 16.0,
              child: Icons.chevronRight(),
            ),
          ],
        ),
        switch (shape) {
          RectangleNodeShapeData s => _RectangleShapeProperties(shape: s, onChanged: apply),
          EllipseNodeShapeData s => _EllipseShapeProperties(shape: s, onChanged: apply),
        },
      ],
    );
  }
}

class _RectangleShapeProperties extends StatelessWidget {
  const _RectangleShapeProperties({
    super.key,
    required this.shape,
    required this.onChanged,
  });

  final RectangleNodeShapeData shape;
  final ValueChanged<RectangleNodeShapeData> onChanged;

  @override
  Widget build(BuildContext context) {
    return DoubleExpressionInputField(
      value: shape.borderRadius.topLeft.x,
      onChanged: (v) {
        final newShape = shape.copyWith(borderRadius: .circular(v.clamp(0.0, double.infinity)));
        onChanged(newShape);
      },
    );
  }
}

class _EllipseShapeProperties extends StatelessWidget {
  const _EllipseShapeProperties({
    super.key,
    required this.shape,
    required this.onChanged,
  });

  final EllipseNodeShapeData shape;
  final ValueChanged<EllipseNodeShapeData> onChanged;

  @override
  Widget build(BuildContext context) {
    return DoubleExpressionInputField(
      value: shape.eccentricity,
      onChanged: (v) {
        final newShape = shape.copyWith(eccentricity: v.clamp(0.0, 1.0));
        onChanged(newShape);
      },
    );
  }
}
