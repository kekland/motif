part of '../program.dart';

sealed class ProgramAnchor {
  const ProgramAnchor();

  const factory ProgramAnchor.start() = StartAnchor;
  const factory ProgramAnchor.end() = EndAnchor;
  const factory ProgramAnchor.at(StatementId id) = AtAnchor;
  const factory ProgramAnchor.after(StatementId id) = AfterAnchor;

  int? resolve(Program program);
}

final class StartAnchor extends ProgramAnchor {
  const StartAnchor();

  @override
  int? resolve(Program program) => 0;
}

final class EndAnchor extends ProgramAnchor {
  const EndAnchor();

  @override
  int? resolve(Program program) => program.length;
}

final class AtAnchor extends ProgramAnchor {
  const AtAnchor(this.id);
  final StatementId id;

  @override
  int? resolve(Program program) => program.indexOf(id);
}

final class AfterAnchor extends ProgramAnchor {
  const AfterAnchor(this.id);
  final StatementId id;

  @override
  int? resolve(Program program) {
    final index = program.indexOf(id);
    if (index == null) return null;
    return index + 1;
  }
}
