import 'package:blueprint/blueprint.dart';
import 'package:canvas/canvas.dart';
import 'package:flutter/foundation.dart';
import 'package:ui/ui.dart';

abstract class BlueprintSocketValueBuilder<T> {
  const BlueprintSocketValueBuilder();

  Widget build(
    BuildContext context,
    InputSocket<T> socket,
    T? value,
    void Function(T value)? onChanged,
  );

  Type get type => T;
}

class BlueprintSocketValueBuilders {
  BlueprintSocketValueBuilders(this.builders);

  final List<BlueprintSocketValueBuilder> builders;

  BlueprintSocketValueBuilder<T>? builderFor<T>(Type type) {
    for (final builder in builders) {
      if (builder.type == type) return builder as BlueprintSocketValueBuilder<T>;
    }
    return null;
  }
}

class BlueprintEditor<B extends Blueprint> extends HookWidget {
  const BlueprintEditor({
    super.key,
    required this.controller,
    this.socketValueBuilders = const [],
  });

  final BlueprintController<B> controller;
  final List<BlueprintSocketValueBuilder> socketValueBuilders;

  @override
  Widget build(BuildContext context) {
    final controller = useListenable(this.controller);
    final builders = useMemoized(() => BlueprintSocketValueBuilders(socketValueBuilders), [...socketValueBuilders]);

    final children = <Widget>[];

    for (final node in controller.nodes) {
      children.add(NodeWidget(node: node));
    }

    return Provider.value(
      value: builders,
      child: ChangeNotifierProvider<BlueprintController>.value(
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
      ),
    );
  }
}
