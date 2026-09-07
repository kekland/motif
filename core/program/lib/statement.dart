part of 'program.dart';

extension type const StatementId._(int value) implements Object {
  static StatementId allocate() => ._(_seq++);
  static int _seq = 1;

  int get namespace => value;

  CellRef<H> cell<H extends CellHandle>(
    CellKind kind,
    int tag, [
    int sub = 0,
  ]) => .raw(namespace: value, tag: tag, sub: sub, kind: kind);
}

extension StatementIdExt on CellRef {
  StatementId get statementId => ._(namespace);
}

sealed class Statement {
  Statement({
    StatementId? id,
    this.modifiers = const [],
  }) : id = id ?? .allocate();

  final StatementId id;
  final List<Statement> modifiers;

  Iterable<Selector> get selectors;

  Iterable<Statement> expand() => const [];
  Iterable<Op> execute(EvalContext context);

  Statement copyWith({
    StatementId? id,
    List<Statement>? modifiers,
  });

  Statement? remap(Remap remap) {
    final copy = copyWith();
    var touched = false;
    for (final s in copy.selectors) {
      final result = s._remap(remap);
      if (result == .refused) return null;
      if (result == .changed) touched = true;
    }

    final modifiers = <Statement>[];
    for (final m in copy.modifiers) {
      final remapped = m.remap(remap);
      if (remapped == null) return null;
      if (!identical(remapped, m)) touched = true;
      modifiers.add(remapped);
    }

    if (!touched) return this;
    return copy.copyWith(modifiers: modifiers);
  }

  // ----
  // Routers
  // ----

  DissolveIntent routeDissolve(Set<CellRef> targeted) => .new(targeted);
  TransformResult routeTransform(EvalContext context, CellRef target) => .refused;
}
