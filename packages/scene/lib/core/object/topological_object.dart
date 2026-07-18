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

    for (final c in _ownedCells) {
      _scene!._attachNode(c);
      c._parent = _parent;
    }

    parent?._children.insertAll(parent!.children.indexOf(this) + 1, _ownedCells);
  }

  @override
  void _detachFromScene() {
    for (final c in _ownedCells) _scene!._detachNode(c);
    super._detachFromScene();
  }

  var _ownedCells = <Cell>[];
  Iterable<Cell> get ownedCells => _ownedCells;

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
    _ownedCells = newCells;
  }

  List<Cell> produceCells(ResolvedSize size) => [];

  @override
  ResolvedSize performLayout(LayoutConstraints constraints) {
    final size = super.performLayout(constraints);

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

    for (final c in newCells) c.transformWith(transform.value);
    if (!didInvalidate) {
      for (var i = 0; i < _ownedCells.length; i++) {
        _ownedCells[i].setFrom(newCells[i]);
      }
    }

    return size;
  }
}
