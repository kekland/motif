part of '../_program.dart';

extension RouteZOrder on Evaluation {
  ProgramEdit? routeReorder(CellRef ref, ZAnchor? anchor) {
    CellRef? _target(CellRef ref) {
      var target = ref;
      while (true) {
        final s = statement(target.statementId);
        if (s == null) return null;
        if (s is! ShapeStatement || s.frame == target) return target;
        target = s.frame;
      }
    }

    final target = _target(ref);
    if (target == null) return null;

    if (anchor != null && anchor.sibling != null) {
      final s = _target(anchor.sibling!);
      if (s == null || s == target) return null;
      anchor = anchor.remap(s);
    }

    final existing = reordersOf(target);
    return .build(this, (e) {
      if (anchor == null) {
        e.removeAll(existing);
        return;
      }

      final statement = ReorderStatement.fromAnchor(target.selector(), anchor: anchor);
      if (existing.isNotEmpty) e.removeAll(existing);
      e.insert([statement]);
    });
  }

  List<StatementId> reordersOf(CellRef cell) {
    final out = <StatementId>[];
    for (final id in graph.dependents([cell.statementId])) {
      final s = statement(id);
      if (s is ReorderStatement && s.target.ref == cell) out.add(s.id);
    }
    return out;
  }
}
