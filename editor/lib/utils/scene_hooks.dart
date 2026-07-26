import 'package:editor/imports.dart';

SceneNode useNode(SceneNode node, {NodeUpdateAspect aspect = .paint}) {
  useListenable(node(aspect));
  return node;
}

T useNodeList<T extends Iterable<SceneNode>>(T nodes, {NodeUpdateAspect aspect = .paint}) {
  final listenable = useMemoized(() => Listenable.merge(nodes.map((n) => n(aspect))), [aspect, ...nodes]);
  useListenable(listenable);

  return nodes;
}
