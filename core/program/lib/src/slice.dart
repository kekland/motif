part of '_program.dart';

final class ProgramSlice {
  new({required this.statements});
  ProgramSlice.empty() : statements = [];

  factory ProgramSlice.decode(gen.ProgramSlice program) => ProgramCodec.decodeProgramSlice(program);
  static ProgramSlice? decodeRaw(Uint8List data) => ProgramCodec.decodeRaw(() => .decode(.fromBuffer(data)));

  factory ProgramSlice.merged(Iterable<ProgramSlice> slices, {int Function(StatementId)? indexOf}) {
    final seen = <StatementId>{};
    final statements = <Statement>[];
    for (final s in slices) {
      for (final statement in s.statements) {
        if (seen.add(statement.id)) {
          statements.add(statement);
        }
      }
    }

    if (indexOf != null) {
      statements.sort((a, b) => indexOf(a.id).compareTo(indexOf(b.id)));
    }

    return .new(statements: statements);
  }

  final List<Statement> statements;
  int get length => statements.length;

  ProgramSlice materialize(StatementId Function(Statement) idOf) {
    final idMap = <StatementId, StatementId>{};
    for (var i = 0; i < statements.length; i++) {
      final s = statements[i];
      final id = idOf(s);
      idMap[s.id] = id;
    }

    final remap = Remap.statements(idMap);
    return ProgramSlice(
      statements: statements.map((s) => s.remap(remap)).toList(),
    );
  }

  ProgramSlice extend(ProgramSlice other) => .new(statements: [...statements, ...other.statements]);
}
