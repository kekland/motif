part of '../properties_panel.dart';

class _EdgeProperties extends HookWidget {
  const _EdgeProperties({super.key, required this.edge});

  final Edge edge;

  @override
  Widget build(BuildContext context) {
    useStream(edge.updateStream);

    return Column(
      children: [
        SectionTemplateWidget(
          title: Text('color'),
          body: [
            ColorInputField(
              value: edge.color,
              onChanged: (v) => edge.color = v,
            ),
          ],
        ),
        SectionTemplateWidget(
          title: Text('width'),
          body: [
            Slider(
              value: edge.strokeWidth,
              onChanged: (v) => edge.strokeWidth = v,
              min: .1,
              max: 20,
            ),
          ],
        ),
      ],
    );
  }
}
