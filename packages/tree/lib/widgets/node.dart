import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../tree.dart';
import '../widgets.dart';

class NodeHitTestEntry<T extends Node> extends HitTestEntry<RenderNodeBase<T>> {
  NodeHitTestEntry(super.target, this.localPosition);

  final Offset localPosition;
}

class NodeHitTestResult<T extends Node> extends HitTestResult {
  NodeHitTestResult() : super();
  NodeHitTestResult.wrap(super.result) : super.wrap();

  @override
  Iterable<NodeHitTestEntry<T>> get path => super.path.cast();
}

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

enum NodeHitTestRectMode {
  /// Only allow nodes that intersect, but don't require to be contanied
  intersect,

  /// Only allow nodes that are fully contained
  contain,

  /// Regular (intersect for leaf nodes, contain for non-leaf nodes)
  normal,
}

mixin RenderNodeBase<T extends Node> on RenderBox {
  T get node;
  Clip get clipBehavior => Clip.none;

  RenderNodeBase<T>? _parentNode;
  final _childrenNodes = <RenderNodeBase<T>>[];

  RenderRootNodeBase<T>? _root;

  RenderNodeBase<T>? get parentNode => _parentNode;
  RenderRootNodeBase<T>? get rootNode => _root;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    RenderObject? current = parent;
    while (current != null) {
      if (_parentNode == null && current is RenderNodeBase<T>) {
        _parentNode = current;
      }

      if (_root == null && current is RenderRootNodeBase<T>) {
        _root = current;
        break;
      }

      current = current.parent;
    }

    _parentNode?._childrenNodes.add(this);
    _root?.registerDescendant(this);
  }

  @override
  void detach() {
    _root?.unregisterDescendant(this);

    _parentNode?._childrenNodes.remove(this);
    _parentNode = null;

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

  // --
  // Node hit testing
  // --

  bool nodeHitTest(NodeHitTestResult result, {required Offset position, List<RenderNodeBase<T>> ignoring = const []}) {
    final canHaveVisualOverflow = clipBehavior == Clip.none;
    if (!canHaveVisualOverflow && !size.contains(position)) return false;
    if (ignoring.contains(this)) return false;

    if (nodeHitTestChildren(result, position: position, ignoring: ignoring) || nodeHitTestSelf(position)) {
      result.add(NodeHitTestEntry<T>(this, position));
      return true;
    }

    return false;
  }

  bool nodeHitTestSelf(Offset position) {
    return size.contains(position);
  }

  bool nodeHitTestChildren(
    NodeHitTestResult result, {
    required Offset position,
    List<RenderNodeBase<T>> ignoring = const [],
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

  bool nodeHitTestRect(NodeHitTestResult result, {required Rect rect, NodeHitTestRectMode mode = .normal}) {
    final canHaveVisualOverflow = clipBehavior == Clip.none;
    if (!canHaveVisualOverflow && !_nodeBounds.overlaps(rect)) return false;

    final isIntersecting = _nodeBounds.overlaps(rect);
    final isContained = rect.contains(_nodeBounds.topLeft) && rect.contains(_nodeBounds.bottomRight);

    bool _addSelf() {
      result.add(NodeHitTestEntry<T>(this, _nodeBounds.center));
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

  bool nodeHitTestRectChildren(NodeHitTestResult result, {required Rect rect}) {
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

class RenderNode<T extends Node> extends RenderProxyBox with RenderNodeBase<T> {
  RenderNode({required T node}) : _node = node;

  late T _node;

  @override
  T get node => _node;
  set node(T value) {
    if (_node == value) return;
    _node = value;
  }
}
