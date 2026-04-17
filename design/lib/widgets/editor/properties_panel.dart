import 'package:design/imports.dart';
import 'package:vector_math/vector_math_64.dart';

final xd = GlobalKey();

class PropertiesPanel extends HookWidget {
  const PropertiesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DesignController.of(context);
    final selectionController = controller.selection;
    final selectedNodes = useComputedValue(() => [...selectionController.selectedNodes]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          key: ValueKey(selectedNodes),
          child: ListView(
            children: [
              if (selectedNodes.length == 1) ...[
                InfoSection(selectedNode: selectedNodes.first),
                Divider(height: 1.0),
                TransformSection(selectedNode: selectedNodes.first),
                Divider(height: 1.0),
                LayoutSection(selectedNode: selectedNodes.first),
                if (selectedNodes.first is NodeWithFill) ...[
                  Divider(height: 1.0),
                  FillSection(selectedNode: selectedNodes.first as NodeWithFill),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

Widget _wrapIcon(Widget icon) => Transform.translate(
  offset: Offset(0.0, 1.0),
  child: icon,
);

class InfoSection extends StatelessWidget {
  const InfoSection({super.key, required this.selectedNode});

  final Node selectedNode;

  @override
  Widget build(BuildContext context) {
    final nodeType = switch (selectedNode) {
      RootNode() => 'root',
      ContainerNode() => 'container',
      _ => 'unknown',
    };

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(nodeType, style: context.typography.caption3.tertiary),
          const SizedBox(height: 8.0),
          TextFormField(
            // leading: selectedNode.icon,
            initialValue: selectedNode.name,
            onChanged: selectedNode is MutableNode ? (v) => (selectedNode as MutableNode).name = v! : null,
          ),
        ],
      ),
    );
  }
}

class TransformSection extends HookWidget {
  const TransformSection({
    super.key,
    required this.selectedNode,
  });

  final Node selectedNode;

  @override
  Widget build(BuildContext context) {
    final controller = DesignController.of(context);
    final renderNode = controller.renderRootNode.getRenderNode(selectedNode)!;
    final parentRenderNode = renderNode.parentNode;
    final isTranslationIgnored = selectedNode.parent?.layout.childLayout.isTranslationIgnored ?? false;

    final isMutable = selectedNode is MutableNode;
    final transform = useComputedValue(() => selectedNode.transform);
    final layout = useComputedValue(() => selectedNode.layout);
    final translation = transform.translation;
    final rotation = transform.rotation;

    void apply(NodeTransformData newTransform) {
      (selectedNode as MutableNode).transform = newTransform;
    }

    final renderTransform = renderNode.getLayoutTransformTo(parentRenderNode);
    final offset = renderTransform.getTranslation().xy;

    Offset getCenterPivot() {
      final size = renderNode.size;
      final center = size.center(Offset.zero);
      final parentCenter = MatrixUtils.transformPoint(renderTransform, center);
      return parentCenter;
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text('transform', style: context.typography.caption3.tertiary),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: DoubleExpressionInputField(
                  value: offset.x,
                  onChanged: isMutable
                      ? (v) => apply(transform.copyWithTranslation(translation.copyWith(dx: v)))
                      : null,
                  options: .new(
                    leading: _wrapIcon(Icons.x()),
                    textStyle: isTranslationIgnored ? context.typography.caption1.tertiary : null,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: DoubleExpressionInputField(
                  value: offset.y,
                  onChanged: isMutable
                      ? (v) => apply(transform.copyWithTranslation(translation.copyWith(dy: v)))
                      : null,
                  options: .new(
                    leading: _wrapIcon(Icons.y()),
                    textStyle: isTranslationIgnored ? context.typography.caption1.tertiary : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DoubleExpressionInputField(
                  value: rotation * radians2Degrees,
                  onChanged: isMutable
                      ? (v) => apply(transform.copyWithRotation(v * degrees2Radians, anchor: getCenterPivot()))
                      : null,
                  options: .new(
                    leading: _wrapIcon(Icons.angle()),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              GestureSurface(
                color: context.colors.surface.secondary,
                borderRadius: BorderRadius.circular(4.0),
                width: 32.0,
                height: 32.0,
                onTap: isMutable ? () => apply(transform.rotatedCw(anchor: getCenterPivot())) : null,
                child: Center(child: Icons.rotateCw(size: 16.0)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LayoutSection extends HookWidget {
  const LayoutSection({super.key, required this.selectedNode});

  final Node selectedNode;

  @override
  Widget build(BuildContext context) {
    final controller = DesignController.of(context);
    final renderNode = controller.renderRootNode.getRenderNode(selectedNode)!;
    final isMutable = selectedNode is MutableNode;
    final layout = useComputedValue(() => selectedNode.layout);

    return DeferredLayoutBuilder(
      targets: [renderNode],
      builder: (context, constraints) {
        final size = layout.size;
        final width = size.width;
        final height = size.height;

        final childLayout = layout.childLayout;

        void apply({NodeLayoutSize? size, NodeChildLayout? childLayout}) {
          (selectedNode as MutableNode).layout = layout.copyWith(size: size, childLayout: childLayout);
        }

        void applySize({NodeLayoutDimension? width, NodeLayoutDimension? height}) {
          final size = layout.size.copyWith(width: width, height: height);
          apply(size: size);
        }

        final widthValue = renderNode.size.width;
        final heightValue = renderNode.size.height;
        final isWidthOverridden = width.type != .fixed;
        final isHeightOverridden = height.type != .fixed;

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text('layout', style: context.typography.caption3.tertiary),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: DoubleExpressionInputField(
                      value: widthValue,
                      onChanged: isMutable ? (v) => applySize(width: .fixed(v)) : null,
                      options: .new(
                        leading: _wrapIcon(Icons.w()),
                        textStyle: isWidthOverridden ? context.typography.caption1.tertiary : null,
                        padding: .zero,
                        builder: (context, child) => Column(
                          children: [
                            Padding(
                              padding: .symmetric(horizontal: 6.0),
                              child: child,
                            ),
                            Divider(),
                            ToggleableButtonRow(
                              borderRadius: .vertical(bottom: .circular(4.0)),
                              height: 28.0,
                              children: [
                                ToggleableButton(
                                  isActive: width.type == .fixed,
                                  onChanged: (v) => applySize(width: width.copyWith(type: .fixed)),
                                  iconSize: 16.0,
                                  child: width.type == .fixed ? Icons.layoutSizeFixed() : Icons.layoutSizeNonFixed(),
                                ),
                                ToggleableButton(
                                  isActive: width.type == .contain,
                                  onChanged: (v) => applySize(width: width.copyWith(type: .contain)),
                                  iconSize: 16.0,
                                  child: RotatedBox(quarterTurns: 1, child: Icons.layoutSizeContain()),
                                ),
                                ToggleableButton(
                                  isActive: width.type == .expand,
                                  onChanged: (v) => applySize(width: width.copyWith(type: .expand)),
                                  iconSize: 16.0,
                                  child: RotatedBox(quarterTurns: 1, child: Icons.layoutSizeExpand()),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: DoubleExpressionInputField(
                      value: heightValue,
                      onChanged: isMutable ? (v) => applySize(height: .fixed(v)) : null,
                      options: .new(
                        leading: _wrapIcon(Icons.h()),
                        textStyle: isWidthOverridden ? context.typography.caption1.tertiary : null,
                        padding: .zero,
                        builder: (context, child) => Column(
                          children: [
                            Padding(
                              padding: .symmetric(horizontal: 6.0),
                              child: child,
                            ),
                            Divider(),
                            ToggleableButtonRow(
                              borderRadius: .vertical(bottom: .circular(4.0)),
                              height: 28.0,
                              children: [
                                ToggleableButton(
                                  isActive: height.type == .fixed,
                                  onChanged: (v) => applySize(height: height.copyWith(type: .fixed)),
                                  iconSize: 16.0,
                                  child: height.type == .fixed ? Icons.layoutSizeFixed() : Icons.layoutSizeNonFixed(),
                                ),
                                ToggleableButton(
                                  isActive: height.type == .contain,
                                  onChanged: (v) => applySize(height: height.copyWith(type: .contain)),
                                  iconSize: 16.0,
                                  child: Icons.layoutSizeContain(),
                                ),
                                ToggleableButton(
                                  isActive: height.type == .expand,
                                  onChanged: (v) => applySize(height: height.copyWith(type: .expand)),
                                  iconSize: 16.0,
                                  child: Icons.layoutSizeExpand(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              ToggleableButtonRow(
                children: [
                  ToggleableButton(
                    isActive: childLayout is StackNodeChildLayout,
                    onChanged: (v) => apply(childLayout: .stack),
                    child: Icons.layoutStack(),
                  ),
                  ToggleableButton(
                    isActive: childLayout is FlexNodeChildLayout && childLayout.direction == .row,
                    onChanged: (v) => apply(childLayout: .flex(direction: .row)),
                    child: Icons.layoutRow(),
                  ),
                  ToggleableButton(
                    isActive: childLayout is FlexNodeChildLayout && childLayout.direction == .column,
                    onChanged: (v) => apply(childLayout: .flex(direction: .column)),
                    child: Icons.layoutColumn(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class FillSection extends HookWidget {
  const FillSection({super.key, required this.selectedNode});

  final NodeWithFill selectedNode;

  @override
  Widget build(BuildContext context) {
    // final isMutable = selectedNode is MutableNode;
    // final fill = useComputedValue(() => selectedNode.fill);

    // void apply(NodeFillData newFill) {
    //   (selectedNode as MutableNodeWithFill).fill = newFill;
    // }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text('fill', style: context.typography.caption3.tertiary),
          const SizedBox(height: 8.0),
          // ColorInputField(
          //   value: fill.color,
          //   valueListenable: useComputed(() => selectedNode.fill.color),
          //   onChanged: isMutable ? (c) => apply(fill.copyWith(color: c)) : null,
          // ),
        ],
      ),
    );
  }
}
