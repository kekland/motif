part of '../program.dart';

final class VertexStatement extends Statement with PlacedStatement {
  VertexStatement(
    this.position, {
    this.style = .default_,
    super.id,
    super.modifiers,
    FrameKey? parent,
  }) : parent = parent?.selector();

  final Vec2 position;
  final VertexStyle style;

  @override
  final CellSelector<FrameHandle>? parent;

  @override
  Iterable<Selector> get selectors => [?parent];

  late final VertexKey key = .vertex(cellId('vertex'));

  @override
  void performExecute(EvalContext context) {
    final handle = context.transaction.addVertex(
      key.id,
      position,
      parent: parent?.resolve(context),
    );
  }

  @override
  VertexStatement copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    Vec2? position,
    VertexStyle? style,
    FrameKey? parent,
  }) => .new(
    position ?? this.position,
    style: style ?? this.style,
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    parent: parent ?? this.parent?.key,
  );
}
