part of '../program.dart';

sealed class DissolveIntent {
  const DissolveIntent();
  const factory DissolveIntent.statement() = DissolveStatement;
  const factory DissolveIntent.cells(Set<CellRef> cells) = DissolveCells;
}

final class const DissolveStatement() extends DissolveIntent;
final class const DissolveCells(final Set<CellRef> cells) extends DissolveIntent;

final class DissolveRouter {
  new({
    required this.remove,
    required this.insert,
  });

  final Set<StatementId> remove;
  final List<Statement> insert;
}

extension RouteDissolve on Evaluation {
  DissolveRouter routeDissolve(Iterable<CellRef> targets) {
    final remove = HashSet<StatementId>();

    final byOwner = <StatementId, HashSet<CellRef>>{};
    for (final t in targets) {
      byOwner.putIfAbsent(ownerOf(t.statementId), HashSet.new).add(t);
    }

    final cells = <CellRef>{};
    for (final entry in byOwner.entries) {
      final s = program.statement(entry.key)!;
      final targeted = entry.value;
      final intent = s.resolveDissolve(targeted);
      final _ = switch (intent) {
        DissolveStatement() => remove.add(s.id),
        DissolveCells d => cells.addAll(d.cells),
      };
    }

    final selectors = cells.map((c) => c.selector()).toList();

    return .new(
      remove: remove,
      insert: selectors.isNotEmpty ? [Dissolve(selectors)] : [],
    );
  }
}
