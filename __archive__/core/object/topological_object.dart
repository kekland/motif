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
      _scene!._attachObject(c);
      c._parent = _parent;
    }

    _parent?._children.insertAll(parent!.indexOf(this) + 1, _cells);
  }

  @override
  void _detachFromScene() {
    for (final c in _cells) _scene!._detachObject(c);
    super._detachFromScene();
  }

  var _cells = <Cell>[];
  Iterable<Cell> get cells => _cells;

  void _onCellsInvalidated(List<Cell> oldCells, List<Cell> newCells) {
    for (final c in oldCells) {
      _scene?._detachObject(c);
      parent!._children.remove(c);
    }

    for (final c in newCells) {
      _scene?._attachObject(c);
      c._parent = _parent;
      c._owner = this;
    }

    _parent?._children.insertAll(parent!.indexOf(this) + 1, newCells);
    _cells = newCells;
  }

  List<Cell> produceCells(Size size) => [];

  @override
  Size performLayout(BoxConstraints constraints) {
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
