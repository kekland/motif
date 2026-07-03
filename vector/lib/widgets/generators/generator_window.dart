import 'package:vector/imports.dart';
import 'package:blueprint/widgets.dart';
import 'package:vector/widgets/generators/blueprint_add_node_window.dart';

class GeneratorWindow extends HookWidget {
  const GeneratorWindow({
    super.key,
    required this.generator,
  });

  final Generator generator;

  static WindowEntry createEntry(BuildContext context, {required Generator generator}) => .withContextAnchor(
    context,
    builder: (_) => GeneratorWindow(generator: generator),
  );

  @override
  Widget build(BuildContext context) {
    final controller = useDisposable(() => GeneratorBlueprintController(generator));

    return WindowScaffold(
      leading: Icons.generator(),
      title: Text('Generator ${generator.id}'),
      child: Column(
        children: [
          Surface(
            width: 600.0,
            height: 400.0,
            color: context.colors.surface.tertiary,
            child: BlueprintEditor(
              controller: controller,
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
                        controller.addNode(node);
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
