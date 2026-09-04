part of 'program.dart';

final class ProgramGraph {
  final Map<StatementId, Set<StatementId>> _dependents = {};
  final Map<Ref, Set<StatementId>> _borrowers = {};
  final Map<Ref, StatementId> _owner = {};

  Iterable<StatementId> borrowersOf(Ref ref) => _borrowers[ref] ?? const {};
  StatementId? ownerOf(Ref ref) => _owner[ref];
  Iterable<StatementId> dependentsOf(StatementId statementId) => _dependents[statementId] ?? const {};

  Set<StatementId> closureOf(Iterable<StatementId> roots) {
    final seen = <StatementId>{};
    final work = [...roots];
    while (work.isNotEmpty) {
      final id = work.removeLast();
      if (!seen.add(id)) continue;
      work.addAll(dependentsOf(id));
    }
    return seen;
  }

  void _add(Statement s) {
    for (final arg in s.args) {
      if (arg.isOwn) {
        assert(_owner[arg.ref] == null, 'ref ${arg.ref} has two owners');
        _owner[arg.ref] = s.id;
      } else {
        _borrowers.putIfAbsent(arg.ref, () => {}).add(s.id);
      }
      _dependents.putIfAbsent(arg.ref.statement, () => {}).add(s.id);
    }
  }

  void _remove(Statement s) {
    for (final arg in s.args) {
      _owner.remove(arg.ref);
      _borrowers[arg.ref]?.remove(s.id);
      _dependents[arg.ref.statement]?.remove(s.id);
    }
  }

  void _clear() {
    _owner.clear();
    _borrowers.clear();
    _dependents.clear();
  }
}
