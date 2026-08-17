part of '../scene.dart';

final class SceneSelection with ChangeNotifier {
  SceneSelection(this.scene);
  final Scene scene;

  final _selected = <CellKey>{};
  final _selectedStatements = <StatementId>{};
  var _stamp = 0;

  Iterable<CellKey> get cells => _selected;
  bool get isEmpty => _selected.isEmpty;

  Iterable<StatementId> get statements => _selectedStatements;

  void set(CellKey key) {
    _selected.clear();
    _selected.add(key);
    _onUpdated();
  }

  void setStatement(StatementId id) {
    final statement = scene.statement(id);
    final keys = scene.keysOf(statement.products);
    setMultiple(keys);
  }

  void setMultiple(Iterable<CellKey> keys) {
    _selected.clear();
    _selected.addAll(keys);
    _onUpdated();
  }

  void add(CellKey key) {
    _selected.add(key);
    _onUpdated();
  }

  void clear() {
    _selected.clear();
    _onUpdated();
  }

  void _onUpdated() {
    final stmts = _selected.map((key) => scene.refOf(key)?.statement).whereType<StatementId>().toSet();
    _selectedStatements.clear();
    _selectedStatements.addAll(stmts);
    notifyListeners();
    _stamp++;
  }

  int get stamp => _stamp;
}
