part of 'program.dart';

final class ProgramSlice {
  new({required this.statements});
  ProgramSlice.empty() : statements = const [];

  factory ProgramSlice.merged(Iterable<ProgramSlice> slices, {required int Function(StatementId) indexOf}) {
    final seen = <StatementId>{};
    final statements = <Statement>[];
    for (final s in slices) {
      for (final statement in s.statements) {
        if (seen.add(statement.id)) {
          statements.add(statement);
        }
      }
    }

    statements.sort((a, b) => indexOf(a.id).compareTo(indexOf(b.id)));
    return .new(statements: statements);
  }

  final List<Statement> statements;

  ProgramSlice materialize(StatementId Function(Statement) idOf) {
    final idMap = <StatementId, StatementId>{};
    for (var i = 0; i < statements.length; i++) {
      final s = statements[i];
      final id = idOf(s);
      idMap[s.id] = id;
    }

    final remap = Remap.namespace(idMap);
    return ProgramSlice(
      statements: statements.map((s) => s.remap(remap)!).toList(),
    );
  }

  ProgramSlice extend(List<Statement> newStatements) => .new(statements: [...statements, ...newStatements]);
}
