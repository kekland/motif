part of '../core.dart';

mixin MultiChildSceneObject on SceneObject {
  @override
  set parent(MultiChildSceneObject? value) => super.parent = value;

  @override
  List<SceneNode> get children => _children;
  List<Cell> get cells => _children.whereType<Cell>().toList();

  void addChild(SceneNode child) => _addChild(child);
  void insertChild(int index, SceneNode child) => _insertChild(index, child);

  void addChildren(Iterable<SceneNode> children) => _addChildren(children);
  void insertChildren(int index, Iterable<SceneNode> children) => _insertChildren(index, children);

  SceneNode removeChild(SceneNode child) => _removeChild(child);

  List<SceneNode> clearChildren() => _clearChildren();
  List<SceneNode> removeChildren(Iterable<SceneNode> children) => _removeChildren(children);

  bool controlsChildTransform(SceneObject child) => false;
}
