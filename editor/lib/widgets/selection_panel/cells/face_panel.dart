import 'package:editor/imports.dart';

class const FacePanel({
  super.key,
  required final FaceKey cellKey,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          leading: Icons.face(),
          title: Text('Face'),
          footnote: Text(cellKey.id.toString()),
        ),
      ],
    );
  }
}
