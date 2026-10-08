part of 'scene.dart';

final class SceneSelection with ChangeNotifier {
  SceneSelection(this.scene);
  final Scene scene;

  final _refSources = <Ref>{};
  final _statementSources = <StatementId>{};

  final _refs = <Ref>{};
  final _cells = <CellRef>{};
  final _frames = <FrameRef>{};
  final _statements = <StatementId>{};
  var _visibleCovertices = <CovertexRef>{};
  var _stamp = 0;

  Set<Ref> get refs => _refs;
  Set<Ref> get refSources => _refSources;
  Set<CellRef> get cells => _cells;
  Set<FrameRef> get frames => _frames;
  Set<StatementId> get statements => _statements;
  Set<StatementId> get statementSources => _statementSources;
  Set<CovertexRef> get visibleCovertices => _visibleCovertices;

  bool get isEmpty => _refs.isEmpty && _statements.isEmpty;
  bool get isNotEmpty => !isEmpty;

  void _clear() {
    _refSources.clear();
    _statementSources.clear();
  }

  void set(Ref ref) {
    _clear();
    _refSources.add(ref);
    _onUpdated();
  }

  void setMultiple(Iterable<Ref> refs) {
    _clear();
    _refSources.addAll(refs);
    _onUpdated();
  }

  void add(Ref ref) {
    _refSources.add(ref);
    _onUpdated();
  }

  void setStatement(StatementId id) {
    _clear();
    _statementSources.add(id);
    _onUpdated();
  }

  void setStatements(Iterable<StatementId> ids) {
    _clear();
    _statementSources.addAll(ids);
    _onUpdated();
  }

  void addStatement(StatementId id) {
    _statementSources.add(id);
    _onUpdated();
  }

  void toggleStatement(StatementId id) {
    if (_statementSources.contains(id)) {
      _statementSources.remove(id);
    } else {
      _statementSources.add(id);
    }
    _onUpdated();
  }

  void clear() {
    _clear();
    _onUpdated();
  }

  void _onUpdated() {
    final e = scene.evaluation;

    _refs.clear();
    for (final r in _refSources) _refs.addAll(e.lineage.descendantsOf(r).where((r) => e.bundle.isLive(r.cell)));
    _statements.clear();
    _statements.addAll(_statementSources.where((s) => e.statement(s) != null));
    _statements.addAll(_refs.map((ref) => e.rootOf(ref.statementId)));
    for (final s in _statementSources) _refs.addAll(e.productsOf(s).where(e.bundle.isLive));

    _cells.clear();
    _frames.clear();
    for (final r in _refs) {
      final cell = r.cell;
      _cells.add(cell);

      if (cell.kind == .frame) _frames.add(cell.asFrame);

      final parent = scene.bundle.query.parent(cell);
      if (parent != null) _frames.add(parent);
    }

    _resolveVisibleCovertices();

    _stamp++;
    notifyListeners();
  }

  void _resolveVisibleCovertices() {
    _visibleCovertices = resolveDisplayCovertices(scene.bundle, _cells);
  }

  void _onEvaluated() {
    final e = scene.evaluation;

    final nextStatements = <StatementId>{};
    final nextRefs = <Ref>{};
    final nextProducts = <Ref>{};
    for (final s in _statementSources) {
      if (e.statement(s) != null) nextStatements.add(s);
    }

    for (final r in _refSources) {
      nextRefs.addAll(e.lineage.descendantsOf(r).where((r) => e.bundle.isLive(r.cell)));
    }

    for (final s in nextStatements) {
      nextProducts.addAll(e.productsOf(s).where(e.bundle.isLive));
    }

    var updated = false;
    if (!setEquals(nextStatements, _statementSources)) {
      _statementSources.clear();
      _statementSources.addAll(nextStatements);
      updated = true;
    }

    if (!setEquals(nextRefs, _refSources)) {
      _refSources.clear();
      _refSources.addAll(nextRefs);
      updated = true;
    }

    if (updated || !setEquals({...nextRefs, ...nextProducts}, _refs)) {
      _onUpdated();
    } else {
      _resolveVisibleCovertices();
    }
  }

  int get stamp => _stamp;

  bool isImplicitlySelected(StatementId id) {
    if (_statements.contains(id)) return true;

    final node = scene.tree.nodeOf(id);
    final parent = node?.parent;
    if (parent is ObjectSceneNode) return isImplicitlySelected(parent.id);
    return false;
  }
}
