part of '../editor.dart';

class NodeWidget extends HookWidget {
  const NodeWidget({
    super.key,
    required this.editor,
    required this.id,
  });

  final BlueprintEditor editor;
  final NodeId id;

  @override
  Widget build(BuildContext context) {
    final node = useExistingSignal(editor.node(id)).value;
    final isSelected = useListenable(editor.selection).isNodeSelected(id);
    final color = context.watch<BlueprintColorResolvers>();
    final enums = context.watch<BlueprintEnums>();

    Widget child = GestureSurface(
      onTap: () => context.invoke(intents.selectNode(id)),
      width: 200.0,
      color: context.colors.surface.primary,
      clipBehavior: .none,
      shadows: context.shadows.small,
      borderRadius: .circular(4.0),
      child: Column(
        mainAxisSize: .min,
        children: [
          SizedBox(
            width: .infinity,
            height: 24.0,
            child: Surface(
              color: color.resolve(node.category) ?? context.colors.surface.secondary,
              borderRadius: .vertical(top: .circular(4.0)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    node.name,
                    style: context.typography.body,
                  ),
                ),
              ),
            ),
          ),
          Divider(),
          const SizedBox(height: 4.0),
          for (final (i, p) in node.properties.indexed)
            ?switch (p) {
              ListInputSocket s => NodeListInputSocketWidget(editor: editor, socket: s),
              InputSocket s => NodeInputSocketWidget(editor: editor, socket: s),
              Enum e => NodeEnumWidget(
                editor: editor,
                enums: enums,
                value: e,
                onChanged: (e) => editor.replace(node.copyWithProperty(i, e)),
              ),
              _ => null,
            },
          for (final output in node.outputs) NodeOutputSocketWidget(socket: output),
          const SizedBox(height: 4.0),
        ],
      ),
    );

    child = DecoratedBox(
      decoration: BoxDecoration(
        border: .all(
          color: isSelected ? context.colors.accent.primary : context.colors.divider,
          width: isSelected ? 2.0 : 1.0,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: .circular(4.0),
      ),
      child: child,
    );

    child = _NodeWidget(
      node: node,
      child: child,
    );

    final position = editor.positionOf(id);

    return Positioned(
      left: position.x,
      top: position.y,
      child: child,
    );
  }
}

class NodeInputSocketWidget extends HookWidget {
  const NodeInputSocketWidget({
    super.key,
    required this.editor,
    required this.socket,
  });

  final BlueprintEditor editor;
  final InputSocket socket;

  @override
  Widget build(BuildContext context) {
    final signal = editor.socket<InputSocket>(this.socket.ref);
    final socket = useExistingSignal(signal).value;
    final isConnected = editor.isConnected(socket);

    final valueBuilders = context.watch<BlueprintSocketValueBuilders>();
    final valueBuilder = valueBuilders.builderFor(socket.type);
    final value = useComputed<Object?>(() => signal().inlineValue);

    late final Widget? trailing;
    final isInline = valueBuilder?.isInline ?? false;

    if (!isConnected && valueBuilder != null) {
      trailing = valueBuilder.build(
        context,
        socket,
        value,
        (v) => editor.replace(socket.node.copyWithProperty(socket.index, v)),
      );
    } else {
      trailing = null;
    }

    return Column(
      children: [
        SizedBox(
          height: 24.0,
          child: Row(
            children: [
              BaseSocketWidget(socket: socket, index: 0, dx: -1.0),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  socket.name,
                  style: context.typography.body.secondary,
                ),
              ),
              if (isInline) ...[
                const SizedBox(width: 12.0),
                ?trailing,
                const SizedBox(width: 4.0),
              ],
            ],
          ),
        ),
        if (trailing != null && !isInline) ...[
          const SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: trailing,
          ),
          const SizedBox(height: 8.0),
        ],
      ],
    );
  }
}

final class const NodeListInputSocketWidget({
  super.key,
  required final BlueprintEditor editor,
  required final ListInputSocket socket,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final signal = editor.socket<InputSocket>(this.socket.ref);
    final socket = useExistingSignal(signal).value;
    final connections = editor.socketConnections(socket.ref);
    final maxIndex = connections.isEmpty ? -1 : connections.map((c) => c.index).reduce(max);

    return Column(
      children: [
        for (var i = 0; i <= maxIndex + 1; i++) ...[
          SizedBox(
            height: 24.0,
            child: Row(
              children: [
                BaseSocketWidget(
                  key: ValueKey(i),
                  socket: socket,
                  index: i,
                  dx: -1.0,
                ),
                const SizedBox(width: 12.0),
                Text(
                  socket.name,
                  style: context.typography.body.secondary,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class NodeOutputSocketWidget extends StatelessWidget {
  const NodeOutputSocketWidget({super.key, required this.socket});

  final OutputSocket socket;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.0,
      child: Row(
        mainAxisAlignment: .end,
        children: [
          Text(
            socket.name,
            style: context.typography.body.secondary,
          ),
          const SizedBox(width: 12.0),
          BaseSocketWidget(socket: socket, index: 0, dx: 1.0),
        ],
      ),
    );
  }
}

class _NodeWidget extends SingleChildRenderObjectWidget {
  const _NodeWidget({
    super.key,
    required this.node,
    super.child,
  });

  final Node node;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderNode(node: node);
  }

  @override
  void updateRenderObject(BuildContext context, RenderNode renderObject) {
    renderObject.node = node;
  }
}

class RenderNode extends RenderProxyBox {
  RenderNode({required this._node});

  Node _node;
  Node get node => _node;
  set node(Node value) {
    _node = value;
    markNeedsLayout();
  }

  RenderConnections? _connections;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _connections = findAncestorRenderObjectOfType<RenderConnections>();
    _connections?.attachNode(this);
  }

  @override
  void detach() {
    _connections?.detachNode(this);
    _connections = null;
    super.detach();
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (size.contains(position)) {
      if (hitTestChildren(result, position: position) || hitTestSelf(position)) {
        result.add(NodeHitTestEntry(this, position, node: node));
        return true;
      }
    }
    return false;
  }
}

class MoveSelectedNodesActivity extends DragActivity {
  MoveSelectedNodesActivity({
    required this.editor,
    super.onStart,
  });

  final BlueprintEditor editor;

  late final List<NodeId> nodes;
  late final List<Vec2> startPositions;

  final mergeKey = Object();

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    nodes = editor.selection.nodes.toList();
    startPositions = nodes.map((nodeId) => editor.positionOf(nodeId)).toList();
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);
    final delta = editor.globalToLocal(details.globalPosition) - editor.globalToLocal(startDetails.globalPosition);
    final positions = <NodeId, Vec2>{};
    for (final (i, id) in nodes.indexed) {
      positions[id] = startPositions[i] + delta.vec2;
    }

    editor.edit(() => editor.moveMany(positions), mergeKey: mergeKey);
  }
}

final class const NodeEnumWidget({
  super.key,
  required final BlueprintEditor editor,
  required final Enum value,
  required final BlueprintEnums enums,
  required final ValueChanged<Enum> onChanged,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final input = useSignal(value);
    useSimpleEffect(() => input.value = value, [value]);

    final values = enums.values[value.runtimeType];
    if (values == null) {
      _logger.warning('no enum values found for enum type ${value.runtimeType}');
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const .symmetric(horizontal: 12.0, vertical: 8.0),
      child: EnumInputField(
        values: values,
        value: input,
        onChanged: onChanged,
      ),
    );
  }
}
