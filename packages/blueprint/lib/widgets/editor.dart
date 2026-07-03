import 'package:blueprint/blueprint.dart';
import 'package:canvas/canvas.dart';
import 'package:ui/ui.dart';

class BlueprintEditor<B extends Blueprint> extends HookWidget {
  const BlueprintEditor({
    super.key,
    required this.controller,
  });

  final BlueprintController<B> controller;

  @override
  Widget build(BuildContext context) {
    final controller = useListenable(this.controller);

    final children = <Widget>[];

    for (final node in controller.nodes) {
      children.add(NodeWidget(node: node));
    }

    return ChangeNotifierProvider<BlueprintController>.value(
      value: controller,
      child: Surface(
        color: context.colors.surface.tertiary,
        child: InteractiveCanvas(
          child: ConnectionsWidget(
            key: controller.renderKey,
            controller: controller,
            child: OverflowHitTestableStack(
              clipBehavior: .none,
              children: [
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
