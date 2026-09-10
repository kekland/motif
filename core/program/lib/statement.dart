part of 'program.dart';

extension type const StatementId._(int value) implements Object {
  static StatementId allocate() => ._(_seq++);
  static int _seq = 1;

  static StatementId derived(StatementId base, int key) => ._(mix(base.value, key) | (1 << 62));

  int get namespace => value;

  CellRef<H> cell<H extends CellHandle>(
    CellKind kind,
    int tag, [
    int sub = 0,
  ]) => .make(namespace: value, tag: tag, sub: sub, kind: kind);

  bool get isGenerated => value & (1 << 62) != 0;

  static int mix(int a, int b) {
    var x = a * 0x9E3779B97F4A7C15 ^ b;
    x = (x ^ (x >>> 30)) * 0xBF58476D1CE4E5B9;
    x = (x ^ (x >>> 27)) * 0x94D049BB133111EB;
    return x ^ (x >>> 31);
  }
}

extension StatementIdCellRefExt on CellRef {
  StatementId get statementId => ._(namespace);
}

extension StatementIdRefExt on Ref {
  StatementId get statementId => switch (this) {
    CellRef r => ._(r.namespace),
    CovertexRef r => ._(r.edge.namespace),
  };

  CellRef get cell => switch (this) {
    CellRef r => r,
    CovertexRef r => r.edge,
  };
}

sealed class Statement {
  Statement({
    StatementId? id,
    this.enabled = true,
  }) : id = id ?? .allocate();

  final StatementId id;
  final bool enabled;

  Iterable<Selector> get selectors;
  Iterable<Op> execute(EvalContext context);

  Statement copyWith({
    StatementId? id,
    bool? enabled,
  });

  Statement? remap(Remap remap) {
    final copy = copyWith();
    var touched = false;
    for (final s in copy.selectors) {
      final result = s._remap(remap);
      if (result == .refused) return null;
      if (result == .changed) touched = true;
    }

    final newId = remap.statement(id);
    if (newId != null) touched = true;

    if (!touched) return this;
    return copy.copyWith(id: newId);
  }

  // ----
  // Routers
  // ----

  TransformRoute routeTransform(EvalContext context, Ref target) => .refuse;
  TransformAbsorb? absorbTransform(EvalContext context, Set<Ref> absorbed, Set<Ref> all) => null;

  DissolveIntent routeDissolve(Set<CellRef> targeted) => .new(targeted);
}
