part of '../core.dart';

mixin TopologicalSceneObject on SceneObject {
  @override
  void _initialize() {
    super._initialize();
    performLayout(.new());
  }

  @override
  void _attachToScene(Scene scene) {
    super._attachToScene(scene);

    for (final c in _cells) {
      _scene!._attachNode(c);
      c._parent = _parent;
    }

    parent?._children.insertAll(parent!.children.indexOf(this) + 1, _cells);
  }

  @override
  void _detachFromScene() {
    for (final c in _cells) _scene!._detachNode(c);
    super._detachFromScene();
  }

  var _cells = <Cell>[];
  Iterable<Cell> get cells => _cells;

  void _onCellsInvalidated(List<Cell> oldCells, List<Cell> newCells) {
    for (final c in oldCells) {
      _scene?._detachNode(c);
      parent!._children.remove(c);
    }

    for (final c in newCells) {
      _scene?._attachNode(c);
      c._parent = _parent;
      c._owner = this;
    }

    parent?._children.insertAll(parent!.children.indexOf(this) + 1, newCells);
    _cells = newCells;
  }

  List<Cell> produceCells(ResolvedSize size) => [];

  @override
  ResolvedSize performLayout(LayoutConstraints constraints) {
    final size = super.performLayout(constraints);

    var didInvalidate = false;
    final newCells = produceCells(size);
    for (final c in newCells) c.applyTransform(transform.value);

    if (_cells.length != newCells.length) {
      _onCellsInvalidated(_cells, newCells);
      didInvalidate = true;
    } else {
      for (var i = 0; i < _cells.length; i++) {
        if (_cells[i].runtimeType != newCells[i].runtimeType) {
          _onCellsInvalidated(_cells, newCells);
          didInvalidate = true;
          break;
        }
      }
    }

    if (!didInvalidate) {
      for (var i = 0; i < _cells.length; i++) {
        _cells[i].setFrom(newCells[i]);
      }
    }

    if (_scene != null) {
      for (final c in _cells) {
        c.layout(.new());
      }
    }

    return size;
  }
}
