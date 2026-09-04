import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_panel/props/prop.dart';

class const CellPanel({
  super.key,
  required final List<Ref> refs,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final rawProps = <List<PropSource>>[];
    for (final ref in refs) {
      final kind = editor.handleOf(ref)?.kind;
      final props = switch (kind) {
        .vertex => vertexProps(editor.scene, ref.cast()),
        .edge => edgeProps(editor.scene, ref.cast()),
        .face => faceProps(editor.scene, ref.cast()),
        .frame => frameProps(editor.scene, ref.cast()),
        _ => const <PropSource>[],
      };

      rawProps.add(props);
    }

    final props = Prop.union(rawProps);

    late final Widget? icon, title, footnote;
    if (refs.length == 1) {
      final ref = refs.single;
      final key = editor.keyOf(ref);
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

      footnote = Text(key.id.value);
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
