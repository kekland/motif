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
  final _frameOf = <CellRef, FrameRef?>{};

  FrameRef? frameOf(CellRef r) {
    if (_frameOf.containsKey(r)) return _frameOf[r];
    final h = bundle.handle(r);
    if (h == null) return null;

    final f = bundle.parentOf(h);
    return f == null ? null : bundle.frameRef(f);
  }

  void _rememberFrames(Iterable<CellRef> cells) {
    final bundle = evaluation.bundle;
    for (final r in cells) {
      final h = bundle.handle(r);
      if (h == null) continue;
      _frameOf[r] = bundle.parentOf(h)?.ref(bundle);
    }
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
    _frameOf.clear();
  }
}
