part of 'program.dart';

sealed class Anchor {
  const Anchor();

  const factory Anchor.start() = _StartAnchor;
  const factory Anchor.end() = _EndAnchor;
  const factory Anchor.at(StatementId id) = _AtAnchor;
  const factory Anchor.after(StatementId id) = _AfterAnchor;

  int? resolve(Program program);
}

final class _StartAnchor extends Anchor {
  const _StartAnchor();

  @override
  int? resolve(Program program) => 0;
}

final class _EndAnchor extends Anchor {
  const _EndAnchor();

  @override
  int? resolve(Program program) => program.length;
}

final class _AtAnchor extends Anchor {
  const _AtAnchor(this.id);
  final StatementId id;

  @override
  int? resolve(Program program) => program.indexOf(id);
}

final class _AfterAnchor extends Anchor {
  const _AfterAnchor(this.id);
  final StatementId id;

  @override
  int? resolve(Program program) {
    final index = program.indexOf(id);
    if (index == null) return null;
    return index + 1;
  }
}
