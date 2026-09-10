part of '../editor.dart';

abstract class BlueprintSocketValueBuilder<T> {
  const BlueprintSocketValueBuilder();

  Widget build(
    BuildContext context,
    InputSocket<T> socket,
    ReadonlySignal<Object?> value,
    ValueChanged<T>? onChanged,
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

class BlueprintColorResolvers {
  BlueprintColorResolvers(this.resolve);
  BlueprintColorResolvers.empty() : resolve = ((_) => null);

  final Color? Function(Symbol type) resolve;
}

class BlueprintEditorWidget<B extends Blueprint<B>> extends HookWidget {
  const BlueprintEditorWidget({
    super.key,
    required this.editor,
    this.socketValueBuilders = const [],
    this.colorResolvers,
  });

  final BlueprintEditor<B> editor;
  final List<BlueprintSocketValueBuilder> socketValueBuilders;
  final BlueprintColorResolvers? colorResolvers;

  @override
  Widget build(BuildContext context) {
    final editor = useListenable(this.editor);
    final builders = useMemoized(() => BlueprintSocketValueBuilders(socketValueBuilders), [...socketValueBuilders]);
    final colorResolvers = useMemoized(() => this.colorResolvers ?? .empty(), [this.colorResolvers]);

    final children = <Widget>[];

    for (final node in editor.nodes) {
      children.add(NodeWidget(editor: editor, id: node.id));
    }

    return Provider.value(
      value: builders,
      child: Provider.value(
        value: colorResolvers,
        child: ChangeNotifierProvider<BlueprintEditor>.value(
          value: editor,
          child: Surface(
            color: context.colors.surface.tertiary,
            child: InteractiveCanvas(
              child: ConnectionsWidget(
                key: editor.renderKey,
                editor: editor,
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
      ),
    );
  }
}
