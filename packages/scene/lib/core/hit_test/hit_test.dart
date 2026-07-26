part of '../core.dart';

bool _hitTestChildren(
  SceneHitTestResult result,
  MultiChildSceneObject node,
  List<SceneNode> children,
  Vector2 localPosition, {
  Matrix4? globalToScene,
  List<SceneNode> ignore = const [],
}) {
  // final cells = children.whereType<Cell>();
  // final cellHits = _hitTestCells(
  //   node,
  //   cells.toList(),
  //   localPosition,
  //   globalToScene: globalToScene,
  //   ignore: ignore,
  // );

  for (final child in children.reversed) {
    if (ignore.contains(child)) continue;

    final childTransform = node.getTransformTo(child);
    final childPosition = childTransform.transform2(localPosition);

    // if (child.hitTestSelf(childPosition, globalToScene: globalToScene)) {
    //   // for (final c in cellHits) result.add(c);
    //   child.hitTest(result, childPosition, globalToScene: globalToScene);
    //   return true;
    // }

    if (child.hitTest(result, childPosition, globalToScene: globalToScene, ignore: ignore)) {
      return true;
    }
  }

  // for (final c in cellHits) result.add(c);
  return false;
}
