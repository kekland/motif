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
  Iterable<Op> ops(EvalContext context);

  Statement copyWith({
    StatementId? id,
    List<Statement>? modifiers,
  });

  // ----
  // Routers
  // ----

  DissolveIntent resolveDissolve(Set<CellRef> targeted) => .cells(targeted);
  TransformResult routeTransform(EvalContext context, CellRef target) => .refused;
}
