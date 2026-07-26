part of 'properties_panel.dart';

class PropertiesLayoutSection extends HookWidget {
  const PropertiesLayoutSection({super.key, required this.nodes});

  final Set<SceneNode> nodes;

  @override
  Widget build(BuildContext context) {
    final nodes = useNodeList(this.nodes, aspect: .size);
    final node = nodes.first;

    late final ObjectLayoutDimension width, height;
    if (node is SceneObject) {
      width = node.size.width;
      height = node.size.height;
    } else {
      width = .fixed(node.bbox.width);
      height = .fixed(node.bbox.height);
    }

    void apply({ObjectLayoutDimension? width, ObjectLayoutDimension? height}) {
      if (node is SceneObject) {
        node.size = node.size.copyWith(
          width: width ?? node.size.width,
          height: height ?? node.size.height,
        );
      }
    }

    void applyChildLayout(ContainerChildLayout layout) {
      if (node is ContainerObject) {
        node.childLayout = layout;
      }
    }

    return PropertiesSection(
      title: Text('Layout'),
      children: [
        Row(
          children: [
            Expanded(
              child: _ObjectLayoutDimension(
                dimension: width,
                onChanged: (v) => apply(width: v),
                isWidth: true,
              ),
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: _ObjectLayoutDimension(
                dimension: height,
                onChanged: (v) => apply(height: v),
                isWidth: false,
              ),
            ),
          ],
        ),

        if (node is ContainerObject)
          ToggleableButtonRow(
            children: [
              ToggleableButton(
                onChanged: (v) => v ? applyChildLayout(.stack) : null,
                isActive: node.childLayout.type == .stack,
                child: Icons.layoutStack(),
              ),
              ToggleableButton(
                onChanged: (v) => v ? applyChildLayout(.flex(direction: .row)) : null,
                isActive:
                    node.childLayout.type == .flex && (node.childLayout as FlexContainerChildLayout).direction == .row,
                child: Icons.layoutRow(),
              ),
              ToggleableButton(
                onChanged: (v) => v ? applyChildLayout(.flex(direction: .column)) : null,
                isActive:
                    node.childLayout.type == .flex && (node.childLayout as FlexContainerChildLayout).direction == .column,
                child: Icons.layoutColumn(),
              ),
            ],
          ),
      ],
    );
  }
}

class _ObjectLayoutDimension extends StatelessWidget {
  const _ObjectLayoutDimension({
    super.key,
    required this.dimension,
    required this.isWidth,
    this.onChanged,
  });

  final bool isWidth;
  final ObjectLayoutDimension dimension;
  final ValueChanged<ObjectLayoutDimension>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DoubleExpressionInputField(
      value: dimension.value,
      onChanged: (v) => onChanged?.call(dimension.copyWith(value: v, type: .fixed)),
      options: .new(
        leading: isWidth ? Icons.w() : Icons.h(),
        builder: (context, child) {
          return Column(
            children: [
              child,
              Divider(),
              ToggleableButtonRow(
                isFilled: false,
                height: 28.0,
                children: [
                  ToggleableButton(
                    isActive: dimension.type == .fixed,
                    onChanged: (v) => onChanged?.call(dimension.copyWith(type: .fixed)),
                    iconSize: 16.0,
                    child: Icons.layoutSizeFixed(),
                  ),
                  ToggleableButton(
                    isActive: dimension.type == .contain,
                    onChanged: (v) => onChanged?.call(dimension.copyWith(type: .contain)),
                    iconSize: 16.0,
                    child: Icons.layoutSizeContain(),
                  ),
                  ToggleableButton(
                    isActive: dimension.type == .expand,
                    onChanged: (v) => onChanged?.call(dimension.copyWith(type: .expand)),
                    iconSize: 16.0,
                    child: Icons.layoutSizeExpand(),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
