part of 'core.dart';

class Scene with ChangeNotifier, ChangeNotifierDisposable, SceneListeners, SceneTopology, SceneLayout {
  Scene() : root = .new() {
    topology = .new(scene: this);
    root._attachToScene(this);
  }

  final RootObject root;
  final Map<NodeId, SceneNode> _nodes = {};

  late final Topology topology;

  void _attachNode(SceneNode node) => node._attachToScene(this);
  void _onNodeAttached(SceneNode node) {
    _nodes[node.id] = node;
  }

  void _detachNode(SceneNode node) => node._detachFromScene();
  void _onNodeDetached(SceneNode node) {
    _removeObjectCallbacks(node.id);
    _nodes.remove(node.id);
  }

  void reassemble() {
    for (final node in _nodes.values) {
      node._markNeedsLayout();
    }
  }

  void layout() => _layout();

  @override
  T _getNode<T extends SceneNode>(NodeId id) => _nodes[id] as T;

  SceneHitTestResult hitTest(Vector2 localPosition, {Matrix4? globalToLocal}) {
    final result = SceneHitTestResult();
    root.hitTest(result, localPosition, globalToScene: globalToLocal);
    return result;
  }

  SceneHitTestResult hitTestRect(Aabb2 localRect, {HitTestRectMode mode = .normal}) {
    final result = SceneHitTestResult();
    root.hitTestRect(result, localRect);
    return result;
  }
}
