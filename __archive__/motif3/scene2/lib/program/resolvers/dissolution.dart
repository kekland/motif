part of '../program.dart';

final class DissolveIntent({final Set<Ref> lose = const {}, final Set<Ref> keep = const {}});
final class DissolveRemains(final List<Statement> replacements, final RefMap refMap);

final class DissolveResult({
  required final Set<StatementId> removed,
  required final Map<StatementId, List<Statement>> replaced,
  required final RefMap refMap,
}) {
  bool get isEmpty => removed.isEmpty && replaced.isEmpty;
}

// extension DissolveProgram on Program {
//   DissolveResult resolveDissolve(
//     Evaluation evaluation, {
//     Iterable<StatementId> statements = const [],
//     Iterable<Ref> refs = const [],
//   }) {
//     final bindings = evaluation.bindings;
//     final cellGraph = evaluation.cellGraph;
//     final lost = <Ref>{};
//     final pinned = <Ref>{};
//   }
// }
