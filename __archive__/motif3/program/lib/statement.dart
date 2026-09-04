part of 'program.dart';

extension type const StatementId(String value) {
  StatementId child(String name) => StatementId('$value/$name');
  static StatementId generate() => StatementId('${DateTime.now().microsecondsSinceEpoch}');
}

sealed class Statement {
  Statement({
    StatementId? id,
    this.modifiers = const [],
  }) : id = id ?? .generate();

  final StatementId id;
  final List<Statement> modifiers;
  Iterable<Selector> get selectors;

  void performExecute(EvalContext context);
  Iterable<Statement> expand() => const [];

  CellId cellId(String name) => .new('$id/$name');

  Iterable<Statement> execute(EvalContext context) {
    performExecute(context);
    return [...expand(), ...modifiers];
  }

  Iterable<CellKey> products(EvalContext c) => c.createdBy(id);
  Set<StatementId> get references => {
    for (final s in selectors) ...s.references,
    for (final m in modifiers) ...m.references,
  };

  RebaseResult resolveRebase(RebaseContext context) {
    final next = copyWith();
    try {
      var changed = false;
      for (final s in next.selectors) changed |= s._rebase(context);
      return changed ? .replaced([next]) : .none();
    } on RebaseRefused catch (e) {
      return .refused(e.reason);
    }
  }

  Statement? resolveAbsorption(Statement incoming) => null;

  Statement copyWith({StatementId? id, List<Statement>? modifiers});
}

extension CellKeyCreator on CellKey {
  StatementId? get creator {
    final i = id.value.indexOf('/');
    return i < 0 ? null : .new(id.value.substring(0, i));
  }
}
