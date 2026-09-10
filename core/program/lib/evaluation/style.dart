part of '../program.dart';

final class StyleIndex {
  StyleIndex(this.evaluation);
  final Evaluation evaluation;

  final _map = <CellRef, CellStyle>{};

  CellStyle<H>? of<H extends CellHandle>(CellRef<H> ref) => _map[ref] as CellStyle<H>?;

  void set(CellRef r, CellStyle style) {
    _map[r] = style;
  }

  void _remove(CellRef r) => _map.remove(r);

  void resolve(EvaluationPass pass, Commit c) {
    for (final r in c.added) {
      if (r.kind == .frame) continue;
      final base = c.styles[r] ?? inherited(r) ?? .defaultOf(r.kind);
      final resolved = evaluation.program.styles.of(r)?.apply(base) ?? base;
      if (_map[r] == resolved) continue;
      _map[r] = resolved;
      pass.restyled.add(r);
    }
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

extension EvaluationStyle on Evaluation {
  void restyle(EvaluationPass pass, CellRef r) {
    final c = _commits[r.statementId];
    if (c == null || !c.added.contains(r)) return;
    final base = c.styles[r] ?? style.inherited(r) ?? .defaultOf(r.kind);
    final resolved = program.styles.of(r)?.apply(base) ?? base;
    style.set(r, resolved);
    pass.restyled.add(r);
  }
}
