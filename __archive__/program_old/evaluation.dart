part of 'program.dart';

class Evaluation {
  Evaluation(this.program) {
    bundle = .new();
    graph = .new(this);
    lineage = .new();
    layout = .new(indexOf);
    style = .new(this);
    drawOrder = .new(this);
    generated = .new();
    modifier = .new(this);
    live = .new();
    _initialPass();
  }

  final Program program;
  late final Bundle bundle;
  late final Graph graph;
  late final LineageIndex lineage;
  late final LayoutTree layout;
  late final StyleIndex style;
  late final DrawOrderIndex drawOrder;
  late final ModifierIndex modifier;
  late final GeneratedIndex generated;
  late final LiveIndex live;

  // -------------------------------------------------------------------------------------------------------------------
  // Statement data
  // -------------------------------------------------------------------------------------------------------------------

  final _order = <Statement>[];
  final _index = <StatementId, int>{};
  final _commits = <StatementId, Commit>{};

  @pragma('vm:prefer-inline')
  int? indexOf(StatementId id) => _index[id];

  @pragma('vm:prefer-inline')
  S? statement<S extends Statement>(StatementId id) {
    final index = _index[id];
    if (index == null) return null;
    return _order[index] as S;
  }

  @pragma('vm:prefer-inline')
  S statementAt<S extends Statement>(int i) {
    if (i < 0 || i >= _order.length) throw RangeError.index(i, _order, 'i');
    return _order[i] as S;
  }

  @pragma('vm:prefer-inline')
  Statement? rootStatement(StatementId id) {
    return statement(generated.rootOf(id));
  }

  StatementId baseOf(StatementId id) => modifier.baseOf(id);
  Iterable<StatementId> stackOf(StatementId id) => modifier.stackOf(id);
  Set<StatementId> stacksOf(Iterable<StatementId> ids) {
    final out = <StatementId>{};
    for (final id in ids) out.addAll(stackOf(id));
    return out;
  }

  StatementId rootOf(StatementId id) => generated.rootOf(id);
  Iterable<Statement> groupOf(StatementId id) {
    final start = indexOf(id);
    if (start == null) return .empty();
    final end = _orderEnd(start);
    return _order.getRange(start, end);
  }

  Iterable<StatementId> dependenciesOf(StatementId id) {
    final commit = _commits[id];
    if (commit == null) return const [];
    return commit.dependencies;
  }

  Iterable<R> descendantsOf<R extends Ref>(R ref) => switch (ref) {
    CellRef r => lineage.descendantsOf(r, bundle) as Iterable<R>,
    CovertexRef r => lineage.covertexDescendantsOf(r, bundle) as Iterable<R>,
  };

  Iterable<CellRef> productsOf(StatementId id) sync* {
    for (final s in groupOf(id)) {
      final commit = _commits[s.id];
      if (commit == null) continue;
      yield* commit.added;
    }
  }

  Iterable<CellRef> consumedOf(StatementId id) sync* {
    for (final s in groupOf(id)) {
      final commit = _commits[s.id];
      if (commit == null) continue;
      yield* commit.deleted;
    }
  }

  Set<StatementId> dependentsBefore(Set<StatementId> ids, int top) {
    final out = <StatementId>{};
    final work = [...ids];

    while (work.isNotEmpty) {
      final dependents = graph.dependents(work.removeLast());
      for (final d in dependents) {
        final root = generated.rootOf(d);
        final index = indexOf(root);
        if (index == null || index > top || ids.contains(root)) continue;
        if (out.add(root)) work.add(root);
      }
    }

    return out;
  }


  List<StatementId> sorted(Iterable<StatementId> ids) {
    return ids.toList()..sort((a, b) => indexOf(a)!.compareTo(indexOf(b)!));
  }

  Commit? commitOf(StatementId id) => _commits[id];

  Placement? layoutOf(StatementId id) => layout.placementOf(id);

  void _splice(int start, int end, List<Statement> inserted) {
    for (var i = start; i < end; i++) _index.remove(_order[i].id);

    _order.replaceRange(start, end, inserted);
    final stop = inserted.length == end - start ? start + inserted.length : _order.length;
    for (var i = start; i < stop; i++) _index[_order[i].id] = i;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Generated statements
  // -------------------------------------------------------------------------------------------------------------------

  StatementId? generatorOf(StatementId id) => generated.generatorOf(id);

  int _orderEnd(int i) {
    final id = _order[i].id;
    var j = i + 1;
    while (j < _order.length && generated.generatedBy(_order[j].id, id)) j++;
    return j;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Context
  // -------------------------------------------------------------------------------------------------------------------

  EvalContext contextFor(StatementId id, {bool includeResolutions = true}) => .new(
    this,
    id,
    resolutions: includeResolutions ? _commits[id]?.resolutions : null,
  );

  // -------------------------------------------------------------------------------------------------------------------
  // Update propagation
  // -------------------------------------------------------------------------------------------------------------------

  late var _lastPass = EvaluationPass(this);
  late final _updateNotifier = AlwaysNotifier<EvaluationPass>(_lastPass);

  void addUpdateListener(void Function(EvaluationPass) listener) {
    _updateNotifier.addListener(() => listener(_updateNotifier.value));
  }

  void removeUpdateListener(void Function(EvaluationPass) listener) {
    _updateNotifier.removeListener(() => listener(_updateNotifier.value));
  }

  void _onPassComplete(EvaluationPass pass) {
    _lastPass = pass;
    _updateNotifier.value = pass;
  }

  void dispose() {
    _updateNotifier.dispose();
  }
}

class AlwaysNotifier<T> extends ChangeNotifier implements ValueListenable<T> {
  AlwaysNotifier(this._value);

  @override
  T get value => _value;
  T _value;
  set value(T newValue) {
    _value = newValue;
    notifyListeners();
  }
}
