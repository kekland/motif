part of '../program.dart';

Map<StatementId, (Statement, List<Statement>)> _edit(
  Evaluation eval,
  int start,
  int end,
  List<Statement> with_,
) {
  final program = eval.program;

  if (start == end && with_.length == 1) {
    final incoming = with_.single;
    final hosts = {for (final r in incoming.references) program.indexOf(r)};
    if (hosts.length == 1 && hosts.single != null) {
      final i = hosts.single!;
      final host = program[i];
      final absorbed = host.resolveAbsorption(incoming);
      if (absorbed != null) {
        return _edit(eval, i, i + 1, [absorbed]);
      }
    }
  }

  final context = RebaseContext(eval);
  final retained = <StatementId, Commit>{};
  final changed = <CellKey>{};
  final rewritten = <StatementId, (Statement, List<Statement>)>{};
  final refused = <StatementId, String>{};
  final rebased = {for (final s in with_) s.id};

  final pending = SplayTreeSet<StatementId>((a, b) => program.indexOf(a)!.compareTo(program.indexOf(b)!));

  void revert(StatementId id) {
    final commit = eval._revert(id);
    if (commit == null) return;
    retained[id] = commit;
    context.reverted(commit);
    pending.add(id);
  }

  final slice = {for (var i = start; i < end; i++) program[i].id};
  final revertClosure = eval._closure(slice).where((i) => !slice.contains(i)).toList();
  for (final id in revertClosure.reversed) revert(id);
  for (var i = end - 1; i >= start; i--) {
    final commit = eval._revert(program[i].id);
    if (commit != null) {
      context.reverted(commit);
      changed.addAll(commit.writes);
    }
  }

  program._replaceRange(start, end, with_);
  pending.addAll(rebased);

  var x = 0;

  while (pending.isNotEmpty) {
    final id = pending.first;
    pending.remove(id);

    final i = program.indexOf(id)!;
    final s = program[i];

    if (rebased.add(id)) {
      final result = s.resolveRebase(context);
      if (result is RebaseReplaced) {
        final replacement = result.replacement;
        rewritten[id] = (s, replacement);
        retained.remove(id);
        program._replaceRange(i, i + 1, replacement);
        for (final n in replacement) {
          rebased.add(n.id);
          pending.add(n.id);
        }

        continue;
      } else if (result is RebaseRefused) {
        final reason = result.reason;
        refused[id] = reason;
        retained.remove(id);
      }
    }

    final commit = retained.remove(id);
    if (commit != null && commit.reads.intersection(changed).isEmpty) {
      eval._replay(commit);
      context.ran(commit);
      changed.addAll(commit.writes);
      continue;
    }

    final keys = {for (final sel in s.selectors) ...sel.keys};
    final laterWriters = {
      for (final o in eval.graph.writersOf(keys))
        if (eval.program.indexOf(o)! > i) o,
    };
    final closure = eval._closure(laterWriters).reversed;
    for (final id in closure) revert(id);

    while (true) {
      final c = eval._execute(s);
      x++;
      final conflicts = eval._conflictsAfter(i, id);
      if (conflicts.isEmpty) {
        context.ran(c);
        changed.addAll(c.writes);
        break;
      }

      eval._revert(id);
      for (final c in eval._closure(conflicts).reversed) revert(c);
    }

    if (refused[id] != null) {
      final reason = refused[id]!;
      eval.failures[id] = RebaseRefused(reason);
    }
  }

  // print('executed $x times');

  return rewritten;
}
