part of '../core.dart';

mixin SceneLayout on SceneListeners {
  final _nodesNeedingLayout = <SceneNode>{};
  void _markNeedsLayout(SceneNode object) {
    if (_nodesNeedingLayout.contains(object)) return;

    SceneNode? current = object;
    while (current != null) {
      _nodesNeedingLayout.add(current);
      _nodeSignals[current.id]?.markAsDirty();
      _layoutListeners[current.id]?.notifyListeners();

      current = current.parent;
    }

    _nodesNeedingLayout.add(object);
    _nodeSignals[object.id]?.markAsDirty();
    _layoutListeners[object.id]?.notifyListeners();
    notifyListeners();
  }

  void _markNeedsPaint(SceneNode node) {
    _nodeSignals[node.id]?.markAsDirty();
    _paintListeners[node.id]?.notifyListeners();
    notifyListeners();
  }

  void _layout() {
    print('LAYOUT (${DateTime.now()}) - ${_nodesNeedingLayout.length} objects');
    var iteration = 0;

    while (true) {
      iteration++;

      if (iteration > 100) throw Exception('circular layout');
      if (_nodesNeedingLayout.isEmpty) break;
      final _needingLayout = _nodesNeedingLayout.toList();
      _nodesNeedingLayout.clear();

      for (final object in _needingLayout) {
        print('  = layout: ${object}');
        object.layout(.new());
      }
    }

    _nodesNeedingLayout.clear();
  }
}
