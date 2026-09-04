part of 'program.dart';

final class Evaluation {
  new({
    required this.bundle,
    required this.bindings,
    required this.failures,
  });

  factory Evaluation.of(Program program) => evaluate(program);

  final TopologyBundle bundle;
  final BindingTable bindings;
  final List<EvalFailure> failures;

  late final cellGraph = CellGraph._((bundle, bindings));
}

Evaluation evaluate(Program program) {
  final bundle = TopologyBundle();
  final transaction = bundle.beginTransaction();

  final bindings = BindingTable();
  final style = StyleTable();

  final context = EvalContext(
    graph: program.graph,
    transaction: transaction,
    bindings: bindings,
    style: style,
    styleOverrides: program.styleOverrides,
  );

  for (final statement in program.statements) {
    final mark = transaction.mark();
    context._currentMark = mark;
    try {
      statement.execute(context);
    } catch (e) {
      assert(e is EvalFailure, 'unexpected exception $e');
      transaction.rollbackTo(mark);
      bindings.unbind(statement.id);
      context.failures.add(e as EvalFailure);
    }
  }

  transaction.commit();
  return Evaluation(
    bundle: bundle,
    bindings: context.bindings,
    failures: context.failures,
  );
}
