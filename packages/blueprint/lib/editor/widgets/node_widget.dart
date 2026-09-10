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
    final panStartPosition = useState<Vec2?>(null);
    final panStartLocalPosition = useState<Vec2?>(null);

    final color = context.watch<BlueprintColorResolvers>();

    final child = Surface(
      width: 160.0,
      color: context.colors.surface.primary,
      borderSide: .new(color: context.colors.divider),
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
          for (final input in node.inputs) NodeInputSocketWidget(editor: editor, socket: input),
          for (final output in node.outputs) NodeOutputSocketWidget(socket: output),
          const SizedBox(height: 4.0),
        ],
      ),
    );

    final position = editor.positionOf(id);

    return Positioned(
      left: position.x,
      top: position.y,
      child: DeferredPointerHandler(
        child: GestureDetector(
          onPanStart: (d) {
            panStartPosition.value = position;
            panStartLocalPosition.value = d.localPosition.vec2;
          },
          onPanUpdate: (d) {
            final delta = d.localPosition.vec2 - panStartLocalPosition.value!;
            editor.move(id, panStartPosition.value! + delta);
          },
          onPanEnd: (d) {},
          child: child,
        ),
      ),
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

    if (!isConnected && valueBuilder != null) {
      trailing = valueBuilder.build(
        context,
        socket,
        value,
        (v) => editor.replace(socket.node.copyWithInline(socket.index, v)),
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
              BaseSocketWidget(socket: socket, dx: -1.0),
              const SizedBox(width: 12.0),
              Text(
                socket.name,
                style: context.typography.body.secondary,
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
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
          BaseSocketWidget(socket: socket, dx: 1.0),
        ],
      ),
    );
  }
}
