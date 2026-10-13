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

class BlueprintNodeFactory {
  BlueprintNodeFactory({
    required this.name,
    required this.create,
  });

  final String name;
  final Node Function() create;
}

class BlueprintEditorWidget<B extends Blueprint<B>> extends HookWidget {
  const BlueprintEditorWidget({
    super.key,
    required this.editor,
    this.socketValueBuilders = const [],
    this.colorResolvers,
    this.nodeFactories = const {},
  });

  final BlueprintEditor<B> editor;
  final List<BlueprintSocketValueBuilder> socketValueBuilders;
  final BlueprintColorResolvers? colorResolvers;
  final Map<String, List<BlueprintNodeFactory>> nodeFactories;

  @override
  Widget build(BuildContext context) {
    final editor = useListenable(this.editor);
    final builders = useMemoized(() => BlueprintSocketValueBuilders(socketValueBuilders), [...socketValueBuilders]);
    final colorResolvers = useMemoized(() => this.colorResolvers ?? .empty(), [this.colorResolvers]);

    final child = EditorActions(
      child: EditorShortcuts(
        child: EditorCanvas(),
      ),
    );

    return Provider.value(
      value: builders,
      child: Provider.value(
        value: colorResolvers,
        child: ChangeNotifierProvider<BlueprintEditor>.value(
          value: editor,
          child: Surface(
            clipBehavior: .hardEdge,
            child: BlueprintContextMenuWidget(
              onAddNode: (position, node) => editor.add(node, position: position),
              onDeleteNode: (node) => editor.remove(node.id),
              nodeFactories: nodeFactories,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class BlueprintContextMenuWidget extends StatelessWidget {
  const BlueprintContextMenuWidget({
    super.key,
    required this.child,
    required this.onAddNode,
    required this.onDeleteNode,
    this.nodeFactories = const {},
  });

  final Widget child;
  final void Function(Vec2, Node) onAddNode;
  final void Function(Node) onDeleteNode;
  final Map<String, List<BlueprintNodeFactory>> nodeFactories;
  // final void Function(Connection) onDeleteConnection;

  @override
  Widget build(BuildContext context) {
    final editor = BlueprintEditor.of(context);

    return GestureDetector(
      behavior: .opaque,
      onSecondaryTapDown: (details) async {
        final nodeEntries = editor.hitTestNodes(details.globalPosition);
        var node = nodeEntries.lastOrNull?.node;
        if (node != null && editor.isFixed(node.id)) {
          node = null;
        }

        final entries = <ContextMenuEntry>[];
        for (final category in nodeFactories.keys) {
          final categoryEntries = nodeFactories[category]!;
          entries.add(
            .submenu(
              entries: categoryEntries.map((f) => ContextMenuItem(f, label: f.name)).toList(),
              label: category,
            ),
          );
        }

        final result = await ContextMenu.push(
          context,
          .new(
            [
              ...entries,
              if (node != null) ...[
                .divider,
                .item(#delete, label: 'Delete'),
              ],
            ],
          ),
          details: details,
        );

        if (result != null && context.mounted) {
          if (result == #delete) {
            onDeleteNode(node!);
          } else if (result is BlueprintNodeFactory) {
            final position = editor.globalToLocal(details.globalPosition);
            onAddNode(position.vec2, result.create());
          }
        }
      },
      child: child,
    );
  }
}
