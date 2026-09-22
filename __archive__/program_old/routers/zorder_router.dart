part of '../program.dart';

extension RouteZOrder on Evaluation {
  ProgramEdit? routeReorder(CellRef ref, ZAnchor anchor) {
    var target = ref;
    while (true) {
      final s = statement(target.statementId);
      if (s == null) return null;
      if (s is! ShapeStatement || s.frame == target) break;
      target = s.frame;
    }

    return .build(this, (e) => e.reorder(target, anchor));
  }
}
