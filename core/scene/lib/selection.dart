part of 'scene.dart';

final class SceneSelection with ChangeNotifier {
  SceneSelection(this.scene);
  final Scene scene;

  final _selected = <CellRef>{};
  final _selectedStatements = <StatementId>{};
  var _stamp = 0;

  Iterable<CellRef> get refs => _selected;
  bool get isEmpty => _selected.isEmpty;

  Iterable<StatementId> get statements => _selectedStatements;

  void set(CellRef ref) {
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

  void setMultiple(Iterable<CellRef> refs) {
    _selected.clear();
    _selected.addAll(refs);
    _onUpdated();
  }

  void add(CellRef ref) {
    _selected.add(ref);
    _onUpdated();
  }

  void clear() {
    _selected.clear();
    _onUpdated();
  }

  void _onUpdated() {
    final stmts = _selected.map((ref) => ref.statementId).toSet();
    _selectedStatements.clear();
    _selectedStatements.addAll(stmts);
    notifyListeners();
    _stamp++;
  }

  void _onEvaluated() {
    final e = scene.evaluation;
    final next = <CellRef>{};
    for (final r in _selected) next.addAll(e.descendantsOf(r));

    if (next.length != _selected.length) {
      _selected.clear();
      _selected.addAll(next);
      _onUpdated();
    }
  }

  int get stamp => _stamp;
}
