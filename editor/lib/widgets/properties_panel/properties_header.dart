part of 'properties_panel.dart';

class PropertiesHeaderSection extends HookWidget {
  const PropertiesHeaderSection({
    super.key,
    required this.nodes,
  });

  final Set<SceneNode> nodes;

  @override
  Widget build(BuildContext context) {
    final nodes = useNodeList(this.nodes, aspect: .name);
    
    late final String title;
    late final String name;
    late final Widget icon;

    if (nodes.length == 1) {
      final node = nodes.single;
      name = node.name;
      (title, icon) = switch (node) {
        RectangleObject _ => ('Rectangle', Icons.square()),
        ContainerObject _ => ('Container', Icons.layoutStack()),
        RootObject _ => ('Root', Icons.world()),
        Vertex _ => ('Vertex', Icons.vertex()),
        Edge _ => ('Edge', Icons.edge()),
        _ => ('Object', Icons.polygon()),
      };
    } else {
      title = '${nodes.length} objects';
      name = nodes.map((e) => e.name).join(', ');
      icon = Icons.stacks();
    }

    return PropertiesSection(
      key: ValueKey(nodes),
      title: Text(title),
      children: [
        TextFormField(
          options: .new(leading: icon),
          initialValue: name,
          onChanged: nodes.length == 1 ? (v) => nodes.single.name = v : null,
        ),
      ],
    );
  }
}
