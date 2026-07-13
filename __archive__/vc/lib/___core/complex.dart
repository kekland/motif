part of 'core.dart';

abstract class VectorComplex<C extends Cell, V extends Vertex, E extends Edge> implements ChangeNotifier {
  VectorComplex();

  // final SymbolManager symbolManager;

  Iterable<C> get cells;
  Iterable<C> get reversedCells;
  Iterable<V> get vertices => cells.whereType<V>();
  Iterable<E> get edges => cells.whereType<E>();

  VectorGeometry get geometry;
}

class ImmutableVectorComplex extends VectorComplex<ImmutableCell, ImmutableVertex, ImmutableEdge> with StaticNotifier {
  ImmutableVectorComplex({
    this._cells = const [],
    // required super.symbolManager,
  }) : geometry = .new() {
    for (final c in _cells) geometry.push(c);
  }

  @override
  Iterable<ImmutableCell> get cells => _cells;

  @override
  Iterable<ImmutableCell> get reversedCells => _cells.reversed;

  final List<ImmutableCell> _cells;

  @override
  final VectorGeometry geometry;
}

class MutableVectorComplex extends VectorComplex<MutableCell, MutableVertex, MutableEdge>
    with ChangeNotifier, ChangeNotifierDisposable {
  MutableVectorComplex() : _geometry = .new();

  @override
  Iterable<MutableCell> get cells => _cells;

  @override
  Iterable<MutableCell> get reversedCells => _cells.reversed;

  final _cells = LinkedList<MutableCell>();
  final _cellDisposeHandles = <MutableCell, DisposeHandle>{};

  @override
  VectorGeometry get geometry {
    // if (_geometry.isDirty) _geometry.flush();
    return _geometry;
  }

  final VectorGeometry _geometry;

  void _onCellChanged(MutableCell c) {
    geometry.push(c);
    notifyListeners();
  }

  T add<T extends MutableCell>(T c) {
    _cells.add(c);
    _cellDisposeHandles[c] = $listen(c, () => _onCellChanged(c));
    geometry.push(c);

    notifyListeners();
    return c;
  }

  MutableVertex addVertex(Vector2 position, {List<VertexModifier>? modifiers}) {
    return add(MutableVertex(position, modifiers: modifiers));
  }

  MutableEdge addEdge(
    MutableVertex start,
    MutableVertex end, {
    EdgePath? path,
    EdgeDecoration? decoration,
    EdgeWeights? weights,
    List<EdgeModifier>? modifiers,
  }) {
    return add(
      MutableEdge(
        start,
        end,
        path: path,
        decoration: decoration,
        weights: weights,
        modifiers: modifiers,
      ),
    );
  }

  void hardDelete(MutableCell c) {
    c.unlink();
    geometry.remove(c);
    _cellDisposeHandles.remove(c)?.dispose();
    c.dispose();
  }

  void reassemble() {
    for (final c in _cells) {
      geometry.push(c);
    }
  }
}
