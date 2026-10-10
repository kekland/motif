part of '../../_program.dart';

mixin PlacedStatement on Statement {
  ParentSelector? get parent;

  @override
  PlacedStatement copyWith({
    StatementId? id,
    ModifierStack? modifiers,
    String? name,
    FrameRef? parent,
  });
}
