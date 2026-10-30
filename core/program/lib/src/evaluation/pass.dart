part of '../_program.dart';

final class EvalPass extends EvalPassData {
  EvalPass(this.evaluation) : super.empty();

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

  FrameRef? frameOf(CellRef r) {
    final h = bundle.handle(r);
    if (h == null) return null;

    final f = bundle.parentOf(h);
    return f == null ? null : bundle.frameRef(f);
  }

  @override
  void reset() {
    _current = null;
    queue.clear();
    super.reset();
  }
}

class EvalPassData {
  EvalPassData.empty();

  final added = HashSet<CellRef>();
  final deleted = HashSet<CellRef>();
  final changed = HashSet<CellRef>();
  final moved = HashSet<CellRef>();
  final movedFrames = HashSet<FrameRef>();
  final evaluated = HashSet<StatementId>();
  final relayouted = HashSet<StatementId>();
  final restyled = HashSet<CellRef>();

  void add(EvalPassData other) {
    added.addAll(other.added);
    deleted.addAll(other.deleted);
    changed.addAll(other.changed);
    moved.addAll(other.moved);
    movedFrames.addAll(other.movedFrames);
    evaluated.addAll(other.evaluated);
    relayouted.addAll(other.relayouted);
    restyled.addAll(other.restyled);
  }

  void reset() {
    added.clear();
    deleted.clear();
    changed.clear();
    moved.clear();
    movedFrames.clear();
    evaluated.clear();
    relayouted.clear();
    restyled.clear();
  }
}
