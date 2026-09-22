part of '../../_program.dart';

mixin GeneratingStatement on Statement {
  Iterable<Statement> generate(EvalContext context);
}
