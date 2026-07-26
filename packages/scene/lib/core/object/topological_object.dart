part of '../core.dart';

mixin TopologicalSceneObject on SceneObject {
  @override
  void _initialize() {
    super._initialize();
    final cells = produceCells(.zero);
    _onCellsInvalidated([], cells);
  }

  var _ownedCells = <Cell>[];
  Iterable<Cell> get ownedCells => _ownedCells;

  void _onCellsInvalidated(List<Cell> oldCells, List<Cell> newCells) {
    _removeChildren(oldCells);
    _addChildren(newCells);

    _ownedCells = newCells;
  }

  List<Cell> produceCells(ResolvedSize size) => [];

  @override
  void performLayout(LayoutConstraints constraints) {
    super.performLayout(constraints);
    _layoutTopology(_resolvedSize!);
  }

  void _layoutTopology(ResolvedSize size) {
    var didInvalidate = false;
    final newCells = produceCells(size);

    if (_ownedCells.length != newCells.length) {
      _onCellsInvalidated(_ownedCells, newCells);
      didInvalidate = true;
    } else {
      for (var i = 0; i < _ownedCells.length; i++) {
        if (_ownedCells[i].runtimeType != newCells[i].runtimeType) {
          _onCellsInvalidated(_ownedCells, newCells);
          didInvalidate = true;
          break;
        }
      }
    }

    if (!didInvalidate) {
      for (var i = 0; i < _ownedCells.length; i++) _ownedCells[i].setFrom(newCells[i]);
    }

    for (var i = 0; i < _ownedCells.length; i++) {
      _ownedCells[i].layout(.unconstrained);
    }
  }
}
