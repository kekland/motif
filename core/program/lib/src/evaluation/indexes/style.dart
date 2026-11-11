part of '../../_program.dart';

/// A [StyleIndex] keeps track of the resolved styles for each cell.
final class StyleIndex {
  StyleIndex(this.evaluation);
  final Evaluation evaluation;

  final _map = <CellRef, CellStyle>{};

  CellStyle<H>? of<H extends CellHandle>(CellRef<H> ref) => _map[ref] as CellStyle<H>?;

  void set(CellRef r, CellStyle style) {
    _map[r] = style;
  }

  void detach(Commit c) {
    for (final r in c.added) {
      _map.remove(r);
    }
  }

  Set<CellRef> attach(Commit c) {
    final restyled = <CellRef>{};
    for (final r in c.added) {
      if (_process(c, r)) restyled.add(r);

      for (final d in evaluation.lineage.descendantsOf(r)) {
        if (_process(c, d, parent: _map[r])) restyled.add(d);
      }
    }
    return restyled;
  }

  bool _process(Commit c, CellRef r, {CellStyle? parent}) {
    if (r.kind == .frame) return false;
    final base = c.styles[r] ?? parent ?? inherited(r) ?? .defaultOf(r.kind);
    final resolved = evaluation.program.styles.of(r)?.apply(base) ?? base;
    if (_map[r] == resolved) return false;
    _map[r] = resolved;
    return true;
  }

  CellStyle? inherited(CellRef ref) {
    final source = evaluation.lineage.producerOf(ref)?.source;
    if (source == null) return null;

    final inherited = of(source);
    if (inherited == null) return null;
    if (inherited.kind != ref.kind) return null;

    return inherited;
  }
}

extension EvaluationStyle on EvalPass {
  void restyle(CellRef r) {
    final c = evaluation.commitOf(r.statementId);
    if (c == null || !c.added.contains(r)) return;
    final base = c.styles[r] ?? evaluation.style.inherited(r) ?? .defaultOf(r.kind);
    final resolved = program.styles.of(r)?.apply(base) ?? base;
    evaluation.style.set(r, resolved);
    restyled.add(r);
  }
}
