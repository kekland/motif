import 'package:editor/imports.dart';

final class const EditorCanvasContainersLabels({
  super.key,
  required final Matrix4 transform,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final scene = context.editor.scene;
    final containers = useListenableSelector(scene, () {
      final containers = <ObjectNode>[];

      for (final node in scene.tree.children) {
        if (node.statement is ContainerStatement) {
          containers.add(node);
        }
      }

      return containers;
    });

    return Stack(
      children: containers.map((node) {
        return _ContainerLabel(
          key: ValueKey(node.id),
          scene: scene,
          node: node,
          transform: transform,
        );
      }).toList(),
    );
  }
}

final class const _ContainerLabel({
  super.key,
  required final Scene scene,
  required final ObjectNode node,
  required final Matrix4 transform,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final id = node.id;
    final (name, transform) = useComputed(() {
      scene.notifier.forStatement(id)();
      final statement = node.statement as ContainerStatement;
      return (statement.resolveName(context), statement.transform);
    }).value;

    final scale = this.transform.getMaxScaleOnAxis2D();

    final Widget label = switch (node.statement) {
      PrefabOriginStatement() => Row(
        spacing: 2.0,
        crossAxisAlignment: .center,
        children: [
          Icons.prefabOrigin(color: context.colors.selectionAlt.primary, size: 12.0),
          Text(name, style: context.typography.caption.copyWith(color: context.colors.selectionAlt.primary)),
        ],
      ),
      PrefabInstanceStatement() => Row(
        spacing: 2.0,
        crossAxisAlignment: .center,
        children: [
          Icons.prefabInstance(color: context.colors.display.tertiary, size: 12.0),
          Text(name, style: context.typography.caption.tertiary),
        ],
      ),
      _ => Text(name, style: context.typography.caption.tertiary),
    };

    return Transform(
      transform: transform.asVM(),
      child: FractionalTranslation(
        translation: .new(0.0, -1.0),
        child: Transform.scale(
          scale: 1.0 / scale,
          alignment: .bottomLeft,
          child: Padding(
            padding: .only(bottom: 4.0),
            child: label,
          ),
        ),
      ),
    );
  }
}
