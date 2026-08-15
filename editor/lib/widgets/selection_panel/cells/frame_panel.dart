import 'package:editor/imports.dart';

class const FramePanel({
  super.key,
  required final FrameKey cellKey,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          leading: Icons.frame(),
          title: Text('Frame'),
          footnote: Text(cellKey.id.toString()),
        ),
      ],
    );
  }
}
