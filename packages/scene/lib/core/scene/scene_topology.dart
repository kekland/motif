part of '../core.dart';

mixin SceneTopology {
  T _getNode<T extends SceneNode>(NodeId id);

  void _addStar(NodeId target, Cell reference) {
    final targetCell = _getNode<Cell>(target);
    targetCell._addStar(reference);
  }

  void _removeStar(NodeId target, Cell reference) {
    final targetCell = _getNode<Cell>(target);
    targetCell._removeStar(reference);
  }
}
