part of '../../_program.dart';

mixin GeneratingStatement on Statement {
  Iterable<Statement> generate(EvalContext context);

  GeneratingStatement? absorbChildUpdate(StatementId child, StatementPartial update);
}
