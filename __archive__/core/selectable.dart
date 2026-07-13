part of 'core.dart';

sealed class SelectableObject {
  SceneObject get sceneObject;

  bool isAncestorOf(SelectableObject object);
  bool isDescendantOf(SelectableObject object);

  int get depth;
  Aabb2 get bbox;

  ReadonlySignal<SelectableObject> call();
}
