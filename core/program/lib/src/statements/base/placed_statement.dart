part of '../../_program.dart';

mixin PlacedStatement on Statement {
  ParentSelector? get parent;

  @override
  PlacedStatement copyWith({
    StatementId? id,
    List<Modifier>? modifiers,
    FrameRef? parent,
  });
}
