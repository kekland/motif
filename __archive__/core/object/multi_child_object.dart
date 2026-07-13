part of '../core.dart';

mixin MultiChildSceneObject on SceneObject {
  @override
  void _initialize() {
    super._initialize();
    for (final child in _children) child._parent = this;
  }

  @override
  void _attachToScene(Scene scene) {
    super._attachToScene(scene);
    for (final child in _children) child._attachToScene(scene);
  }

  @override
  void _detachFromScene() {
    for (final child in _children) child._detachFromScene();
    super._detachFromScene();
  }

  final _children = <SceneObject>[];
  List<SceneObject> get children => _children;
  
  int indexOf(SceneObject child) => _children.indexOf(child);

  void addChild(SceneObject child) => insertChild(child, _children.length);

  void insertChild(SceneObject child, int index) {
    if (_children.contains(child)) return;
    child.detach();

    _children.insert(index, child);
    child._parent = this;
    if (_scene != null) child._attachToScene(_scene!);

    child._markNeedsLayout();
    _markNeedsLayout();
  }

  SceneObject removeChild(SceneObject child) {
    if (!_children.contains(child)) return child;

    _children.remove(child);
    child._parent = null;
    child._detachFromScene();

    child._markNeedsLayout();
    _markNeedsLayout();

    return child;
  }

  void addChildren(Iterable<SceneObject> children) => insertChildren(children, _children.length);

  void insertChildren(Iterable<SceneObject> children, int index) {
    final filteredChildren = children.where((child) => !_children.contains(child)).toList();

    for (final child in filteredChildren) child.detach();
    _children.insertAll(index, filteredChildren);

    for (final child in filteredChildren) {
      child._parent = this;
      if (_scene != null) child._attachToScene(_scene!);
      child._markNeedsLayout();
    }

    _markNeedsLayout();
  }
}
