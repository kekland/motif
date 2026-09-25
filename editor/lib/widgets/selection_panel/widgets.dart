import 'package:editor/imports.dart';

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
    required this.child,
  });

  final Widget title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 8.0,
        children: [
          DefaultForegroundStyle(
            style: context.typography.caption.secondary,
            child: title,
          ),
          child,
        ],
      ),
    );
  }
}
