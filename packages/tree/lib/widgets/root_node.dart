import 'dart:ui';
import 'package:flutter/foundation.dart';

import '../tree.dart';
import '../widgets.dart';

abstract class RootNodeWidgetBase<T extends Node> extends NodeWidgetBase<T> {
  const RootNodeWidgetBase({super.key, required super.child, required super.node});
}

mixin RenderRootNodeBase<T extends Node> on RenderNodeBase<T> {
  final _descendantNodes = <T, RenderNodeBase<T>>{};
  void registerDescendant(RenderNodeBase<T> node) {
    if (kDebugTreeLogEnabled) debugPrint('registering descendant ${node.node} of ${this.node}');
    _descendantNodes[node.node] = node;
  }

  void unregisterDescendant(RenderNodeBase<T> node) {
    if (kDebugTreeLogEnabled) debugPrint('unregistering descendant ${node.node} of ${this.node}');
    _descendantNodes.remove(node.node);
  }

  RenderNodeBase<T>? getRenderNode(T node) {
    if (node == this.node) return this;
    return _descendantNodes[node];
  }

  @override
  bool nodeHitTestSelf(Offset position) => true;
}

class RenderRootNode<T extends Node> extends RenderNode<T> with RenderRootNodeBase<T> {
  RenderRootNode({required super.node});
}
