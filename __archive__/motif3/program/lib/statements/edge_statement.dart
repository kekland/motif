part of '../program.dart';

final class EdgeStatement extends Statement with PlacedStatement {
  EdgeStatement(
    VertexSelector start,
    VertexSelector end, {
    this.startTangent,
    this.endTangent,
    this.style = .default_,
    super.id,
    super.modifiers,
    FrameKey? parent,
  }) : start = start.copyWith(),
       end = end.copyWith(),
       parent = parent?.selector();

  final VertexSelector start;
  final VertexSelector end;
  final Vec2? startTangent;
  final Vec2? endTangent;
  final EdgeStyle style;

  @override
  final CellSelector<FrameHandle>? parent;

  @override
  Iterable<Selector> get selectors => [start, end, ?parent];

  late final EdgeKey key = .edge(cellId('edge'));

  @override
  void performExecute(EvalContext context) {
    final handle = context.transaction.addEdge(
      key.id,
      start.resolve(context),
      end.resolve(context),
      startTangent: startTangent,
      endTangent: endTangent,
      parent: parent?.resolve(context),
    );
  }

  @override
  EdgeStatement copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    VertexSelector? start,
    VertexSelector? end,
    Vec2? startTangent,
    Vec2? endTangent,
    EdgeStyle? style,
    FrameKey? parent,
  }) => .new(
    start ?? this.start,
    end ?? this.end,
    startTangent: startTangent ?? this.startTangent,
    endTangent: endTangent ?? this.endTangent,
    style: style ?? this.style,
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    parent: parent ?? this.parent?.key,
  );
}
