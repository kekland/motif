part of '../core.dart';

bool _hitTestChildren(
  SceneHitTestResult result,
  MultiChildSceneObject node,
  List<SceneNode> children,
  Vector2 localPosition, {
  Matrix4? globalToScene,
}) {
  final cells = children.whereType<Cell>();
  final cellHits = _hitTestCells(node, cells.toList(), localPosition, globalToScene: globalToScene);

  for (final child in children.reversed.where((c) => c is! Cell)) {
    final childTransform = node.getTransformTo(child);
    final childPosition = childTransform.transform2(localPosition);

    if (child.hitTestSelf(childPosition, globalToScene: globalToScene)) {
      for (final c in cellHits) result.add(c);
      child.hitTest(result, childPosition, globalToScene: globalToScene);
      return true;
    }
  }

  for (final c in cellHits) result.add(c);
  return false;
}
