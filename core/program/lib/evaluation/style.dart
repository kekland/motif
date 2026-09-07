part of '../program.dart';

extension EvaluationStyle on Evaluation {
  CellStyle<H> styleOf<H extends CellHandle>(CellRef<H> ref) => _styles[ref]! as CellStyle<H>;

  void _resolveStyles(EvaluationPass pass, Commit c) {
    for (final r in c.added) {
      if (r.kind == .frame) continue;
      final base = c.styles[r] ?? _inheritedStyle(r) ?? .defaultOf(r.kind);
      final style = program.styles.of(r)?.apply(base) ?? base;
      if (_styles[r] == style) continue;
      _styles[r] = style;
      pass.restyled.add(r);
    }
  }

  CellStyle? _inheritedStyle(CellRef ref) {
    final source = lineage.producerOf(ref)?.source;
    if (source == null) return null;

    final style = _styles[source];
    if (style == null) return null;
    if (style.kind != ref.kind) return null;

    return style;
  }

  void restyle(EvaluationPass pass, CellRef r) {
    final c = commits[r.statementId];
    if (c == null || !c.added.contains(r)) return;
    final base = c.styles[r] ?? _inheritedStyle(r) ?? .defaultOf(r.kind);
    final style = program.styles.of(r)?.apply(base) ?? base;
    _styles[r] = style;
    pass.restyled.add(r);
  }
}
