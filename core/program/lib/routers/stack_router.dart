part of '../program.dart';

extension RouteStack on Evaluation {
  StatementId objectOf(StatementId id) {
    id = rootOf(id);
    final s = statement(id);
    if (s == null) return id;

    StatementId? root;
    for (final selector in s.selectors) {
      if (selector is ParentSelector) continue;
      for (final dependency in selector.dependencies) {
        final r = objectOf(dependency);
        if (root != null && root != r) return id;
        root = r;
      }
    }

    return root ?? id;
  }

  Iterable<Statement> stackOf(StatementId root) {
    final result = <Statement>[];
    for (final s in program.statements) {
      if (s.id != root && objectOf(s.id) == root) result.add(s);
    }
    return result;
  }

  Iterable<StatementId> groupOf(StatementId id) {
    final object = objectOf(id);
    return [object, ...stackOf(object).map((s) => s.id)];
  }
}
