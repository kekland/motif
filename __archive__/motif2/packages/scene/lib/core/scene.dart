part of 'core.dart';

class Scene with ChangeNotifier, ChangeNotifierDisposable, SceneUpdate {
  Scene() : root = .new() {
    topology = SceneTopology(this);
    transientTransforms = $disposable(SceneTransientTransforms(this));
    scheduler = $disposable(.new(this));
    root._attachToScene(this);
    root.layout();
  }

  final RootObject root;
  final Map<NodeId, SceneNode> _nodes = {};
  final Map<TopologyId, Cell> _topologyNodes = {};

  late final Topology topology;
  late final SceneScheduler scheduler;
  late final SceneTransientTransforms transientTransforms;

  @override
  void _onNodeAttached(SceneNode node) {
    super._onNodeAttached(node);
    _nodes[node.id] = node;
  }

  @override
  void _onNodeDetached(SceneNode node) {
    _nodes.remove(node.id);
    super._onNodeDetached(node);
  }

  void reassemble() {
    for (final node in _nodes.values) {
      node._markNeedsLayout();
    }
  }

  T _getNode<T extends SceneNode>(NodeId id) => _nodes[id] as T;
  T _getCell<T extends Cell>(TopologyId id) => _nodes[id] as T;
  T? _maybeGetCell<T extends Cell>(TopologyId id) => _nodes[id] as T?;

  var _flushScheduled = false;

  @override
  void _scheduleFlush() {
    if (_flushScheduled) return;
    if (scheduler._scheduler == null) return;

    _flushScheduled = true;
    scheduler.scheduleFrameCallback(() {
      flush();
      _flushScheduled = false;
    });
  }

  SceneHitTestResult hitTest(Vector2 localPosition, {Matrix4? globalToLocal, List<SceneNode> ignore = const []}) {
    final result = SceneHitTestResult();
    root.hitTest(result, localPosition, globalToScene: globalToLocal, ignore: ignore);
    return result;
  }

  SceneHitTestResult hitTestRect(Aabb2 localRect, {HitTestRectMode mode = .normal}) {
    final result = SceneHitTestResult();
    root.hitTestRect(result, localRect, mode: mode);
    return result;
  }
}
