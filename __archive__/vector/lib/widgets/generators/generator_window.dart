import '../../imports.dart';
import 'package:blueprint/widgets.dart';
import 'blueprint_add_node_window.dart';

class GeneratorWindow extends HookWidget {
  const GeneratorWindow({
    super.key,
    required this.controller,
    required this.generator,
  });

  final VectorController controller;
  final Generator generator;

  static WindowEntry createEntry(
    BuildContext context, {
    required VectorController controller,
    required Generator generator,
  }) => .withContextAnchor(
    context,
    builder: (_) => GeneratorWindow(
      controller: controller,
      generator: generator,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return WindowScaffold(
      leading: Icons.generator(),
      title: Text('Generator ${generator.id}'),
      child: Column(
        children: [
          Surface(
            width: 600.0,
            height: 400.0,
            color: context.colors.surface.tertiary,
            child: GeneratorEditor(
              generator: generator,
              vectorComplexContext: controller.complex.context,
            ),
          ),
          Divider(),
          Surface(
            height: 48.0,
            child: Row(
              children: [
                Builder(
                  builder: (context) {
                    return ToolbarButton(
                      onTap: () async {
                        final node = await WindowNavigator.pushUnique(
                          context,
                          BlueprintAddNodeWindow.createEntry(context),
                        );

                        if (node == null) return;
                        generator.addNode(node);
                      },
                      child: Icons.add(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
