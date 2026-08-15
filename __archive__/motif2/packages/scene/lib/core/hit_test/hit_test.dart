part of '../core.dart';

bool _hitTestChildren(
  SceneHitTestResult result,
  SceneNode node,
  List<SceneNode> children,
  Vector2 localPosition, {
  Matrix4? globalToScene,
  List<SceneNode> ignore = const [],
}) {
  final cells = children.whereType<Cell>();
  final cellHits = _hitTestCells(
    node,
    cells.toList(),
    localPosition,
    globalToScene: globalToScene,
    ignore: ignore,
  );

  if (cellHits.isNotEmpty) {
    for (final c in cellHits) result.add(c);
    return true;
  }

  for (final child in children.reversed) {
    if (ignore.contains(child)) continue;

    final childTransform = node.getTransformTo(child);
    final childPosition = childTransform.transform2(localPosition);
    if (child.hitTest(result, childPosition, globalToScene: globalToScene, ignore: ignore)) {
      return true;
    }
  }

  return false;
}
