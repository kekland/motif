part of 'scene.dart';

final class SceneSelection with ChangeNotifier {
  SceneSelection(this.scene);
  final Scene scene;

  final _selected = <Ref>{};
  final _selectedStatements = <StatementId>{};
  final _cells = <CellRef>{};
  var _visibleCovertices = <CovertexRef>{};
  var _stamp = 0;

  Set<Ref> get refs => _selected;
  Set<CellRef> get cells => _cells;
  bool get isEmpty => _selected.isEmpty;

  Iterable<StatementId> get statements => _selectedStatements;
  Set<CovertexRef> get visibleCovertices => _visibleCovertices;

  void set(Ref ref) {
    _selected.clear();
    _selected.add(ref);
    _onUpdated();
  }

  void setStatement(StatementId id) {
    final statement = scene.statement(id);
    if (statement == null) return;
    setMultiple(scene.evaluation.productsOf(statement.id));
  }

  void setStatements(Iterable<StatementId> ids) {
    _selected.clear();
    for (final id in ids) {
      final statement = scene.statement(id);
      if (statement == null) return;
      _selected.addAll(scene.productsOf(statement.id));
    }
    _onUpdated();
  }

  void setMultiple(Iterable<Ref> refs) {
    _selected.clear();
    _selected.addAll(refs);
    _onUpdated();
  }

  void add(Ref ref) {
    _selected.add(ref);
    _onUpdated();
  }

  void clear() {
    _selected.clear();
    _onUpdated();
  }

  void _onUpdated() {
    final stmts = _selected.map((ref) => scene.evaluation.rootOf(ref.statementId)).toSet();
    _selectedStatements.clear();
    _selectedStatements.addAll(stmts);

    _cells.clear();
    for (final r in _selected) {
      if (r is CellRef) _cells.add(r);
      if (r is CovertexRef) _cells.add(r.edge);
    }

    _resolveVisibleCovertices();
    notifyListeners();
    _stamp++;
  }

  void _resolveVisibleCovertices() {
    _visibleCovertices = resolveDisplayCovertices(scene.bundle, _selected);
  }

  void _onEvaluated() {
    final e = scene.evaluation;
    final next = <Ref>{};
    for (final r in _selected) next.addAll(e.descendantsOf(r));

    if (!(const SetEquality()).equals(next, _selected)) {
      _selected.clear();
      _selected.addAll(next);
      _onUpdated();
    } else {
      _resolveVisibleCovertices();
    }
  }

  int get stamp => _stamp;
}
