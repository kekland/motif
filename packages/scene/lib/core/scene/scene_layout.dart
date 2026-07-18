part of '../core.dart';

mixin SceneLayout on SceneListeners {
  final _nodesNeedingLayout = <SceneNode>{};
  void _markNeedsLayout(SceneNode object) {
    if (_nodesNeedingLayout.contains(object)) return;
    SceneNode current = object;

    while (true) {
      if (current.parent == null) break;
      if (current.isLayoutBoundary) break;
      current = current.parent!;
    }

    if (current is Cell) {
      for (final c in current._star) {
        _markNeedsLayout(c);
      }
    }

    _nodesNeedingLayout.add(current);
    _nodeSignals[current.id]?.markAsDirty();
    _layoutListeners[current.id]?.notifyListeners();
    notifyListeners();
  }

  void _markNeedsPaint(SceneNode node) {
    _nodeSignals[node.id]?.markAsDirty();
    _paintListeners[node.id]?.notifyListeners();
    notifyListeners();
  }

  void _layout() {
    final objectsNeedingLayout = _nodesNeedingLayout.whereType<SceneObject>().toList();
    for (final o in objectsNeedingLayout) o.layout(.new());

    final cellsNeedingLayout = _nodesNeedingLayout.whereType<Cell>();
    final verticesNeedingLayout = cellsNeedingLayout.whereType<Vertex>();
    final edgesNeedingLayout = cellsNeedingLayout.whereType<Edge>();

    for (final c in verticesNeedingLayout) c.layout(.new());
    for (final e in edgesNeedingLayout) e.layout(.new());

    _nodesNeedingLayout.clear();
  }
}
