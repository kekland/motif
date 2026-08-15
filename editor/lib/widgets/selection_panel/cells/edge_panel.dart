import 'package:editor/imports.dart';

class const EdgePanel({
  super.key,
  required final EdgeKey cellKey,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          leading: Icons.edge(),
          title: Text('Edge'),
          footnote: Text(cellKey.id.toString()),
        ),
      ],
    );
  }
}
