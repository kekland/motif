part of 'program.dart';

class Evaluation {
  Evaluation(this.program) {
    bundle = .new();
    graph = .new();
    lineage = .new();
    layout = .new(indexOf);
    style = .new(this);
    drawOrder = .new(this);
    generated = .new();
    _initialPass();
  }

  final Program program;
  late final Bundle bundle;
  late final Graph graph;
  late final LineageIndex lineage;
  late final LayoutTree layout;
  late final StyleIndex style;
  late final DrawOrderIndex drawOrder;
  late final GeneratedIndex generated;

  // -------------------------------------------------------------------------------------------------------------------
  // Statement data
  // -------------------------------------------------------------------------------------------------------------------

  final _order = <Statement>[];
  final _index = <StatementId, int>{};
  final _commits = <StatementId, Commit>{};

  @pragma('vm:prefer-inline')
  int? indexOf(StatementId id) => _index[id];

  @pragma('vm:prefer-inline')
  Statement? statement(StatementId id) {
    final index = _index[id];
    if (index == null) return null;
    return _order[index];
  }

  Iterable<Statement> _groupOf(StatementId id) {
    final start = indexOf(id);
    if (start == null) return .empty();
    final end = _orderEnd(start);
    return _order.getRange(start, end);
  }

  Iterable<R> descendantsOf<R extends Ref>(R ref) => switch (ref) {
    CellRef r => lineage.descendantsOf(r, bundle) as Iterable<R>,
    CovertexRef r => lineage.covertexDescendantsOf(r, bundle) as Iterable<R>,
  };

  Iterable<CellRef> productsOf(StatementId id) sync* {
    for (final s in _groupOf(id)) {
      final commit = _commits[s.id];
      if (commit == null) continue;
      yield* commit.added;
    }
  }

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

  StatementId rootOf(StatementId id) => generated.rootOf(id);
  StatementId? generatorOf(StatementId id) => generated.generatorOf(id);
  bool _under(StatementId id, StatementId generator) => generated.generatedBy(id, generator);

  int _orderEnd(int i) {
    final id = _order[i].id;
    var j = i + 1;
    while (j < _order.length && _under(_order[j].id, id)) j++;
    return j;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Context
  // -------------------------------------------------------------------------------------------------------------------

  EvalContext _contextFor(StatementId id, {bool includeResolutions = true}) => .new(
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
