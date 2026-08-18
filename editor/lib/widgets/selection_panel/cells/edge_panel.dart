import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_panel/properties/edge_style_property.dart';
import 'package:editor/widgets/selection_panel/widgets.dart';

class const EdgePanel({
  super.key,
  required final EdgeKey cellKey,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ref = context.editor.refOf(cellKey)!;
    final decoration = context.editor.decorationOf<EdgeStyle>(ref);

    return Column(
      children: [
        Header(
          leading: Icons.edge(),
          title: Text('Edge'),
          footnote: Text(cellKey.id.toString()),
        ),
        Divider(),
        PropertiesBody(
          children: [
            PropertiesSection(
              title: Text('Stroke'),
              children: [
                EdgeStyleProperty(
                  value: decoration,
                  onChanged: (v) {},
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
