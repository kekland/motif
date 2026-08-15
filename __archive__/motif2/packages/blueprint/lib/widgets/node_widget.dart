part of 'widgets.dart';

class NodeWidget extends HookWidget {
  const NodeWidget({
    super.key,
    required this.node,
  });

  final Node node;

  @override
  Widget build(BuildContext context) {
    final node = useExistingSignal(this.node()).value;
    final panStartPosition = useState<Offset?>(null);
    final panStartLocalPosition = useState<Offset?>(null);

    final child = Surface(
      width: 160.0,
      color: context.colors.surface.primary,
      clipBehavior: .none,
      shadows: context.shadows.small,
      // borderSide: .new(color: context.colors.divider),
      borderRadius: .circular(4.0),
      child: Column(
        mainAxisSize: .min,
        children: [
          SizedBox(
            width: .infinity,
            height: 24.0,
            child: Surface(
              color: node.resolveColor(context) ?? context.colors.surface.secondary,
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
          const SizedBox(height: 4.0),
          for (final input in node.inputs) NodeInputSocketWidget(socket: input),
          for (final output in node.outputs) NodeOutputSocketWidget(socket: output),
          const SizedBox(height: 4.0),
        ],
      ),
    );

    final position = node.position;

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: DeferredPointerHandler(
        child: GestureDetector(
          onPanStart: (d) {
            panStartPosition.value = position;
            panStartLocalPosition.value = d.localPosition;
          },
          onPanUpdate: (d) {
            final delta = d.localPosition - panStartLocalPosition.value!;
            node.position = panStartPosition.value! + delta;
          },
          onPanEnd: (d) {},
          child: child,
        ),
      ),
    );
  }
}

class NodeInputSocketWidget<T> extends StatelessWidget {
  const NodeInputSocketWidget({super.key, required this.socket});

  final InputSocket<T> socket;

  @override
  Widget build(BuildContext context) {
    final valueBuilders = context.watch<BlueprintSocketValueBuilders>();
    final valueBuilder = valueBuilders.builderFor<T>(socket.type);

    late final Widget? trailing;

    if (valueBuilder != null) {
      final field = socket.resolve();
      late final T? value;
      if (field is ConstantField<T>) {
        value = field.value;
      } else {
        value = null;
      }

      trailing = valueBuilder.build(
        context,
        socket,
        value,
        field is ConstantField<T>
            ? (v) {
                socket.inlineValue = v;
              }
            : null,
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
