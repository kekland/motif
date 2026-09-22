part of '../program.dart';

final class ModifierIndex {
  ModifierIndex(this._evaluation);
  final Evaluation _evaluation;

  final _baseOf = <StatementId, StatementId>{};
  final _modifiers = <StatementId, List<StatementId>>{};

  /// Base statement of the given modifier statement, or itself, if it's not modifying anything.
  StatementId baseOf(StatementId id) {
    final root = _evaluation.generated.rootOf(id);
    return _baseOf[root] ?? root;
  }

  /// Every statement of a stack, including the base statement itself.
  Iterable<StatementId> stackOf(StatementId id) sync* {
    final base = baseOf(id);
    yield base;
    yield* modifiersOf(base);
  }

  /// Modifiers of the given statement, excluding the base statement.
  List<StatementId> modifiersOf(StatementId id) {
    final base = baseOf(id);
    return _modifiers[base] ?? const [];
  }

  void add(Commit c) {
    final id = c.statement.id;
    final base = _resolveBase(c.statement);
    if (base == id) return;
    _baseOf[id] = base;
    _insertMember(base, id);
  }

  void remove(Commit c) {
    final id = c.statement.id;
    final base = _baseOf.remove(id);
    if (base == null) return;

    final modifiers = _modifiers[base]!;
    modifiers.remove(id);
    if (modifiers.isEmpty) _modifiers.remove(base);
  }

  StatementId _resolveBase(Statement s) {
    StatementId? base;
    for (final selector in s.selectors) {
      if (selector is ParentSelector) continue;
      for (final dependency in selector.dependencies) {
        final b = baseOf(dependency);
        if (base != null && base != b) return s.id;
        base = b;
      }
    }

    return base ?? s.id;
  }

  void _insertMember(StatementId base, StatementId member) {
    final members = _modifiers.putIfAbsent(base, () => []);
    final index = _evaluation.indexOf(member)!;
    final insertion = members.indexWhere((m) => _evaluation.indexOf(m)! > index);
    if (insertion != -1) return members.insert(insertion, member);
    members.add(member);
  }
}
