part of '../core.dart';

mixin SceneListeners on ChangeNotifier {
  final Map<NodeId, ObjectSignal<SceneNode>> _nodeSignals = {};
  ReadonlySignal<T> _signalFor<T extends SceneNode>(T node) {
    _nodeSignals[node.id] ??= ObjectSignal<T>(node);
    return _nodeSignals[node.id]! as ReadonlySignal<T>;
  }

  final Map<NodeId, ChangeNotifier> _layoutListeners = {};
  final Map<NodeId, ChangeNotifier> _paintListeners = {};

  void _addObjectLayoutListener(NodeId id, VoidCallback callback) {
    _layoutListeners[id] ??= ChangeNotifier();
    _layoutListeners[id]!.addListener(callback);
  }

  void _removeObjectLayoutListener(NodeId id, VoidCallback callback) {
    assert(_layoutListeners[id] != null);
    _layoutListeners[id]!.removeListener(callback);
  }

  void _addObjectPaintListener(NodeId id, VoidCallback callback) {
    _paintListeners[id] ??= ChangeNotifier();
    _paintListeners[id]!.addListener(callback);
  }

  void _removeObjectPaintListener(NodeId id, VoidCallback callback) {
    assert(_paintListeners[id] != null);
    _paintListeners[id]!.removeListener(callback);
  }

  void _removeObjectCallbacks(NodeId id) {
    _nodeSignals.remove(id)?.dispose();
    _layoutListeners.remove(id)?.dispose();
    _paintListeners.remove(id)?.dispose();
  }
}
