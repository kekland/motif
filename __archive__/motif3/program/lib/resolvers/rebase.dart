part of '../program.dart';

sealed class const RebaseResult() {
  const factory RebaseResult.replaced(List<Statement> statements) = RebaseReplaced;
  const factory RebaseResult.none() = RebaseNone;
  const factory RebaseResult.refused(String reason) = RebaseRefused;
}

final class const RebaseReplaced(final List<Statement> replacement) extends RebaseResult;
final class const RebaseNone() extends RebaseResult;
final class const RebaseRefused(final String reason) extends RebaseResult implements Exception;

final class RebaseContext {
  RebaseContext(this._eval);
  final Evaluation _eval;

  final removed = LineageIndex();
  final added = LineageIndex();

  TopologyBundle get bundle => _eval.bundle;

  void ran(Commit c) => added.add(c.delta);
  void reverted(Commit c) => removed.add(c.delta);

  bool affects(CellKey c) => removed.produces(c) || added.consumes(c);
  List<CellKey> descendantsOf(CellKey k) => added.descendantsOf(removed.ancestorOf(k)).toList();
}
