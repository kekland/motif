part of 'core.dart';

class VectorComplexBase with StaticNotifier implements ChangeNotifier {
  VectorComplexBase({List<Cell> cells = const [], required this.context}) : _cells = .new() {
    for (final c in cells) {
      _cells.add(c);
      geometry.push(c);
    }

    geometry.flush();
  }

  final LinkedList<Cell> _cells;
  final VectorComplexContext context;

  Iterable<Cell> get cells => _cells;
  Iterable<Cell> get reversedCells => _cells.reversed;
  Iterable<Vertex> get vertices => cells.whereType<Vertex>();
  Iterable<Edge> get edges => cells.whereType<Edge>();

  late final geometry = VectorGeometry(context);

  void reassemble() {
    for (final c in _cells) {
      geometry.remove(c);
      geometry.push(c);
    }
  }
}

class VectorComplex extends VectorComplexBase with ChangeNotifier, ChangeNotifierDisposable {
  VectorComplex({super.cells, required super.context}) {
    for (final c in _cells) {
      c._complex = this;
    }
  }

  void _markCellAsDirty(Cell c) {
    assert(c._complex == this);
    assert(_cells.contains(c));
    _cellSignals[c]?.markAsDirty();
    geometry.push(c);

    notifyListeners();
  }

  C add<C extends Cell>(C c) {
    c._complex = this;
    _cells.add(c);
    _markCellAsDirty(c);
    return c;
  }

  Vertex addVertex(Vector2 position, {List<Modifier>? modifiers}) => add(
    .new(
      position,
      modifiers: modifiers,
    ),
  );

  Edge addEdge(
    Vertex start,
    Vertex end, {
    EdgePath? path,
    EdgeDecoration? decoration,
    EdgeWeights? weights,
    List<Modifier>? modifiers,
  }) => add(
    .new(
      start,
      end,
      path: path,
      decoration: decoration,
      weights: weights,
      modifiers: modifiers,
    ),
  );

  void remove(Cell c) {
    c.unlink();
    geometry.remove(c);
    _cellSignals.remove(c)?.dispose();
  }

  @override
  void dispose() {
    for (final c in _cellSignals.values) c.dispose();
    _cellSignals.clear();
    super.dispose();
  }

  final Map<Cell, ObjectSignal<Cell>> _cellSignals = {};
  ReadonlySignal<T> _signalFor<T extends Cell>(T cell) {
    _cellSignals[cell] ??= ObjectSignal<T>(cell);
    return _cellSignals[cell]! as ReadonlySignal<T>;
  }
}
