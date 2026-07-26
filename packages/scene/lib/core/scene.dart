part of 'core.dart';

class Scene with ChangeNotifier, ChangeNotifierDisposable, SceneUpdate, SceneTopology {
  Scene() : root = .new() {
    topology = .new(scene: this);
    transientTransforms = $disposable(SceneTransientTransforms(this));
    scheduler = $disposable(.new(this));
    root._attachToScene(this);
  }

  final RootObject root;
  final Map<NodeId, SceneNode> _nodes = {};

  late final Topology topology;
  late final SceneScheduler scheduler;
  late final SceneTransientTransforms transientTransforms;

  void _attachNode(SceneNode node) => node._attachToScene(this);

  @override
  void _onNodeAttached(SceneNode node) {
    super._onNodeAttached(node);
    _nodes[node.id] = node;
  }

  void _detachNode(SceneNode node) => node._detachFromScene();

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

  @override
  T _getNode<T extends SceneNode>(NodeId id) => _nodes[id] as T;

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
