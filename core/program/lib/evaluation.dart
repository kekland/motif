part of 'program.dart';

final class Evaluation {
  Evaluation(this.program) {
    _initialPass();
  }

  final Program program;
  final bundle = Bundle();
  final lineage = LineageIndex();
  final graph = Graph();
  late final layoutTree = LayoutTree(indexOf);
  final commits = <StatementId, Commit>{};

  // -------------------------------------------------------------------------------------------------------------------
  // Flattened statements
  // -------------------------------------------------------------------------------------------------------------------

  final order = <Statement>[];
  final _index = <StatementId, int>{};
  final _span = <StatementId, int>{};
  final _owner = <StatementId, StatementId>{};

  @pragma('vm:prefer-inline')
  int? indexOf(StatementId id) => _index[id];

  Statement? statement(StatementId id) {
    final index = _index[id];
    if (index == null) return null;
    return order[index];
  }

  StatementId ownerOf(StatementId id) => _owner[id]!;
  Iterable<Statement> subtree(StatementId id) => order.getRange(_index[id]!, _index[id]! + _span[id]!);

  Placement placementOf(StatementId id) => layoutTree.placementOf(id);

  void _flattenInto(Statement s, List<Statement> out, List<int> spans, List<StatementId> owners, [StatementId? root]) {
    final at = out.length;
    out.add(s);
    spans.add(0);
    owners.add(root ?? s.id);
    for (final c in s.expand()) _flattenInto(c, out, spans, owners, root ?? s.id);
    for (final m in s.modifiers) _flattenInto(m, out, spans, owners);
    spans[at] = out.length - at;
  }

  void _splice(int start, int end, List<Statement> inserted, List<int> spans, List<StatementId> owners) {
    for (var i = start; i < end; i++) {
      final id = order[i].id;
      _index.remove(id);
      _span.remove(id);
      _owner.remove(id);
    }

    for (var i = 0; i < inserted.length; i++) {
      _span[inserted[i].id] = spans[i];
      _owner[inserted[i].id] = owners[i];
    }

    order.replaceRange(start, end, inserted);
    final stop = inserted.length == end - start ? start + inserted.length : order.length;
    for (var i = start; i < stop; i++) _index[order[i].id] = i;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Context
  // -------------------------------------------------------------------------------------------------------------------

  EvalContext _contextFor(StatementId id, {bool includeResolutions = true}) => .new(
    this,
    id,
    resolutions: includeResolutions ? commits[id]?.resolutions : null,
  );

  // -------------------------------------------------------------------------------------------------------------------
  // Update propagation
  // -------------------------------------------------------------------------------------------------------------------

  late var _lastPass = EvaluationPass(this);
  late final _updateNotifier = ValueNotifier<EvaluationPass>(_lastPass);

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
