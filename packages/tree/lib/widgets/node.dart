import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../tree.dart';
import '../widgets.dart';

abstract class NodeWidgetBase<T extends Node> extends SingleChildRenderObjectWidget {
  const NodeWidgetBase({
    super.key,
    required this.node,
    super.child,
  });

  final T node;

  @override
  RenderNodeBase createRenderObject(BuildContext context);

  @override
  void updateRenderObject(BuildContext context, RenderNodeBase renderObject);
}

/// A base mixin for render objects for nodes.
mixin RenderNodeBase<
  T extends Node,
  TRenderNode extends RenderNodeBase<T, TRenderNode, TRenderRoot>,
  TRenderRoot extends RenderRootNodeBase<T, TRenderNode, TRenderRoot>
>
    on RenderBox {
  T get node;
  Clip get clipBehavior => Clip.none;

  TRenderNode? _parentNode;
  final _childrenNodes = <TRenderNode>[];

  TRenderRoot? _root;

  TRenderNode? get parentNode => _parentNode;
  TRenderRoot? get rootNode => _root;
  List<TRenderNode> get childrenNodes => _childrenNodes;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    RenderObject? current = parent;
    while (current != null) {
      if (_parentNode == null && current is TRenderNode) {
        _parentNode = current;
      }

      if (_root == null && current is TRenderRoot) {
        _root = current;
        break;
      }

      current = current.parent;
    }

    _parentNode?._childrenNodes.add(this as TRenderNode);
    _root?.registerDescendant(this as TRenderNode);

    if (node is ChangeNotifier) {
      (node as ChangeNotifier).addListener(_onNodeChildrenChanged);
    }
  }

  @override
  void detach() {
    _root?.unregisterDescendant(this as TRenderNode);

    _parentNode?._childrenNodes.remove(this as TRenderNode);
    _parentNode = null;

    if (node is ChangeNotifier) {
      (node as ChangeNotifier).removeListener(_onNodeChildrenChanged);
    }

    super.detach();
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (hitTestChildren(result, position: position) || hitTestSelf(position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }

    return false;
  }

  @override
  bool hitTestSelf(Offset position) => size.contains(position);

  void _onNodeChildrenChanged() {
    // TODO: make this more efficient.
    markNeedsLayout();
  }

  @override
  void performLayout() {
    super.performLayout();

    // Sort the children by their order in the node tree.
    _childrenNodes.sort((a, b) {
      final aIndex = node.children.indexOf(a.node);
      final bIndex = node.children.indexOf(b.node);
      return aIndex.compareTo(bIndex);
    });
  }

  // --
  // Node hit testing
  // --

  bool nodeHitTest(
    NodeHitTestResult<TRenderNode> result, {
    required Offset position,
    Iterable<TRenderNode> ignoring = const [],
  }) {
    final canHaveVisualOverflow = clipBehavior == Clip.none;
    if (!canHaveVisualOverflow && !size.contains(position)) return false;
    if (ignoring.contains(this)) return false;

    if (nodeHitTestChildren(result, position: position, ignoring: ignoring) || nodeHitTestSelf(position)) {
      result.add(NodeHitTestEntry<TRenderNode>(this as TRenderNode, position));
      return true;
    }

    return false;
  }

  bool nodeHitTestSelf(Offset position) {
    return size.contains(position);
  }

  bool nodeHitTestChildren(
    NodeHitTestResult<TRenderNode> result, {
    required Offset position,
    Iterable<TRenderNode> ignoring = const [],
  }) {
    if (node.isLeaf) return false;

    for (final child in _childrenNodes.reversed) {
      if (ignoring.contains(child)) continue;

      final transform = child.getTransformTo(this);
      final transformedPosition = MatrixUtils.transformPoint(Matrix4.inverted(transform), position);
      final isHit = child.nodeHitTest(result, position: transformedPosition, ignoring: ignoring);
      if (isHit) return true;
    }

    return false;
  }

  Rect get _nodeBounds => Offset.zero & size;

  // --
  // Node rect hit testing (e.g. for marquee selection)
  // --

  bool nodeHitTestRect(
    NodeHitTestResult<TRenderNode> result, {
    required Rect rect,
    NodeHitTestRectMode mode = .normal,
  }) {
    final canHaveVisualOverflow = clipBehavior == Clip.none;
    if (!canHaveVisualOverflow && !_nodeBounds.overlaps(rect)) return false;

    final isIntersecting = _nodeBounds.overlaps(rect);
    final isContained = rect.contains(_nodeBounds.topLeft) && rect.contains(_nodeBounds.bottomRight);

    bool _addSelf() {
      result.add(NodeHitTestEntry<TRenderNode>(this as TRenderNode, _nodeBounds.center));
      return true;
    }

    if (isContained) {
      return _addSelf();
    } else if (node.isLeaf && isIntersecting && mode != .contain) {
      return _addSelf();
    } else if (!node.isLeaf && isIntersecting && mode == .intersect) {
      return _addSelf();
    } else {
      return nodeHitTestRectChildren(result, rect: rect);
    }
  }

  bool nodeHitTestRectChildren(NodeHitTestResult<TRenderNode> result, {required Rect rect}) {
    if (node.isLeaf) return false;
    var _result = false;

    for (final child in _childrenNodes.reversed) {
      final transform = child.getTransformTo(this);
      final transformedRect = MatrixUtils.inverseTransformRect(transform, rect);

      if (child.nodeHitTestRect(result, rect: transformedRect)) {
        _result = true;
      }
    }

    return _result;
  }
}

class RenderNode<
  T extends Node,
  TRenderNode extends RenderNodeBase<T, TRenderNode, TRenderRoot>,
  TRenderRoot extends RenderRootNodeBase<T, TRenderNode, TRenderRoot>
>
    extends RenderProxyBox
    with RenderNodeBase<T, TRenderNode, TRenderRoot> {
  RenderNode({required T node}) : _node = node;

  late T _node;

  @override
  T get node => _node;
  set node(T value) {
    if (_node == value) return;
    _node = value;
  }
}

// -
// Hit testing
// -

class NodeHitTestEntry<TRenderNode extends RenderObject> extends HitTestEntry<TRenderNode> {
  NodeHitTestEntry(super.target, this.localPosition);

  final Offset localPosition;
}

class NodeHitTestResult<TRenderNode extends RenderObject> extends HitTestResult {
  NodeHitTestResult() : super();
  NodeHitTestResult.wrap(super.result) : super.wrap();

  @override
  Iterable<NodeHitTestEntry<TRenderNode>> get path => super.path.cast();
}

enum NodeHitTestRectMode {
  /// Only allow nodes that intersect, but don't require to be contanied
  intersect,

  /// Only allow nodes that are fully contained
  contain,

  /// Regular (intersect for leaf nodes, contain for non-leaf nodes)
  normal,
}
