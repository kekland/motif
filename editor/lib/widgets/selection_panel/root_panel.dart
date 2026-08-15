import 'package:editor/imports.dart';

class RootSelectionPanel extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          leading: Icons.frame(),
          title: Text('Document'),
        ),
        Divider(),
      ],
    );
  }
}
