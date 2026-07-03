part of '../properties_panel.dart';

class AddModifierWindow extends StatelessWidget {
  const AddModifierWindow({
    super.key,
    required this.controller,
  });

  final VectorController controller;

  static WindowEntry<Modifier> createEntry(BuildContext context, {required VectorController controller}) =>
      .withContextAnchor(
        context,
        builder: (_) => AddModifierWindow(controller: controller),
        isModal: true,
      );

  @override
  Widget build(BuildContext context) {
    return WindowScaffold(
      title: Text('Add modifier'),
      child: SizedBox(
        width: 200.0,
        height: 400.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Tile(
              onTap: () => Navigator.pop(context, GeneratorModifier(generatorId: null)),
              leading: Icons.generator(),
              title: Text('Generator'),
            ),
            Divider(),
            Tile(
              onTap: () => Navigator.pop(context, SimplifyEdgeModifier()),
              leading: Icons.squiggly(),
              title: Text('Simplify'),
            ),
            Divider(),
            Tile(
              onTap: () => Navigator.pop(context, MirrorModifier()),
              leading: Icons.mirror(),
              title: Text('Mirror'),
            ),
          ],
        ),
      ),
    );
  }
}
