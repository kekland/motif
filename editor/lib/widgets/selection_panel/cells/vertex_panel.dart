import 'package:editor/imports.dart';

class const VertexPanel({
  super.key,
  required final VertexKey cellKey,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          leading: Icons.vertex(),
          title: Text('Vertex'),
          footnote: Text(cellKey.id.toString()),
        ),
      ],
    );
  }
}
