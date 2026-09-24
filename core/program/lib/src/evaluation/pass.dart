part of '../_program.dart';

final class EvalPass {
  EvalPass(this.evaluation);

  final Evaluation evaluation;
  Program get program => evaluation.program;
  Bundle get bundle => evaluation.bundle;
  EvalTree get tree => evaluation.tree;
  DependencyGraph get graph => evaluation.graph;
  LayoutTree get layout => evaluation.layout;

  /// Objects queued for evaluation, in program order.
  late final SplayTreeSet<StatementId> queue = .new((a, b) => program.indexOf(a)!.compareTo(program.indexOf(b)!));

  /// Currently evaluated statement.
  StatementId? _current;

  final added = HashSet<CellRef>();
  final deleted = HashSet<CellRef>();
  final changed = HashSet<CellRef>();
  final moved = HashSet<CellRef>();
  final movedFrames = HashSet<FrameRef>();
  final relayouted = HashSet<StatementId>();
  final restyled = HashSet<CellRef>();
  final reordered = HashSet<CellRef>();

  FrameRef? frameOf(CellRef r) {
    final h = bundle.handle(r);
    if (h == null) return null;

    final f = bundle.parentOf(h);
    return f == null ? null : bundle.frameRef(f);
  }

  void reset() {
    _current = null;
    queue.clear();
    added.clear();
    deleted.clear();
    changed.clear();
    moved.clear();
    movedFrames.clear();
    relayouted.clear();
    restyled.clear();
    reordered.clear();
  }
}
