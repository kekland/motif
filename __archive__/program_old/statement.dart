part of 'program.dart';

extension type const StatementId.raw(U64 value) implements Object {
  static StatementId allocate() => .raw(.of(0, _seq++));
  static int _seq = 1;

  static const _derived = 0x40000000;
  bool get isDerived => value.hi & _derived != 0;
  static StatementId derived(StatementId base, U64 key) {
    final m = Mix64.mix(base.value, key);
    return .raw(.of(m.hi | _derived, m.lo));
  }

  U64 get namespace => value;

  CellRef<H> cell<H extends CellHandle>(
    CellKind kind,
    int tag, [
    int sub = 0,
  ]) => .make(namespace: value, op: tag, sub: sub, kind: kind);
}

extension StatementIdCellRefExt on CellRef {
  StatementId get statementId => .raw(namespace);
}

extension StatementIdRefExt on Ref {
  StatementId get statementId => switch (this) {
    CellRef r => .raw(r.namespace),
    CovertexRef r => .raw(r.edge.namespace),
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

  Statement? maybeRemap(Remap remap) {
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

  Statement remap(Remap remap) {
    final result = maybeRemap(remap);
    if (result == null) throw StateError('failed to remap statement $id');
    return result;
  }

  // ----
  // Routers
  // ----

  TransformRoute routeTransform(EvalContext context, Ref target) => .refuse;
  TransformAbsorb? absorbTransform(EvalContext context, Set<Ref> absorbed, Set<Ref> all) => null;

  DissolveIntent routeDissolve(Set<CellRef> targeted) => .new(targeted);
  ReparentRoute routeReparent(CellRef target) => .refuse;
  Statement reparented(FrameRef parent) => this;
}
