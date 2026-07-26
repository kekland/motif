part of '../core.dart';

mixin SceneUpdate on ChangeNotifierDisposable {
  final _nodeNotifiers = <NodeId, SceneNodeNotifier>{};

  SceneNodeNotifier notifierForNode(NodeId id) => _nodeNotifiers.putIfAbsent(id, () => .new());
  SceneNodeNotifier? _maybeNotifierForNode(NodeId id) => _nodeNotifiers[id];

  final _dirtyNodes = <SceneNode>{};
  final _detachedNodes = <NodeId>{};
  void _markNodeDirty(SceneNode node) {
    _dirtyNodes.add(node);
    _scheduleFlush();
  }

  void _clearNotifiersForNode(NodeId id) {
    _nodeNotifiers.remove(id)?.dispose();
  }

  void _onNodeAttached(SceneNode node) {
    _detachedNodes.remove(node.id);
  }

  void _onNodeDetached(SceneNode node) {
    _detachedNodes.add(node.id);
  }

  final _boundariesNeedingLayout = <SceneNode>{};

  /// Marks the node as needing layout.
  void _markBoundaryNeedsLayout(SceneNode node) {
    node._needsLayout = true;
    _boundariesNeedingLayout.add(node);
    _scheduleFlush();
  }

  void _scheduleFlush();

  void _performLayout() {
    final sortedBoundaries = _boundariesNeedingLayout.toList()..sort((a, b) => a.depth.compareTo(b.depth));

    for (final boundary in sortedBoundaries) {
      if (!boundary.needsLayout) continue;
      final LayoutConstraints? constraints = boundary is RootObject ? .unconstrained : boundary._lastConstraints;
      boundary.layout(constraints!);
    }
  }

  void _flushNodeUpdates() {
    for (final id in _detachedNodes) {
      _clearNotifiersForNode(id);
    }
    for (final node in _dirtyNodes) {
      final notifier = _maybeNotifierForNode(node.id);
      if (notifier != null) node._$flushUpdates(notifier);
    }

    _detachedNodes.clear();
    _dirtyNodes.clear();
  }

  /// Flushes all pending updates to the scene graph, including layout and paint updates, and notifies listeners of any
  /// changes.
  void flush() {
    _performLayout();
    _flushNodeUpdates();
  }

  @override
  void dispose() {
    for (final notifier in _nodeNotifiers.values) notifier.dispose();
    _nodeNotifiers.clear();
    _dirtyNodes.clear();
    _boundariesNeedingLayout.clear();
    super.dispose();
  }
}
