part of 'core.dart';

class Scene with ChangeNotifier, ChangeNotifierDisposable {
  Scene() : root = .new() {
    root._attachToScene(this);
  }

  final RootObject root;
  final Map<ObjectId, SceneObject> _objects = {};

  void _addStar(ObjectId target, Cell reference) {
    final targetCell = _getObject<Cell>(target);
    targetCell._addStar(reference);
  }

  void _removeStar(ObjectId target, Cell reference) {
    final targetCell = _getObject<Cell>(target);
    targetCell._removeStar(reference);
  }

  void _attachObject(SceneObject object) {
    object._scene = this;
    _objects[object.id] = object;
  }

  void _detachObject(SceneObject object) {
    _removeObjectCallbacks(object.id);
    _objects.remove(object.id);
    object._scene = null;
  }

  T _getObject<T>(ObjectId id) => _objects[id] as T;

  final Map<ObjectId, ObjectSignal<SceneObject>> _objectSignals = {};
  ReadonlySignal<T> _signalFor<T extends SceneObject>(T object) {
    _objectSignals[object.id] ??= ObjectSignal<T>(object);
    return _objectSignals[object.id]! as ReadonlySignal<T>;
  }

  final Map<ObjectId, ChangeNotifier> _objectLayoutListeners = {};
  final Map<ObjectId, ChangeNotifier> _objectPaintListeners = {};

  void _addObjectLayoutListener(ObjectId id, VoidCallback callback) {
    _objectLayoutListeners[id] ??= ChangeNotifier();
    _objectLayoutListeners[id]!.addListener(callback);
  }

  void _removeObjectLayoutListener(ObjectId id, VoidCallback callback) {
    assert(_objectLayoutListeners[id] != null);
    _objectLayoutListeners[id]!.removeListener(callback);
  }

  void _addObjectPaintListener(ObjectId id, VoidCallback callback) {
    _objectPaintListeners[id] ??= ChangeNotifier();
    _objectPaintListeners[id]!.addListener(callback);
  }

  void _removeObjectPaintListener(ObjectId id, VoidCallback callback) {
    assert(_objectPaintListeners[id] != null);
    _objectPaintListeners[id]!.removeListener(callback);
  }

  void _removeObjectCallbacks(ObjectId id) {
    _objectSignals.remove(id)?.dispose();
    _objectLayoutListeners.remove(id)?.dispose();
    _objectPaintListeners.remove(id)?.dispose();
  }

  final _objectsNeedingLayout = <SceneObject>{};
  void _markNeedsLayout(SceneObject object) {
    if (_objectsNeedingLayout.contains(object)) return;

    _objectsNeedingLayout.add(object);
    _objectSignals[object.id]?.markAsDirty();
    _objectLayoutListeners[object.id]?.notifyListeners();
    notifyListeners();
  }

  void _markNeedsPaint(SceneObject object) {
    _objectSignals[object.id]?.markAsDirty();
    _objectPaintListeners[object.id]?.notifyListeners();
    notifyListeners();
  }

  void reassemble() {
    for (final object in _objects.values) {
      object._markNeedsLayout();
    }
  }

  void layout() {
    _layout();
  }
}
