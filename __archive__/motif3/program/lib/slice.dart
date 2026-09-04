part of 'program.dart';

final class ProgramSlice {
  new({required this.statements, this.overrides});
  ProgramSlice.single(Statement statement, {this.overrides}) : statements = [statement];

  final List<Statement> statements;
  Iterable<StatementId> get ids => statements.map((s) => s.id);

  final StyleOverrides? overrides;
}
