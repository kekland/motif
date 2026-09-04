part of '../scene.dart';

final class SceneSelection with ChangeNotifier {
  SceneSelection(this.scene);
  final Scene scene;

  final _selected = <Ref>{};
  final _selectedStatements = <StatementId>{};
  var _stamp = 0;

  Iterable<Ref> get refs => _selected;
  bool get isEmpty => _selected.isEmpty;

  Iterable<StatementId> get statements => _selectedStatements;

  void set(Ref ref) {
    _selected.clear();
    _selected.add(ref);
    _onUpdated();
  }

  void setStatement(StatementId id) {
    final statement = scene.statement(id);
    setMultiple(statement.products);
  }

  void setStatements(Iterable<StatementId> ids) {
    _selected.clear();
    for (final id in ids) {
      final statement = scene.statement(id);
      _selected.addAll(statement.products);
    }
    _onUpdated();
  }

  void setMultiple(Iterable<Ref> keys) {
    _selected.clear();
    _selected.addAll(keys);
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
    final stmts = _selected.map((ref) => ref.statement).whereType<StatementId>().toSet();
    _selectedStatements.clear();
    _selectedStatements.addAll(stmts);
    notifyListeners();
    _stamp++;
  }

  void _onEvaluated() {
    _selected.removeWhere((ref) => scene.program.byId(ref.statement) == null);
  }

  int get stamp => _stamp;
}
