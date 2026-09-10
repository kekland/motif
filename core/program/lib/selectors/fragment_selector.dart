part of '../program.dart';

final class FragmentSelector extends Selector<ProgramSlice> {
  new(this.id);

  final StatementId id;

  @override
  ProgramSlice _resolve(EvalContext context) {
    final eval = context._evaluation;
    final before = eval.indexOf(context.id)!;
    final statements = <Statement>[];
    for (final s in eval.groupOf(id)) {
      if (eval.indexOf(s)! < before) statements.add(eval.statement(s)!);
    }

    return .new(statements: statements);
  }

  @override
  FragmentSelector clone() => .new(id);

  @override
  Iterable<CellRef<CellHandle>> resolved(EvalContext context) {
    final out = <CellRef>{};
    for (final s in context.resolve(this).statements) {
      final products = context.productsOf(s.id);
      for (final p in products) out.addAll(context.descendants(p));
    }
    return out;
  }

  @override
  Iterable<CellRef<CellHandle>> get refs => const [];

  @override
  Iterable<StatementId> get dependencies => [id];

  @override
  RemapResult _remap(Remap remap) => .unchanged;
}
