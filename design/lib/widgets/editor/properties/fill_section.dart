part of '../properties_panel.dart';

class FillSection extends HookWidget {
  const FillSection({super.key, required this.selectedNode});

  final NodeWithFill selectedNode;

  @override
  Widget build(BuildContext context) {
    final isMutable = selectedNode is MutableNode;
    final fill = useComputedValue(() => selectedNode.fill);

    void apply(NodeFillData newFill) {
      (selectedNode as MutableNodeWithFill).fill = newFill;
    }

    return SectionTemplateWidget(
      title: Text('fill'),
      body: [
        ColorInputField(
          value: fill.color,
          onChanged: isMutable ? (c) => apply(fill.copyWith(color: c)) : null,
        ),
      ],
    );
  }
}
