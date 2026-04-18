part of '../properties_panel.dart';

class SectionTemplateWidget extends StatelessWidget {
  const SectionTemplateWidget({
    super.key,
    required this.title,
    required this.body,
  });

  final Widget title;
  final List<Widget> body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        spacing: 8.0,
        crossAxisAlignment: .start,
        children: [
          DefaultForegroundStyle(
            textStyle: context.typography.caption3.tertiary,
            child: title,
          ),
          ...body,
        ],
      ),
    );
  }
}
