import 'package:editor/imports.dart';
import 'package:flutter/widgets.dart';

class PropertiesBody extends StatelessWidget {
  const new({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.interleave(Divider()).toList(),
    );
  }
}

class PropertiesSection extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.children,
  });

  final Widget title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 8.0,
        children: [
          DefaultForegroundStyle(
            style: context.typography.body.secondary,
            child: title,
          ),
          ...children,
        ],
      ),
    );
  }
}
