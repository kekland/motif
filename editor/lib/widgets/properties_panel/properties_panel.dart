import 'package:editor/imports.dart';

part 'properties_header.dart';
part 'properties_layout.dart';
part 'properties_transform.dart';

class PropertiesPanel extends HookWidget {
  const PropertiesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = Editor.watch(context);
    final selection = useListenable(context.selection);
    final nodes = selection.nodes.isNotEmpty ? selection.nodes : {editor.scene.root};

    return Column(
      children: [
        PropertiesHeaderSection(nodes: nodes),
        Divider(),
        PropertiesTransformSection(nodes: nodes),
        Divider(),
        PropertiesLayoutSection(nodes: nodes),
      ],
    );
  }
}

class PropertiesSection extends StatelessWidget {
  const PropertiesSection({super.key, required this.children, required this.title});

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
            textStyle: context.typography.body,
            child: title,
          ),
          ...children,
        ],
      ),
    );
  }
}
