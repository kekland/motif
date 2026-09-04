part of 'program.dart';

sealed class Anchor {
  const Anchor();

  const factory Anchor.start() = StartAnchor;
  const factory Anchor.end() = EndAnchor;
  const factory Anchor.at(StatementId id) = AtAnchor;
  const factory Anchor.after(StatementId id) = AfterAnchor;

  int? resolve(Program program);
}

final class StartAnchor extends Anchor {
  const StartAnchor();

  @override
  int? resolve(Program program) => 0;
}

final class EndAnchor extends Anchor {
  const EndAnchor();

  @override
  int? resolve(Program program) => program.length;
}

final class AtAnchor extends Anchor {
  const AtAnchor(this.id);
  final StatementId id;

  @override
  int? resolve(Program program) => program.indexOf(id);
}

final class AfterAnchor extends Anchor {
  const AfterAnchor(this.id);
  final StatementId id;

  @override
  int? resolve(Program program) {
    final index = program.indexOf(id);
    if (index == null) return null;
    return index + 1;
  }
}
