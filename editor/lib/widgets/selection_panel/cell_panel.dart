import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_panel/props/prop.dart';

class const CellPanel({
  super.key,
  required final List<CellRef> refs,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final rawProps = <List<PropSource>>[];
    for (final ref in refs) {
      final kind = editor.handleOf(ref)?.kind;
      final props = switch (kind) {
        .frame => frameProps(editor.scene, ref.asFrame),
        .vertex => vertexProps(editor.scene, ref.asVertex),
        .edge => edgeProps(editor.scene, ref.asEdge),
        .face => faceProps(editor.scene, ref.asFace),
        _ => const <PropSource>[],
      };

      rawProps.add(props);
    }

    final props = Prop.union(rawProps);

    late final Widget? icon, title, footnote;
    if (refs.length == 1) {
      final ref = refs.single;
      final kind = ref.kind;

      icon = switch (kind) {
        .frame => Icons.frame(),
        .vertex => Icons.vertex(),
        .edge => Icons.edge(),
        .face => Icons.face(),
      };

      title = switch (kind) {
        .frame => Text('Frame'),
        .vertex => Text('Vertex'),
        .edge => Text('Edge'),
        .face => Text('Face'),
      };

      footnote = Text(ref.id.toString());
    } else {
      icon = Icons.stacks();
      title = Text('${refs.length} cells');
      footnote = null;
    }

    return Column(
      children: [
        Header(
          leading: icon,
          title: title,
          footnote: footnote,
        ),
        Divider(),
        PropListBuilder(
          scene: editor.scene,
          props: props,
        ),
      ],
    );
  }
}
