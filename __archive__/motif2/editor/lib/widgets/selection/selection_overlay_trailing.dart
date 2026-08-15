part of 'selection_overlay.dart';

class SelectionOverlayTrailing extends StatelessWidget {
  const SelectionOverlayTrailing({
    super.key,
    required this.nodes,
    required this.editor,
  });

  final Editor editor;
  final List<SceneNode> nodes;

  @override
  Widget build(BuildContext context) {
    final glueVertices = Button(
      onTap: () {
        final v = editor.scene.topology.glueVertices(nodes.cast<Vertex>());
        editor.selection.set(v);
      },
      leading: Icons.glue(),
      child: Text('Glue'),
    );

    return Row(
      children: [
        if (nodes.length > 1 && nodes.every((n) => n is Vertex)) glueVertices,
      ],
    );
  }
}
