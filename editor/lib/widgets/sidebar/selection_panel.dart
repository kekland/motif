import 'package:editor/imports.dart';

class SelectionPanel extends HookWidget {
  const SelectionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final selection = useListenable(context.selection);
    return Column(
      children: [
        Subtitle(
          child: Text('Selection'),
        ),
        Divider(),
        Text(selection.nodes.toString()),
      ],
    );
  }
}
