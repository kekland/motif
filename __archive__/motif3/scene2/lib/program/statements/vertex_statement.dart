part of '../program.dart';

final class VertexStatement extends Statement with PlacedStatement {
  VertexStatement(this.position, {
    super.id,
    super.scope,
    this.style = .default_,
    FrameRef? parent,
  }) : parent = parent?.borrow();

  final Vec2 position;
  final VertexStyle style;

  @override
  final Borrow<FrameRef>? parent;

  @override
  late final _args = [?parent];

  late final ref = Ref.vertex(this, 'vertex');

  @override
  void performExecute(EvalContext context) {
    final handle = context.transaction.addVertex(
      ref.cellId,
      position,
      parent: context.resolve.maybe(parent?.ref),
    );

    context.bind(ref, handle, style: style);
  }

  @override
  VertexStatement copyWith({
    StatementId? id,
    Scope? scope,
    Vec2? position,
    VertexStyle? style,
    FrameRef? parent,
  }) => VertexStatement(
    position ?? this.position,
    id: id ?? this.id,
    scope: scope ?? this.scope,
    style: style ?? this.style,
    parent: parent ?? this.parent?.ref,
  );
}
