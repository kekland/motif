import 'dart:ui';
import 'package:flutter/foundation.dart';

import '../tree.dart';
import '../widgets.dart';

abstract class RootNodeWidgetBase<T extends Node> extends NodeWidgetBase<T> {
  const RootNodeWidgetBase({super.key, required super.child, required super.node});
}

mixin RenderRootNodeBase<
  T extends Node,
  TRenderNode extends RenderNodeBase<T, TRenderNode, TRenderRoot>,
  TRenderRoot extends RenderRootNodeBase<T, TRenderNode, TRenderRoot>
>
    on RenderNodeBase<T, TRenderNode, TRenderRoot> {
  final _descendantNodes = <T, TRenderNode>{};
  void registerDescendant(TRenderNode node) {
    if (kDebugTreeLogEnabled) debugPrint('registering descendant ${node.node} of ${this.node}');
    _descendantNodes[node.node] = node;
  }

  void unregisterDescendant(TRenderNode node) {
    if (kDebugTreeLogEnabled) debugPrint('unregistering descendant ${node.node} of ${this.node}');
    _descendantNodes.remove(node.node);
  }

  TRenderNode? getRenderNode(T node) {
    if (node == this.node) return this as TRenderNode;
    return _descendantNodes[node];
  }

  @override
  bool nodeHitTestSelf(Offset position) => true;
}
